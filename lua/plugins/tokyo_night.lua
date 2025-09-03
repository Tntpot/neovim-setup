return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local transparent = true
        local getOS = require("config.getOS")
        if getOS.getName() == "Windows" then
            transparent = false
        end
        require("tokyonight").setup({
            transparent = transparent,
            terminal_colors = true,
            on_colors = function(colors)
                colors.comment = colors.orange
            end,
        })
        -- load the colorscheme here
        vim.cmd.colorscheme("tokyonight-storm")
    end,
}
