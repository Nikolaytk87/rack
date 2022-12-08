class App
  def call(env)
    [status, headers, body]
  end

  private

  def status
    200
  end

  def headers
    { 'content-type' => 'text/plain' }
  end

  def body
    ["Welcome !\n"]
  end
end
