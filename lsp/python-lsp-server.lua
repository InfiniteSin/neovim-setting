return {
	cmd = { 'python-lsp-server' },
	filetypes = { 'py' },
	root_markers = {
        'pyproject.toml',
        'uv.lock',
		'.git',
	}
}
