# Global Rules

These are global rules that AI agents, such as OpenCode, should follow while working in or exploring any project or repo.

## Tools

- **NEVER** invoke `cat`, `head`, `tail`, `sed`, `awk`, `python`/`python3` (or any scripting language), or heredocs/`echo` redirection to read, search, or edit files. There are no exceptions.
- **ALWAYS** use the built-in Read tool to read files, the Edit tool to modify files, the Write tool to create files, and the Grep/Glob tools to search files.
- **ALWAYS** use the built-in tools even when a bash one-liner feels faster or more "necessary" for the task at hand. If you catch yourself reaching for `cat`/`sed`/`python` to touch a file, stop and use the matching built-in tool instead.
- Reserve the bash tool exclusively for actual system/terminal operations (builds, tests, package managers, running programs, etc.) that have no built-in tool equivalent.
- **DO** use the `gh` CLI to fetch information anytime you are given GitHub links or asked about GitHub Issues, Pull Requests, Commits, or any other GitHub related resources.

Quick reference:

| Task | Use | Never use |
| --- | --- | --- |
| Read a file | Read tool | `cat`, `head`, `tail` |
| Edit a file | Edit tool | `sed`, `awk`, python scripts |
| Create a file | Write tool | heredoc, `echo >` |
| Search file contents | Grep tool | `grep`/`rg` via bash |
| Find files by name | Glob tool | `find`, `ls -R` |
| VCS read-only lookups | `jj status`/`jj diff`/`jj log` | `git status`/`git diff`/`git log`, or any other `git` subcommand |

## Version Control

- **NEVER** run any `git` command, including read-only ones (`git status`, `git diff`, `git log`, etc.). This repo's history/trunk model differs from git's, and git commands can misread or corrupt state.
- **ALWAYS** use `jj` instead: `jj status`, `jj diff`, `jj log`, etc.
- **DO NOT** create Jujutsu (`jj`) commits, move bookmarks, or perform *any* write operations with `jj`. Only use read-only operations to explore the codebase.

## Tool Permissions

- If a tool call is rejected or you lack edit/write access to a file or resource, **DO NOT** try to work around it via another tool or mechanism (e.g. shell redirection, a different editing tool, `git`/`jj` plumbing, etc.). Simply stop and ask the user for permission instead.

## AWS / Terraform

- **DO NOT** run `terraform` commands yourself (including read-only ones like `terraform plan`, `terraform init`, or `terraform validate` against a real/live backend), and **DO NOT** run AWS CLI commands or otherwise take any action against a live AWS environment yourself. This applies even for verification/validation purposes. Instead, ask the user to run the command and share the output back with you.

## Code Style

- **MINIMAL COMMENTS** - when you write code avoid lengthy comments unless absolutely necessary. The code you write should be self-documenting as much as possible and the comments for that code should be as concise as possible. DO NOT refer to previous changes in comments.
