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
      raise "Integer#in? waits for a Array or a Range. Given: #{ary.class}."
    end
  end

end 
