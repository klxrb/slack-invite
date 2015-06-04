class SlackInvite < Sinatra::Base

  SLACK_API_ENDPOINT = "https://#{ENV['SLACK_TEAM_NAME']}.slack.com/api/users.admin.invite"

  set :public_folder => "public", :static => true

  get "/invite.json" do
    content_type :json

    param :email,     String, required: true, blank: false

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
        channels: ENV['SLACK_CHANNEL'],
        set_active: true,
        _attempts: 1,
        token: ENV['SLACK_TEAM_AUTH_TOKEN']
      }
      response = HTTParty.post(SLACK_API_ENDPOINT, body: post_params)
      "#{params[:callback]}(\"#{response.body}\")"
    else
      "#{params[:callback]}(\"{'ok': false, 'error': 'invalid_email'}\")"
    end
  end
end
