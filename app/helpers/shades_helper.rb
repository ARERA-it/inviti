module ShadesHelper

  def shaded_cell_classes(cal_date, value, max_value, color: 'green')
    value = 0.0 if value.nil?
    v = (value*10.0/max_value).ceil
    arr = []
    arr << 'inner'
    arr << "shade-#{color}"
    arr << "shade-#{v}"
    [:top, :bottom, :left, :right].each do |direction|
      arr << ("#{direction}_line" if cal_date.send("#{direction}_line"))
    end
    arr.compact.join(" ")
  end


  def twentyfour_hours_shaded_cell_classes(hour, value, max_value, color: 'green')
    value = 0.0 if value.nil?
    max_value = 1.0 if value.nil?
    v = (value*10.0/max_value).ceil
    arr = []
    arr << "shade-#{color}"
    arr << "shade-#{v}"
    arr.compact.join(" ")
  end

end
