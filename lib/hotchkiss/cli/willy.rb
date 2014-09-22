module Cli

  class Willy < Thor

    desc "new NAME",
         "Create new hotchkiss application directories with skel files."
    def new(name)
      dir = Dir.pwd + '/' + name
      unless File.exists?(dir)
        FileUtils.cp_r(TEMPLATE_DIR + "new", dir)
        FileUtils.mkpath(dir + '/db/migrations')
      else
        abort("#{dir} exists. Remove it or change your app name.")
      end
    end

    desc "server [host - default 127.0.0.1] [port - default 3000]",
         "Run development server."
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

    desc "console", "IRB console."
    def console
      require 'irb'
      begin
        YAML::load(File.open(DB_INFO_FILE))
      rescue Errno::ENOENT
        abort(ERROR_DB_INFOS_FILE_MSG)
      end
      Sequel.connect(DB_INFOS[:url], DB_INFOS[:options])
      Dir["#{Dir.pwd}/code/app/models/*.rb"].each { |file|
        require file
      }
      ARGV.clear
      IRB.start
    end

    desc "routes", "Show app routes"
    def routes
      begin
        load(ROUTE_FILE)
      rescue LoadError => e
        abort(e.message)
      end
      http_methods = HK::Application.routes_by_method
      http_methods.each { |method, resources|
        puts "#{method.to_s}:"
        resources.each { |resource|
          p = resource[:path]
          c = "#{resource[:controller].capitalize}Controller"
          a = resource[:action]
          puts "#{p} -> #{c} -> #{a}"
        }
        puts
      }
    end

    desc "generate SUBCOMMAND", "Generators for model and controller files."
    subcommand "generate", Generate

    desc "migrate SUBCOMMAND", "Up/down migration tool."
    subcommand "migrate", Migrate

  end # Willy

end ## Cli
