class PostsController < ApplicationController
  # 컨트롤러가 실행되면 무조건 먼저 실행되는 함수
  before_action :authorize, except: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def new
  end

  def create
    post = Post.create(post_params)
    flash[:notice] = "글이 작성 되었습니다."
    redirect_to "/posts/#{post.id}"
  end

  def show
    # @post = Post.find(params[:id])
  end

  def edit
    # @post = Post.find(params[:id])
  end

  def update
    # Post.find(params[:id]).update(user_id: current_user.id, title: params[:title], content: params[:content])
    @post.update(post_params)
    flash[:notice] = "글이 수정 되었습니다."
    redirect_to "/posts/#{params[:id]}"
  end

  def destroy
    # Post.destroy(params[:id])
    @post.destroy
    flash[:alert] = "글이 삭제 되었습니다."
    redirect_to "/"
  end

  # 중복되는 구문을 함수로 이용하기
  private
  def set_post
    @post = Post.find(params[:id])
  end

  # 데이터 조적을 막기 위해 허락된 permit만 받도록 설정
  # user_id는 current_user를 활용하여 merge로 붙여준다.
  def post_params
    params.permit(:title, :content).merge(user_id: current_user.user_id)
  end

end
