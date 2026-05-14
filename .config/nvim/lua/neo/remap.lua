local map = vim.keymap.set

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("i", "jj", "<Esc>", { noremap = true, silent = true })

-- Set timeout for key sequences
vim.opt.timeout = true
vim.opt.timeoutlen = 300 

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlights text when yanking",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Copy current line or selection to Windows clipboard with 'wy'
-- Normal mode: copy current line
map('n', 'wy', '"+yy', { noremap = true, silent = true, desc = "Copy line to Windows clipboard" })

-- Visual mode: copy selection
map('v', 'wy', '"+y', { noremap = true, silent = true, desc = "Copy selection to Windows clipboard" })

-- tab remappings in nvim
-- vim.keymap.set("n", "<Tab>", "gt", { silent = true })
-- vim.keymap.set("n", "<S-Tab>", "gT", { silent = true })
-- vim.keymap.set("n", "T", ":tabclose<CR>", { silent = true })

-- split remappings in nvim
map("n", "SH", "<C-w>h", { silent = true , desc = "Move to window on the left"})
map("n", "SL", "<C-w>l", { silent = true , desc = "Move to window on the right"})
map("n", "SW", "<C-w>w", { silent = true , desc = "Move to next window"})
map("n", "SK", "<C-w>k", { silent = true , desc = "Move to window above"})
map("n", "SJ", "<C-w>j", { silent = true , desc = "Move to window below"})
map("n", "SV", "<C-w>v", { silent = true , desc = "Split window vertically"})
map("n", "SS", "<C-w>s", { silent = true , desc = "Split window horizontally"})
map("n", "SQ", "<C-w>q", { silent = true , desc = "Close current window"})
map("n", "SO", "<C-w>o", { silent = true , desc = "Close other windows"})
