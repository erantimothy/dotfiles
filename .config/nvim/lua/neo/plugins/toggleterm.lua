return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function ()
        require("toggleterm").setup({
            open_mapping = [[<C-\>]],
            direction = "float",
            shade_terminals = true,
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
        })
        local Terminal = require("toggleterm.terminal").Terminal

        -- Horizontal terminal (bottom)
        local horizontal = Terminal:new({ direction = "horizontal" })

        -- Vertical terminal (right side)
        local vertical = Terminal:new({ direction = "vertical" })

        -- Floating terminal (center overlay)
        local floating = Terminal:new({ direction = "float" })

        -- Tab terminal (in a new tab)
        local tab = Terminal:new({ direction = "tab" })
        
        -- vim.keymap.set({"n","t"}, "<leader>ht", function() horizontal:toggle() end, { desc = "Toggle horizontal terminal" })
        -- vim.keymap.set({"n", "t"}, "<leader>vt", function() vertical:toggle() end, { desc = "Toggle vertical terminal" })
        -- vim.keymap.set({"n", "t"}, "<leader>ft", function() floating:toggle() end, { desc = "Toggle floating terminal" })
        vim.keymap.set({"n", "t"}, "<leader><Tab>", function() tab:toggle() end, { desc = "Toggle tab terminal" })

    end,
}
