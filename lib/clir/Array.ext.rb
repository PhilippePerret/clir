class Array

  def pretty_join
    return self.first if self.count == 1
    ary = self.dup
    dernier = ary.pop
    ary.join(', ') + ' et ' + dernier.to_s
  end
end
