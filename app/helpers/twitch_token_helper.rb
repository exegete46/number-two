module TwitchTokenHelper
  def twitch_token
    session.dig('devise.twitch_data', 'credentials', 'token')
  end
end