#!/bin/bash

# 检查操作系统类型
if [ -f /etc/os-release ]; then
    source /etc/os-release
    OS=$ID
else
    echo "无法检测操作系统。脚本仅支持基于Debian和CentOS的系统。"
    exit 1
fi

# 检查是否已经安装了 Zsh
if [ -z "$(command -v zsh)" ]; then
    echo "安装 Zsh..."
    if [ "$OS" == "ubuntu" ] || [ "$OS" == "debian" ]; then
        sudo apt update
        sudo apt install zsh -y
    elif [ "$OS" == "centos" ] || [ "$OS" == "anolis" ]; then
        sudo yum install zsh -y
    else
        echo "不支持的操作系统。"
        exit 1
    fi
else
    echo "Zsh 已经安装。"
fi

# 检查是否已经安装了 Oh-My-Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "安装 Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh-My-Zsh 已经安装。"
fi

# 安装 zsh-syntax-highlighting 插件
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo "安装 zsh-syntax-highlighting 插件..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting 插件已经安装。"
fi

# 安装 zsh-autosuggestions 插件
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "安装 zsh-autosuggestions 插件..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions 插件已经安装。"
fi

# 安装 aphrodite 主题
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/aphrodite" ]; then
    echo "安装 aphrodite 主题..."
    git clone --quiet https://github.com/lvsong/aphrodite-terminal-theme.git $HOME/.oh-my-zsh/custom/themes/aphrodite
else
    echo "aphrodite 主题已经安装。"
fi

# 设置 Oh-My-Zsh 主题为 aphrodite
echo "设置 Oh-My-Zsh 主题为 aphrodite..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="aphrodite\/aphrodite"/' $HOME/.zshrc


# 切换默认 shell 为 Zsh
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "切换默认 shell 为 Zsh..."
    chsh -s /bin/zsh
else
    echo "默认 shell 已经是 Zsh。"
fi

# 更新 .zshrc 文件以启用插件
if [ -f "$HOME/.zshrc" ]; then
    echo "更新 .zshrc 文件以启用插件..."
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions z)/' $HOME/.zshrc
fi

echo "安装完成！请重新登录或者重新启动终端以使更改生效。"

