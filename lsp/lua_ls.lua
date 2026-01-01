-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
---@type vim.lsp.Config
return {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath('config')
				and (vim.us.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
			then
				return
			end
		end
		
		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua is using
				-- most likely LuaJIT in the case of Neovim
				version = 'LuaJIT',
				path = {
					'lua/?/lua',
					'lua/?/init.lua',
				},
			},
			workspace = {
				checkThirParty = false,
				library = {
					vim.env.VIMRUNTIME
					-- Depending on the usage
					-- Can add additonal paths
					-- '${3rd}/luv/library',
					-- '${3rd}/busted/library',
				},
				-- Or pull in all or 'runtimepath'
				-- with cost of a lot slower and some issues when
				-- working on own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
					-- vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = {
		'.emmyrc.json',
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'selene.toml',
		'seleny.yml',
		'.git',
	},
	settings = {
		Lua = {
			codeLens = { enable = true },
			hint = { enable = true, semicolon = 'Disable' },
		},
	},
}
