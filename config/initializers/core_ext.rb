

module KernelMyMethods
  def dice(float)
    k = 1_000_000
    rand(k) < float*k
  end
end


include KernelMyMethods
