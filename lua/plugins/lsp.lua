return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd  = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstalAll",
			"MasonLog",
			"MasonUpdate",
			"MasonUpdateAll",
		},
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {}
	},
}
