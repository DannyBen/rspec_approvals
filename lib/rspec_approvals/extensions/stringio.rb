# This is a fix for a pesky issue with tty-screen, which is a sub-dependency
# of tty-* gems.
# Without this fix, gems that include rspec_approval and tty-* gems might
# cause an error in some cases.
#
# ref: https://github.com/piotrmurach/tty-screen/issues/11
require 'stringio'

unless StringIO.method_defined? :ioctl
  class StringIO
    def ioctl(*)
      # :nocov:
      80
      # :nocov:
    end
  end
end

unless StringIO.method_defined? :wait_readable
  class StringIO
    def wait_readable(*)
      # :nocov:
      true
      # :nocov:
    end
  end
end
