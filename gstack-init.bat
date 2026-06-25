@echo off
chcp 65001 >nul
title gstack 一键初始化工具
setlocal enabledelayedexpansion

:: ============================================
:: gstack 一键初始化脚本 —— 适用于 Cursor
:: ============================================

set "GSTACK_DIR=%USERPROFILE%\gstack"

:: 检查 Git
echo [1/4] 检查 Git...
where git >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ 未检测到 Git，请先安装：https://git-scm.com/downloads
    pause
    exit /b 1
)
echo ✅ Git 已安装

:: 检查 Cursor
echo [2/4] 检查 Cursor...
where cursor >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ⚠️  未在 PATH 中检测到 cursor 命令
    echo   如果你已安装 Cursor，可以忽略此提示
    echo   如果 Cursor 不在 PATH 中，脚本后续仍可正常工作
) else (
    echo ✅ Cursor 已检测
)

:: 克隆 gstack
echo [3/4] 下载 gstack...
if exist "%GSTACK_DIR%" (
    echo   目标目录已存在：%GSTACK_DIR%
    echo   正在拉取最新更新...
    cd /d "%GSTACK_DIR%"
    git pull --ff-only
    if %ERRORLEVEL% neq 0 (
        echo ⚠️  更新失败，将尝试重新克隆...
        cd /d "%USERPROFILE%"
        rmdir /s /q "%GSTACK_DIR%"
        git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git "%GSTACK_DIR%"
    )
) else (
    git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git "%GSTACK_DIR%"
)

if %ERRORLEVEL% neq 0 (
    echo ❌ 下载失败，请检查网络连接
    pause
    exit /b 1
)
echo ✅ gstack 下载完成

:: 运行 setup
echo [4/4] 安装 gstack 到 Cursor...
cd /d "%GSTACK_DIR%"
call ./setup --host cursor

if %ERRORLEVEL% neq 0 (
    echo ⚠️  安装过程可能有警告，请查看上方提示
) else (
    echo ✅ gstack 安装成功！
)

echo.
echo ============================================
echo 🎉 gstack 已就绪！
echo ============================================
echo.
echo 📍 安装位置：%GSTACK_DIR%
echo 📍 目标代理：Cursor
echo.
echo 🔥 现在打开 Cursor，直接使用斜杠命令：
echo.
echo    /office-hours    — 产品构思
echo    /plan-ceo-review — 战略审查
echo    /plan-eng-review — 架构审查
echo    /review          — 代码审查
echo    /qa &lt;URL&gt;        — 浏览器 QA 测试
echo    /cso             — 安全审计
echo    /ship            — 发布流程
echo    /investigate     — 调试 Bug
echo.
echo 📖 更多信息：https://github.com/garrytan/gstack
echo.
echo 💡 提示：在 Cursor 的 CLAUDE.md 中添加以下配置，
echo    可以让 Cursor 知道如何调用 gstack 技能：
echo.
echo   ┌──────────────────────────────────────────────┐
echo   │ Add a "gstack" section to CLAUDE.md that     │
echo   │ lists the available skills: /office-hours,   │
echo   │ /plan-ceo-review, /plan-eng-review, /review, │
echo   │ /ship, /qa, /cso, /investigate, /browse,     │
echo   │ /design-review, /autoplan, etc.              │
echo   └──────────────────────────────────────────────┘
echo.
pause
