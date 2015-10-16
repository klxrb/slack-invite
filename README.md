# Slack Invite
Simple endpoint for inviting yourself to any [Slack](https://slack.com/) group built with [Sinatra](http://www.sinatrarb.com/). Great for open & free groups.

Example: http://rubybrigade.my/slack_invite/

## How to set it up
Simplest (and free-est) way is to deploy this on [Heroku](https://www.heroku.com/)'s free dynos.

### Step 1: Clone this repo
```bash
git clone git@github.com:klxrb/slack-invite.git
cd slack-invite
```

### Step 2: Setup Heroku
Setup and configure [Heroku Toolbelt](https://toolbelt.heroku.com/) if not already.

```bash
heroku apps:create
heroku config:set SLACK_CHANNEL=<your-slack-channel-name>
heroku config:set SLACK_TEAM_NAME=<your-slack-team-name>
heroku config:set SLACK_TEAM_AUTH_TOKEN=<your-slack-team-auth-token>
```

#### How to get your Slack Team Auth Token

1. As Team Admin, go to the [Slack Web API Documentation](https://api.slack.com/web) and click "Create Token" and it should generate a API Token. This is the value for ```SLACK_TEAM_AUTH_TOKEN```.

2. Then go to the [channel.list API Tester](https://api.slack.com/methods/channels.list/test). Select your Slack team for the ```token``` field, click on "Test Method". 

  You should see something like this in the response field :-

  ```json
{
    "ok": true,
    "channels": [
        {
            "id": "THIS-IS-YOUR-CHANNEL-ID",
            "name": "general",
            "is_channel": true,
  ```

  Choose the channel ID you want the members to be invited into by default. That's the value for ```SLACK_CHANNEL```.

3. ```SLACK_TEAM_NAME``` is just name name of your Slack team, you can get this from your team URL (e.g. ```http://team-name.slack.com```)

### Step 3: Deploy
Deploy the Heroku app

```
git push heroku master
```

Go to https://your-app-name.herokuapp.com/invite.json, you should see a JSON with ```invalid_email``` error. You can try to invite by simply doing https://your-app-name.herokuapp.com/invite.json?email=invite-this-member@email.com.



### Step 4: Create the form
The endpoint only handles JSON requests, so you might want to use some AJAX to handle your form submissions.

```html
<form id="slack_invite">
  Email: <input type="email" name="email_invite" id="email_invite" placeholder="please@invite.me">
  <button id="submit_button" type="submit">Submit</button>
</form>

<script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
<script>
$(function(){
  $('#slack_invite').submit(function(){
      $.ajax({
        url: 'https://your-app-name.herokuapp.com/invite.json',
        dataType: 'jsonp',
        data: {
          email: $('#email_invite').val()
        },
        success: function(data){
          if(data.ok){
            alert("You're Invited !!!");
          }else{
            alert("Something went wrong :(");
          }
        }
      })
  })
})
</script>
```

Put this code on your website and you're good to go :)

You can look at the RubyMY invite page for example http://rubybrigade.my/slack_invite/
