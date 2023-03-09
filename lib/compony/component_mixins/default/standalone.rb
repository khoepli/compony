module Compony
  module ComponentMixins
    module Default
      # This contains all default component logic concerning standalone functionality
      module Standalone
        extend ActiveSupport::Concern

        included do
          # Called in routes.rb
          # Returns the compiled standalone config for this component
          # If the components have an inheritance hierarchy, the configs are merged in the right order to perform proper overrides.
          attr_reader :standalone_configs
        end

        # Called by fab_controller when a request is issued.
        # This is the entrypoint where a request enters the Component world.
        def on_standalone_access(verb_config, controller)
          # Register as root comp
          if parent_comp.nil?
            fail "#{inspect} is attempting to become root component, but #{root_comp.inspect} is already root." if Compony.root_comp.present?
            RequestStore.store[:compony_root_comp] = self
          end

          # Prepare the request context in which the innermost DSL calls will be executed
          request_context = RequestContext.new(self, controller)

          ###===---
          # Dispatch request to component. Empty Dslblend base objects are used to provide multiple contexts to the authorize and respond blocks.
          # Lifecycle is (see also "doc/Resourceful Lifecycle.pdf"):
          #   - load data (optional, speficied ResourcefulVerbDsl, by convention, should default to the implementation in Resourceful)
          #     - after_load_data (optional, specified in Resourceful)
          #   - assign_attributes (optional, speficied ResourcefulVerbDsl, by convention, should default to the implementation in Resourceful)
          #     - after_assign_attributes (optional, specified in Resourceful)
          #   - authorize
          #   - store_data (optional, speficied ResourcefulVerbDsl, by convention, should default to the implementation in Resourceful)
          #   - respond (typically either redirect or render standalone, specified in VerbDsl), which defaults to render_standalone, performing:
          #     - before_render
          #     - render (unless before_render already redirected)
          ###===---

          if verb_config.load_data_block
            request_context.evaluate_with_backfire(&verb_config.load_data_block)
            if global_after_load_data_block
              request_context.evaluate_with_backfire(&global_after_load_data_block)
            end
          end

          if verb_config.assign_attributes_block
            request_context.evaluate_with_backfire(&verb_config.assign_attributes_block)
            if global_after_assign_attributes_block
              request_context.evaluate_with_backfire(&global_after_assign_attributes_block)
            end
          end

          # TODO: Make much prettier, providing message, action, subject and conditions
          fail CanCan::AccessDenied, inspect unless request_context.evaluate(&verb_config.authorize_block)

          if verb_config.store_data_block
            request_context.evaluate_with_backfire(&verb_config.store_data_block)
          end

          # Check if there is a specific respond block for the format.
          # If there isn't, fallback to the nil respond block, which defaults to `render_standalone`.
          respond_block = verb_config.respond_blocks[controller.request.format.symbol] || verb_config.respond_blocks[nil]
          request_context.evaluate(&respond_block)
        end

        # Call this on a standalone component to find out whether default GET access is permitted for the current user.
        # This is useful to hide/disable buttons leading to components a user may not press.
        # For resourceful components, before calling this, you must have loaded date beforehand, for instance in one of the following ways:
        # - when called standalone (via request to the component), the load data step must be completed
        # - when called to check for permission only, e.g. to display a button to it, initialize the component by passing the :data keyword to `new`
        # By default, this checks the authorization to access the main standalone entrypoint (with name `nil`) and HTTP verb GET.
        def standalone_access_permitted_for?(controller, standalone_name: nil, verb: :get)
          standalone_name = standalone_name&.to_sym
          verb = verb.to_sym
          standalone_config = standalone_configs[standalone_name] || fail("#{inspect} does not provide the standalone config #{standalone_config.inspect}.")
          verb = standalone_config.verbs[verb] || fail("#{inspect} standalone config #{standalone_config.inspect} does not provide verb #{verb.inspect}.")
          return RequestContext.new(self, controller).evaluate(&verb.authorize_block)
        end

        # Renders the component using the controller passed to it upon instanciation (calls the controller's render)
        # Do not overwrite
        def render_standalone(controller, status: nil, standalone_name: nil)
          # Start the render process. This produces a nil value if before_render has already produced a response, e.g. a redirect.
          rendered_html = render(controller)
          if rendered_html.present? # If nil, a response body was already produced in the controller and we take no action here (would have DoubleRenderError)
            opts = { html: rendered_html, layout: @standalone_configs[standalone_name].layout }
            opts[:status] = status if status.present?
            controller.respond_to do |format|
              # Form posts trigger format types turbo stream and then html, turbo stream wins.
              # For this reason, Rails prefers stream, in which case the layout is disabled, regardless of the option.
              # To mitigate this, we use respond_to to force a HTML-only response.
              format.html { controller.render(**opts) }
            end
          end
        end

        protected

        # DSL method
        def standalone(name = nil, *args, **nargs, &block)
          block = proc {} unless block_given? # If called without a block, must default to an empty block to provide a binding to the DSL.
          name = name&.to_sym # nil name is the most common case
          @standalone_configs[name] ||= Compony::MethodAccessibleHash.new
          @standalone_configs[name].deep_merge! StandaloneDsl.new(self, name, *args, **nargs).to_conf(&block)
        end

        private

        def init_standalone
          @standalone_configs = {}
        end
      end
    end
  end
end
