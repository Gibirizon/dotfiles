return {
    {
        "mfussenegger/nvim-dap",
        config = function(_, opts)
            local dap = require('dap')
            dap.adapters.python = {
                type = 'executable';
                command = os.getenv('HOME') .. '/python/bin/python';
                args = { '-m', 'debugpy.adapter' };
            }
            dap.configurations.python = {
                {
                    type = 'python';
                    request = 'launch';
                    name = "Debug file";
                    console = 'integratedTerminal';
                    justMyCode = false;
                    program = "${file}";
                    pythonPath = function()
                        return os.getenv('HOME') .. '/python/bin/python'
                    end;
                },
            }


            vim.keymap.set("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>")
            vim.keymap.set("n", "<C-i>", "<cmd>lua require('dap').step_over()<cr>")
            vim.keymap.set("n", "<C-n>", "<cmd>lua require('dap').step_into()<cr>")
            vim.keymap.set("n", "<C-p>", "<cmd>lua require('dap').step_out()<cr>")
            vim.keymap.set("n", "<C-Space>", "<cmd>lua require('dap').continue()<cr>")
        end,
    },
    {
        "nvim-neotest/nvim-nio",
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        depenedencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function(_, opts)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)

            vim.keymap.set("n", "<leader>dpr", "<cmd>lua require('dap-python').test_method()<cr>")
        end,
    },
    -- {
    --     "rcarriga/nvim-dap-ui",
    --     dependencies = {
    --         "mfussenegger/nvim-dap",
    --         "nvim-neotest/nvim-nio",
    --     },
    --     config = function()
    --         local dap = require "dap"
    --         local dapui = require "dapui"
    --         dapui.setup()
    --         dap.listeners.after.event_initialized["dapui_config"] = function()
    --             dapui.open()
    --         end
    --             vim.keymap.set("n", "<C-c>", "<cmd>lua require('dapui').close()<cr> <bar> :lua require('dap').disconnect()<cr> <bar> :lua require('dap').close()<cr>")
    --             end,
    --         },
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            vim.keymap.set("n", "<C-c>", "<cmd>lua require('dapui').close()<cr> <bar> :lua require('dap').disconnect()<cr> <bar> :lua require('dap').close()<cr>")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },
        }
