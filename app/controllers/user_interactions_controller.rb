class UserInteractionsController < ApplicationController
  before_action :set_user_interaction, only: [:show, :edit, :update, :destroy]

  # GET /user_interactions
  # GET /user_interactions.json
  def index
    # authorize :user_interaction
    authorize :page, :web_app_stats?, policy_class: PagePolicy

    @display_name = params[:display_name]
    @display_name = "" if params[:commit]=="Tutti" || params[:commit]=="All" # TODO: localize!
    @user = User.find_by(display_name: @display_name)

    ui_limit = 200 # User interactions limit

    interval             = 3.month
    @today               = Date.today
    dfd                  = 1 # desired first day of calendar (1: monday)
    t2 = Time.zone.parse((@today + 1.day).to_s)
    if @user
      @total_interactions_count = UserInteraction.where(user_id: @user.id).count
      @user_interactions        = UserInteraction.where(user_id: @user.id).limit(ui_limit)
      first_date_available      = UserInteraction.where(user_id: @user.id).last.created_at.to_date rescue @today # last because of default_scope
      t1                        = Time.zone.parse([@today - interval, first_date_available].max.to_s)
      @ui                       = UserInteraction.unscoped.where(user_id: @user.id).where("created_at BETWEEN ? AND ?", t1, t2).group("date(created_at)").order(date_created_at: :desc).count
    else
      @total_interactions_count = UserInteraction.count
      @user_interactions        = UserInteraction.limit(ui_limit)
      first_date_available      = UserInteraction.last.created_at.to_date # last because of default_scope
      t1                        = Time.zone.parse([@today - interval, first_date_available].max.to_s)
      @ui                       = UserInteraction.unscoped.where("created_at BETWEEN ? AND ?", t1, t2).group("date(created_at)").order(date_created_at: :desc).count
    end

    @user_interactions_aggreg = UserInteractionAggregated.new(10.minutes)
    @user_interactions_aggreg.aggregate(@user_interactions.to_a)


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
