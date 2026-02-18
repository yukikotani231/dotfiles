---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- フィルタされたアイテムを表示（グレーアウト表示）
        hide_dotfiles = false, -- 隠しファイル（.で始まるファイル）を常に表示
        hide_gitignored = false, -- gitignoreされたファイルも表示
      },
    },
  },
}
