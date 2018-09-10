# ChatWorkBot作成のための技術検証

## メッセージ送信
`http://localhost:3000/`にアクセス
送信したいメッセージを入力し、submit
`ChatWork::Message.create(room_id: ENV['ROOM_ID'], body: "<送信内容>")`

## 新規メッセージ受信時にトリガーしてメッセージ送信
リクエストの署名検証
`if chatwork_signature.present? && chatwork_signature == Base64.strict_encode64(digest)`
