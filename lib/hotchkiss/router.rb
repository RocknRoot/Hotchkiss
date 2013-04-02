module HK

  class Router

    def initialize
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
      method = env['REQUEST_METHOD']
      path = env['REQUEST_PATH'].eql?("/") ? "/" : env['REQUEST_PATH'].gsub(/\/$/, '')
      @routes.each do |route|
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
        end
    end

    def finish
      @routes << {:path => "/favicon.ico", :action => "favicon", :controller => :FastResponder, :special => true}
    end

  end # Router

end ## HK
