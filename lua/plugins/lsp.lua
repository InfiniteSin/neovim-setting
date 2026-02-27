-- LSP Configs
-- vim.pack.add({
--     { src = 'https://github.com/neovim/nvim-lspconfig' },
-- })

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
                    vim.api.nvim_get_runtime_file("", true),
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
})



local function lsp_on_attach(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
        return
    end

    local bufnr = ev.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "<leader>gd", function()
        require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
    end, opts)

    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

    vim.keymap.set("n", "<leader>gS", function()
        vim.cmd("vsplit")
        vim.lsp.buf.definition()
    end, opts)

    vim.keymap.set("n", "grr", function()
        require("fzf-lua").lsp_references()
    end, opts)
    vim.keymap.set("n", "<leader>ft", function()
        require("fzf-lua").lsp_typedefs()
    end, opts)
    vim.keymap.set("n", "<leader>fs", function()
        require("fzf-lua").lsp_document_symbols()
    end, opts)
    vim.keymap.set("n", "<leader>fw", function()
        require("fzf-lua").lsp_workspace_symbols()
    end, opts)
    vim.keymap.set("n", "<leader>fi", function()
        require("fzf-lua").lsp_implementations()
    end, opts)
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


return {
    {
        'mason-org/mason.nvim',
        cmd = 'Mason',
        dependencies = {
            'neovim/nvim-lspconfig'
        },
        opts = {},
    },
}
