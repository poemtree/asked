class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
  end

  def create
    post = Post.create(username: params[:username], title: params[:title], content: params[:content])
    flash[:notice] = "글이 작성 되었습니다."
    redirect_to "/posts/show/#{post.id}"
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    Post.find(params[:id]).update(username: params[:username], title: params[:title], content: params[:content])
    flash[:notice] = "글이 수정 되었습니다."
    redirect_to "/posts/show/#{params[:id]}"
  end

  def destroy
    Post.destroy(params[:id])
    flash[:alert] = "글이 삭제 되었습니다."
    redirect_to "/"
  end
end
