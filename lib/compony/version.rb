module Compony
  module Version
    MAJOR = 0
    MINOR = 0
    PATCH = 5

    EDGE = false

    LABEL = [MAJOR, MINOR, PATCH, EDGE ? 'edge' : nil].compact.join('.')
  end
end
