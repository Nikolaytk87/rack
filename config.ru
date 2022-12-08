require_relative 'middleware/rundatetime'
require_relative 'app'
require_relative 'middleware/logger'

use RunDateTime
use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
run App.new
