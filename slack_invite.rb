class SlackInvite < Sinatra::Base
  SLACK_API_ENDPOINT = "https://#{ENV['SLACK_TEAM_NAME']}.slack.com/api/users.admin.invite"
  SLACK_CHANNEL = 'C056L5E1X'

  set :public_folder => "public", :static => true

  post "/invite.json" do
    content_type :json

    class Invitee
      include ActiveModel::Validations
      attr_accessor :email

      validates :email, :presence => true, :email => true
    end

    invitee = Invitee.new
    invitee.email = params[:email].gsub!(/\s/,'+')

    if invitee.valid?
      post_params = {
        email: invitee.email,
        channels: SLACK_CHANNEL,
        set_active: true,
        _attempts: 1,
        token: ENV['SLACK_TEAM_AUTH_TOKEN']
      }
      response = HTTParty.post(SLACK_API_ENDPOINT, body: post_params)
      response.body
    else
      {ok: false, error: "invalid_email"}.to_json
    end
  end
end
