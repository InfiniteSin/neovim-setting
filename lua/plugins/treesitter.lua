return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync" },
		dependencies = {
			"nvim-treesitter/nvim-tree-docs",
			"nvim-treesitter/playground",
		},
		keys = {
			{ "<c-space>", desc = "Increment selection" },
			{ "<bs>", desc = "Decrement selection", mode = "x" },
		},
		opts = {
			highlight = { 
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"sql",
				"vim",
				"vimdoc",
				"yaml"
			},
			sync_install = false,
			auto_install = false,
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			tree_docs = { enable = true },
			playground = { 
				enable = true,
				updatetime = 25,
				persist_queries = false,
				keybindings = {
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
		},
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
