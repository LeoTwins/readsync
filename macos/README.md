# ReadSync macOS

ReadSyncのmacOSネイティブアプリケーション

## 環境構築手順

### 必要な環境
- Xcode 15.0以上（Mac App Storeからインストール）
- macOS 14.0以上
- Swift 5.9以上
- Homebrew
- Cursor エディタ

### 1. 必要なライブラリをbrewでインストール

```bash
# Xcodeを開かずにプロジェクトをビルドするためのツール
brew install xcode-build-server

# xcodebuildの出力を美しくするツール
brew install xcbeautify

# 高度なフォーマットと言語機能を有効にするツール
brew install swiftformat
```

### 2. Cursor拡張機能の追加

Cursor（VSCode）に以下の拡張機能をインストールしてください：

1. **Swift Language Support** - Swift言語サポート
2. **Sweetpad** - Xcode統合のための拡張機能

### 3. プロジェクトセットアップ手順

1. このリポジトリをクローン
2. Cursorでプロジェクトを開く
3. `ReadSync.xcodeproj` をXcodeで開く
4. Cursorで「Sweetpad: Generate Build Server Config」コマンドを実行
5. 初回ビルドで自動補完と言語機能が有効になります

### 4. 推奨ワークフロー

- **Cursor**: メインのコードエディタとして使用（AI機能を活用）
- **Xcode**: ビルド・実行・デバッグに使用
- オプション: [Inject](https://github.com/krzysztofzablocki/Inject) でホットリロード機能を追加

## アーキテクチャ

このプロジェクトは **MVVM (Model-View-ViewModel)** アーキテクチャパターンを採用しています。

### アーキテクチャ構成

```
ReadSync/
├── Models/                       # データモデル
├── Views/                        # SwiftUI ビュー
│   └── Components/               # 再利用可能なコンポーネント
├── ViewModels/                   # ビューモデル
├── Services/                     # サービス層（APIリクエスト処理）
├── Utilities/                    # ユーティリティ
└── Resources/                    # リソース
```

### 各層の役割

#### **Model層**
- データ構造の定義
- ビジネスロジックの実装
- APIレスポンスの型定義

#### **View層（SwiftUI）**
- UIコンポーネントの描画
- ユーザーインタラクションの処理
- ViewModelからの状態を監視

#### **ViewModel層**
- ViewとModelの橋渡し
- 状態管理（@Published、@StateObject）
- ビジネスロジックの呼び出し

#### **Services層（APIリクエスト処理）**
- REST API通信の実装
- 記事の CRUD 操作（要約記事の取得・保存・更新・削除）
- カテゴリ関連の API 呼び出し
- ユーザー認証処理


## ライブラリ

TBD
