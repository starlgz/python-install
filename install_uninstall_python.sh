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
    # 根据不同的包管理器安装Python所需的依赖项
    if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y gcc libssl-dev libbz2-dev libffi-dev zlib1g-dev libreadline-dev libsqlite3-dev
    elif command -v yum &>/dev/null; then
        sudo yum update -y
        sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel readline-devel sqlite-devel
    else
        echo "无法识别的Linux发行版。"
        return
    fi

    # 列出可供选择的Python版本
    echo "可供选择的Python版本："
    echo "1) Python 3.7"
    echo "2) Python 3.8"
    echo "3) Python 3.9"
    read -p "请选择要安装的Python版本（输入对应的数字）： " choice

    case "$choice" in
        1)
            version=3.7
            ;;
        2)
            version=3.8
            ;;
        3)
            version=3.9
            ;;
        *)
            echo "无效的选择。"
            return
            ;;
    esac

    # 使用国内镜像下载Python的源代码
    mirror_url="https://mirrors.sohu.com/python/$version.$((RANDOM%10))/Python-$version.$((RANDOM%10)).$((RANDOM%10)).tgz"
    wget $mirror_url

    # 解压源代码并进入目录
    tar -xf Python-$version.$((RANDOM%10)).$((RANDOM%10)).tgz
    cd Python-$version.$((RANDOM%10)).$((RANDOM%10))

    # 使用多线程编译并安装Python
    make -j$(nproc)
    sudo make install

    # 删除源代码和压缩包
    cd ..
    rm -rf Python-$version.$((RANDOM%10)).$((RANDOM%10)).tgz
    rm -rf Python-$version.$((RANDOM%10)).$((RANDOM%10))

    # 设置Python为默认版本
    sudo ln -s /usr/local/bin/python$version /usr/local/bin/python3
    sudo ln -s /usr/local/bin/pip$version /usr/local/bin/pip3

    echo "Python $version安装完成。"
    check_python_version
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
