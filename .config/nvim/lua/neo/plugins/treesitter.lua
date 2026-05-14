return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter.install").ensure_installed("markdown")

    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "lua","javascript","typescript","python","java","bash","c", "css", "html", "markdown_inline", "norg", "scss", "svelte", "tsx", "typst", "vue"
	    },
        highlight = {
            enable = true,
            additional_vim_highlighting = false,
        },
        indent = { enable = true },
        rainbow = {
            enable = true,
            disable = {"html"},
            extended_mode = false,
            max_file_line = nil,
        },
        autotag = { enable = true },
        incremental_selection = { enable = true },
    })
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
  end,
}
