# news

Ruby on Rails + React + PostgreSQL の DevContainer/Docker 開発環境です。

## 必要なもの

- Docker
- Docker Compose
- Visual Studio Code Dev Containers 拡張、または Dev Container CLI

## DevContainer で使う

1. VS Code でこのディレクトリを開く
2. `.env.example` から `.env` を作成する

```bash
cp .env.example .env
```

3. `Dev Containers: Reopen in Container` を実行
4. 初回だけコンテナ内で Rails アプリを生成する

```bash
chmod +x scripts/setup-rails-react.sh
scripts/setup-rails-react.sh
```

5. 開発サーバーを起動する

```bash
bin/dev
```

Rails は <http://localhost:3000> で開きます。

## Docker Compose だけで使う

```bash
cp .env.example .env
docker compose up -d --build
docker compose exec app bash
chmod +x scripts/setup-rails-react.sh
scripts/setup-rails-react.sh
bin/dev
```

## 構成

- Ruby: `3.3`
- Rails: `7.2`
- Node.js: `22`
- PostgreSQL: `16`

PostgreSQL の接続情報と公開ポートは `.env` で変更できます。
