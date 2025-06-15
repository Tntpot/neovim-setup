return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			terminal_colors = true,
			on_colors = function(colors)
				colors.comment = colors.orange
			end,
		})
		-- load the colorscheme here
		vim.cmd.colorscheme("tokyonight-storm")
	end,
}
