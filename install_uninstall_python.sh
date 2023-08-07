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

# 先检查是否已安装Python，如果有，则询问是否卸载
if command -v python3 &>/dev/null; then
    read -p "已检测到Python已安装，是否卸载并重新安装？(y/n): " reinstall_choice
    if [[ "$reinstall_choice" =~ ^[Yy]$ ]]; then
        uninstall_python
    else
        check_python_version
        echo "已取消安装。"
        exit 0
    fi
fi

install_python
