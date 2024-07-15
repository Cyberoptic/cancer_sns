# CANCER SNS


## システム要求事項

Ruby 3.1.2

Rails 5.0.0 [6.0以上へのアップデートが必要です]

PostgreSQL 8.4以上

## 設定

./config/database.ymlでDBの設定を進めます。

## データベースの作成

以下のコマンドを使用してデータベースを作成します。
```
$ rake db:create

$ rake db:migrate
```
## ローカルサイトの動作

以下のコマンドを使用してローカル サイトを起動します
```
$ bin/rails server
```
ブラウザで http://localhost:8000 を訪問します。

## プロダクション·ディプロイ

Heroku にデプロイするために下記のコマンドを利用します。
```
$ git push heroku master
```
