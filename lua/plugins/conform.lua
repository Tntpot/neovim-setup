return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
			},
		})

		vim.keymap.set("n", "<leader>f", function()
			print("Formatted buffer via Conform")
			require("conform").format({
				bufnr = 0,
				lsp_fallback = true,
			})
		end)
	end,
}
