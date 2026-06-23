# 前提依存

## 実行モデル

前提依存（MCP/CLI/プラグイン）の存在確認は**自動では行わない**。各ツールは実際に使う段で必要になるので、その時点で欠落に気づき、本ドキュメントのインストール手順で是正する。

| 層 | 内容 | 実行機構 | タイミング |
|---|---|---|---|
| **① 前提依存** | 必須 MCP / CLI / プラグインの存在確認と是正 | Claude が、各ツールを使う段で利用可否を判定し欠落を是正 | **オンデマンド（必要時）** |
| **② Serena 起動** | `check_onboarding_performed` → `activate_project` | Claude が MCP 呼び出し | **コード作業に入る時（遅延）** |
| **③ プロジェクト把握** | memories / 構造 / シンボル概要 / 設定ファイル | Claude が MCP 呼び出し | **必要になった時（遅延・段階取得）** |

**重要**:
- ①は事前に一括チェックしない。各 skill/ツールが実際に必要になった時点で利用可否を判定し、欠落していれば本ドキュメントの該当インストール手順を案内する（実行は是正のみ、不可逆操作の承認ルールに従う）。
- ②③を**毎セッション無条件に走らせない**こと。特にシンボル概要は高価で、段階取得（最初から全ファイルを読まない）の原則に反する。コード作業が実際に必要になった時だけ実行する。② で `check_onboarding_performed` が「No source files found」を返したらコードベースが無い→Serena をスキップ。
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

## 推奨MCPについて

各MCPの詳細は `CLAUDE.md` を参照。

### Playwright MCP

- **特性**: スクリーンショット取得、ネットワーク監視、複雑なページ遷移のデバッグ
- **インストール**:
```bash
claude mcp add playwright -s user -- npx @playwright/mcp@latest
```
