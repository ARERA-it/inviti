class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    authorize Group
    @groups = Group.all
  end


  # GET /groups/1
  # GET /groups/1.json
  def show
    authorize @group
  end

  # GET /groups/new
  def new
    @group = Group.new
    authorize @group
  end

  # GET /groups/1/edit
  def edit
    authorize @group
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    authorize @group

    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_url, notice: 'Il gruppo è stato creato correttamente.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    authorize @group
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to groups_url, notice: 'Il gruppo è stato modificato correttamente.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    authorize @group
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Il gruppo è stato eliminato correttamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :in_use, user_ids: [])
    end
end
