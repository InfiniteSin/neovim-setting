return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",

			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local lsp = require("lsp-zero").preset({})

			lsp.ensure_installed({
				"bashls",
				"eslint",
				"lua-language-server",
				"marksman",
				-- "pyright",
				-- "pylsp",
				"ruff_lsp",
				"rust_analyzer",
				"tsserver",
			})

			local cmp = require("cmp")
			local cmp_action = require("lsp-zero").cmp_action()

			cmp.setup({
				mapping = {
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
				},
			})

			lsp.on_attach(function(client, bufnr)
				lsp.default_keymaps({ 
					buffer = bufnr,
					preserve_mappings = false,
				})
			end)

			require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

			lsp.setup()
		end,
	},
}
