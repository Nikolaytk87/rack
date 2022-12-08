require_relative 'time_app'

ROUTES = {
  '/time' => TimeApp.new
}

run Rack::URLMap.new(ROUTES)
