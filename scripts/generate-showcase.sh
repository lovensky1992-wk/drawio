#!/bin/bash
# 图表展示图生成器 — Shell 包装
# 用法：
#   ./generate-showcase.sh <diagram.png> [--style editorial] [--title "Title"]
#   ./generate-showcase.sh <diagram.png> --all --title "Architecture"
#
# 支持风格：void | frosted | editorial | clinical | ui_container | swiss_flat
# 默认风格：editorial
#
# API 优先级：idealab → Gemini Key 轮换

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_SCRIPTS="${HOME}/.openclaw/workspace/scripts"
SHOWCASE_PY="$SCRIPT_DIR/generate_showcase.py"

# 默认参数
DIAGRAM=""
STYLE="editorial"
ALL=false
TITLE="Diagram"
DESCRIPTION=""
OUTPUT_DIR="output"
MODEL="gemini-3.1-flash-image-preview"

# 解析参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        --style|-s)
            STYLE="$2"; shift 2 ;;
        --all|-a)
            ALL=true; shift ;;
        --title|-t)
            TITLE="$2"; shift 2 ;;
        --description|-d)
            DESCRIPTION="$2"; shift 2 ;;
        --output-dir|-o)
            OUTPUT_DIR="$2"; shift 2 ;;
        --model)
            MODEL="$2"; shift 2 ;;
        --help|-h)
            echo "用法: generate-showcase.sh <diagram.png> [选项]"
            echo ""
            echo "选项:"
            echo "  --style, -s    背景风格 (void|frosted|editorial|clinical|ui_container|swiss_flat)"
            echo "                 默认: editorial"
            echo "  --all, -a      生成全部 6 种风格"
            echo "  --title, -t    图表标题 (默认: Diagram)"
            echo "  --description  图表描述"
            echo "  --output-dir   输出目录 (默认: output)"
            echo "  --model        模型名称 (默认: gemini-3.1-flash-image-preview)"
            exit 0
            ;;
        -*)
            echo "未知选项: $1" >&2; exit 1 ;;
        *)
            if [[ -z "$DIAGRAM" ]]; then
                DIAGRAM="$1"
            else
                echo "多余参数: $1" >&2; exit 1
            fi
            shift ;;
    esac
done

if [[ -z "$DIAGRAM" ]]; then
    echo "错误: 请指定图表 PNG 文件" >&2
    echo "用法: generate-showcase.sh <diagram.png> [--style editorial] [--all]" >&2
    exit 1
fi

if [[ ! -f "$DIAGRAM" ]]; then
    echo "错误: 文件不存在: $DIAGRAM" >&2
    exit 1
fi

if [[ ! -f "$SHOWCASE_PY" ]]; then
    echo "错误: 找不到 $SHOWCASE_PY" >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# ============================================================
# 通道 1: idealab（默认）
# ============================================================
IDEALAB_AK="${IDEALAB_API_KEY:-}"
IDEALAB_URL="${IDEALAB_API_BASE:-https://idealab.alibaba-inc.com/api/openai/v1/chat/completions}"

PY_ARGS=(
    "$DIAGRAM"
    --title "$TITLE"
    --output-dir "$OUTPUT_DIR"
    --api-key "$IDEALAB_AK"
    --api-base "$IDEALAB_URL"
    --model "$MODEL"
)

if [[ -n "$DESCRIPTION" ]]; then
    PY_ARGS+=(--description "$DESCRIPTION")
fi

if [[ "$ALL" == true ]]; then
    PY_ARGS+=(--all)
else
    PY_ARGS+=(--style "$STYLE")
fi

echo "🎨 [idealab] 生成展示图..." >&2

if python3 "$SHOWCASE_PY" "${PY_ARGS[@]}"; then
    # 去水印（如果工具存在）
    WATERMARK_SCRIPT="$WORKSPACE_SCRIPTS/remove-ai-watermark.py"
    if [[ -f "$WATERMARK_SCRIPT" ]]; then
        echo "🧹 去水印..." >&2
        STEM=$(basename "$DIAGRAM" .png)
        if [[ "$ALL" == true ]]; then
            for style in void frosted editorial clinical ui_container swiss_flat; do
                TARGET="$OUTPUT_DIR/${STEM}_${style}.png"
                [[ -f "$TARGET" ]] && python3 "$WATERMARK_SCRIPT" "$TARGET" 2>/dev/null || true
            done
        else
            TARGET="$OUTPUT_DIR/${STEM}_${STYLE}.png"
            [[ -f "$TARGET" ]] && python3 "$WATERMARK_SCRIPT" "$TARGET" 2>/dev/null || true
        fi
    fi
    echo "🎉 完成!" >&2
    exit 0
fi

echo "⬇️ idealab 失败，降级到 Gemini Key 轮换..." >&2

# ============================================================
# 通道 2: Gemini Key 轮换
# ============================================================
KEYGEN_SCRIPT="$WORKSPACE_SCRIPTS/gemini-keygen.sh"

if [[ ! -f "$KEYGEN_SCRIPT" ]]; then
    echo "❌ 找不到 gemini-keygen.sh，无法降级" >&2
    exit 1
fi

source "$KEYGEN_SCRIPT"

MAX_RETRIES=${#GEMINI_KEYS[@]}
RETRY=0

while [[ $RETRY -lt $MAX_RETRIES ]]; do
    CURRENT_KEY=$(get_gemini_key)
    GEMINI_BASE="https://generativelanguage.googleapis.com/v1beta/openai/chat/completions"

    echo "🎨 [Gemini] 使用 Key #$(get_key_index) 生图..." >&2

    PY_ARGS_GEMINI=(
        "$DIAGRAM"
        --title "$TITLE"
        --output-dir "$OUTPUT_DIR"
        --api-key "$CURRENT_KEY"
        --api-base "$GEMINI_BASE"
        --model "$MODEL"
    )

    if [[ -n "$DESCRIPTION" ]]; then
        PY_ARGS_GEMINI+=(--description "$DESCRIPTION")
    fi

    if [[ "$ALL" == true ]]; then
        PY_ARGS_GEMINI+=(--all)
    else
        PY_ARGS_GEMINI+=(--style "$STYLE")
    fi

    OUTPUT=$(python3 "$SHOWCASE_PY" "${PY_ARGS_GEMINI[@]}" 2>&1) && EXIT_CODE=0 || EXIT_CODE=$?

    if [[ $EXIT_CODE -eq 0 ]]; then
        echo "$OUTPUT"
        echo "🎉 完成!" >&2
        exit 0
    fi

    if echo "$OUTPUT" | grep -qi "quota\|rate.limit\|resource.exhausted\|429\|RESOURCE_EXHAUSTED"; then
        rotate_gemini_key
        RETRY=$((RETRY + 1))
    else
        echo "$OUTPUT" >&2
        exit $EXIT_CODE
    fi
done

echo "❌ 所有通道都失败了！idealab + Gemini 全部不可用。" >&2
exit 1
