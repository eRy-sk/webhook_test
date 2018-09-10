class WebhookController < ApplicationController
  require 'openssl'
  require 'base64'
  protect_from_forgery :except => [:hook]

  def home
  end

  def sendmessage
    ChatWork::Message.create(room_id: ENV['ROOM_ID'], body: params[:body])
    redirect_to action: 'home'
  end

  def webhook
    # ダイジェスト値をBASE64エンコードした文字列が、リクエストヘッダに付与された署名（`X-ChatWorkWebhookSignature`ヘッダ、もしくはリクエストパラメータ`chatwork_webhook_signature`の値）と一致することを確認
    if chatwork_signature.present? && chatwork_signature == Base64.strict_encode64(digest)
      body = JSON.parse(request.body.read, {:symbolize_names => true})
      ChatWork::Message.create(room_id: '<SEND_ROOM_ID>', body: body[:webhook_event][:body])
      head :ok
    else
      render text: 'invalid', status: 403
    end
  end

  private

    def secret_key
      # リクエストの署名検証に使う秘密鍵
      # トークンをBASE64デコードしたバイト列
      token = ENV['WEBHOOK_TOKEN']
      Base64.decode64(token)
    end

    def request_body
      # チャットワークのWebhookからのHTTPSリクエストボディをそのままの文字列で取得
      request.body.read
    end

    def chatwork_signature
      request.headers[:HTTP_X_CHATWORKWEBHOOKSIGNATURE]
    end

    def digest
      # 取得したHTTPSリクエストボディと秘密鍵をつかって、HMAC-SHA256アルゴリズムによりダイジェスト値を取得
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret_key, request_body)
    end
end
