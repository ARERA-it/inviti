class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
  end

  def search_by_name
    u = User.find_by(display_name: params[:name].strip)
    respond_to do |format|
      if u
        format.json { render json: {id: u.id, name: u.display_name} }
      end
    end
  end


  # GET /users/new
  def new
    authorize :user
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # POST /users
  # POST /users.json
  def create
    authorize :user
    @user = User.new
    @user.update_attributes permitted_attributes(@user)
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
