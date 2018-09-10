class WebhookController < ApplicationController
  def home
  end
  def sendMessage
    ChatWork::Message.create(room_id: ENV['ROOM_ID'], body: "どすこい")
    redirect_to action: 'home'
  end
  def hook
    # ダイジェスト値をBASE64エンコードした文字列が、リクエストヘッダに付与された署名（`X-ChatWorkWebhookSignature`ヘッダ、もしくはリクエストパラメータ`chatwork_webhook_signature`の値）と一致することを確認
    if chatwork_signature.present? && chatwork_signature == Base64.strict_encode64(digest)
      render text: 'success', status: 200
      ChatWork::Message.create(room_id: '122180676', body: request_params)
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
    def request_params
      @params ||= JSON.parse(request.body.read, {:symbolize_names => true})
    end
end
