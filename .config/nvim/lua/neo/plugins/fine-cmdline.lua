return {
    "VonHeikemen/fine-cmdline.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    
    config = function()
        require("fine-cmdline").setup({
            cmdline = {
                enable_keymaps = true,
                smart_history = true,
            },
            popup = {
                position = {
                    row = "10%",
                    col = "50%",
                },
                size = {
                    width = "60%"
                },
                border = {
                    style = "rounded",
                    text = {
                        top = "Cmdline",
                        top_align = "center",
                    },
                },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None",
                },
            }
        })

        set_keymaps = function(imap, feedkeys)
            local fn = require('fine-cmdline').fn

            imap('<M-k>', fn.up_search_history)
            imap('<M-j>', fn.down_search_history)
            imap('<Up>', fn.up_history)
            imap('<Down>', fn.down_history)
        end
    end,

    keys = {
        {
            ":",
            "<cmd>FineCmdline<CR>",
            mode = "n",
            desc = "FineCmdline",
        },
    },
}
