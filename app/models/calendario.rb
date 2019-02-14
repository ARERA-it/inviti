class Calendario

  class Interval
    attr_reader :start_dt, :end_dt
    def initialize(start_dt, end_dt)
      @start_dt = start_dt
      @end_dt   = end_dt
    end

    def inside_interval?(dt)
      !outside_interval?(dt)
    end
    def outside_interval?(dt)
      dt<start_dt || dt>end_dt
    end
  end

  class CalDay
    attr_reader :date, :workday, :outer, :region
    attr_accessor :top_line, :bottom_line, :left_line, :right_line
    def initialize(date, workday, outer: false, region: :it)
      @date = date
      @workday = workday
      @outer = outer # outer interval
      @top_line = false
      @bottom_line = false
      @left_line = false
      @right_line = false
      @region = region
    end

    def day
      date.day
    end

    def wday
      date.wday
    end

    def month
      date.month
    end

    def holiday?
      ::Holidays.on(date, region).any?
    end

    def holiday_name
      if ::Holidays.on(date, region).any?
        ::Holidays.on(date, region).first[:name]
      end
    end
  end

  attr_reader :weeks
  def initialize(sd, ed, dtd: 1, workdays: [1,2,3,4,5], region: :it)
    @weeks = []
    week = []

    # sd: desired start date
    # v_sd: visible start date
    interval = Interval.new(sd, ed)
    v_sd = Calendario.calc_visible_start_date(sd, dtd)
    v_ed = Calendario.calc_visible_end_date(ed, dtd)

    v_sd.upto(v_ed).each do |d|
      wday = Calendario.corrected_wday(d, dtd)
      if wday==0 && !week.empty?
        @weeks << week
        week = []
      end
      week << CalDay.new(d, workdays.include?(d.wday), outer: interval.outside_interval?(d), region: region )
    end
    @weeks << week unless week.empty?

    weeks_count = @weeks.size
    @weeks.each_with_index do |week, w_i|
      week.each_with_index do |cal_day, d_i|
        # top
        if w_i>0 && @weeks[w_i-1][d_i].month!=cal_day.month
          cal_day.top_line=true
        end
        # bottom
        if w_i<(weeks_count-1) && @weeks[w_i+1][d_i].month!=cal_day.month
          cal_day.bottom_line=true
        end
        # left
        if d_i>0 && @weeks[w_i][d_i-1].month!=cal_day.month
          cal_day.left_line=true
        end
        # right
        if d_i<6 && @weeks[w_i][d_i+1].month!=cal_day.month
          cal_day.right_line=true
        end
      end
    end
  end

  def Calendario.corrected_wday(date, dtd)
    (date.wday-dtd)%7
  end

  def Calendario.calc_visible_start_date(sd, dtd=0)
    offset = Calendario.corrected_wday(sd, dtd)
    sd-offset.days
  end

  def Calendario.calc_visible_end_date(ed, dtd=0)
    offset = (6-ed.wday+dtd)%7
    ed+offset.days
  end

end
