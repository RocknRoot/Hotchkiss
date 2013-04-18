module HK

  class Router

    def initialize
      @routes_by_method = {}
      @routes = []
      yield(self)
      finish
      compute
    end

    def bind(path, infos)
      route = {}
      route[:path] = path
      route = route.merge!(infos)
      @routes << route
    end

    def root(infos)
      raise TypeError unless infos.is_a?(Hash)
      bind("/", infos)
    end

    def match?(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['REQUEST_PATH'].eql?("/") ? "/" : env['REQUEST_PATH'].gsub(/\/$/, '')
      @routes_by_method[method].each do |route|
        if path.match(route[:regexp])
          return route
        end
      end
      return nil
    end

    private

    def compute
      @routes.each do |route|
        computed_route = route[:path].gsub!(/((:\w+)|\*)/, /(\w+)/.to_s)
        computed_route = "^#{route[:path]}$" if computed_route.nil?
        computed_route = Regexp.new(computed_route)
        route[:regexp] = computed_route
        if @routes_by_method.has_key? route[:method]
          @routes_by_method[route[:method]] << route
        else
          @routes_by_method[route[:method]] = [route]
        end
      end
    end

    def finish
      @routes << { :method => :get, :path => "/favicon.ico", :action => "favicon",
                   :controller => :FastResponder, :special => true }
    end

  end # Router

end ## HK
