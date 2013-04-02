module HK

  class Server < Rack::Server

    def initialize(options)
      @options = options
    end

    def self.start!(options)
      new(options).start
    end

    def options
      @options
    end

    def start
      time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      puts "[#{time}] => Hotchkiss - #{HK::VERSION} version"
      puts "[#{time}] => It rolls on http://#{options[:Host]}:#{options[:Port]}"
      [:INT, :TERM].each { |sig| trap(sig) { exit } }
      super
    end

  end # Server

end ## HK
