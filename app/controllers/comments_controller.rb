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
          msg = "Commento assente"
        else
          msg = "Qualcosa è andato storto"
        end
        @feedback_hash = { msg: msg, kind: 'alert' }
        format.js { render template: 'comments/failed.js.erb' }
      end
    end
  end


  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content, :invitation_id)
    end
end
