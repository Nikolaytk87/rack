require_relative 'time_formatter'

class TimeApp
  def call(env)
    request = Rack::Request.new(env)
    handle(request)
  end

  private

  def handle(request)
    return response_with_errors([]) if request.params['format'].nil?

    format_params = request.params['format']
    formatter = TimeFormatter.new(format_params)
    if formatter.valid?
      response_with_ok(formatter.result)
    else
      response_with_errors(formatter.invalid_params)
    end
  end

  def response_with_ok(result)
    body = "#{result}\n"
    Rack::Response.new(body, 200).finish
  end

  def response_with_errors(invalid_params)
    body = "Unknown time format #{invalid_params}\n"
    Rack::Response.new(body, 400).finish
  end
end
