return {
	"nvim-telescope/telescope.nvim",

	-- tag = "0.1.8",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>sf",
			function()
				require("telescope.builtin").find_files({
					find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
				})
			end,
		},
		{
			"<leader>gf",
			function()
				require("telescope.builtin").git_files()
			end,
		},
		{
			"<leader>sp",
			function()
				require("telescope.builtin").live_grep()
			end,
		},
		{
			"<leader>vh",
			function()
				require("telescope.builtin").help_tags()
			end,
		},
	},
}
