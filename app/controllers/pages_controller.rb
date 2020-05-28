class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome if Rails.env!="development"
  layout 'layouts/welcome', only: :welcome

  def welcome
  end

  def dashboard
    @follow_ups = PagePolicy::Scope.new(current_user, FollowUp).resolve_follow_ups(page: params[:page])
  end


  def stats

  end


  def decisions_chart_data
    labels = []
    datasets = [
      { label: "In attesa", bg_color: 'rgba(104, 114, 121, 0.5)', data: [] },
      { label: "Rifiutati", bg_color: 'rgba(178, 27, 19, 0.5)', data: [] },
      { label: "Accettati", bg_color: 'rgba(42, 121, 18, 0.5)', data: [] },
    ]
    sum_per_month = []
    # sum_per_datasets = []

    d = Date.today
    12.times do
      d1 = Date.new(d.year, d.month, 1)
      d2 = d1 + 1.month - 1.day
      i  = Invitation.where("?<=from_date_and_time AND from_date_and_time<=?", d1, d2)

      labels.unshift "#{I18n.t('date.abbr_month_names')[d1.month]} #{d1.year}"
      wa = i.count{|e| e.decision=='waiting'}
      no = i.count{|e| e.decision=='do_not_participate'}
      pa = i.count{|e| e.decision=='participate'}
      datasets[0][:data].unshift wa
      datasets[1][:data].unshift no
      datasets[2][:data].unshift pa
      sum_per_month.unshift wa+no+pa
      d = d - 1.month
    end

    # datasets.each_with_index do |el, i|
    #   sum_per_datasets[i] = datasets[2][:data].sum
    # end

    render :json => { labels: labels, datasets: datasets, sum_per_month: sum_per_month }
    # render :json => { labels: labels, datasets: datasets, sum_per_month: sum_per_month, sum_per_datasets: sum_per_datasets }
  end



  def appointees_chart_data
    people_count = 7 # i'll count the best 'people_count' appointees
    colors = [
      'rgba(165,42,42, 0.5)',
      'rgba(255,99,71, 0.5)',
      'rgba(255,165,0, 0.5)',
      'rgba(189,183,107, 0.5)',
      'rgba(128,128,0, 0.5)',
      'rgba(0,128,0, 0.5)',
      'rgba(30,144,255, 0.5)',
      'rgba(138,43,226, 0.5)',
      'rgba(255,20,147, 0.5)',
      'rgba(160,82,45, 0.5)',
    ] # https://www.rapidtables.com/web/color/RGB_Color.html
    sum_per_month = []

    d    = Date.today
    d1   = Date.new(d.year, d.month, 1)-11.months
    d2   = Date.new(d.year, d.month, 1)+1.month-1.day
    hash = Appointee.joins(:invitation).where("?<=from_date_and_time AND from_date_and_time<=?", d1, d2).group(:user_id).count
    arr  = hash.to_a.sort{|b,c| c[1]<=>b[1]}.first(people_count) # [[30, 37], [3, 24], [5, 15], [4, 15], [2, 9]]

    users    = arr.map{|e| User.find(e.first) rescue nil}
    labels   = []
    datasets = []
    arr.each_with_index do |e, i|
      datasets << { label: (users[i] ? users[i].name : "Utente sconosciuto"), bg_color: colors[i], data: [] }
    end

    d = Date.today
    12.times do
      d1 = Date.new(d.year, d.month, 1)
      d2 = d1 + 1.month - 1.day
      i  = Invitation.where("?<=from_date_and_time AND from_date_and_time<=?", d1, d2)

      labels.unshift "#{I18n.t('date.abbr_month_names')[d1.month]} #{d1.year}"
      sum = 0
      users.each_with_index do |user, i|
        c = Appointee.joins(:invitation).where("?<=invitations.from_date_and_time AND invitations.from_date_and_time<=? AND appointees.user_id=?", d1, d2, user.id).count
        datasets[i][:data].unshift c
        sum += c
      end
      sum_per_month.unshift sum
      d = d - 1.month
    end
    render :json => { labels: labels, datasets: datasets, sum_per_month: sum_per_month }
  end
end
