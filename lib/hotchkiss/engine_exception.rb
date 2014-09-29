class EngineException < HK::Controller

  def on_exception
    e = request.env["hk.exception"]
    status(500)
    @class = e.class
    @message = e.message
    @backtrace = e.backtrace
    "<html><title>ERROR</title><body>#{@class} : #{@message}<br />#{@backtrace.join("<br />")}</body><html>"
  end

end
