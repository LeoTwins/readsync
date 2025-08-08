# ReadSync Backend

ReadSyncのバックエンドAPI

## 環境構築手順

### 必要な環境
- Docker & Docker Compose
- Go 1.24.2以上（ローカル開発時）
- PostgreSQL 17（Dockerで提供）

### 1. 環境変数の設定

`.env.example`をコピーして`.env`ファイルを作成してください：

```bash
# .env.exampleをコピーして.envを作成
cp .env.example .env
```

### 2. Docker環境のセットアップ

```bash
# コンテナをビルドして起動
make build
make up

# APIコンテナにアクセス（デバッグ用）
make exec-api

# コンテナを停止
make down

# コンテナを再起動
make restart
```

### 3. 推奨ワークフロー

- **Docker**: メインの開発環境として使用（API + PostgreSQL）
- **ローカル開発**: ホットリロード機能付きでGoアプリケーションを実行
- **テスト**: 専用のテストデータベースを使用

## アーキテクチャ
### アーキテクチャ構成

```
backend/
├── cmd/                        # アプリケーションエントリーポイント
│   └── api/                    # APIサーバー
├── core/                       # アプリケーション共通コード
├── registry/                   # 依存性注入（DI）
├── presentation/               # プレゼンテーション層
│   ├── handler/                # HTTPハンドラー
│   ├── middleware/             # ミドルウェア
│   └── server/                 # サーバー設定・ルーティング
├── domain/                     # ドメイン層（ビジネスロジック）
│   ├── model/                  # ドメインモデル
│   └── repository/             # リポジトリインターフェース
├── usecase/                    # ユースケース層（アプリケーションロジック）
├── infra/                      # インフラストラクチャ層
│   ├── dto/                    # データ転送オブジェクト
│   ├── persistence/            # データ永続化
│   ├── external/               # 外部サービス連携
│   └── db/                     # データベース関連
└── docker/                     # Docker設定
    ├── go/                     # Go用Dockerfile
    └── postgres/               # PostgreSQL用設定・データ
```

### 各層の役割

#### **cmd層（エントリーポイント）**
- アプリケーションの起動処理
- DIコンテナの初期化
- 設定の初期化

#### **core層（アプリケーション共通）**
- **config**: 設定管理（環境変数、設定ファイル）
- **applicationError**: アプリケーション固有のエラー定義
- **strings**: 文字列定数、メッセージ定義
- **logger**: ログ出力の共通機能

#### **registry層（依存性注入）**
- 依存関係の解決と注入
- インターフェースと実装の結合
- オブジェクトのライフサイクル管理

#### **presentation層（プレゼンテーション）**
- **handler/**: HTTPリクエスト/レスポンスの処理、リクエストバリデーション
- **middleware/**: 認証、ログ、CORS、レート制限などの横断的関心事
- **server/**: ルーティング設定、サーバー起動処理

#### **domain層（ドメイン）**
- **model/**: ビジネスロジックの中核、エンティティとバリューオブジェクト
- **repository/**: データアクセスのインターフェース定義

#### **usecase層（ユースケース）**
- アプリケーションのビジネスルール
- ドメインオブジェクトの操作
- リポジトリを通じたデータアクセス

#### **infra層（インフラストラクチャ）**
- **dto/**: データ転送オブジェクト、APIレスポンス/リクエスト用構造体
- **persistence/**: リポジトリの実装、データベースアクセス
- **external/**: 外部API呼び出し、第三者サービス連携
- **db/**: データベース接続、マイグレーション、クエリ

## 開発・デバッグ

### ログ確認
```bash
# APIサーバーのログを表示
docker compose logs -f api

# データベースのログを表示
docker compose logs -f db
```

### データベース接続
```bash
# メインデータベースに接続
docker compose exec db psql -U postgres -d readsync

# テストデータベースに接続
docker compose exec test-db psql -U postgres -d readsync_test
```

### テスト実行
```bash
# コンテナ内でテスト実行
make exec-api
go test ./...
```

## 使用技術・ライブラリ

- **Go 1.24.2** - プログラミング言語
- **Echo v4** - Webフレームワーク
- **PostgreSQL 17** - データベース
- **Docker & Docker Compose** - コンテナ化・開発環境