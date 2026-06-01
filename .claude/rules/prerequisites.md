# 前提依存

このドキュメントは、Claude Code の前提依存（必須 MCP / CLI / プラグイン）について、何が要るか・どう入れるか・いつ使うかをまとめる。いずれもセッション開始時に自動実行せず、必要になった時点でオンデマンドに確認・是正する。

## 実行モデル

前提依存（MCP/CLI/プラグイン）の存在確認は**自動では行わない**。以前は `SessionStart` フック（`session-prereq-check.ps1`）が毎セッション fail-fast でチェックしていたが、欠落を検知しても是正は Claude の読み取りに依存する中途半端な構成だったため **2026-06-01 に廃止**した。各ツールは実際に使う段で必要になるので、その時点で欠落に気づき、本ドキュメントのインストール手順で是正する。

| 層 | 内容 | 実行機構 | タイミング |
|---|---|---|---|
| **① 前提依存** | 必須 MCP / CLI / プラグインの存在確認と是正 | Claude が、各ツールを使う段で利用可否を判定し欠落を是正 | **オンデマンド（必要時）** |
| **② Serena 起動** | `check_onboarding_performed` → `activate_project` | Claude が MCP 呼び出し | **コード作業に入る時（遅延）** |
| **③ プロジェクト把握** | memories / 構造 / シンボル概要 / 設定ファイル | Claude が MCP 呼び出し | **必要になった時（遅延・段階取得）** |

**重要**:
- ①は事前に一括チェックしない。各 skill/ツールが実際に必要になった時点で利用可否を判定し、欠落していれば本ドキュメントの該当インストール手順を案内する（実行は是正のみ、不可逆操作の承認ルールに従う）。
- ②③を**毎セッション無条件に走らせない**こと。特にシンボル概要は高価で、`token-efficiency.md`（最初から全ファイルを読まない／段階取得）と矛盾する。コード作業が実際に必要になった時だけ実行する。
- 以降の「必須MCP/CLI/プラグイン」節は、欠落に気づいた際の**インストール・是正リファレンス**として読む。

## 必須MCP（インストール是正リファレンス）

以下が `claude mcp list` に出ない場合、下記でインストールする。

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

### Gemini MCP

- **インストール**:
```bash
claude mcp add gemini-cli -s user -- npx -y gemini-mcp-tool
```

**注**: いずれかが未セットアップの場合、ユーザーに通知してインストール方法を提案する。

## 必須プラグイン

### superpowers（@obra）

設計・計画・実装ワークフロー（brainstorming, writing-plans, subagent-driven-development, test-driven-development, executing-plans 等）を提供する。

- **確認**: `~/.claude/plugins/known_marketplaces.json` に `superpowers-marketplace` があるか
- **インストール**（Claude Code セッション内で実行）:
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

インストール後 `/reload-plugins` で `superpowers:*` 系の skill が有効化される。

**重要**: グローバル `~/.claude/skills/` に `brainstorming` `writing-plans` 等の同名スキルが残っていれば、superpowers と重複するので削除すること（`structured-thinking` 等のカスタムは残す）。

## 必須CLI（インストール是正リファレンス）

`gemini` / `agent-browser` が無い場合、下記でインストールする。各CLIの詳細は `CLAUDE.md` を参照。

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

## ②③ Serena 起動・プロジェクト把握（遅延実行）

**毎セッションでは走らせない。** コード解析・実装などで実際に必要になった時に、以下の手順で Serena の利用可否を判定してからプロジェクト構造を把握する。高価なシンボル概要（手順3）は特に、対象が定まってから段階的に取得する。

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
