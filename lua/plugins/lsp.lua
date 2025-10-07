return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {},
		})

		local cmp = require("cmp")

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"ts_ls",
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		local augroup = vim.api.nvim_create_augroup
		local tnt_pot_group = augroup("tnt_pot", {})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = tnt_pot_group,
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				print(client.name .. " LSP attached to bufnr: " .. args.buf)
				local is_omnisharp = client and client.name == "omnisharp"
				-- local has_telescope = pcall(require, "telescope.builtin")

				-- Telescope
				local builtin = require("telescope.builtin")

				vim.keymap.set("n", "gd", function()
					if is_omnisharp then
						require("omnisharp_extended").telescope_lsp_definitions()
						-- require("omnisharp_extended").lsp_definitions()
					else
						vim.lsp.buf.definition()
					end
				end, opts)
				vim.keymap.set("n", "gdd", function()
					if is_omnisharp then
						require("omnisharp_extended").telescope_lsp_implementations()
						-- require("omnisharp_extended").lsp_implementations()
					else
						vim.lsp.buf.implementation()
					end
				end, opts)
				vim.keymap.set("n", "gi", function()
					vim.lsp.buf.hover()
				end, opts)
				vim.keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)
				vim.keymap.set("n", "gl", function()
					vim.diagnostic.open_float()
				end, opts)
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, opts)
				vim.keymap.set("n", "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, opts)
				vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { buffer = 0 })
				-- vim.keymap.set("n", "<leader>gr", function()
				-- 	vim.lsp.buf.references()
				-- end, opts)
				vim.keymap.set("n", "<leader>vrn", function()
					vim.lsp.buf.rename()
				end, opts)
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})
	end,
}
