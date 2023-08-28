class Symbol

  # @return TRUE if self is inside +ary+ or has key self
  # @param ary {Range|Array|Hash}
  def in?(ary)
    case ary
    when Array
      ary.include?(self)
    when Hash
      ary.key?(self)
    else
      raise "Symbol#in? waits for a Array or an Hash. Given: #{ary.class}."
    end
  end

  def camelize
    self.to_s.camelize
  end

end 
