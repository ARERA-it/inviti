module FakeInvitations
  extend ActiveSupport::Concern

  included do
    # put here instance methods
  end

  class_methods do
    # Invitation.create_fake_records(30, email_status_only: true)
    def create_fake_records(size=30, email_status_only: false)
      a1 = ["Congresso", "Simposio", "Convegno", "Meeting", "Evento"]
      a2 = ["Trasmissione televisiva"]
      a23 = ["Rai 1", "Rai 2", "Rai 3", "Canale 5", "La7", "Sky"]
      example_pdfs = Dir[File.join(Rails.root, 'example_pdfs', '*')]
      appointeeables = User.appointeeable.pluck(:id)
      advisor_ids = User.all.pluck(:id) # User.advisor.pluck(:id)

      size.times do
        stato = email_status_only ? 0 : rand(6)
        # stato 0: solo dati email
        # stato 1: dati compilati
        # stato 2: parere espresso
        # stato 3: partecipante assegnato
        # stato 4: invito rifiutato
        # stato 5: invito passato
        org = nil
        subj = dice(0.5) ? "#{a1.sample} #{org = Faker::University.name}" : "#{a2.sample} #{org = a23.sample}"
        # from_dt = Faker::Time.between(2.weeks.ago, 3.weeks.from_now, :all)
        from_dt = Faker::Time.between_dates(from: 2.weeks.ago, to: 3.weeks.from_now, period: :day)

        appointee_id = nil    # id incaricato
        # alt_appointee_name = nil  # nome incaricato
        if stato>2
          appointee_id = appointeeables.sample
          # if dice(0.167)
          #   alt_appointee_name = Faker::Name.name
          # else
          #   appointee_id = appointeeables.sample
          # end
        end
        email_body = Faker::Lorem.paragraph

        i = Invitation.create(
          email_id: (Invitation.last.try(:email_id) || 1000).to_i + 1,
          email_from_name: Faker::Name.name,
          email_from_address: Faker::Internet.email,
          email_subject: subj,
          email_body_preview: Faker::Lorem.sentence,
          email_body: email_body,
          email_decoded: email_body,
          email_received_date_time: Faker::Time.between_dates(from: 6.weeks.ago, to: 2.weeks.ago, period: :all),
          location: stato>0 ? Faker::Address.city : nil,
          from_date_and_time: stato>0 ? from_dt : nil,
          to_date_and_time: stato>0 ? (dice(0.5) ? from_dt+2.hour : nil): nil,
          organizer: stato>0 ? org : nil,
          notes: stato>0 && dice(0.2) ? Faker::Lorem.paragraph : nil,
          appointee_id: appointee_id,
          # alt_appointee_name: alt_appointee_name,
          delegation_notes: dice(0.25) ? Faker::Lorem.sentence : ""
        )
        if i.nil?
          puts i.errors
        end
        if i && stato>1
          Opinion.create(user_id: advisor_ids.sample, invitation_id: i.id, selection: Opinion::CHOICES[1..-1].sample)
          # i.create_opinion(user_id: advisor_ids.sample, selection: Opinion::CHOICES[1..-1].sample)
        end
        if dice(0.4)
          pdfs = example_pdfs.clone.shuffle
          pdf = pdfs.pop
          i.files.attach(io: File.open(pdf), filename: File.basename(pdf))
          if dice(0.4) # a second file will be attached
            pdf = pdfs.pop
            i.files.attach(io: File.open(pdf), filename: File.basename(pdf))
          end
        end
      end
    end
  end
end
