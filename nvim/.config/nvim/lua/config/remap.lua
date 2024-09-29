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

-- run python fast
vim.keymap.set("n", "<leader>r", function()
    local file_dir = vim.fn.expand('%:p:h')
    local file_name = vim.fn.expand('%:t')
    vim.cmd('write')
    vim.cmd('lcd ' .. file_dir)
    vim.cmd('below 10new')  -- Open a new horizontal split window below
    vim.cmd('setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap')
    
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Running Python script...", "", "Output:"})
    
    local job_id = nil
    
    local function append_data(_, data)
        if data and vim.api.nvim_buf_is_valid(buf) then
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.schedule(function()
                        if vim.api.nvim_buf_is_valid(buf) then
                            vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                        end
                    end)
                end
            end
        end
    end

    job_id = vim.fn.jobstart('python ' .. file_name, {
        on_stdout = append_data,
        on_stderr = append_data,
        on_exit = function()
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(buf) then
                    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
                    vim.api.nvim_win_set_cursor(win, {1, 0})
                end
            end)
        end,
    })

    -- Set up an autocommand to stop the job if the buffer is closed
    vim.api.nvim_create_autocmd("BufWipeout", {
        buffer = buf,
        once = true,
        callback = function()
            if job_id and vim.fn.jobstop(job_id) == 1 then
                print("Python script stopped.")
            end
        end
    })
end, { silent = true })
