class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # 헬퍼 메소드로 만든다!
  helper_method :current_user
  def current_user
    # session에 저장되어있는 경우
    # @user에 User을 찾아서 저장한다.
    # ||= 연산을 사용하면 @user가 비어있는 경우에만 연산을 실행한다!
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :authorize
  def authorize
    if current_user.nil?
      flash[:alert] = "로그인을 해주세요."
      redirect_to '/login'
    end
  end

end
