return {
    'mfussenegger/nvim-lint',
    config = function ()
        local lint = require('lint')

        lint.linters_by_ft = {
            go = {'golangcilint'},
            javascript = { 'eslint_d' },
            typescript = { 'eslint_d' },
        }

        vim.api.nvim_create_autocmd(
            { "BufWritePre" },
            {
                callback = function ()
                    lint.try_lint()
                end
            }
        )
    end,

}
