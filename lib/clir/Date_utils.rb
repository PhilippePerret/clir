=begin
  
  Usefull methods for date & time

  @author: Philippe Perret <philippe.perret@yahoo.fr>

=end
require 'date'

MOIS = {
  1 => {court: 'jan', long: 'janvier'},
  2 => {court: 'fév', long: 'février'},
  3 => {court: 'mars', long: 'mars'},
  4 => {court: 'avr', long: 'avril'},
  5 => {court: 'mai', long: 'mai'},
  6 => {court: 'juin', long: 'juin'},
  7 => {court: 'juil', long: 'juillet'},
  8 => {court: 'aout', long: 'aout'},
  9 => {court: 'sept', long: 'septembre'},
  10 => {court: 'oct', long: 'octobre'},
  11 => {court: 'nov', long: 'novembre'},
  12 => {court: 'déc', long: 'décembre'}
}

DAYNAMES = [
  'Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'
]


# @return [String] Une date formatée avec le moins verbal
# 
# @param [Time|Date|NIl] La date. Si non fournie, on prend maintenant
# @param [Hash] options Les options de formatage
# @option lenght [Symbol] :court (pour le mois court)
def human_date(ladate = nil, **options)
  ladate ||= Time.now
  options.key?(:length) || options.merge!(length: :long)
  lemois = MOIS[ladate.month][options[:length]]
  lemois = "#{lemois}." if options[:length] == :court
  "#{ladate.day} #{lemois} #{ladate.year}"
end
alias :date_humaine :human_date


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
# @param [Hash] options table:
# @option options [Boolean] :verbal     If true, the format will be "month the day-th etc."
# @option options [Boolean] :no_time    If true, only day, without time
# @option options [Boolean] :seconds    If true, add seconds with time
# @option options [Boolean] :update_format If true, the format is updated. Otherwise, the last format is used for all next date
# @option options [Boolean] :sentence   If true, on met "le ... à ...."
# 
def formate_date(date, options = nil)
  options ||= {}
  @last_format = nil if options[:update_format] || options[:template]
  @last_format ||= begin
    as_verbal = options[:verbal]||options[:sentence]
    if options[:template]
      options[:template]
    else
      fmt = []
      fmt << 'le ' if options[:sentence]
      if as_verbal
        forday = date.day == 1 ? '1er' : '%-d'
        fmt << "#{forday} #{MOIS[date.month][:long]} %Y" 
      else
        fmt << '%d %m %Y'
      end
      delh = options[:sentence] ? 'à' : '-'
      unless options[:no_time]
        fmt << (as_verbal ? " à %H h %M" : " #{delh} %H:%M")
      end
      if options[:seconds]
        fmt << (as_verbal ? ' mn et %S s' : ':%S' )
      end
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
