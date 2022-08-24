# DO NOT EDIT
# This file is auto-generated via: 'rake gemspec'.

# -*- encoding: utf-8 -*-
# stub: compony 0.0.1.edge ruby lib

Gem::Specification.new do |s|
  s.name = "compony".freeze
  s.version = "0.0.1.edge"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sandro Kalbermatter".freeze, "contributors".freeze]
  s.date = "2022-08-24"
  s.files = [".gitignore".freeze, ".ruby-version".freeze, "CHANGELOG.md".freeze, "LICENSE".freeze, "README.md".freeze, "Rakefile".freeze, "app/controllers/compony_controller.rb".freeze, "compony.gemspec".freeze, "config/routes.rb".freeze, "lib/compony.rb".freeze, "lib/compony/attr_group.rb".freeze, "lib/compony/attr_group/attr.rb".freeze, "lib/compony/attr_group/form_helper.rb".freeze, "lib/compony/component.rb".freeze, "lib/compony/component_mixins/default/labelling.rb".freeze, "lib/compony/component_mixins/default/standalone.rb".freeze, "lib/compony/component_mixins/default/standalone/standalone_dsl.rb".freeze, "lib/compony/component_mixins/default/standalone/verb_dsl.rb".freeze, "lib/compony/component_mixins/resourceful.rb".freeze, "lib/compony/components/button.rb".freeze, "lib/compony/components/form.rb".freeze, "lib/compony/components/resourceful/edit.rb".freeze, "lib/compony/components/resourceful/new.rb".freeze, "lib/compony/components/with_form.rb".freeze, "lib/compony/controller_mixin.rb".freeze, "lib/compony/engine.rb".freeze, "lib/compony/method_accessible_hash.rb".freeze, "lib/compony/model_mixin.rb".freeze, "lib/compony/request_context.rb".freeze, "lib/compony/translations_object_mixin.rb".freeze, "lib/compony/version.rb".freeze, "lib/compony/view_helpers.rb".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0.0".freeze)
  s.rubygems_version = "3.2.33".freeze
  s.summary = "Needs summary".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<request_store>.freeze, [">= 1.5"])
    s.add_runtime_dependency(%q<haml>.freeze, [">= 5.2"])
    s.add_runtime_dependency(%q<schemacop>.freeze, [">= 3.0.17"])
    s.add_runtime_dependency(%q<simple_form>.freeze, [">= 5.1.0"])
    s.add_runtime_dependency(%q<dslblend>.freeze, [">= 0.0.3"])
    s.add_runtime_dependency(%q<ransack>.freeze, [">= 3.2.1"])
  else
    s.add_dependency(%q<request_store>.freeze, [">= 1.5"])
    s.add_dependency(%q<haml>.freeze, [">= 5.2"])
    s.add_dependency(%q<schemacop>.freeze, [">= 3.0.17"])
    s.add_dependency(%q<simple_form>.freeze, [">= 5.1.0"])
    s.add_dependency(%q<dslblend>.freeze, [">= 0.0.3"])
    s.add_dependency(%q<ransack>.freeze, [">= 3.2.1"])
  end
end