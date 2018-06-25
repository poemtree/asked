class SessionsController < ApplicationController

    def new
    end

    def create
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

    def destroy
      session.clear
      flash[:notice] = "로그아웃 되었습니다."
      redirect_to "/"
    end

end
