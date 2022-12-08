=begin
  
  Usefull methods for date & time

  @author: Philippe Perret <philippe.perret@yahoo.fr>

=end
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
