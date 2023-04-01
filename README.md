# プロジェクト名
うんオジ

# 概要
シンプルな排便管理アプリです。
経過時間によってイラストが変化します。
画面上の紐を引っ張ると、水が流れてイラストがリセットされます。
流した日付とその時のイラストをカレンダーに記録し表示します。
App Store:https://apps.apple.com/jp/app/%E3%81%86%E3%82%93%E3%82%AA%E3%82%B8/id6446942004

![aa2606c787dcdfdcc401e6ced273d0e3](https://user-images.githubusercontent.com/93628118/229288098-6a6e4cae-c0e4-471d-8445-fab70bb50fea.gif)

# 環境構築
1. リポジトリをclone
　　git clone https://github.com/oggysy/unoji.git
1. cocoapodsをインストール
　　sudo gem install cocoapods
3. cocoapodsをセットアップ
　　pod setup
4. ライブラリのインストール
　　pod install

開発環境
項目	バージョン
Xcode	14.1
Swift	5.7.2
iOS	15.0以上
CocoaPods	1.12.0
Lottie	2.0
RealmSwift	10.36.0
FSCalendar	2.8.4

# 使用ライブラリ
・LicensePlist
使用ライブラリのライセンス情報を作成するライブラリ
・Lottie
アニメーションライブラリ
・RealmSwift
データをローカルに保存するためのデータベースライブラリ
・FSCalendar
カレンダーUIライブラリ

# バージョン管理
GitHubを使用
# デザインパターン
MVCモデルを使用
