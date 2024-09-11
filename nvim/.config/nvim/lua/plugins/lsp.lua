return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x',
        lazy = true,
        config = false,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local null_ls = require "null-ls"

            require("mason").setup()

            require("mason-null-ls").setup {
                ensure_installed = {
                    "ruff-lsp",
                    "black",
                    "debugpy",
                },
                automatic_installation = false,
                handlers = {},
            }

            null_ls.setup {
                sources = {
                    null_ls.builtins.formatting.black.with {
                        extra_args = { "--line-length=99", "--preview", "--enable-unstable-feature", "string_processing"},
                    },
                },
                on_attach = function(client, bufnr)
                    if client.supports_method "textDocument/formatting" then
                        vim.api.nvim_clear_autocmds {
                            group = augroup,
                            buffer = bufnr,
                        }
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format { bufnr = bufnr }
                            end,
                        })
                    end
                end,
            }
        end,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip'},
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    {name = 'nvim_lsp'},
                    { name = 'nvim_lsp_signature_help' },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<Enter>"] = cmp.mapping.confirm { select = true },
                }),
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = {'LspInfo', 'LspInstall', 'LspStart'},
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
        },
        config = function()
            local lsp_zero = require('lsp-zero')

            -- lsp_attach is where you enable features that only work
            -- if there is a language server active in the file
            local lsp_attach = function(client, bufnr)
                local opts = {buffer = bufnr}

                vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                vim.keymap.set("n", "<leader>m", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                vim.keymap.set("n", "<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
                vim.keymap.set("n", "<leader>vrn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                vim.keymap.set("n", "<leader>vrr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                vim.keymap.set({ "n", "x" }, "<leader>f", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
            end

            lsp_zero.extend_lspconfig({
                sign_text = true,
                lsp_attach = lsp_attach,
                capabilities = require('cmp_nvim_lsp').default_capabilities()
            })

            require('mason-lspconfig').setup({
                ensure_installed = {
                "pyright",
            },
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                }
            })

            local lspconfig = require "lspconfig"

            local servers = {
                "pyright",
                "ruff_lsp",
            }

            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup {
                    filetypes = { "python" },
                }
            end
        end
    }
}
