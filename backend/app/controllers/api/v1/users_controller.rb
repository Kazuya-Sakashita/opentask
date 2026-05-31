module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show update]

      def index
        users = policy_scope(User)

        render json: users.map { |user| UserSerializer.call(user) }
      end

      def show
        authorize @user

        render json: UserSerializer.call(@user)
      end

      def update
        authorize @user

        if @user.update(user_params)
          render json: UserSerializer.call(@user)
        else
          render_validation_error(@user)
        end
      end

      private

      def set_user
        @user = User.find_by!(public_id: params[:public_id])
      end

      def user_params
        params.require(:user).permit(:name)
      end
    end
  end
end
