local ts_select_dir_for_grep = function(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local fb = require("telescope").extensions.file_browser
  local live_grep = require("telescope.builtin").live_grep
  local current_line = action_state.get_current_line()

  fb.file_browser({
    files = false,
    depth = false,
    attach_mappings = function(prompt_bufnr)
      require("telescope.actions").select_default:replace(function()
        local entry_path = action_state.get_selected_entry().Path
        local dir = entry_path:is_dir() and entry_path or entry_path:parent()
        local relative = dir:make_relative(vim.fn.getcwd())
        local absolute = dir:absolute()

        live_grep({
          results_title = relative .. "/",
          cwd = absolute,
          default_text = current_line,
        })
      end)

      return true
    end,
  })
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "prochri/telescope-all-recent.nvim", dependencies = { "kkharji/sqlite.lua" }, config = function() end },
      { "nvim-telescope/telescope-file-browser.nvim" }
    },
    config = function(plugin, opts)
      local custom_opts = {
        pickers = {
          live_grep = {
            mappings = {
              i = {
                ["<C-f>"] = ts_select_dir_for_grep,
              },
              n = {
                ["<C-f>"] = ts_select_dir_for_grep,
              }
            }
          }
        }
      }

      require "plugins.configs.telescope"(plugin, vim.tbl_deep_extend("force", opts, custom_opts))
      require("telescope").load_extension "file_browser"
      require("telescope-all-recent").setup {}
    end,
  },
}
