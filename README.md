# BestRamen

![homegif](https://i.imgur.com/5qQSsgm.gif "homegif")
## 製品概要
BestRamen
ラーメン口コミアプリ


### 背景(製品開発のきっかけ、課題等）
自分と同じ好みの人と繋がれるラーメンのみの口コミアプリを作成したいという想いがきっかけになった。
ラーメン好きと言っても、好みは分かれる。
食べログの評価がくても自分の好みかは分からない。
そこで、自分と同じ好みの人を探せば、好みのラーメンと出会えるのでは、と考えて今回のプロダクトを作成した。

  
### 製品説明（具体的な製品の説明）
SNS形式でラーメンの口コミを投稿する。
他人の口コミはホーム画面(タイムライン)やユーザーページ、ショップページにて閲覧可能。
マップから店舗検索が可能。（現在マップ表示のみ実装。検索機能は追加予定。）
マイページにて、自分の好きなラーメンBEST３を登録できる。
他人のBEST３も確認可能。


### 今後の展望
データの充実(某口コミサイトの情報をクローリングし、店舗情報を充実)  
機械学習を用いて、好みそうな投稿、趣味が合いそうなユーザーをおすすめ表示。
いいね機能/メッセージ機能などを追加しSNSとしての役割も充実。

### 注力したこと（こだわり等）
* 使いやすく，心地よいUIデザイン
* Firebaseを用いたデータ管理
* 投稿機能/フォロー機能をはじめとする多機能の搭載
* 多種類のデバイスで対応するためのAutoLayout


## 開発環境
* 言語：Swift5

### 活用した技術
* Xcode 12.0.1
* GitHub

* Illustrator(ポートフォリオムービー作成)
* PremierePro(ポートフォリオムービー作成)

#### フレームワーク・ライブラリ・モジュール
* Map Kit
* Firebase/Storage
* Firebase/Firestore
* Firebase/Auth
* GoogleSignIn
* RSKImageCropper

#### デバイス
* iPhone 11
その他のデバイスの動作確認中

#### 実行

gem 3.0.3
cocoapods 1.10.0
Xcode 12.0.1

### 未実装箇所
* Map画面で店舗を検索する機能は未実施。現在検索フィールドのみ存在。

### デモンストレーション動画
[https://www.youtube.com/watch?v=JU4YCqh2cOA](https://www.youtube.com/watch?v=JU4YCqh2cOA)

### スクリーンショット
![home](https://imgur.com/6fiaqFw.png "home")
![mypage](https://i.imgur.com/NSIPtsJ.png "mypage")
![map](https://i.imgur.com/GYzWoFV.png "map")
![maptapped](https://i.imgur.com/DEbs8bR.png "post")
<img src="https://i.imgur.com/6HVv73h.png" width="340">
![resize](https://i.imgur.com/6UwS2f6.png "resize")
![posting](https://i.imgur.com/HfHmNNa.png "posting")
![posted](https://i.imgur.com/7wtQ5Q1.png "posted")
![edit](https://i.imgur.com/adjiD1M.png "edit")
![userpage](https://i.imgur.com/FVLdLuS.png "userpage")
![shop](https://i.imgur.com/kzSOeFm.png "shop")
![followlist](https://i.imgur.com/4D4L9AS.png "followlist")
![logout](https://i.imgur.com/ZeufTuC.png "logout")


### README作成中
