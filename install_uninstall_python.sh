#!/bin/bash

function check_python_version() {
    if command -v python3 &>/dev/null; then
        echo "当前系统已安装的Python版本："
        python3 --version
    else
        echo "未找到已安装的Python版本。"
    fi
}

function install_python_3_7() {
    # 在这里添加安装Python 3.7的代码
    echo "安装Python 3.7"
}

function install_python_3_8() {
    # 在这里添加安装Python 3.8的代码
    echo "安装Python 3.8"
}

function install_python_3_9() {
    # 在这里添加安装Python 3.9的代码
    echo "安装Python 3.9"
}

function force_install_python() {
    # 根据不同的包管理器安装Python所需的依赖项
    if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3 python3-pip
    elif command -v yum &>/dev/null; then
        sudo yum update -y
        sudo yum install -y python3 python3-pip
    else
        echo "无法识别的Linux发行版。"
        return
    fi

    echo "Python安装完成。"
    check_python_version
}

echo "欢迎使用Python安装与查看版本脚本！"
read -p "请输入 'i' 安装Python，输入 'c' 查看Python版本，或者其他键退出： " choice

if [[ "$choice" =~ ^[Ii]$ ]]; then
    echo "可供选择的Python版本："
    echo "1) Python 3.7"
    echo "2) Python 3.8"
    echo "3) Python 3.9"
    read -p "请选择要安装的Python版本（输入对应的数字）： " version_choice

    case "$version_choice" in
        1)
            install_python_3_7
            ;;
        2)
            install_python_3_8
            ;;
        3)
            install_python_3_9
            ;;
        *)
            echo "无效的选择。"
            ;;
    esac

    read -p "是否要强行安装Python？(y/n): " force_install_choice
    if [[ "$force_install_choice" =~ ^[Yy]$ ]]; then
        force_install_python
    fi

elif [[ "$choice" =~ ^[Cc]$ ]]; then
    check_python_version
else
    echo "已退出脚本。"
fi
