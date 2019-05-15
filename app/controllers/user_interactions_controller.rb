class UserInteractionsController < ApplicationController
  before_action :set_user_interaction, only: [:show, :edit, :update, :destroy]

  # GET /user_interactions
  # GET /user_interactions.json
  def index
    authorize :user_interaction
    @user_interactions = UserInteraction.limit(200)

    first_date_available = UserInteraction.last.created_at.to_date # last because of default_scope
    interval             = 3.month
    @today               = Date.today
    dfd                  = 1 # desired first day of calendar (1: monday)

    t1 = Time.zone.parse([@today - interval, first_date_available].max.to_s)
    t2 = Time.zone.parse((@today + 1.day).to_s)

    @ui         = UserInteraction.unscoped.where("created_at BETWEEN ? AND ?", t1, t2).group("date(created_at)").order(date_created_at: :desc).count
    @calendario = Calendario.new(t1.to_date, t2.to_date, dtd: dfd, workdays: [1,2,3,4,5])
    @ui_max     = @ui.values.max

    # 24 hours
    query_one_day(@today)
  end


  def daytail
    @today = Date.parse params[:date]
    query_one_day(@today)

    respond_to do |format|
      format.js {}
    end
  end


  private
    def query_one_day(date)
      t1 = Time.zone.parse(date.to_s)
      t2 = Time.zone.parse((date+1.day).to_s)
      offset = t1.utc_offset
      hash     = UserInteraction.unscoped.where("created_at BETWEEN ? AND ?", t1, t2).group("EXTRACT(HOUR FROM created_at)").count
      @ui_day  = Hash[hash.map{|k, v| [((k+offset/3600)%24).to_i, v]}]
      @ui_day_max = @ui_day.values.max
    end
end
