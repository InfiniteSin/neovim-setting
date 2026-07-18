# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project overview

This is a **personal Neovim configuration** (dotfiles-style, single `init.lua` entry), not an application or library. It targets **Neovim 0.11+** (uses the built-in `vim.lsp.config` / `vim.lsp.enable` API) and is developed on **Windows** (see the hardcoded `python3_host_prog = "G:/Code/pyneovim/.venv/Scripts/python"` in `lua/options.lua`). Licensed under Apache-2.0. All comments and docs are in English.

There is no build system, no test suite, and no CI. "Running the project" means starting Neovim with this directory as the config (e.g. `NVIM_APPNAME` or symlinking/copying it to `stdpath('config')`).

## Repository layout

- `init.lua` — entry point; loads, in order: `options`, `plugin`, `utils`, `keymaps` (all under `lua/`).
- `lua/options.lua` — all `vim.g` / `vim.opt` settings and the `vim.diagnostic.config` (signs, float borders, virtual text). Leader key is `<Space>`.
- `lua/plugin.lua` — bootstraps **lazy.nvim** (clones it to `stdpath('data')/lazy/lazy.nvim` if missing) and imports every spec in `lua/plugins/`.
- `lua/plugins/*.lua` — one lazy.nvim spec per file; each returns a Lua table. This is where plugins are added/removed.
- `lua/keymaps.lua` — global keymaps (`vim.keymap.set`), all with `desc` strings.
- `lua/utils.lua` — user commands (`:PackClean`, `:PluginClear`), a hand-rolled dynamic statusline using Nerd Font icons (functions exposed as `_G.*` for `v:lua` statusline items), and autocmds: LSP format-on-save (`BufWritePre` → `vim.lsp.buf.format`), highlight-on-yank, spell/wrap for prose filetypes, restore-last-cursor-position.
- `lua/after/ftplugin/{lua,python}.lua` — filetype overrides. **Lua buffers use 2-space indent** (overriding the global 4-space setting); Python sets `commentstring`.
- `lsp/*.lua` (~385 files) — a **vendored copy of nvim-lspconfig's `lsp/` directory** (per-server `vim.lsp.Config` definitions). These live on the runtimepath, so `vim.lsp.enable('name')` picks them up without loading the lspconfig plugin first. Some configs `require 'lspconfig.util'`, so the `nvim-lspconfig` plugin itself is still needed at runtime (it is installed as a `mason.nvim` dependency). Do not hand-edit these files as if they were local code — they mirror upstream; local server customization goes in `lua/plugins/lsp.lua` via `vim.lsp.config('name', {...})`.
- `lua/luv/` — git submodule of `LuaCATS/luv` (EmmyLua type definitions for `vim.uv`/luv), feeding the lua_ls workspace library. Clone with `git submodule update --init`.
- `lazy-lock.json` — lazy.nvim lockfile (pinned plugin commits).
- `nvim-pack-lock.json` — lockfile for Neovim's built-in `vim.pack` (currently only pins `nvim-lspconfig`; the corresponding `vim.pack.add` call in `lua/plugins/lsp.lua` is commented out — vim.pack support is experimental here, and `:PackClean` / `:PluginClear` in `lua/utils.lua` manage it).

## Plugin and LSP architecture

