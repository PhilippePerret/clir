


# @return [String] La valeur exprimée en euro
# @example
#   €("12")       # => '12 €'
#   €("12", true) # => '12.00 €'
#   €(12.5698)    # => '12.57 €'
# @param [String|Integer|Float] Number to return as euro value
def €(value, with_cents = false)
  if value.is_a?(Integer)
    "#{value}#{".00" if with_cents} €"
  elsif value.to_f.to_s != value.to_s
    raise "Bad value. #{value.inspect} can't be converted to euros."
  else
    n, d = value.to_f.round(2).to_s.split('.')
    d = d.ljust(2,'0')
    "#{n}.#{d} €"
  end
end

# @return [String] Value +value+ as pourcentage
# 
# @example
#   pcent(12)           # => "12 %"
#   pcent(12, 3)        # => "12.000 %"
#   pcent(12.436, 1)    # => "12.4 %"
#   pcent(12.436, true) # => "12.4 %"
#   pcent(12.436, 2)    # => "12.44 %"
# 
# @param value [Integer|String|Float] The value to convert
# @param with_cents [TrueClass|Integer] Decimal value. If true,
#         1 decimal is used ("10.1 %")
# 
def pcent(value, with_cents = nil)
  if value.is_a?(Integer)
    value = value.to_s
  elsif value == value.to_i.to_s
    value = value.to_i.to_s
  elsif value.to_f.to_s != value.to_s
    raise "Bad value. #{value.inspect}:#{value.class} can't be converted to pourcentage."
  end
  with_cents = 1 if with_cents == true
  if with_cents
    n, d = value.to_f.round(with_cents).to_s.split('.')
    d = d.ljust(with_cents,'0')
    value = "#{n}.#{d}"
  end
  "#{value} %"
end
