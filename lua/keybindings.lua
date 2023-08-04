-- Using Which-Key manage keymap
local wk = require("which-key")

-- Basic Key Maps
wk.register({
	r = {
		name = "Netrw",
		w = { vim.cmd.Ex, "Return Netrw" },
	},
	{ prefix = "<leader>" },
})

-- Telescope Key Maps
local builtin = require("telescope.builtin")
wk.register({
	f = {
		name = "Fuzzy Find",
		f = { builtin.find_files, "Find File" },
		b = { builtin.find_buffers, "Find Buffers" },
	},
	{ prefix = "<leader>" },
})

-- Treesitter Key Maps
wk.register({
	p = {
		g = { "<cmd>:TSPlaygroundToggle<cr>", "Toggle Playground" }
	},
	{ prefix = "<leader>" },
})
