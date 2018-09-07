class WebhookController < ApplicationController
  def home
  end
  def sendMessage
    ChatWork::Message.create(room_id: '121815162', body: "どすこい")
    redirect_to action: 'home'
  end
end
