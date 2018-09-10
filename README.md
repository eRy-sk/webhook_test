# ChatWorkBot作成のための技術検証

## メッセージ送信
`http://localhost:3000/`にアクセス  
送信したいメッセージを入力し、submit  
[`ChatWork::Message.create(room_id: ENV['ROOM_ID'], body: "<送信内容>")`](https://github.com/eRy-sk/webhook_test/blob/master/app/controllers/webhook_controller.rb#L10)  

## 新規メッセージ受信時にトリガーしてメッセージ送信
Can't verify CSRF token authenticity エラー回避  
[`protect_from_forgery :except => [:webhook]`](https://github.com/eRy-sk/webhook_test/blob/master/app/controllers/webhook_controller.rb#L4)  
リクエストの署名検証  
[`chatwork_signature == Base64.strict_encode64(digest)`](https://github.com/eRy-sk/webhook_test/blob/master/app/controllers/webhook_controller.rb#L16)  
JSONリクエストのパース  
[`JSON.parse(request.body.read, {:symbolize_names => true})`](https://github.com/eRy-sk/webhook_test/blob/master/app/controllers/webhook_controller.rb#L17)  
メッセージの内容を取得して、同じ内容でメッセージを送信  
[`ChatWork::Message.create(room_id: '<SEND_ROOM_ID>', body: body[:webhook_event][:body])`](https://github.com/eRy-sk/webhook_test/blob/master/app/controllers/webhook_controller.rb#L18)  
template is missing 回避  
[`head :ok`](https://github.com/eRy-sk/webhook_test/blob/master/app/controllers/webhook_controller.rb#L19)
