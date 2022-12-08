class App
  OK = 200
  WRONG_FORMAT = 400
  NOT_FOUND = 404
  FORMAT_PARAMS = { second: '%s', minute: '%M', hour: '%H', day: '%d', month: '%m', year: '%Y' }.freeze

  attr_reader :env, :path, :query, :method

  def call(env)
    setenv_values(env)
    handle_request
  end

  private

  def handle_request
    if method == 'GET' && path == '/time' && wrong_params.empty?
      [OK, headers, body[:ok]]
    elsif path == '/time' && wrong_params.any?
      [WRONG_FORMAT, headers, body[:wrong_format]]
    else
      [NOT_FOUND, headers, body[:not_found]]
    end
  end

  def setenv_values(env)
    @env = env
    @path, @query, @method = env.values_at('PATH_INFO', 'QUERY_STRING', 'REQUEST_METHOD')
  end

  def time_params
    Hash[FORMAT_PARAMS.keys.zip Time.now.strftime(FORMAT_PARAMS.values.join('-')).split('-')]
  end

  def query_string_params
    query.delete_prefix('format=').split('%2C').map!(&:to_sym)
  end

  def user_response
    time_params.values_at(*query_string_params).join('-')
  end

  def wrong_params
    query_string_params - FORMAT_PARAMS.keys
  end

  def headers
    { 'content-type' => 'text/plain' }
  end

  def body
    {
      ok: ["#{user_response}\n"],
      wrong_format: ["Unknown time format #{wrong_params}\n"],
      not_found: ["Not Found\n"]
    }
  end
end
