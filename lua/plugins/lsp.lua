-- LSP Configs

-- load=false: on the rtp so vendored lsp/*.lua can require 'lspconfig.util';
-- its tiny plugin/ file (defines :LspInfo etc.) is sourced at startup.
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
}, { load = false })

-- fully deferred: load=false would still source plugin/ at end of startup
-- (:packadd! semantics); a noop load function keeps mason off the rtp entirely.
vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
}, { load = function() end })

-- approximates lazy.nvim's cmd = "Mason": load on first :Mason
vim.api.nvim_create_user_command("Mason", function()
    vim.cmd.packadd("mason.nvim") -- add to rtp + source plugin/ (defines the real :Mason)
    require("mason").setup({})
    vim.cmd("Mason")
end, { desc = "Load mason.nvim and open :Mason" })

local lua_root_markers1 = {
    '.emmyrc.json',
    '.luarc.json',
    '.luarc.jsonc',
}
local lua_root_markers2 = {
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
}
-- Lua-Language-Server Extend configs
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { lua_root_markers1, lua_root_markers2, { '.git' } }
        or vim.list_extend(vim.list_extend(lua_root_markers1, lua_root_markers2), { '.git' }),
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                    "{$3rd}/luv/library",
                },
                runtime = {
                    version = 'LuaJIT',
                },
                telemetry = { enable = false },
            },
        },
    },
})

-- detect .mdx as markdown.mdx: markdown tooling applies to MDX too
-- (marksman lists the ft; core treesitter maps it to the markdown parser)
vim.filetype.add({ extension = { mdx = "markdown.mdx" } })

-- vendored lsp/mdx_analyzer.lua targets filetype 'mdx'; retarget to markdown.mdx
vim.lsp.config('mdx_analyzer', {
    filetypes = { 'markdown.mdx' },
})

vim.lsp.enable({
    -- AST
    'ast_grep',
    -- Lua
    'lua_ls',
    -- C
    'clangd',
    -- Python
    'ruff',
    'ty',
    'debugpy',
    -- Markdown/MDX
    'marksman',
    'mdx_analyzer',
})



-- LuaJIT exposes unpack as a global (Lua 5.1); 5.2+ moved it to table.unpack
local unpack = table.unpack or unpack

-- fzf-lua stays off the rtp until loaded; packadd is a no-op once loaded
local function fzf(fn, ...)
    local args = { ... }
    return function()
        vim.cmd.packadd("fzf-lua")
        require("fzf-lua")[fn](unpack(args))
    end
end

local function lsp_on_attach(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
        return
    end

    local bufnr = ev.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "<leader>gd", fzf("lsp_definitions", { jump_to_single_result = true }), opts)

    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

    vim.keymap.set("n", "<leader>gS", function()
        vim.cmd("vsplit")
        vim.lsp.buf.definition()
    end, opts)

    vim.keymap.set("n", "grr", fzf("lsp_references"), opts)
    vim.keymap.set("n", "<leader>ft", fzf("lsp_typedefs"), opts)
    vim.keymap.set("n", "<leader>fs", fzf("lsp_document_symbols"), opts)
    vim.keymap.set("n", "<leader>fw", fzf("lsp_workspace_symbols"), opts)
    vim.keymap.set("n", "<leader>fi", fzf("lsp_implementations"), opts)
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)

    if client:supports_method("textDocument/codeAction", bufnr) then
        vim.keymap.set("n", "<leader>oi", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" }, diagnostics = {} },
                apply = true,
                bufnr = bufnr,
            })
            vim.defer_fn(function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end, 50)
        end, opts)
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyLSPConfig", { clear = true }),
    callback = lsp_on_attach
})
