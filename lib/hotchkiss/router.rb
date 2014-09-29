module HK

  class Router

    def initialize
      @routes_by_method = {}
      @routes = []
      yield(self)
      compute
    end

    def bind(path, infos)
      route = {}
      route[:path] = path
      route = route.merge!(infos)
      @routes << route
    end

    def get_routes
      @routes
    end

    def get_routes_by_method
      @routes_by_method
    end

    def root(infos)
      raise TypeError unless infos.is_a?(Hash)
      bind("/", infos)
    end

    def match?(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['REQUEST_PATH'].eql?("/") ? "/" :
             env['REQUEST_PATH'].gsub(/\/$/, '')
      if !@routes_by_method.has_key?(method)
        raise Exception, "Unknown route for path: #{env['REQUEST_PATH']}"
      end
      @routes_by_method[method].each do |route|
        if path.match(route[:regexp])
          return route, extract_params(route,
                                       path.scan(route[:regexp]).flatten!)
        end
      end
      return nil, nil
    end


    private

    def compute
      @routes.each do |route|
        backup = String.new(route[:path])
        computed_route = route[:path].gsub!(/((:\w+)|\*)/,
                                            /(\w+)/.to_s)
        computed_route = "^#{route[:path]}$"
        computed_route = Regexp.new(computed_route)
        route[:regexp] = computed_route
        route[:path] = backup
        route[:params] = route[:path].scan(/:\w*/).map { |a|
          a.tr(':', '').to_sym
        }
        if @routes_by_method.has_key? route[:method]
          @routes_by_method[route[:method]] << route
        else
          @routes_by_method[route[:method]] = [route]
        end
      end
    end

    def extract_params(route, params)
      length = route[:params].length
      if length > 0 && length = params.length
        par = {}
        i = 0
        while i < length
          par[route[:params][i]] = params[i]
          i += 1
        end
        par
      else
        nil
      end
    end

  end # Router

end ## HK
