class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  autocomplete :user, :display_name, full: true

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    authorize @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize @user
    @total_interactions_count = UserInteraction.where(user_id: @user.id).count
    @user_interactions        = UserInteraction.where(user_id: @user.id).limit(100)
    @user_interactions_aggreg = UserInteractionAggregated.new(10.minutes)
    @user_interactions_aggreg.aggregate(@user_interactions.to_a)
  end


  # GET /users/new
  def new
    authorize User
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new
    @user.update_attributes permitted_attributes(@user)
    authorize @user
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "L'utente è stato creato con successo." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user
    respond_to do |format|
      if @user.update(permitted_attributes(@user))
        format.html { redirect_to @user, notice: "L'utente è stato modificato con successo." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "L'utente è stato eliminato." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(policy(@user).permitted_attributes)
    end
end
