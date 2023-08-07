#!/bin/bash

# 安装所需的开发包和Python运行时依赖项
function install_dependencies() {
    echo "正在安装所需的开发包和Python运行时依赖项..."
    sudo yum install -y epel-release
    sudo yum install -y gcc make openssl-devel bzip2-devel libffi-devel zlib-devel
    echo "依赖项安装完成。"
}

function check_python_version() {
    if command -v python3 &>/dev/null; then
        echo "当前系统已安装的Python版本："
        python3 --version
    else
        echo "未找到已安装的Python版本。"
    fi
}

function install_python() {
    # 获取可供选择的Python版本列表
    python_versions=("3.7" "3.8" "3.9")

    # 显示可供选择的Python版本
    echo "可供选择的Python版本："
    for ((i=0; i<${#python_versions[@]}; i++)); do
        echo "$((i+1)). Python ${python_versions[i]}"
    done

    # 用户选择要安装的Python版本
    read -p "请选择要安装的Python版本（输入对应的数字），或输入 'q' 退出： " version_choice

    if [[ "$version_choice" == "q" || "$version_choice" == "Q" ]]; then
        echo "已退出脚本。"
        return
    fi

    # 验证用户输入是否合法
    re='^[0-9]+$'
    if ! [[ $version_choice =~ $re ]] || ((version_choice < 1)) || ((version_choice > ${#python_versions[@]})); then
        echo "无效的选择。"
        install_python
        return
    fi

    # 安装选定的Python版本
    selected_version=${python_versions[version_choice-1]}
    echo "正在安装 Python $selected_version ..."

    # 检查是否已安装所选版本的Python
    if python3 --version | grep -q "Python $selected_version"; then
        read -p "Python $selected_version 已安装，是否要覆盖安装？(y/n): " overwrite_choice

        if [[ "$overwrite_choice" =~ ^[Yy]$ ]]; then
            # 卸载已安装的Python版本
            uninstall_python
        else
            echo "已取消安装 Python $selected_version。"
            return
        fi
    fi

    # 下载已编译好的Python版本并解压
    echo "正在下载 Python $selected_version ..."
    wget --progress=bar:force:noscroll https://www.python.org/ftp/python/$selected_version/Python-$selected_version.tgz
    tar -xzf Python-$selected_version.tgz
    cd Python-$selected_version

    # 安装Python
    sudo ./configure --enable-optimizations
    sudo make -j$(nproc)
    sudo make altinstall

    # 删除临时文件
    cd ..
    rm -rf Python-$selected_version.tgz Python-$selected_version

    echo "Python $selected_version 安装完成。"
    check_python_version
}

function uninstall_python() {
    if command -v python3 &>/dev/null; then
        # 获取当前已安装的Python版本
        current_version=$(python3 --version | awk '{print $2}')
        echo "当前已安装的Python版本为：$current_version"

        echo "正在卸载 Python $current_version ..."
        sudo yum remove -y python$current_version python$current_version-libs
        echo "Python $current_version 卸载完成。"
    else
        echo "未找到已安装的Python版本。"
    fi
}

echo "欢迎使用Python交互式安装与管理脚本！"

# 安装依赖项
install_dependencies

check_python_version

while true; do
    read -p "请输入以下选项： 'i' 安装Python， 'u' 卸载Python， 'c' 查看Python版本， 'q' 退出： " choice

    if [[ "$choice" =~ ^[Ii]$ ]]; then
        install_python
    elif [[ "$choice" =~ ^[Uu]$ ]]; then
        uninstall_python
    elif [[ "$choice" =~ ^[Cc]$ ]]; then
        check_python_version
    elif [[ "$choice" =~ ^[Qq]$ ]]; then
        echo "已退出脚本。"
        break
    else
        echo "无效的选择。"
    fi
done
