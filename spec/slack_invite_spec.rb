require_relative "spec_helper"
require_relative "../slack_invite.rb"

def app
  SlackInvite
end

describe SlackInvite do
  it "responds with a welcome message" do
    get '/'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end
