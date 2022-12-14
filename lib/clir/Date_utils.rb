=begin
  
  Usefull methods for date & time

  @author: Philippe Perret <philippe.perret@yahoo.fr>

=end
require 'date'

# @return A date for a file, now
# @example
#   date_for_file # => "2022-12-14"
#   date_for_file(nil, true) # => "2022-12-14-23-11"
def date_for_file(time = nil, with_hour = false, del = '-')
  time ||= Time.now
  fmt = "%Y#{del}%m#{del}%d"
  fmt = "#{fmt}#{del}%H#{del}%M" if with_hour
  time.strftime(fmt)
end

# @return Date corresponding to +foo+
# @param [String|Integer|Time|Date] foo
#           - [Time] Return itself
#           - [Date] Return itself.to_time
#           - [String] JJ/MM/AAAA or 'YYYY/MM/DD'
#           - [Integer] Number of seconds
# @note
#   Alias :time_from (more semanticaly correct)
# 
def date_from(foo)
  case foo
  when Time then foo
  when Date then foo.to_time
  when Integer    then Time.at(foo)
  when String
    a, b, c = foo.split('/')
    if c.length == 4
      Time.new(c.to_i, b.to_i, a.to_i)
    else
      Time.new(a.to_i, b.to_i, c.to_i)
    end
  else
    raise "Unable to transform #{foo.inspect} to Time."
  end
end
alias :time_from :date_from

##
# Formate de date as JJ MM AAAA (or MM JJ AAAA in english)
# @param {Time} date
# @param {Hash} Options table:
#   :no_time    Only day, without time
#   :seconds    Add seconds with time
#   :update_format    If true, the format is updated. Otherwise, the
#                     last format is used for all next date
#   :sentence   Si true, on met "le ... à ...."
# 
def formate_date(date, options = nil)
  options ||= {}
  @last_format = nil if options[:update_format] || options[:template]
  @last_format ||= begin
    if options[:template]
      options[:template]
    else
      fmt = []
      fmt << 'le ' if options[:sentence]
      fmt << '%d %m %Y'
      delh = options[:sentence] ? 'à' : '-'
      fmt << " #{delh} %H:%M" unless options[:no_time]
      fmt << ':%S' if options[:seconds]
      fmt.join('')
    end
  end
  date.strftime(@last_format)
end

class Time

  # @return [String] French date with separator
  # @example
  #   Time.now.jj_mm_yyyy # => "28/12/2022"
  # @param separator [String] Separator to use (default: '/')
  def jj_mm_aaaa(separator = '/')
    self.strftime(['%d','%m','%Y'].join(separator))
  end

  # @return [String] English date with separator
  # @example
  #   Time.now.mm_dd_yyyy # => "12/28/2022"
  # 
  # @param separator [String] Separator to use (default: '/')
  def mm_dd_yyyy(separator = '/')
    self.strftime(['%m','%d','%Y'].join(separator))
  end

end #/class Time

class Integer

  def ago
    (Time.now - self).mm_dd_yyyy
  end

end #/class Integer

def ilya(laps, options = nil)
  options ||= {}
  (Time.now - laps).jj_mm_aaaa(options[:separator] || '/')
end
