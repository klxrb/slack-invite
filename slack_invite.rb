class SlackInvite < Sinatra::Base

  SLACK_API_ENDPOINT = "https://#{ENV['SLACK_TEAM_NAME']}.slack.com/api/users.admin.invite"

  set :public_folder => "public", :static => true

  get "/invite.json" do

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
      http_response = HTTParty.post(SLACK_API_ENDPOINT, body: post_params)
      data = http_response.body
    else
      data = {'ok': false, 'error': 'invalid_email'}.to_json
    end

    callback = params.delete('callback')
    if callback
      content_type :js
      response = "#{callback}(#{data})"
    else
      content_type :json
      response = data
    end

    response
  end
end
