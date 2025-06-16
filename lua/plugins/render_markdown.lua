return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
		},
		opts = {
			enabled = true,
			pipe_table = {
				enabled = true,
				preset = "normal",
				head = "RenderMarkdownTableHead",
				row = "RenderMarkdownTableRow",
				filler = "RenderMarkdownTableFill",
			},
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)
		end,
	},
}
