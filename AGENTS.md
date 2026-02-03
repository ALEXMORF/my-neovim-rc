# Neovim 配置项目概览

## 项目描述

这是一个个人的 Neovim 配置项目，使用 Lua 编写。该配置旨在提供一个现代化的、功能丰富的编辑环境，主要面向 C++ 和 Lua 开发。

## 技术栈

- **Neovim**: 版本未知（基于 Lua 配置）
- **插件管理器**: lazy.nvim
- **配置语言**: Lua
- **主要颜色主题**: 自定义主题（基于 Gruvbox Material 风格）

## 核心功能

### 编辑器设置

- 相对行号和行号显示
- 智能大小写搜索
- 光标行高亮
- Tab/空格缩进（4空格）
- 自动缩进
- 剪贴板同步（UIEnter 后启用）

### 键位映射

- **Leader 键**: 空格键
- **窗口导航**: Alt + h/j/k/l（在所有模式下）
- **退出插入模式**: `jk`
- **Telescope 快捷键**:
  - `<C-p>`: 在 code 文件夹或当前目录查找文件
  - `<leader>ff`: 查找文件
  - `<leader>fg`: 实时 grep
  - `<leader>fb`: 查找缓冲区
  - `<leader>fh`: 查找帮助标签
  - `<leader>fk`: 查找键位映射
  - `<leader>fv`: 查找 Neovim 配置文件
- **Git 相关**:
  - `<leader>gg`: 打开 lazygit
  - `<leader>gc`: 查看提交历史
  - `<leader>gb`: 查看分支
  - `<leader>gs`: 查看 git 状态
- **文件树**:
  - `<leader>dt`: 切换 Nvim-tree
  - `<leader>df`: 在 Nvim-tree 中查找当前文件
- **构建相关**:
  - `<M-m>`: 构建项目（执行 ./code/build.sh 或 ./code/build.bat）
  - `<M-n>`: 下一个 quickfix 错误
  - `<M-p>`: 上一个 quickfix 错误
  - `<M-,>`: 关闭 quickfix 窗口
- **调试器 (DAP)**:
  - `<F5>`: 继续执行
  - `<S-F5>`: 终止调试
  - `<F10>`: 单步跳过
  - `<F11>`: 单步进入
  - `<S-F11>`: 单步跳出
  - `<leader>b`: 切换断点
  - `<leader>?`: 求值表达式
- **LSP 快捷键**:
  - `grn`: 重命名
  - `gra`: 代码操作
  - `grr`: 查找引用
  - `gri`: 查找实现
  - `grd`: 查找定义
  - `<M-j>`: 查找定义（备用）
  - `grD`: 查找声明
  - `gO`: 文档符号
  - `gW`: 工作区符号
  - `grt`: 类型定义
- **其他**:
  - `<leader>t`: 打开终端
  - `<leader>p`: 选择会话（persistence）
  - `<M-o>`: clangd 切换头文件
  - `<M-k>`: 跳回

## 主要插件

### 插件管理
- **lazy.nvim**: 插件管理器

### LSP 和补全
- **nvim-lspconfig**: LSP 配置
- **clangd**: C++ 语言服务器
- **lua-language-server**: Lua 语言服务器
- **blink.cmp**: 自动补全（Rust 实现）
- **lazydev.nvim**: Neovim Lua 开发支持

### 模糊查找
- **telescope.nvim**: 模糊查找器
- **telescope-project.nvim**: 项目管理
- **plenary.nvim**: telescope 依赖

### Git 集成
- **gitsigns.nvim**: Git 符号显示
- **snacks.nvim**: lazygit 集成、仪表盘等
- **diffview.nvim**: Git diff 查看
- **persistence.nvim**: 会话持久化

### 调试器
- **nvim-dap**: 调试适配器协议
- **nvim-dap-ui**: 调试 UI
- **nvim-dap-virtual-text**: 虚拟文本显示变量值
- **codelldb**: C++ 调试器

### UI 和主题
- **gruvbox-material**: 颜色主题
- **tokyonight.nvim**: 备用颜色主题
- **lualine.nvim**: 状态栏
- **nvim-web-devicons**: 文件图标
- **nvim-tree.lua**: 文件树
- **which-key.nvim**: 键位提示
- **fidget.nvim**: LSP 状态更新

### 其他工具
- **guess-indent.nvim**: 自动检测缩进
- **todo-comments.nvim**: TODO 注释高亮
- **mini.nvim**: 小插件集合
- **hlsl.vim**: HLSL 语法支持

## 外部依赖

### 必需依赖
- **Git**: 版本控制
- **ripgrep**: telescope grep 使用
- **lazygit**: Git 可视化工具
- **clangd**: C++ 语言服务器
- **lua-language-server**: Lua 语言服务器
- **codelldb**: C++ 调试器

### 字体
- **Google Sans Code Nerd Font**: 主字体
- **Noto Color Emoji**: 表情符号支持
- **Nerd Font**: 图标支持

### 编译工具
- **rustup/cargo**: 用于编译 blink.cmp

## 开发约定

### 项目构建
- 项目构建脚本位于 `./code/build.sh`（Linux/Mac）或 `./code/build.bat`（Windows）
- 构建时自动保存所有文件
- 构建结果显示在 quickfix 窗口

### C++ 项目调试
- 调试目标路径从 `nvim-dap-cpp-target.txt` 读取（位于项目根目录）
- 如果文件不存在，首次运行时会提示输入
- 工作目录设置为 `./build`

### clangd 配置
- 禁用自动头文件插入（`--header-insertion=never`）
- C++ 项目需要在根目录生成 `compile_commands.json` 以供 clangd 使用

### 会话管理
- 使用 persistence.nvim 自动保存和恢复会话
- 会话在打开文件时开始保存

## 自定义颜色主题

项目使用自定义颜色主题，主要基于 Gruvbox Material 风格：

- 背景色: `#1F1F1F`
- 默认前景色: `#CDAA7D`
- 注释色: `#7F7F7F`
- 常量/字符串色: `#7B9E33`
- 关键字/类型色: `#DDAD3C`
- 错误色: `#DD5555`

## 文件结构

```
/home/chen/.config/nvim/
├── init.lua          # 主配置文件
├── lazy-lock.json    # 插件版本锁定文件
├── README.md         # 依赖说明
└── AGENTS.md         # 本文件
```

## 使用说明

### 初始化
首次使用时，lazy.nvim 会自动安装并下载所有插件。blink.cmp 需要 Rust 编译，如果自动编译失败，需要手动在 `~/.local/share/nvim/blink.cmp/` 目录下运行 `cargo build --release`。

### 启动
直接运行 `nvim` 即可启动编辑器。启动后会显示仪表盘（Snacks dashboard）。

### 开发 C++ 项目
1. 在项目根目录创建 `compile_commands.json` 供 clangd 使用
2. 在 `./code/` 目录下放置构建脚本
3. 使用 `<M-m>` 构建项目
4. 使用 DAP 快捷键进行调试

### 开发 Neovim 配置
1. 编辑 `init.lua`
2. 使用 `<leader>fv` 查找配置文件
3. lua_ls 会自动提供补全和类型检查