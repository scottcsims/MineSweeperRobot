require 'log4r-color'

include Log4r

Log4r::Logger.global.level = ALL

Log4r::ColorOutputter.new 'color', {:colors =>
  {
    :debug  => :blue,
    :info   => :light_blue,
    :warn   => :yellow,
    :error  => :red,
    :fatal  => {:color => :red, :background => :white}
  },
  :formatter => PatternFormatter.new(:pattern => "[%d:#{$$}:%l] %m")
}

Log4r::Logger.new('color_logger', DEBUG).add('color')

Log = Log4r::Logger['color_logger']

$DEBUG_AUTO ||= ENV['DEBUG_AUTO']

Log.level = $DEBUG_AUTO ? DEBUG : INFO

Log.debug 'Logging Started'