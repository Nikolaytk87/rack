require_relative 'time_formatter'

class TimeApp
  TIME_FORMATS = { second: '%S', minute: '%M', hour: '%H', day: '%d', month: '%m', year: '%Y' }.freeze

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
    body = ["#{result}\n"]
    [200, headers, body]
  end

  def response_with_errors(invalid_params)
    body = ["Unknown time format #{invalid_params}\n"]
    [400, headers, body]
  end

  def headers
    { 'content-type' => 'text/plain' }
  end
end
