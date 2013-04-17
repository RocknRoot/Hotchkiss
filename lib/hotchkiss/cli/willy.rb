module Cli

  class Willy < Thor

    desc "new NAME", "Create new hotchkiss application directories with skel files."
    def new(name)
      dir = Dir.pwd + '/' + name
      FileUtils.mkdir(dir)
      FileUtils.cp_r(Cli::TEMPLATE_DIR + "new/.", dir)
    end

    desc "server [host - default 127.0.0.1] [port - default 3000]", "Run development server."
    def server(host = nil, port = nil)
      port ||= 3000
      host ||= "127.0.0.1"
      [:INT, :TERM].each { |sig| trap(sig) { exit } }
      options = {}
      options[:Host] = host
      options[:Port] = port
      options[:config] = "config.ru"
      options[:server] = :webrick
      HK::Server.start!(options)
    end

    desc "generate SUBCOMMAND", "Generators for model and controller files."
    subcommand "generate", Generate

    desc "migrate SUBCOMMAND", "Up/down migration tool."
    subcommand "migrate", Migrate

  end # Willy

end ## Cli
