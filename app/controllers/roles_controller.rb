class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /roles
  # GET /roles.json
  def index
    authorize Role
    @roles = Role.all
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    authorize @role
  end

  def duplicate
    @role = Role.find params[:role_id]
    authorize @role

    respond_to do |format|
      if @role = @role.duplicate
        format.html { redirect_to edit_role_path(@role), notice: 'Role was successfully duplicated.' }
      else
        format.html { render :index }
      end
    end
  end

  # GET /roles/1/edit
  def edit
    authorize @role
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    authorize @role
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    authorize @role
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :description, permission_roles_attributes: [ :id, :permission_id, :permitted ])
    end
end
