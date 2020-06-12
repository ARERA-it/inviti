class CommentsController < ApplicationController
  before_action :set_comment, only: [ :destroy ]

  # Add a comment
  def create
    authorize Comment
    options = { user_id: current_user.id }.merge comment_params
    # "comment"=>{"invitation_id"=>"33", "content"=>"Un commento"}

    @comment = Comment.new(options)
    respond_to do |format|
      if @comment.save
        @feedback_hash = { msg: "" }
        format.js {}
      else
        if @comment.content.blank?
          @feedback_hash = { msg: "Commento assente", kind: 'alert' }
        else
          @feedback_hash = { msg: "Qualcosa è andato storto", kind: 'alert' }
        end
        format.js { render template: 'comments/failed.js.erb' }
      end
    end



    #
    # if options['content'].blank?
    #   render json: { status: 200, message: "Commento assente." }.to_json
    # else
    #   @comment = Comment.new(options)
    #   respond_to do |format|
    #     if @comment.save
    #       format.js
    #     else
    #       format.js { render template: 'shared/wrong.js.erb' }
    #     end
    #   end
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :invitation_id)
    end
end
