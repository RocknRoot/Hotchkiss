require 'rack/utils'

module HK

  class Application

    @@router = nil
    @@root  = nil

    attr_accessor :router, :root

    def self.router=(router)
      @@router = router if @@router.nil?
    end

    def self.root=(root)
      @@root = root if @@root.nil?
    end

    def self.root
      @@root
    end

    def self.burnbabyburn!
      lambda do |env|
        begin
          route, params = @@router.match?(env)
          env['hk.params'] = (params.nil? ? {} : params)
          if !route.nil? && route.has_key?(:special)
            env['hk.controller'] = route[:controller]
          elsif !route.nil?
            env['hk.controller'] = "#{route[:controller].capitalize}Controller"
          else
            raise Exception, "Unknown route for path: #{env['REQUEST_PATH']}"
          end
          env['hk.action'] = route[:action]
          resp = Object.const_get(env['hk.controller']).new.call(env)
        rescue Exception => e
          env['hk.action'] = "on_exception"
          env['hk.exception'] = e
          if Object.const_get("ApplicationController").instance_methods(false).include?(:on_exception)
            env['hk.controller'] = :ApplicationController
          else
            env['hk.controller'] = :FastResponder
          end
          resp = Object.const_get(env['hk.controller']).new.call(env)
        end
        response = Rack::Response.new()
        response.write(resp)
        response.finish
      end
    end

  end # Application

end ## HK
