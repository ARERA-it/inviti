class ProjectsController < ApplicationController
  before_action :set_project

  def edit
    authorize @project
  end


  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    authorize @project
    respond_to do |format|
      if @project.update(comment_params)
        format.html { redirect_to edit_project_path(@project), notice: "Le impostazioni sono state salvate con successo." }
        # format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        # format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  private

    def comment_params
      params.require(:project).permit(:president_can_assign)
    end

    def set_project
      @project = Project.primo
    end
end
