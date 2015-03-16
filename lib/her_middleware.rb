require "her_middleware/version"

module HerMiddleware
  class Web < Faraday::Middleware
    def call(env)
      if token = Thread.current[:access_token]
        env[:request_headers]['Authorization'] = "Bearer #{token}"
      end

      if request = Thread.current[:request]
        env[:request_headers]['ORIGINAL_USER_AGENT'] = request.user_agent
        env[:request_headers]['ORIGINAL_REMOTE_IP']  = request.remote_ip
      end

      env[:request_headers]['Accept'] = 'application/json'

      @app.call(env)
    end
  end
end