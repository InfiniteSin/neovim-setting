local M = {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require("nvim-treesitter.install").update({
      prefer_git = false, -- using curl + tar instead of git to download parser packages.
      compilers = {
        "clang",
        "gcc",
      }, -- use clang as compliler, otherwise use gcc.
    })
  end,
}

return M
