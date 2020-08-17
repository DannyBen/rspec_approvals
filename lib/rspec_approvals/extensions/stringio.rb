# This is a fix for a pesky issue with tty-screen (dependency of tty-reader,
# which is a dependency of tty-prompt, which is a dependency of ours).
# ref: https://github.com/piotrmurach/tty-screen/issues/11
require 'stringio'

unless StringIO.method_defined? :ioctl
  class StringIO
    def ioctl(*)
      80
    end
  end
end

unless StringIO.method_defined? :wait_readable
  class StringIO
    def wait_readable(*)
      true
    end
  end
end

