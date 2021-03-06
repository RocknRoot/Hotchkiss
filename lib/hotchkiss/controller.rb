module HK

  class Controller

    def call(env)
      resp = {}
      @env = env
      @request = Rack::Request.new(env)
      @response = Rack::Response.new()
      @request.update_param :url, env['hk.params']
      resp[:body] = self.send(env['hk.action'])
      resp[:status] = @response.status
      resp
    end

  private

    def params
      @request.params
    end

    def reroute(controller, action, args = {})
      name = controller.to_s.capitalize + 'Controller'
      c = Object.const_get(name).new
      env = @env
      env['hk.controller'] = name
      env['hk.action'] = action
      env['hk.params'] ||= args
      c.call(env)
    end

    def redirect_to(url)
      @response.redirect(url)
    end

    def render(tpl_name = nil)
      full_ctrl_name = @request.env['hk.controller']
      # "ApplicationController" -> "Application".
      full_ctrl_name = full_ctrl_name[0..-11]
      tpl_name ||= @request.env['hk.action']
      tpl_name = '/' + tpl_name.to_s + '.html.erb'
      controller_dir = full_ctrl_name.downcase
      view_dir = HK::Application.root + "/code/app/views/"
      tpl_path = view_dir + controller_dir + tpl_name
      layout_path = view_dir + "application.html.erb"
      Tilt.new(layout_path).render(self) do
        Tilt.new(tpl_path).render(self)
      end
    end

    def request
      @request
    end

    def status(code)
      @response.status = code.to_i
    end

  end # Controller

end ## HK
