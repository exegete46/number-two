# == Schema Information
#
# Table name: messages
#
#  id            :uuid             not null, primary key
#  channel       :string
#  content       :string
#  from_username :string
#  kind          :integer          default("chat"), not null
#  status        :integer          default("active"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  setup do
    @chat = messages(:chat)
  end
  # TODO:  Look up how other people test simple models.
  # Do I need to test validation?
  test 'Sanity test' do
    assert @chat.chat?
  end

  test 'recent does not include chat messages beyond chat timeout' do
    @chat.touch
    assert_includes Message.recent, @chat
    travel Message.chat_timeout + 1.second
    assert_not_includes Message.recent, @chat
  end

  test 'for_channel limits results to a specific channel' do
    # TODO:  Is there a way to do away with the "magic" number, 1?
    assert_equal Message.for_channel('twitch').count, 1
  end

  test 'expired includes chat messages beyond chat timeout' do
    @chat.touch
    assert_not_includes Message.expired, @chat
    travel Message.chat_timeout + 1.second
    assert_includes Message.expired, @chat
  end

  test 'expired does not include ask messages regardless of age' do
    ask = messages(:ask)
    ask.touch
    assert_not_includes Message.expired, ask
    travel Message.chat_timeout + 1.second
    assert_not_includes Message.expired, ask
  end

  test 'messages are from a banned user' do
    message = Message.create_message!(channel: 'ChaelCodes', from_username: 'PretzelRocks', content: 'Lol, is a song', kind: 'chat')
    assert message.nil?
  end

  test 'activating one message inactivates any other active messages' do
    messages(:ask).update(status: :active)
    assert messages(:ask_active).inactive?
  end

  test 'does not inactivate message unless updating message is active' do
    messages(:ask).update(kind: :todo)
    assert messages(:todo_active).active?
  end

  test 'activating does not effect different kinds of message' do
    messages(:ask).update(status: :active)
    assert messages(:todo_active).active?
  end
end
