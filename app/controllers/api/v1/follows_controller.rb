class Api::V1::FollowsController < ApplicationController

    def friends
        user = User.find(params[:id])
        render json: user.followees
    end

end