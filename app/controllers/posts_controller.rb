class PostsController < ApplicationController
  #post 는 생성,보기,수정,삭제가 가능하다.
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  #post 는 생성한 유저에게는 삭제와 수정이 가능하지만, 나머지는 보기만 가능하다.
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :authorized_user, only: [:edit, :update, :destroy]

  #글 목록 보여주기(페이지는 각 5개씩 보여주도록 페이지네이션 작업(will_paginate 사용))
  def index
    @posts = Post.all.paginate(page: params[:page], per_page: 5)
  end

  #글 Read
  def show
    if @post.user != current_user
      Post.increment_counter(:hits, @id)
    end
  end

  #글 객체 생성
  def new
    @post = current_user.posts.build
  end

  def edit
  end

  #글 생성 작업
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  #글 수정 작업
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  #글 삭제 작업
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #좋아요
  def upvote
    @post = Post.find(params[:id])
    @post.upvote_by current_user
    redirect_to :back
  end
  #싫어요
  def downvote
    @post = Post.find(params[:id])
    @post.downvote_by current_user
    redirect_to :back
  end

  private

    # Callback - 글 초기화 작업
    def set_post
      @id = params[:id]
      @post = Post.find(params[:id])
    end
    # Callback - 유저 확인 작업
    def authorized_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to posts_path, notice: "Not authorized to edit this post" if @post.nil?
    end

    # Cakkbacj - 글 확인 작업
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
