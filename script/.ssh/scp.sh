#!/bin/bash
source ~/.ssh/servers.sh

_preview1() {
    index=$(_index "$1")
    echo ${targets[index]}
}

_preview2() {
    index=$(_index "$1")
    target="$2"
    [ "$target" = "从本地到远程" ] && echo "scp -r [SOURCE] ${targets[index]}:~"
    [ "$target" = "从远程到本地" ] && echo "scp -r ${targets[index]}:[SOURCE] ."
}

# 远程目录遍历，返回最终选中的路径
_remote_browse() {
    local ssh_target="$1"
    local current_path="$2"
    local fzfopt='--cycle --header-first --preview-window=bottom:3:wrap,border-up'

    while true; do
        local listing
        listing=$(ssh "$ssh_target" "ls -la --color=never $current_path 2>/dev/null \
            | awk 'NR>1 && \$NF != \".\" && \$NF != \"..\" {
                if (\$1 ~ /^d/) print \$NF\"/\";
                else print \$NF
            }'")

        if [[ -z "$listing" ]]; then
            echo "⚠ 目录为空或无权限" >&2
            return 1
        fi

        local options="../  (返回上级)\n✔  (选择当前目录: $current_path)\n$listing"

        local selected
        selected=$(echo -e "$options" | fzf $fzfopt \
            --header="📂 $current_path  |  目录/结尾可进入，✔ 选当前目录" \
            --preview="
                item=\$(echo {} | sed 's|/$||' | sed 's|✔.*||' | sed 's|\.\./.*||')
                [[ -z \$item ]] && exit 0
                full='$current_path'/\$item
                ssh '$ssh_target' \"
                    if [ -d \$full ]; then ls -la \$full 2>/dev/null | head -30;
                    else file \$full; echo '---'; cat \$full 2>/dev/null | head -30; fi
                \"
            " \
            --height=15)

        [[ -z "$selected" ]] && return 1

        selected=$(echo "$selected" | xargs)

        if [[ "$selected" == "../  (返回上级)" ]]; then
            current_path=$(dirname "$current_path")
            [[ "$current_path" == "." ]] && current_path="\$HOME"
        elif [[ "$selected" == "✔  (选择当前目录:"* ]]; then
            echo "$current_path"
            return 0
        elif [[ "$selected" == */ ]]; then
            local dirname="${selected%/}"
            current_path="$current_path/$dirname"
        else
            echo "$current_path/$selected"
            return 0
        fi
    done
}

# 本地目录遍历
_local_browse() {
    local current_path="$1"
    local fzfopt='--cycle --header-first --preview-window=bottom:3:wrap,border-up'

    while true; do
        local listing
        listing=$(ls -la --color=never "$current_path" 2>/dev/null \
            | awk 'NR>1 && $NF != "." && $NF != ".." {
                if ($1 ~ /^d/) print $NF"/";
                else print $NF
            }')

        local options="../  (返回上级)\n✔  (选择当前目录: $current_path)\n$listing"

        local selected
        selected=$(echo -e "$options" | fzf $fzfopt \
            --header="📂 $current_path  |  目录/结尾可进入，✔ 选当前目录" \
            --preview="
                item=\$(echo {} | sed 's|/$||' | sed 's|✔.*||' | sed 's|\.\./.*||')
                [[ -z \$item ]] && exit 0
                full='$current_path'/\$item
                if [ -d \"\$full\" ]; then ls -la \"\$full\" 2>/dev/null | head -30;
                else file \"\$full\"; echo '---'; cat \"\$full\" 2>/dev/null | head -30; fi
            " \
            --height=15)

        [[ -z "$selected" ]] && return 1

        selected=$(echo "$selected" | xargs)

        if [[ "$selected" == "../  (返回上级)" ]]; then
            current_path=$(dirname "$current_path")
            [[ "$current_path" == "." ]] && current_path="/"
        elif [[ "$selected" == "✔  (选择当前目录:"* ]]; then
            echo "$current_path"
            return 0
        elif [[ "$selected" == */ ]]; then
            local dirname="${selected%/}"
            current_path="$current_path/$dirname"
        else
            echo "$current_path/$selected"
            return 0
        fi
    done
}

_scp() {
    local fzfopt='--cycle --header-first --preview-window=bottom:1:wrap,border-up'

    # 选择服务器
    local server
    server=$(_list | fzf $fzfopt --header=请选择服务器 --preview="~/.ssh/scp.sh preview1 {}")
    [[ -z "$server" ]] && exit 0

    local ssh_target
    ssh_target=$(_preview1 "$server")

    # 选择方向
    local target
    target=$(echo -e "从本地到远程\n从远程到本地" | fzf $fzfopt \
        --header=请选择操作 \
        --preview="~/.ssh/scp.sh preview2 $server {}" \
        --height=7)
    [[ -z "$target" ]] && exit 0

    # 选择文件（支持目录遍历）
    local _source
    if [ "$target" = "从本地到远程" ]; then
        _source=$(_local_browse "$HOME")
    else
        _source=$(_remote_browse "$ssh_target" "~")
    fi
    [[ -z "$_source" ]] && exit 0

    # 组装命令
    local _cmd
    [ "$target" = "从本地到远程" ] && _cmd="scp -r '$_source' $ssh_target:~"
    [ "$target" = "从远程到本地" ] && _cmd="scp -r $ssh_target:'$_source' ."

    # 选择操作
    local option
    option=$(echo -e "复制命令\n执行命令" | fzf $fzfopt \
        --header=请选择操作 \
        --preview="echo $_cmd" \
        --height=7)
    [[ -z "$option" ]] && exit 0

    [ "$option" = "复制命令" ] && echo -n "$_cmd" | lemonade copy && echo 'copied'
    [ "$option" = "执行命令" ] && echo "开始执行: $_cmd" && eval "$_cmd"
}

case $1 in
    '') _scp ;;
    preview1) _preview1 "$2" ;;
    preview2) _preview2 "$2" "$3" ;;
    *) scp "$@" ;;
esac
