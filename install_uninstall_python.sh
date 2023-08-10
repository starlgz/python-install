import tkinter as tk
import subprocess

# 创建主窗口
root = tk.Tk()
root.title("Python功能菜单")

# 创建菜单栏
menu_bar = tk.Menu(root)

# 创建Python菜单
python_menu = tk.Menu(menu_bar, tearoff=0)

# 创建安装Python菜单
def install_python():
    version = input("请输入要安装的Python版本：")
    subprocess.call(["sudo", "apt-get", "install", "python" + version])
    show_menu()

install_menu = tk.Menu(python_menu, tearoff=0)
install_menu.add_command(label="安装Python", command=install_python)
python_menu.add_cascade(label="安装", menu=install_menu)

# 创建卸载Python菜单
def uninstall_python():
    version = input("请输入要卸载的Python版本：")
    subprocess.call(["sudo", "apt-get", "remove", "python" + version])
    show_menu()

uninstall_menu = tk.Menu(python_menu, tearoff=0)
uninstall_menu.add_command(label="卸载Python", command=uninstall_python)
python_menu.add_cascade(label="卸载", menu=uninstall_menu)

# 创建列出所有Python版本菜单
def list_python_versions():
    output = subprocess.check_output(["apt-cache", "search", "^python$"]).decode("utf-8")
    versions = [line.split()[0] for line in output.split("\n") if line.startswith("python")]
    print("所有Python版本：")
    for version in versions:
        print(version)
    show_menu()

list_menu = tk.Menu(python_menu, tearoff=0)
list_menu.add_command(label="列出所有Python版本", command=list_python_versions)
python_menu.add_cascade(label="列出版本", menu=list_menu)

# 添加Python菜单到菜单栏
menu_bar.add_cascade(label="Python", menu=python_menu)

# 创建帮助菜单
help_menu = tk.Menu(menu_bar, tearoff=0)
help_menu.add_command(label="关于")
menu_bar.add_cascade(label="帮助", menu=help_menu)

# 显示菜单栏
root.config(menu=menu_bar)

# 定义交互式命令
def interactive():
    print("欢迎使用Python交互式命令行！")
    while True:
        command = input(">>> ")
        if command == "exit":
            break
        try:
            exec(command)
        except Exception as e:
            print(e)

# 创建交互式菜单
interactive_menu = tk.Menu(menu_bar, tearoff=0)
interactive_menu.add_command(label="进入交互式命令行", command=interactive)
menu_bar.add_cascade(label="交互式", menu=interactive_menu)

# 显示菜单栏
root.config(menu=menu_bar)

# 显示菜单选项
def show_menu():
    print("作者：满天繁星")
    print("1. 安装Python")
    print("2. 卸载Python")
    print("3. 列出所有Python版本")
    print("4. 进入交互式命令行")
    print("0. 退出脚本")

# 进入消息循环
while True:
    show_menu()
    choice = input("请输入您的选择（0-4）：")
    if choice == "0":
        break
    elif choice == "1":
        install_python()
    elif choice == "2":
        uninstall_python()
    elif choice == "3":
        list_python_versions()
    elif choice == "4":
        interactive()
