class ApplicationController < ActionController::API
    
    def issue_token(payload)
        JWT.encode(payload, ENV["SOME_SECRET"], ENV["SOME_SUPER_SECRET"])
    end

    def decode(jwt_token)
        my_algorithm = { algorithm: ENV["SOME_SUPER_SECRET"]}
        JWT.decode(jwt_token, ENV["SOME_SECRET"], true, my_algorithm)[0]
    end

    def current_user(jwt_token)
        byebug 
        # pull jwt token out of request.headers (assumed to be in format: {Authorization: "Token token=xxx"})
        # authenticate_or_request_with_http_token do |jwt_token, options|
            decoded_token = decode(jwt_token)
            # if a decoded token is found, use it to return a user
            # if decoded_token
                user_id = decoded_token[0]["user_id"]
                @current_user ||= User.find_by(id: user_id)
            # end
        # end
    end




    
end
