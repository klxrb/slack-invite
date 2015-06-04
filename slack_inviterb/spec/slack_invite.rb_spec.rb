require_relative "spec_helper"
require_relative "../slack_invite.rb.rb"

def app
  SlackInvite.rb
end

describe SlackInvite.rb do
  it "responds with a welcome message" do
    get '/'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end
