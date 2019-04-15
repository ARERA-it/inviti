class InvitationCalendar

  def self.generate_ics(inv, url)
    cal = Icalendar::Calendar.new
    description = []
    description << inv.notes << "\n" if !inv.notes.blank?
    description << "Organizzazione: #{inv.organizer}" if !inv.organizer.blank?
    description << "URL invito: <a href='#{url}'>#{url}</a>"

    cal.event do |e|
      e.dtstart     = inv.from_date_and_time
      if inv.to_date_and_time
        e.dtend     = inv.to_date_and_time
      else
        e.dtend     = inv.from_date_and_time + 1.hour
      end
      e.summary     = inv.title
      e.description = description.join("\n")
      e.ip_class    = "PRIVATE"
      # e.organizer   = inv.organizer # deve essere un ind. email
      e.location    = inv.location
      e.url         = url
      # e.comment     = "this is a comment\n2nd line"
    end
    return [cal.to_ical, "invito_#{inv.id}.ics"]
  end
end
