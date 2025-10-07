function SetColours(colour)
    colour = colour or "rose-pine-moon"

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    vim.cmd.colorscheme(colour)
end

return {
    -- {
    --     "folke/tokyonight.nvim",
    --     -- lazy = false,
    --     opts = {},
    --     config = function()
    --         -- SetColours("tokyonight")
    --     end
    -- },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })

            SetColours();
        end
    },
}
