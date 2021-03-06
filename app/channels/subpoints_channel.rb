class SubpointsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "subpoints_#{params['twitch_channel'].downcase}"
  end
end
