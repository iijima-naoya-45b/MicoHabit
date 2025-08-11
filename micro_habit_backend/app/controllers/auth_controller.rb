class AuthController < ApplicationController
  class OauthsController < ApplicationController
    skip_before_action :require_login
  
    def oauth
      login_at(params[:provider])
    end
  
    def callback
      provider = params[:provider]
      if @user = login_from(provider)
        redirect_to root_path, notice: "Logged in from #{provider.titleize}!"
      else
        begin
          @user = create_from(provider)
          reset_session # protect from session fixation attack
          auto_login(@user)
          redirect_to root_path, notice: "Logged in from #{provider.titleize}!"
        rescue
          redirect_to root_path, alert: "Failed to login from #{provider.titleize}!"
        end
      end
    end
  end

    def login
      user = User.find_by(email: params[:email])
  
      if user && user.authenticate(params[:password])
        render json: { token: user.generate_jwt }
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    def register
        user = User.find_or_create_by(email: params[:email]) do |u|
          u.password = params[:password]
          u.password_confirmation = params[:password_confirmation]
        end
      
        if user.persisted?
          render json: { token: user.generate_jwt }
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
    private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end