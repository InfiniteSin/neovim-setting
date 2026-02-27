return {
    "ibhagwan/fzf-lua",
    keys = {
        { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find Files" },
        { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Find Live Grep" },
        { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Find Buffers" },
        { "<leader>fq", function() require("fzf-lua").quickfix() end, desc = "Find Quickfix" },
        { "<leader>fl", function() require("fzf-lua").loclist() end, desc = "Find Locationlist" },
        { "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "Find Help" },
        { "<leader>f=", function() require("fzf-lua").keymaps() end, desc = "Find Keymaps" },
        { "<leader>fx", function() require("fzf-lua").diagnostics_document() end, desc = "Find Diagnostic Document" },
        { "<leader>fX", function() require("fzf-lua").diagnostics_workspace() end, desc = "Find Diagnostic Workspace" },
    },
    opts = {},
}
