module RSpecFixtures
  class << self
    def stdout
      @stdout ||= StringIO.new
    end

    def stderr
      @stderr ||= StringIO.new
    end
  end
end