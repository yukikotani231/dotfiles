---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          -- 隠しファイルを常に表示するように上書き
          ["<Leader>ff"] = {
            function() require("snacks").picker.files { hidden = true } end,
            desc = "Find files",
          },
          ["<Leader>fw"] = {
            function() require("snacks").picker.grep { hidden = true } end,
            desc = "Find words",
          },
        },
      },
    },
  },
}
