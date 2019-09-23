class FollowsController < ApplicationController

    def friends
        user = User.find(params[:id])
        render json: user.followees
    end

end