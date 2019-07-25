

module KernelMyMethods
  def dice(float)
    k = 1_000_000
    rand(k) < float*k
  end
end


include KernelMyMethods


class String

  # Strip the RedCarpet <p> tags
  def rc_unwrap_p
    Regexp.new(/\A<p>(.*)<\/p>\Z/m).match(self)[1] rescue self
  end

end
