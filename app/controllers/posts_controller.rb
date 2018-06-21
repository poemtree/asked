class PostsController < ApplicationController
  # 컨트롤러가 실행되면 무조건 먼저 실행되는 함수
  before_action :authorize, except: [:index]

  def index
    @posts = Post.all
  end

  def new
  end

  def create
    post = Post.create(user_id: current_user.id, title: params[:title], content: params[:content])
    flash[:notice] = "글이 작성 되었습니다."
    redirect_to "/posts/#{post.id}"
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    Post.find(params[:id]).update(user_id: current_user.id, title: params[:title], content: params[:content])
    flash[:notice] = "글이 수정 되었습니다."
    redirect_to "/posts/#{params[:id]}"
  end

  def destroy
    Post.destroy(params[:id])
    flash[:alert] = "글이 삭제 되었습니다."
    redirect_to "/"
  end
end
