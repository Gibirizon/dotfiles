return {
    {
        "kiyoon/jupynium.nvim",
        build = "source ~/python/bin/activate; pip3 install --user .",
        -- build = "conda run --no-capture-output -n jupynium pip install .",
        -- enabled = vim.fn.isdirectory(vim.fn.expand "~/python"),
    },
    "rcarriga/nvim-notify",   -- optional
    "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
}
