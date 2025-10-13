return {
    "nvim-lualine/lualine.nvim",
    event = "ColorScheme",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = false,
                -- theme = "tokyonight",
                theme = "auto",
                component_separators = "|",
                section_separators = "",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
            },
        })
    end,
}
