# --- ~/.fzf_tools.zsh ---

# 1. 智能查找并用 nvim 打开 (支持行号跳转)
# 用法: fgp "关键词"
fgp() {
  local result
  # 使用 grep -n 输出 行号:路径:内容
  result=$(grep -rnI "${1:-.}" . | fzf --ansi \
    --delimiter : \
    --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3')

  # 解析结果并跳转
  if [[ -n "$result" ]]; then
    local file=$(echo "$result" | cut -d: -f1)
    local line=$(echo "$result" | cut -d: -f2)
    nvim +"$line" "$file"
  fi
}

# 2. 增强型文件查找
# 用法: ff "*.js"
ff() {
  local file
  file=$(find . -type f -name "${1:-*}" -not -path '*/.*' | fzf --preview 'bat --color=always {}')
  [[ -n "$file" ]] && nvim "$file"
}
