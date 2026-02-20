# セッション初期化手順

このドキュメントは、セッション開始時に実行すべき手順を定義する。

## 必須MCPの確認

セッション開始時に、以下のMCPが接続されていることを確認する。

**初期化が必要なMCPは、接続確認後に初期化を実行すること。**

### Serena MCP

- **初期化**: `mcp__serena__check_onboarding_performed` を実行
- **インストール**:
```bash
claude mcp add serena -s user -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context claude-code --enable-web-dashboard false
```

### Context7 MCP

- **インストール**:
```bash
claude mcp add context7 -s user -- npx -y @upstash/context7-mcp@latest
```

### Memory MCP

- **初期化**: `mcp__memory__read_graph` を実行して既存知識を確認
- **インストール**:
```bash
claude mcp add memory -s user -- npx -y @modelcontextprotocol/server-memory
```

### Gemini MCP

- **インストール**:
```bash
claude mcp add gemini-cli -s user -- npx -y gemini-mcp-tool
```

**注**: いずれかが未セットアップの場合、ユーザーに通知してインストール方法を提案する。

## 必須CLIの確認

セッション開始時に、`which` コマンドで必須CLIの存在を確認する。各CLIの詳細は `CLAUDE.md` を参照。

### gemini-cli

- **確認**: `which gemini`
- **インストール**:
```bash
npm install -g gemini-cli
# または
pnpm add -g gemini-cli
```

### agent-browser

- **確認**: `which agent-browser`
- **インストール**:
```bash
npm install -g agent-browser
# または
pnpm add -g agent-browser
```

**注**: いずれかが未インストールの場合、ユーザーに通知してインストール方法を提案する。

## プロジェクト構造の自動把握

セッション開始時、以下の手順でSerenaの利用可否を自動判定してからプロジェクト構造を把握する。

まず `mcp__serena__check_onboarding_performed` を呼ぶ。
「No active project」が返った場合は `mcp__serena__activate_project` を試みる。
「No source files found」が返った場合はSerenaをスキップし、以降の手順は不要。
それ以外は以下の手順を続ける。

### 1. 既存知識の確認

- `mcp__serena__list_memories` で記憶されている情報を取得

### 2. プロジェクト構造のスキャン

次に、プロジェクトのディレクトリ構造を把握する：

- `mcp__serena__list_dir` でルートディレクトリの構造を確認（`relative_path: ".", recursive: false`）

### 3. ソースコードの概要取得

プロジェクト構成に応じて、以下のいずれかを実行：

**Workspaces構成の場合**（`package.json` に workspaces がある場合）:
- `mcp__serena__get_symbols_overview` で `frontend/src` のシンボル概要を取得
- `mcp__serena__get_symbols_overview` で `backend/src` のシンボル概要を取得
- `mcp__serena__get_symbols_overview` で `shared/src` のシンボル概要を取得

**単一src構成の場合**:
- `mcp__serena__get_symbols_overview` で `src` のシンボル概要を取得

### 4. 設定ファイルの確認

最後に、プロジェクトの設定ファイルを確認：

- `mcp__serena__find_file` で `package.json` を検索（`file_mask: "package.json", relative_path: "."`）
- 必要に応じて `tsconfig.json`, `.env.example` なども確認

### 注意事項

- これらの手順は**並列実行可能な部分は並列で実行する**こと
- ディレクトリが存在しない場合はスキップし、エラーを無視して次へ進む
- 大規模プロジェクトの場合、段階的に情報を取得する

## 推奨MCPについて

各MCPの詳細は `CLAUDE.md` を参照。

### Codex MCP

- **特性**: Geminiで解決できない難しい問題に使用。レスポンスが遅い
- **インストール**:
```bash
# Codex CLI のインストールが必要
# インストール後、MCP設定に追加される
```

### Playwright MCP

- **特性**: スクリーンショット取得、ネットワーク監視、複雑なページ遷移のデバッグ
- **インストール**:
```bash
claude mcp add playwright -s user -- npx @playwright/mcp@latest
```
