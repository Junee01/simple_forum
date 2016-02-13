class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]


  #댓글 새로 생성하기
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: '새로운 댓글이 달렸습니다.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  #댓글 삭제하기
  def destroy
    @comment.destroy
    respond_to do |format|
      #redirect_to :back 뒤로가기, 다른거로 하면 에러남
      format.html { redirect_to :back, notice: '댓글이 성공적으로 삭제되었습니다.' }
      format.json { head :no_content }
    end
  end

  private
    # Callback - 주석 초기화(해당 아이디 값에 해당하는 주석을 가져온다.)
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:post_id, :body, :user_id)
    end
end
