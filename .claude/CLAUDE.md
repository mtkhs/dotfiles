# Guidelines

This document defines the project's rules, objectives, and progress management methods. Please proceed with the project according to the following content.

## Top-Level Rules

- To maximize efficiency, **if you need to execute multiple independent processes, invoke those tools concurrently, not sequentially**.
- **You must think exclusively in English**. However, you are required to **respond in Japanese**.
- To understand how to use a library, **always use the Contex7 MCP** to retrieve the latest information.

## Programming Rules

- Avoid hard-coding values unless absolutely necessary.
- Do not use `any` or `unknown` types in TypeScript.
- You must not use a TypeScript `class` unless it is absolutely necessary (e.g., extending the `Error` class for custom error handling that requires `instanceof` checks).

## MANDATORY: Project Structure Discovery Protocol

### Auto-execution at Session Start
The following commands MUST be executed automatically at the beginning of each session:

```bash
# 1. Check existing knowledge
mcp__serena__check_onboarding_performed
mcp__serena__list_memories

# 2. Project structure scan
mcp__serena__list_dir({ relative_path: ".", recursive: false })
mcp__serena__get_symbols_overview({ relative_path: "src" })

# 3. Configuration files
mcp__serena__find_file({ file_mask: "package.json", relative_path: "." })
mcp__serena__find_file({ file_mask: "*.config.*", relative_path: "." })
```end

### Serena Tool Priority
1. **For symbol/function search**: Always try `find_symbol` first
2. **For text/string search**: Use `search_for_pattern`
3. **For multiple replacements**: Use `replace_regex` when changing 3+ similar patterns
