class Integer

  # @return TRUE if self is inside +ary+ or has key self
  # @param ary {Range|Array|Hash}
  def in?(ary)
    case ary
    when Array, Range
      ary.include?(self)
    when Hash
      ary.key?(self)
    else
      raise "Integer#in? waits for a Array, an Hash or a Range. Given: #{ary.class}."
    end
  end

  def semaine
    self * 7  * 3600 * 24
  end
  alias :semaines   :semaine
  alias :week       :semaine
  alias :weeks      :semaine

  # For 4.jours / 4.days
  def jour
    self * 3600 * 24
  end
  alias :jours  :jour
  alias :day    :jour
  alias :days   :jour

  def heure
    self * 3600
  end
  alias :heures :heure
  alias :hour   :heure
  alias :hours  :heure

  def minute
    self * 60
  end
  alias :minutes :minute

end 
