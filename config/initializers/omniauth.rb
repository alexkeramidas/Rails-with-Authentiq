Rails.application.config.middleware.use OmniAuth::Builder do
  provider :authentiq, ENV["AUTHENTIQ_APP_ID"], ENV["AUTHENTIQ_APP_SECRET"],
           {
              scope: 'aq:name email~rs aq:push phone address',
              enable_remote_sign_out: (
                lambda do |request|
                  if Rails.cache.read("omnivise:#{:authentiq}:#{request.params['user_id']}") == request.params['user_id']
                    Rails.cache.delete("omnivise:#{:authentiq}:#{request.params['user_id']}")
                    true
                  else
                    false
                  end
                end
              )
           }

  OmniAuth.config.on_failure = Proc.new do |env|
    SessionsController.action(:auth_failure).call(env)
  end
end