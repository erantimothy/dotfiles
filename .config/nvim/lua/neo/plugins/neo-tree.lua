return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "antosha417/nvim-lsp-file-operations",
    "3rd/image.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true, -- auto close Neo-tree if it's the last window
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_default",
        filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                },
      },
      renderer = {
        highlight_git = true,
        icons = {
          enabled = true,
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "u",
            },
          },
        },
      },
      window = {
        width = 35,
        position = 'left',
        mappings = {
            ["<BS>"] = "navigate_up",
            ["l"] = "open",
            ["<CR>"] = function(state)
                local node = state.tree:get_node()
                if not node then return end

                if node.type == "directory" then
                    -- change root to selected directory (navigate_up)
                    require("neo-tree.sources.filesystem.commands").set_root(state, node)
                else 
                    -- open files as usual
                    require("neo-tree.sources.filesystem.commands").open(state)
                end
            end,
            -- Horizontal split
            ["s"] = function(state)
              local node = state.tree:get_node()
              if node.type == "file" then
                vim.cmd("vsplit " .. vim.fn.fnameescape(node.path))
                -- Move the new split to the right
                vim.cmd("wincmd L")
              end
            end,

            -- -- Vertical split
            -- ["v"] = function(state)
            --   local node = state.tree:get_node()
            --   if node.type == "file" then
            --     vim.cmd("split " .. vim.fn.fnameescape(node.path))
            --     -- Move the new split to the right
            --     vim.cmd("wincmd J")
            --   end
            -- end,
        },
      },
    })

    -- Auto open Neo-tree when Neovim starts
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function ()
        -- Delay slightly to ensure the main file buffer loads first
        vim.defer_fn(
          function()
            require("neo-tree.command").execute({toggle = true, dir = vim.loop.cwd()})
          end
        , 10)
      end
    })

    -- Auto close Neo-tree when it's the only window left
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function ()
        if vim.bo.filetype == "neo-tree" and vim.api.nvim_list_wins() == 1 then
          vim.cmd("quit")
        end
      end
    })

    -- clean up treesitter highlight issues
    vim.api.nvim_create_autocmd({ "BufLeave", "BufEnter" }, {
      callback = function()
        pcall(vim.api.nvim_buf_clear_namespace, 0, -1, 0, -1)
      end,
    })
  end,

    keys = {
    {
      "<leader>n",
      function()
        local neotree_state = require("neo-tree.sources.manager").get_state("filesystem")
        if neotree_state and neotree_state.winid
            and vim.api.nvim_get_current_win() == neotree_state.winid
        then
          vim.cmd("wincmd p") -- switch back to previous window
        else
          require("neo-tree.command").execute({ toggle = false, dir = vim.loop.cwd() })
        end
      end,
      desc = "Toggle Neo-tree or return to code window",
    },
    {
      "<leader>t",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = "Toggle Neo-tree",
    },
  },

  -- vim.keymap.set('n', '<leader>n', function()
  --    local neotree_state = require("neo-tree.sources.manager").get_state("filesystem")
  --    if neotree_state and neotree_state.winid and vim.api.nvim_get_current_win() == neotree_state.winid then
  --       -- If currently in Neo-tree, go back to previous window
  --       vim.cmd("wincmd p")
  --    else
  --       -- Otherwise, toggle Neo-tree
  --       require("neo-tree.command").execute({ toggle = false, dir = vim.loop.cwd() })
  --    end
  --  end, { desc = "Toggle Neo-tree or return to code window" }),
  --
  -- -- Toggle Neo-tree when space + t is pressed
  -- vim.keymap.set('n', '<leader>t', function()
  --   require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
  -- end
  -- ),
}
