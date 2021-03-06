class AuthenticationController < ApplicationController
    def login 
        @user = User.find_by username: params[:username]

        if !@user
           render json: { message:'incorrect username or password'},
           status: :unauthorized
        else
            if !@user.authenticate(params[:password])
                render json: {message: 'incorrect username or password'},
                status: :unauthorized 
            else 
                secret = Rails.application.secret_key_base
                payload = { user_id: @user.id }
                token = JWT.encode(payload, secret)
                render json: {token: token},
                status: :created
            end
        end
    end
end
