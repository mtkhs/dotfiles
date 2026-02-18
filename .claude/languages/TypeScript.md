# TypeScript ルール

## 開発環境

プロジェクトごとに適切なツールを選択する。

## 型安全性

### 禁止事項

以下の型の使用は**禁止**である。

- `any` 型
- `unknown` 型

## プロジェクト構造

### モノレポ構成

- はじめはシンプルなプロジェクトでも、将来の拡張を見越してモノレポ構成を採用する
- workspace機能を使用する（pnpm workspaces, yarn workspaces等）

#### 基本構成例

```
packages/
├── frontend/     # フロントエンドアプリケーション
├── backend/      # バックエンドAPI（必要になったら追加）
└── shared/       # 共通の型定義・ユーティリティ
```

### パッケージ内のディレクトリ構造

プロジェクトごとに適切な構造を採用する。以下は参考例：

### Frontend (React/Next.js)

```
src/
├── components/
│   ├── ui/           # 共通UIコンポーネント
│   └── features/     # 機能別コンポーネント
├── lib/              # ユーティリティ・ヘルパー
├── hooks/            # カスタムフック
├── types/            # 型定義
└── app/              # Next.js App Router
```

### Backend (Node.js)

```
src/
├── routes/
├── controllers/
├── services/
├── models/
├── middlewares/
└── utils/
```

## コーディング規約

プロジェクトの既存コードのスタイルに従う。統一的なルールが必要になった時点で追加する。
