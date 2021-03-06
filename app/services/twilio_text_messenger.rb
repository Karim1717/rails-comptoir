class TwilioTextMessenger
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def call(sid, token)
    client = Twilio::REST::Client.new(sid, token)
    client.messages.create({
      from: '+12055286261',
      to: '+33624842229',
      body: message
    })
  end
end
