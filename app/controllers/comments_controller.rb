class CommentsController < ApplicationController
  before_action :set_comment, only: [ :destroy ]

  # Add a comment
  def create
    current_user = User.advisor.first # TODO: get current_user from session
    options = { user_id: current_user.id }.merge comment_params
    puts options.inspect
    if options['content'].blank?
      render json: { status: 200, message: "Commento assente." }.to_json
    else
      @comment = Comment.new(options)
      respond_to do |format|
        if @comment.save
          format.js # { render js: "$('<li>#{@comment.content}</li>').prependTo('.comments > ul');"}
        else
          format.js { render js: "alert('Qualcosa è andato storto...');" }
        end
      end
    end
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
