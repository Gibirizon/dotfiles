vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- run python or cpp
vim.keymap.set("n", "<leader>r", function()
    local file_dir = vim.fn.expand('%:p:h')
    local file_name = vim.fn.expand('%:t')
    local file_ext = vim.fn.expand('%:e')
    local file_base = vim.fn.expand('%:t:r')
    -- Save the file before running
    vim.cmd('write')
    vim.cmd('lcd ' .. file_dir)
    -- Create terminal window
    vim.cmd('below 10new')
    local buf = vim.api.nvim_get_current_buf()

    if file_ext == "py" then
        -- For Python files, start terminal with python command
        vim.cmd('terminal python ' .. file_name)
    elseif file_ext == "cpp" then
        -- Compile C++ first
        local compile_command = 'g++-12 -std=c++20 ' .. file_name .. ' -o ' .. file_base
        local compile_result = vim.fn.system(compile_command)
        if vim.v.shell_error ~= 0 then
            -- Compilation failed - split the error message into lines
            local error_lines = vim.split(compile_result, '\n', { plain = true })
            -- Filter out empty lines at the end
            error_lines = vim.tbl_filter(function(line)
                return line ~= ""
            end, error_lines)
            -- Set buffer to normal (not terminal) for showing compilation errors
            vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
            vim.api.nvim_buf_set_option(buf, 'swapfile', false)
            -- Prepare the complete message
            local message_lines = {
                "Compilation failed:",
                ""
            }
            -- Extend message_lines with error_lines
            vim.list_extend(message_lines, error_lines)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, message_lines)
            vim.api.nvim_buf_set_option(buf, 'modifiable', false)
            return
        end
        -- Start terminal with the compiled executable
        vim.cmd('terminal ./' .. file_base)
        -- Set up cleanup of executable on terminal exit
        -- vim.api.nvim_create_autocmd("TermClose", {
        --     buffer = buf,
        --     once = true,
        --     callback = function()
        --         if vim.fn.filereadable(file_base) == 1 then
        --             vim.fn.delete(file_base)
        --         end
        --     end
        -- })
    else
        -- Set buffer to normal (not terminal) for showing error
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(buf, 'swapfile', false)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
            "Unsupported file type: " .. file_ext,
            "Currently supporting: .py and .cpp files"
        })
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        return
    end

    -- Automatically enter insert mode in the terminal
    vim.cmd('startinsert')
end, { silent = true })
