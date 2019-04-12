class InvitationCalendar

  def self.generate_ics(inv, url)
    cal = Icalendar::Calendar.new
    cal.event do |e|

      e.dtstart     = inv.from_date_and_time
      if inv.to_date_and_time
        e.dtend       = inv.to_date_and_time
      else
        e.dtend       = inv.from_date_and_time + 1.hour
      end
      e.summary     = inv.title
      e.description = inv.notes
      e.ip_class    = "PRIVATE"
      e.organizer   = inv.organizer
      e.location    = inv.location
      e.url         = url
    end
    return [cal.to_ical, "invito_#{inv.id}.ics"]
  end
end
