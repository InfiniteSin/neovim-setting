-- Using Which-Key manage keymap
local wk = require("which-key")

-- Basic Key Maps
wk.register({
	["<leader>"] = {
		r = {
			w = { vim.cmd.Ex, "Return Netrw" },
		},
	},
})
