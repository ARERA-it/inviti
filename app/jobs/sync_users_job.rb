
class SyncUsersJob < ApplicationJob
  queue_as :default


  # SyncUsersJob.perform_now
  def perform(*args)
    # Do something later

    added_users = []
    PersonnelManagement.all.each do |p|
      # p: {
      #   "id"=>1,
      #   "tipo_utente"=>"Standard",
      #   "sAMAccountName"=>"JOHNWICK",
      #   "stato"=>"Attivo",
      #   "data transizione"=>"30/12/2002"
      # }

      # puts p

      username = p["sAMAccountName"].downcase
      active   = p["stato"].downcase=="attivo"
      begin
        if active
          u = User.find_by(username: username)
          if u.nil? && (person = PersonnelManagement.find(p["id"]))
            # add new user
            logger.info "Found new user: adding '#{person["displayname"]}'"
            User.create(
              username: username,
              display_name: person["displayname"]
            )
            added_users << person["displayname"]
          end
        end

      rescue ExceptionName
        logger.error "Error on sync user job"
      end
    end

    if added_users.any?
      AddUserNotificationMailer.with(display_names: added_users.join(', ')).added_these.deliver_later
    end


    # person = PersonnelManagement.find(177)
    # puts person



  end
end
