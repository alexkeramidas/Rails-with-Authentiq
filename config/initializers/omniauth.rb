Rails.application.config.middleware.use OmniAuth::Builder do
  provider :authentiq, ENV["AUTHENTIQ_APP_ID"], ENV["AUTHENTIQ_APP_SECRET"],
           {
               scope: 'aq:name email~rs aq:push phone address',
               enable_remote_sign_out: (
               lambda do |request|
                 if Rails.cache.read("application:#{:authentiq}:#{request.params['sid']}") == request.params['sid']
                   Rails.cache.delete("application:#{:authentiq}:#{request.params['sid']}")
                   true
                 else
                   false
                 end
               end
               ),
               issuer: 'https://dev.connect.authentiq.io/backchannel-logout/',
               client_options: {
                   :site => 'https://dev.connect.authentiq.io/',
                   :authorize_url => '/backchannel-logout/authorize',
                   :token_url => '/backchannel-logout/token',
                   :info_url => '/backchannel-logout/userinfo'
               }
               # client_options: {
               #     :site => 'https://test.connect.authentiq.io/'
               # }
           }
  #
  # OmniAuth.config.on_failure = Proc.new do |env|
  #   SessionsController.action(:auth_failure).call(env)
  # end
end