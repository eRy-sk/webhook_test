class WebhookController < ApplicationController
  def home
  end
  def sendMessage
    ChatWork::Message.create(room_id: ENV['ROOM_ID'], body: "どすこい")
    redirect_to action: 'home'
  end
  def hook
    if chatwork_signature.present? && chatwork_signature == Base64.strict_encode64(digest)
      render text: 'success', status: 200
    else
      render text: 'invalid', status: 403
    end
  end

  private

    def secret_key
      token = ENV['WEBHOOK_TOKEN']
      Base64.decode64(token)
    end

    def request_body
      request.body.read
    end

    def chatwork_signature
      request.headers[:HTTP_X_CHATWORKWEBHOOKSIGNATURE]
    end

    def digest
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret_key, request_body)
    end
end
