module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show]

      def index
        users = policy_scope(User)

        render json: users.map { |user| UserSerializer.call(user) }
      end

      def show
        authorize @user

        render json: UserSerializer.call(@user)
      end

      private

      def set_user
        @user = User.find_by!(public_id: params[:public_id])
      end
    end
  end
end
