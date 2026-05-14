return {
  "github/copilot.vim",
  {
      "CopilotC-Nvim/CopilotChat.nvim",
      cmd = {
        -- "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatToggle",
        "CopilotChatPrompts",
        "CopilotChatModels",
        "CopilotChatStop",
        "CopilotChatReset",
      },
      dependencies = {
          { "nvim-lua/plenary.nvim", branch = "master" },
      },
      build = "make tiktoken",
      opts = {
        -- See Configuration section for option
          model = 'gpt-4.1',
          temperature = 0.1,
          window = {
              layout = 'vertical',
              width = 0.3,
              title = "Copilot Chat",
              zindex = 1,
          },
          headers = {
              user = '👤 ET',
              assistant = '🤖 Copilot',
              tool = '🔧 Tool',
          },
          auto_insert_mode = true,
          highlight_headers = true,
          auto_follow_cursor = true,
      },

      keys = {
        -- Core UI
        { "<leader>aa", function() require("CopilotChat").toggle() end, desc = "AI: Toggle Chat", mode = { "n", "x" } },
        { "<leader>ac", function() require("CopilotChat").reset() end,  desc = "AI: Clear Chat",  mode = { "n", "x" } },
        { "<leader>as", "<cmd>CopilotChatStop<cr>",                   desc = "AI: Stop",        mode = { "n", "x" } },
        { "<leader>ap", function() require("CopilotChat").select_prompt() end, desc = "AI: Prompts", mode = { "n", "x" } },
        { "<leader>am", "<cmd>CopilotChatModels<cr>",                 desc = "AI: Models",      mode = { "n", "x" } },

          -- ASK MODE (like VS Code “Ask”): uses current buffer/selection as context
        {
          "<leader>aq",
          function()
            local input = vim.fn.input("Ask (buffer): ")
            if input ~= "" then
              require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
            end
          end,
          desc = "AI: Ask (buffer)",
          mode = "n",
        },
        {
          "<leader>aq",
          function()
            local input = vim.fn.input("Ask (selection): ")
            if input ~= "" then
              require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
            end
          end,
          desc = "AI: Ask (selection)",
          mode = "x",
        },
        -- AGENT-ISH MODE: prefixes @copilot so it can propose tool calls (grep/glob/file/edit/…)
      {
        "<leader>ag",
        function()
          local input = vim.fn.input("Agent (@copilot): ")
          if input ~= "" then
            require("CopilotChat").ask("@copilot " .. input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "AI: Agent-ish (@copilot)",
        mode = "n",
      },
    }
  },
}
