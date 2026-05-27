# OpenTask

OpenTask は、API駆動開発を学習・実践するための Todo アプリです。

Next.js + Rails API + PostgreSQL + Redis + Supabase Auth を利用し、
実務を意識した構成で開発します。

---

# 技術スタック

## Frontend

- Next.js
- TypeScript
- React
- SWR
- Tailwind CSS

## Backend

- Rails API
- PostgreSQL
- Redis
- Pundit
- RSpec
- OpenAPI

## Auth

- Supabase Auth

## Infrastructure

- Docker Compose
- PostgreSQL
- Redis

---

# ディレクトリ構成

```txt
opentask/
├── frontend/              # Next.js
├── backend/               # Rails API
├── openapi/               # OpenAPI定義
├── docker-compose.yml
├── .env.example
├── .gitignore
└── README.md
```

---

# 開発方針

- API駆動開発
- OpenAPI First
- 認証は Supabase Auth
- 認可は Pundit
- 論理削除を採用
- public_id を利用
- RFC9457 Problem Details を採用
- Issue Driven Development

---

# 認証方式

Supabase Auth を利用します。

```txt
Next.js
↓
Supabase Login
↓
JWT取得
↓
Rails APIへBearer Token送信
↓
RailsでJWT検証
```

---

# 論理削除

Todo の削除は物理削除ではなく論理削除を採用します。

```txt
deleted_at が NULL の場合のみ有効データ
```

---

# ロール

```txt
user
admin
```

管理者は全Todoの閲覧・編集・削除が可能です。

---

# 起動方法

## PostgreSQL / Redis 起動

```bash
docker compose up -d
```

## Rails API 起動

```bash
cd backend
bin/rails s
```

## Next.js 起動

```bash
cd frontend
pnpm dev
```

---

# 環境変数

## frontend/.env.local

```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
NEXT_PUBLIC_API_BASE_URL=http://localhost:3000
```

## backend/.env

```env
DATABASE_URL=postgresql://postgres:password@localhost:5432/opentask_development

REDIS_URL=redis://localhost:6379/0

SUPABASE_JWT_SECRET=
```

---

# API駆動開発フロー

```txt
1. Issue作成
2. OpenAPI更新
3. Rails API実装
4. RSpec実装
5. OpenAPI整合性確認
6. Next.js型生成
7. UI実装
```

---

# API仕様

OpenAPI を利用します。

```txt
openapi/openapi.yaml
```

---

# 主な機能

## User

- ログイン
- Todo一覧
- Todo作成
- Todo編集
- Todo論理削除

## Admin

- 全Todo閲覧
- 全Todo編集
- 全Todo削除
- ユーザー管理

---

# 今後の予定

- OpenAPI型自動生成
- 管理画面
- ページネーション
- フィルター
- ソート
- 通知
- E2Eテスト
- GitHub Actions
- CI/CD

---

# License

MIT
