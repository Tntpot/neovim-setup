return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "Hoffs/omnisharp-extended-lsp.nvim",
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
            formatters_by_ft = {
                -- Conform will run the first available formatter
                javascript = { "prettierd", "prettier", stop_after_first = true },
                lua = { "stylua" },
            },
        })
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()

        local pid = vim.fn.getpid()
        local lspconfig = require("lspconfig")
        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        format = {
                            enable = true,
                            -- Put format options here
                            -- NOTE: the value should be STRING!!
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "2",
                            },
                        },
                    },
                },
            },
            omnisharp = {
                cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
                enable_roslyn_analyzers = true,
                -- organize_imports_on_format = true,
                enable_import_completion = true,
                handlers = {
                    ["textDocument/definition"] = function(...)
                        return require("omnisharp_extended").handler(...)
                    end,
                    ["textDocument/implementation"] = function(...)
                        return require("omnisharp_extended").handler(...)
                    end,
                },
                settings = {
                    filetypes = { "cs", "cshtml" },
                    root_markers = { "*.sln", "*.csproj", ".git" },
                },
            },
            astro = {},
        }

        for name, config in pairs(servers) do
            if config == true then
                config = {}
            end
            config = vim.tbl_deep_extend("force", {}, {
                capabilities = capabilities,
            }, config)

            -- Set up the LSP
            lspconfig[name].setup(config)
        end

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
                ["<C-Space>"] = cmp.mapping.confirm({ select = true }),
                -- ["<C-Space>"] = cmp.mapping.complete(),
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
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        local definition_function = function() end

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                print("LSPAttached to bufnr: " .. args.buf)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local is_omnisharp = client and client.name == "omnisharp"
                -- local has_telescope = pcall(require, "telescope.builtin")

                -- Formatting
                local bufnr = args.buf
                vim.keymap.set("n", "<leader>f", function()
                    print("Formatted bufnr " .. bufnr .. " via Conform")
                    require("conform").format({
                        bufnr = bufnr,
                        lsp_fallback = true,
                    })
                end)

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
