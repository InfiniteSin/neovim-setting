# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project overview

This is a **personal Neovim configuration** (dotfiles-style, single `init.lua` entry), not an application or library. This branch (`vanila`) is a re-implementation that prefers **built-in Neovim APIs over plugins**; it targets **Neovim 0.12+** because plugin management uses the built-in, still-experimental `vim.pack` (`:h vim.pack`), and it uses the `vim.lsp.config` / `vim.lsp.enable` API. It is developed on **Windows** (see the hardcoded `python3_host_prog = "G:/Code/pyneovim/.venv/Scripts/python"` in `lua/options.lua`). Licensed under Apache-2.0. All comments and docs are in English.

There is no build system, no test suite, and no CI. "Running the project" means starting Neovim with this directory as the config (e.g. `NVIM_APPNAME` or symlinking/copying it to `stdpath('config')`).

## Repository layout

- `init.lua` — entry point; loads, in order: `options`, `plugin`, `utils`, `keymaps` (all under `lua/`).
- `lua/options.lua` — all `vim.g` / `vim.opt` settings and the `vim.diagnostic.config` (signs, float borders, virtual text). Leader key is `<Space>`.
- `lua/plugin.lua` — plugin setup entry; just `require`s every module in `lua/plugins/`.
- `lua/plugins/*.lua` — one self-contained module per plugin: each calls `vim.pack.add(...)` and then sets up its loading trigger. `vim.pack.add` is idempotent per session. Fully-deferred plugins pass `{ load = function() end }`: vim.pack installs/registers them but leaves them unloaded and off the runtimepath until an explicit `vim.cmd.packadd()`. Note `{ load = false }` is NOT real deferral — it behaves like `:packadd!`, which still sources `plugin/` files at the end of startup; it is only used where rtp presence is wanted (nvim-lspconfig). This is where plugins are added/removed.
- `lua/keymaps.lua` — global keymaps (`vim.keymap.set`), all with `desc` strings.
- `lua/utils.lua` — user commands (`:PackClean`, `:PluginClear`), a hand-rolled dynamic statusline using Nerd Font icons (functions exposed as `_G.*` for `v:lua` statusline items), and autocmds: LSP format-on-save (`BufWritePre` → `vim.lsp.buf.format`), highlight-on-yank, spell/wrap for prose filetypes, restore-last-cursor-position.
- `lua/after/ftplugin/{lua,python}.lua` — filetype overrides. **Lua buffers use 2-space indent** (overriding the global 4-space setting); Python sets `commentstring`.
- `lsp/*.lua` (~385 files) — a **vendored copy of nvim-lspconfig's `lsp/` directory** (per-server `vim.lsp.Config` definitions). These live on the runtimepath, so `vim.lsp.enable('name')` picks them up without loading the lspconfig plugin first. Some configs `require 'lspconfig.util'`, so the `nvim-lspconfig` plugin itself is still needed at runtime (added via `vim.pack` in `lua/plugins/lsp.lua`). Do not hand-edit these files as if they were local code — they mirror upstream; local server customization goes in `lua/plugins/lsp.lua` via `vim.lsp.config('name', {...})`.
- `lua/luv/` — git submodule of `LuaCATS/luv` (EmmyLua type definitions for `vim.uv`/luv), feeding the lua_ls workspace library. Clone with `git submodule update --init`.
- `nvim-pack-lock.json` — the `vim.pack` lockfile at the config root (`stdpath('config')`); keep it under version control so plugin revisions replicate on other machines. `:PackClean` / `:PluginClear` in `lua/utils.lua` prune/delete installed plugins, `vim.pack.update()` updates them.

## Plugin and LSP architecture

- **Plugin manager:** built-in `vim.pack` (no lazy.nvim on this branch). Plugins in `lua/plugins/`: `fzf-lua` (fuzzy finding, incl. LSP pickers), `oil.nvim` (file manager on `-`; netrw is disabled via `vim.g.loaded_netrw` there), `gitsigns.nvim`, `nvim-treesitter` (`version = "main"` branch, parsers auto-installed on startup; a `PackChanged` autocmd runs `:TSUpdate` after install/update, replacing lazy.nvim's `build`), and `mason.nvim` (installs external LSP servers/tools; `:Mason`). `mini.nvim` and `luarocks.nvim` were dropped: nothing in the config used them.
- **Approximate lazy-loading** (replacing lazy.nvim triggers): fully-deferred plugins use `vim.pack.add(..., { load = function() end })` (stays off the rtp; `{ load = false }` is only `:packadd!` semantics and still sources `plugin/` at startup), then a trigger does `vim.cmd.packadd()` + `setup()`. Autocmd events where they exist, stubs where they don't (Neovim has no keypress/command events): `gitsigns` loads on `BufReadPre`/`BufNewFile` (`once`, exact port of the old `event` spec); `oil.nvim` loads on a stub `:Oil` command, a stub `-` keymap, or a `BufEnter`/`VimEnter` autocmd on directory buffers; `mason.nvim` loads on a stub `:Mason`; `fzf-lua` loads on the first `<leader>f*` keypress or LSP picker (`packadd` is called in the LSP keymaps too); `nvim-treesitter` stays eager (old spec had `lazy = false`); `nvim-lspconfig` uses `load = false` so its Lua modules stay on the rtp for vendored `lsp/*.lua` configs that `require 'lspconfig.util'`. The lazy `performance.rtp.disabled_plugins` list is gone too (built-in `gzip`/`tar`/`zip`/`tohtml`/`tutor` plugins stay enabled).
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
- Use `:checkhealth`, `vim.pack.get()` / `vim.pack.update()` (plugin state and updates), `:Mason` (server installs), and `:LspInfo` to confirm plugins and language servers load.
- Format-on-save runs through attached LSPs, so saving a Lua file is itself a quick smoke test of the LSP setup.

## Security and environment notes

- `vim.pack` clones plugins from GitHub on first launch (into `stdpath('data')/site/pack/core/opt`); `mason.nvim` and `nvim-treesitter` download and build third-party binaries/parsers at runtime. Expect network access and external processes on first start.
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
