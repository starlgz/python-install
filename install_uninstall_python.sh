#!/bin/bash

# 安装Python依赖项
function install_dependencies() {
    if [ "$LINUX_DISTRIBUTION" == "centos" ]; then
        sudo yum install -y gcc make openssl-devel bzip2-devel libffi-devel zlib-devel
    elif [ "$LINUX_DISTRIBUTION" == "ubuntu" ] || [ "$LINUX_DISTRIBUTION" == "debian" ]; then
        sudo apt-get update
        sudo apt-get install -y build-essential libssl-dev libffi-dev zlib1g-dev
    else
        echo "不支持的发行版。"
        exit 1
    fi
}

# 安装Python
function install_python() {
    if command -v python3 &>/dev/null; then
        echo "Python已安装。"
    else
        if [ "$LINUX_DISTRIBUTION" == "centos" ]; then
            sudo yum install -y python3
        elif [ "$LINUX_DISTRIBUTION" == "ubuntu" ] || [ "$LINUX_DISTRIBUTION" == "debian" ]; then
            sudo apt-get install -y python3
        fi
    fi
}

# 卸载Python
function uninstall_python() {
    if command -v python3 &>/dev/null; then
        if [ "$LINUX_DISTRIBUTION" == "centos" ]; then
            sudo yum remove -y python3
        elif [ "$LINUX_DISTRIBUTION" == "ubuntu" ] || [ "$LINUX_DISTRIBUTION" == "debian" ]; then
            sudo apt-get remove -y python3
        fi
    else
        echo "未找到已安装的Python版本。"
    fi
}

# 检查Python版本
function check_python_version() {
    if command -v python3 &>/dev/null; then
        echo "当前系统已安装的Python版本："
        python3 --version
    else
        echo "未找到已安装的Python版本。"
    fi
}

# 获取用户的Linux发行版
function get_linux_distribution() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        LINUX_DISTRIBUTION=$ID
    elif [ -f /etc/lsb-release ]; then
        source /etc/lsb-release
        LINUX_DISTRIBUTION=$DISTRIB_ID
    elif [ -f /etc/debian_version ]; then
        LINUX_DISTRIBUTION="debian"
    else
        LINUX_DISTRIBUTION="unknown"
    fi
}

echo "欢迎使用Python交互式安装与管理脚本！"

get_linux_distribution

while true; do
    echo "请选择以下选项："
    echo "1. 安装Python"
    echo "2. 卸载Python"
    echo "3. 查看Python版本"
    echo "4. 退出"
    read -p "请输入选项编号: " choice

    case "$choice" in
        1)
            install_dependencies
            install_python
            ;;
        2)
            uninstall_python
            ;;
        3)
            check_python_version
            ;;
        4)
            echo "已退出脚本。"
            break
            ;;
        *)
            echo "无效的选项。"
            ;;
    esac
done
