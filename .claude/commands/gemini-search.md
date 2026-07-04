---
allowed-tools: Bash(gemini:*)
description: Web search using Gemini CLI
---

## Gemini Search

Run a web search via Gemini CLI.

Query: $ARGUMENTS

### Execute Search
!`gemini --skip-trust --prompt "WebSearch: $ARGUMENTS"`