- **Plugin manager:** lazy.nvim. Specs in `lua/plugins/`: `fzf-lua` (fuzzy finding, incl. LSP pickers), `oil.nvim` (file manager on `-`), `gitsigns.nvim`, `mini.nvim`, `nvim-treesitter` (main branch, parsers auto-installed in the spec's `init`), `luarocks.nvim` (installs the `jsregexp` rock), and `mason.nvim` (installs external LSP servers/tools; `:Mason`).
- **LSP:** native `vim.lsp` only. Enabled servers (in `lua/plugins/lsp.lua`): `ast_grep`, `lua_ls`, `clangd`, `ruff`, `ty`, `debugpy`. `lua_ls` gets an extended local config there (declares the `vim` global, LuaJIT runtime, nvim runtime files + luv types in the workspace library, telemetry off). Server binaries must exist on `PATH` (install via Mason or manually).
- **LSP keymaps** are buffer-local, set in an `LspAttach` autocmd in `lua/plugins/lsp.lua` (definitions/references/symbols via fzf-lua, `<leader>lf` to format, `<leader>oi` to organize imports + format). A second, mostly commented-out `LspAttach` handler exists in `lua/utils.lua` — keep that in mind before "fixing" apparent duplication.

## Code style guidelines

- Lua throughout; match the existing file's conventions rather than imposing new ones.
- Core config files (`options.lua`, `plugin.lua`, `keymaps.lua`, `utils.lua`) use **4-space indent**, `snake_case` locals, and mostly double quotes; files under `lua/plugins/` (plugin specs) follow the same look. Note the editor itself indents Lua buffers with 2 spaces (`after/ftplugin/lua.lua`), so verify indentation visually instead of trusting auto-indent.
- Vendored `lsp/*.lua` files keep the **upstream nvim-lspconfig style (2-space indent)** — preserve it when syncing from upstream.
- Group settings into tables and apply with `for key, value in pairs(...)` loops, as in `lua/options.lua`.
- Keymaps always include a `desc = "..."` field.
- Comment style: short `--` line comments, usually one per option/section.

## Testing and verification

There are no automated tests. To verify a change:

- Start Neovim headless and check for errors: `nvim --headless "+checkhealth" "+qa"` (or just `nvim --headless "+lua print('ok')" "+qa"`), then inspect `:messages` interactively.
- Use `:checkhealth`, `:Lazy` (plugin state), `:Mason` (server installs), and `:LspInfo` to confirm plugins and language servers load.
- Format-on-save runs through attached LSPs, so saving a Lua file is itself a quick smoke test of the LSP setup.

## Security and environment notes

- `lua/plugin.lua` clones `lazy.nvim` from GitHub on first launch; `mason.nvim` and `nvim-treesitter` download and build third-party binaries/parsers at runtime. Expect network access and external processes on first start.
- The config runs external commands (`git branch --show-current` for the statusline, `git clone` for bootstrapping) — keep paths and shell assumptions Windows/Git-Bash compatible.
- `python3_host_prog` points at a machine-specific virtualenv path; it will not exist on other machines — treat it as a per-machine setting, not something to "correct" without asking.
- `lua/utils.lua`'s `:PluginClear` deletes `stdpath('data')/site/pack/core/opt` recursively — be careful when touching that code path.

# Project Agent Instructions

## Shell Command Policy (RTK)

Route shell commands through `rtk` to minimize token usage. Use the
compact equivalents below instead of their raw counterparts:

- List directories: `rtk ls .` (not `ls -la` / `tree`)
- Read files: `rtk read &lt;file&gt;` (not `cat`); use `rtk read &lt;file&gt; -l aggressive`
  for signatures only
- Search: `rtk grep "pattern" .` (not `grep` / `rg`)
- Find files: `rtk find "*.ext" .`
- Git: `rtk git status`, `rtk git diff`, `rtk git log -n 10`,
  `rtk git add/commit/push/pull`
- Tests: `rtk test &lt;original test command&gt;` (e.g. `rtk test npm test`,
  `rtk pytest`, `rtk cargo test`)
- Lint/build: `rtk lint`, `rtk tsc`, `rtk ruff check`
- Long/unknown commands: `rtk summary &lt;command&gt;` or `rtk err &lt;command&gt;`

Rules:
1. Prefer `rtk` wrappers even when a built-in file tool is available,
   because built-in tools bypass shell hooks and return unfiltered output.
2. If `rtk` is not installed or a wrapper fails, fall back to the original
   command and mention the fallback briefly.
3. Never chain or double-wrap (e.g. do NOT run `rtk rtk git status`).
4. Full raw output of failed commands is auto-saved by rtk (tee); read the
   referenced log file when more detail is needed.

## Communication Style (Caveman, always on)

Default to compressed "caveman" style in all responses:

- No pleasantries, filler, apologies, or restating the question.
- Short sentences. Bullet points over paragraphs.
- Omit articles and pronouns where meaning stays clear
  ("Fixed null check in auth.js" not "I have fixed the null check...").
- NEVER compress: code, commands, file paths, error messages, diffs,
  and any quoted output — keep them verbatim.
- Technical accuracy outranks brevity; if compression risks ambiguity,
  use the full term.
- Respond in the same language the user uses; compress the style,
  not the language.

Mode switching (user may say these at any time):
- `caveman lite` — only remove pleasantries
- `caveman full` — default compressed style
- `caveman ultra` — telegram style, abbreviations allowed
- `normal mode` — disable compression for this session
