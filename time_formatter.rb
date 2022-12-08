class TimeFormatter
  TIME_FORMATS = { second: '%S', minute: '%M', hour: '%H', day: '%d', month: '%m', year: '%Y' }.freeze

  attr_reader :format_params

  def initialize(format_params)
    @format_params = format_params.split(',').map(&:to_sym)
  end

  def valid?
    invalid_params.empty?
  end

  def result
    time_formats = TIME_FORMATS.values_at(*format_params).join('-')
    Time.now.strftime(time_formats)
  end

  def invalid_params
    format_params - TIME_FORMATS.keys
  end
end
