module CalendarioHelper

  def cell_classes(cal_date)
    arr = []
    arr << (cal_date.outer ? 'outer' : 'inner')
    arr << (cal_date.workday ? 'workday' : 'non_workday')
    arr << (cal_date.date==Date.today ? 'today' : nil)
    [:top, :bottom, :left, :right].each do |direction|
      arr << ("#{direction}_line" if cal_date.send("#{direction}_line"))
    end
    arr << (cal_date.holiday? ? 'holiday' : nil)
    arr.compact.join(" ")
  end

end
