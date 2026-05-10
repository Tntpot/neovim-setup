return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        require("nvim-treesitter").setup {
            install_dir = vim.fn.stdpath('data') .. '/site'
        }

        require("nvim-treesitter").install {
            "javascript",
            "lua",
            "c_sharp",
            "markdown",
            "markdown_inline",
        }
    end,
}
