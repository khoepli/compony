module Compony
  module Version
    MAJOR = 0
    MINOR = 0
    PATCH = 6

    EDGE = true

    LABEL = [MAJOR, MINOR, PATCH, EDGE ? 'edge' : nil].compact.join('.')
  end
end
