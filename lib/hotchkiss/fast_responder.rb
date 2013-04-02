class FastResponder < HK::Controller

  def favicon
    @favicon = HK::Application.favicon
    status @favicon.nil? ? 500 : 200
    @favicon
  end

  def on_exception
    e = request.env["hk.exception"]
    status 500
    @class = e.class
    @message = e.message
    @backtrace = e.backtrace
    "<html><title>ERROR</title><body>#{@class} : #{@message}<br />#{@backtrace.join("<br />")}</body><html>"
  end

end
