#!/bin/bash

function check_python_version() {
    if command -v python3 &>/dev/null; then
        echo "当前系统已安装的Python版本："
        python3 --version
    else
        echo "未找到已安装的Python版本。"
    fi
}

function install_python() {
    # ... 安装Python的代码，保持不变 ...
}

function uninstall_python() {
    # 检查是否有Python已安装
    if ! command -v python3 &>/dev/null; then
        echo "未找到已安装的Python版本。"
        return
    fi

    # 获取所有已安装的Python版本
    installed_versions=$(ls /usr/local/bin/python* | awk -F / '{print $NF}' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

    # 列出所有已安装的Python版本供用户选择
    echo "可供选择的Python版本："
    for version in $installed_versions; do
        echo "$version"
    done

    # 让用户选择要卸载的Python版本
    read -p "请选择要卸载的Python版本： " version

    # 检查用户选择的版本是否已安装
    if echo "$installed_versions" | grep -q "$version"; then
        sudo rm -rf /usr/local/bin/python$version*
        sudo rm -rf /usr/local/lib/python$version*
        sudo rm -f /usr/local/bin/python3
        sudo rm -f /usr/local/bin/pip3

        if command -v apt-get &>/dev/null; then
            sudo apt-get install -y python3 python3-pip
        elif command -v yum &>/dev/null; then
            sudo yum install -y python3 python3-pip
        else
            echo "无法识别的Linux发行版。"
            return
        fi

        echo "Python $version卸载完成，已恢复为默认版本。"
        check_python_version
    else
        echo "未找到版本 $version，请检查输入的版本号。"
    fi
}

echo "欢迎使用Python安装与卸载脚本！"
read -p "请输入 'i' 安装Python，输入 'u' 卸载Python，输入 'c' 查看Python版本，或者其他键退出： " choice

if [[ "$choice" =~ ^[Ii]$ ]]; then
    install_python
elif [[ "$choice" =~ ^[Uu]$ ]]; then
    uninstall_python
elif [[ "$choice" =~ ^[Cc]$ ]]; then
    check_python_version
else
    echo "已退出脚本。"
fi
