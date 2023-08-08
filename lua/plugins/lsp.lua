return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd  = {
			"MasonUpdate",
		},
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
	},
}
