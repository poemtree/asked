class UsersController < ApplicationController

  def posts
    @posts = current_user.posts
  end

  def index
  end

  def new
  end

  def create
    address = :back
    if params[:email] == ""
      flash[:alert] = "email을 입력해주세요"
    elsif User.find_by(email: params[:email])
       flash[:alert] = "이미 가입된 email 입니다."
    elsif params[:password] == ""
      flash[:alert] = "비밀번호를 입력해주세요."
    else
      @user = User.new(username: params[:username], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
      if @user.save
        flash[:notice] = "#{params[:username]}님의 가입이 완료되었습니다."
        address = "/"
      else
        flash[:alert] = "비밀번호가 일치하지 않습니다."
      end
    end
    redirect_to address
  end

  def login
  end

  def loginprocess
    address = :back
    user = User.find_by(email: params[:email])
    if user
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:notice] = "안녕하세요 #{user.username}님!"
        address = "/"
      else
        flash[:alert] = "비밀번호가 일치하지 않습니다."
      end
    else
      flash[:alert] = "가입되지 않은 이메일입니다."
    end
    redirect_to address
  end

  def logout
    session.clear
    flash[:notice] = "로그아웃 되었습니다."
    redirect_to "/"
  end

  # def index
  # end
  #
  # def new
  # end
  #
  # def create
  #   address = :back
  #   if params[:email] == ""
  #     flash[:alert] = "email을 입력해주세요"
  #   elsif User.find_by(email: params[:email])
  #      flash[:alert] = "이미 가입된 email 입니다."
  #   else
  #     if params[:password] == ""
  #       flash[:alert] = "비밀번호를 입력해주세요"
  #     elsif params[:password_confirmation] == ""
  #       flash[:alert] = "비밀번호 확인을 해주세요"
  #     elsif params[:password] != params[:password_confirmation]
  #       flash[:alert] = "비밀번호가 일치하지 않습니다."
  #     else
  #       User.create(username: params[:username], email: params[:email], password: params[:password])
  #       flash[:notice]  = "#{params[:username]}님의 가입이 완료되었습니다."
  #       address = "/"
  #     end
  #   end
  #   redirect_to address
  # end

end
