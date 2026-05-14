vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.title = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- vim.opt.list = true
vim.opt.number = true
vim.opt.signcolumn = "yes:1"
vim.opt.scrolloff = 8
vim.opt.showcmd = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undodir")
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true
vim.opt.showmode = false

-- no automatic comment insertion
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

vim.g.clipboard = {
  name = "win32yank-wsl",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = true,
}

vim.api.nvim_set_hl(0, "NormalNC", { bg = "none", fg = "#6f6f8f" })

vim.cmd [[
  hi Normal guibg=none ctermbg=none
  hi NormalNC guibg=none ctermbg=none
  hi NormalFloat guibg=none ctermbg=none
  hi SignColumn guibg=none ctermbg=none
  hi VertSplit guibg=none ctermbg=none
  hi EndOfBuffer guibg=none ctermbg=none
  hi NvimTreeNormal guibg=none
  hi NvimTreeNormalNC guibg=none
  hi NvimTreeEndOfBuffer guibg=none
  hi FloatBorder guibg=none
  hi Pmenu guibg=none
]]

function ToggleBackground()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end

vim.keymap.set("n", "<leader>bt", ToggleBackground, { desc = "Toggle dark/light theme" })

-- Resize splits with Ctrl + arrow keys
vim.keymap.set('n', '<C-Up>',    ':resize -2<CR>')
vim.keymap.set('n', '<C-Down>',  ':resize +2<CR>')
vim.keymap.set('n', '<C-Left>',  ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')

vim.keymap.set("n", "<leader>lz", function ()
   if vim.bo.filetype == "lazy" then
        vim.cmd("q")
    else
        vim.cmd("Lazy")
    end
end, { desc = "Toggle Lazy plugin manager"})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<leader>j', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<leader>k', '<Cmd>BufferNext<CR>', opts)

-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)

-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
map('n', '<C-p>',   '<Cmd>BufferPick<CR>', opts)
map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)

-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)


-- Close all buffers if all are saved, then exit Neovim. Otherwise, prompt to save unsaved buffers.
map('n', '<leader>qq', function()
-- Check for unsaved buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "modified") then
        -- Prompt to save the buffer
        vim.notify("Buffer " .. vim.api.nvim_buf_get_name(buf) .. " has unsaved changes.", vim.log.levels.WARN)
        local choice = vim.fn.confirm("You have unsaved changes. Do you want to save before quitting?", "&Yes\n&No\n&Cancel", 1)
        if choice == 1 then
            vim.api.nvim_buf_call(buf, function() vim.cmd("write") end)  -- saves the buffer
         elseif choice == 3 then
            return  -- cancel quitting
        end
         -- vim.cmd("bufdo update")  -- saves all modified buffers

      return
    end
  end
  -- All buffers are saved; wipe them and quit
  vim.cmd("bufdo bwipeout")  -- closes all buffers
  vim.cmd("qa")               -- quits Neovim
end, { desc = "Quit all if saved" })


-- Keymap to pick a Copilot model and set it globally
map("n", "<leader>cm", function()
  local models = vim.fn["copilot-chat.client"]() -- returns list of available models
  if not models or #models == 0 then
    vim.notify("No Copilot models found!", vim.log.levels.WARN)
    return
  end

  -- Ask user to select a model
  local choice = vim.fn.inputlist(vim.list_extend({ "Select Copilot model:" }, models))
  if choice < 1 or choice > #models then
    vim.notify("Invalid choice", vim.log.levels.WARN)
    return
  end

  local selected_model = models[choice]
  vim.g.copilot_chat_model = selected_model  -- store globally

  -- Update current chat if open
  local chat = require("copilot-chat.ui").get_current()
  if chat then
    chat:set_model(selected_model)
    vim.notify("Switched Copilot model to: " .. selected_model, vim.log.levels.INFO)
  else
    vim.notify("Selected model will be used on next chat: " .. selected_model, vim.log.levels.INFO)
  end
end, { desc = "Select Copilot model" })
