#!/bin/bash
# 图表一键流水线：SVG 验证 → PNG 导出 → 展示图生成（可选）→ 多变体对比（可选）
#
# 用法：
#   ./diagram-pipeline.sh <input.svg|.drawio|.html> [选项]
#
# 选项：
#   --style <name>       展示图风格 (void|frosted|editorial|clinical|ui_container|swiss_flat)
#   --showcase <style>   生成展示图（默认不生成）
#   --multi              多变体模式：生成 3 种风格 SVG+PNG 并输出对比 HTML
#   --output-dir <dir>   输出目录（默认: output/<basename>）
#   --title <title>      图表标题（默认: 文件名）
#   --help               显示帮助
#
# 流程：
#   1. validate-svg.sh 验证 SVG（仅 .svg 输入）
#   2. rsvg-convert 或 Chrome Headless 转 PNG
#   3. （--showcase）generate-showcase.sh 生成展示图
#   4. （--multi）用 diagram-showcase.html 模板生成对比页

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# 默认参数
INPUT=""
OUTPUT_DIR=""
SHOWCASE_STYLE=""
MULTI=false
TITLE=""

# ============================================================
# 参数解析
# ============================================================
while [[ $# -gt 0 ]]; do
    case "$1" in
        --showcase)
            SHOWCASE_STYLE="${2:-editorial}"; shift 2 ;;
        --style)
            SHOWCASE_STYLE="$2"; shift 2 ;;
        --multi)
            MULTI=true; shift ;;
        --output-dir|-o)
            OUTPUT_DIR="$2"; shift 2 ;;
        --title|-t)
            TITLE="$2"; shift 2 ;;
        --help|-h)
            sed -n '2,16p' "$0" | sed 's/^# \?//'
            exit 0 ;;
        -*)
            echo -e "${RED}未知选项: $1${NC}" >&2; exit 1 ;;
        *)
            if [[ -z "$INPUT" ]]; then
                INPUT="$1"
            else
                echo -e "${RED}多余参数: $1${NC}" >&2; exit 1
            fi
            shift ;;
    esac
done

# ============================================================
# 输入验证
# ============================================================
if [[ -z "$INPUT" ]]; then
    echo -e "${RED}错误: 请指定输入文件${NC}" >&2
    echo "用法: $0 <input.svg|.drawio|.html> [--showcase editorial] [--multi]" >&2
    exit 1
fi

if [[ ! -f "$INPUT" ]]; then
    echo -e "${RED}错误: 文件不存在: $INPUT${NC}" >&2
    exit 1
fi

# 推断类型
EXT="${INPUT##*.}"
BASENAME="$(basename "$INPUT" ".$EXT")"
INPUT_ABS="$(cd "$(dirname "$INPUT")" && pwd)/$(basename "$INPUT")"

case "$EXT" in
    svg|drawio|html) ;;
    *)
        echo -e "${RED}错误: 不支持的文件类型 .$EXT（支持 .svg / .drawio / .html）${NC}" >&2
        exit 1 ;;
esac

# 输出目录
if [[ -z "$OUTPUT_DIR" ]]; then
    OUTPUT_DIR="output/${BASENAME}"
fi
mkdir -p "$OUTPUT_DIR"

if [[ -z "$TITLE" ]]; then
    TITLE="$BASENAME"
fi

echo -e "${CYAN}━━━ Diagram Pipeline ━━━${NC}"
echo -e "输入: ${INPUT}"
echo -e "类型: .${EXT}"
echo -e "输出: ${OUTPUT_DIR}/"
echo ""

# ============================================================
# 依赖检查
# ============================================================
check_dep() {
    local cmd="$1" hint="$2"
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${YELLOW}⚠ 未找到 $cmd${NC} — $hint" >&2
        return 1
    fi
    return 0
}

HAS_RSVG=false
HAS_CHROME=false
HAS_DRAWIO=false

check_dep rsvg-convert "brew install librsvg" && HAS_RSVG=true
if [[ -f "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]]; then
    HAS_CHROME=true
fi
if command -v draw.io &>/dev/null || [[ -f "/Applications/draw.io.app/Contents/MacOS/draw.io" ]]; then
    HAS_DRAWIO=true
fi

# ============================================================
# Step 1: 验证（仅 SVG）
# ============================================================
if [[ "$EXT" == "svg" ]]; then
    echo -e "${CYAN}[1/4] 验证 SVG...${NC}"
    if [[ -f "$SCRIPT_DIR/validate-svg.sh" ]]; then
        bash "$SCRIPT_DIR/validate-svg.sh" "$INPUT_ABS" || {
            echo -e "${YELLOW}⚠ SVG 验证有警告，继续处理${NC}"
        }
    else
        echo -e "${YELLOW}⚠ validate-svg.sh 不存在，跳过验证${NC}"
    fi
    echo ""
else
    echo -e "${CYAN}[1/4] 跳过验证（非 SVG 输入）${NC}"
    echo ""
fi

# ============================================================
# Step 2: 导出 PNG
# ============================================================
PNG_OUTPUT="$OUTPUT_DIR/${BASENAME}.png"
echo -e "${CYAN}[2/4] 导出 PNG...${NC}"

case "$EXT" in
    svg)
        if [[ "$HAS_RSVG" == true ]]; then
            rsvg-convert -w 1920 "$INPUT_ABS" -o "$PNG_OUTPUT"
            echo -e "${GREEN}✓ PNG 已生成: $PNG_OUTPUT${NC}"
        else
            echo -e "${RED}✗ 需要 rsvg-convert 来转换 SVG → PNG${NC}" >&2
            echo "  安装: brew install librsvg" >&2
            exit 1
        fi
        ;;
    drawio)
        if [[ "$HAS_DRAWIO" == true ]]; then
            DRAWIO_CMD="draw.io"
            if ! command -v draw.io &>/dev/null; then
                DRAWIO_CMD="/Applications/draw.io.app/Contents/MacOS/draw.io"
            fi
            "$DRAWIO_CMD" -x -f png -e -s 2 -o "$PNG_OUTPUT" "$INPUT_ABS"
            echo -e "${GREEN}✓ PNG 已生成: $PNG_OUTPUT${NC}"
        else
            echo -e "${RED}✗ 需要 draw.io 来转换 .drawio → PNG${NC}" >&2
            echo "  安装: brew install --cask drawio" >&2
            exit 1
        fi
        ;;
    html)
        if [[ "$HAS_CHROME" == true ]]; then
            NO_PROXY="*" no_proxy="*" \
            "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
                --headless=new --disable-gpu --no-sandbox \
                --screenshot="$PNG_OUTPUT" \
                --window-size=1500,1200 \
                --force-device-scale-factor=2 \
                "file://$INPUT_ABS"
            echo -e "${GREEN}✓ PNG 已生成: $PNG_OUTPUT${NC}"
        else
            echo -e "${RED}✗ 需要 Google Chrome 来截图 HTML → PNG${NC}" >&2
            exit 1
        fi
        ;;
esac

# 复制源文件到输出目录
cp "$INPUT_ABS" "$OUTPUT_DIR/" 2>/dev/null || true
echo ""

# ============================================================
# Step 3: 展示图（可选）
# ============================================================
if [[ -n "$SHOWCASE_STYLE" ]]; then
    echo -e "${CYAN}[3/4] 生成展示图（风格: $SHOWCASE_STYLE）...${NC}"
    if [[ -f "$SCRIPT_DIR/generate-showcase.sh" ]]; then
        bash "$SCRIPT_DIR/generate-showcase.sh" "$PNG_OUTPUT" \
            --style "$SHOWCASE_STYLE" \
            --title "$TITLE" \
            --output-dir "$OUTPUT_DIR"
    else
        echo -e "${YELLOW}⚠ generate-showcase.sh 不存在，跳过展示图生成${NC}"
    fi
    echo ""
else
    echo -e "${CYAN}[3/4] 跳过展示图（未指定 --showcase）${NC}"
    echo ""
fi

# ============================================================
# Step 4: 多变体对比（可选）
# ============================================================
if [[ "$MULTI" == true ]]; then
    echo -e "${CYAN}[4/4] 多变体模式...${NC}"

    if [[ "$EXT" == "html" ]]; then
        echo -e "${YELLOW}⚠ HTML+CSS 引擎不支持多变体（无风格系统），跳过${NC}"
    elif [[ "$HAS_RSVG" != true ]]; then
        echo -e "${RED}✗ 多变体模式需要 rsvg-convert${NC}" >&2
        exit 1
    else
        # 3 种变体风格 ID
        VARIANTS=("style-4-notion-clean" "style-2-dark-terminal" "style-3-blueprint")
        VARIANT_LABELS=("Notion Clean (亮色)" "Dark Terminal (暗色)" "Blueprint (特色)")

        SHOWCASE_HTML="$OUTPUT_DIR/multi-compare.html"

        # 生成对比 HTML 头
        cat > "$SHOWCASE_HTML" <<'HTMLHEAD'
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>多风格对比</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; background: #f5f5f5; padding: 40px; }
  h1 { text-align: center; margin-bottom: 32px; color: #1a1a1a; font-size: 24px; }
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 24px; max-width: 1400px; margin: 0 auto; }
  .card { background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
  .card img { width: 100%; display: block; }
  .card-label { padding: 12px 16px; font-size: 14px; font-weight: 600; color: #333; border-top: 1px solid #eee; }
  .card-label span { color: #888; font-weight: 400; font-size: 12px; margin-left: 8px; }
</style>
</head>
<body>
HTMLHEAD

        echo "<h1>${TITLE} — 多风格对比</h1>" >> "$SHOWCASE_HTML"
        echo '<div class="grid">' >> "$SHOWCASE_HTML"

        for i in "${!VARIANTS[@]}"; do
            VARIANT="${VARIANTS[$i]}"
            LABEL="${VARIANT_LABELS[$i]}"
            VARIANT_PNG="${BASENAME}-${VARIANT}.png"
            VARIANT_SVG="${BASENAME}-${VARIANT}.svg"

            echo -e "  变体 $((i+1))/3: ${LABEL}"

            # 这里期望 SVG 文件已由 Claude 在多变体工作流中生成
            # 如果 SVG 存在则转 PNG
            if [[ -f "$OUTPUT_DIR/$VARIANT_SVG" ]]; then
                rsvg-convert -w 1920 "$OUTPUT_DIR/$VARIANT_SVG" -o "$OUTPUT_DIR/$VARIANT_PNG"
                echo -e "  ${GREEN}✓ $VARIANT_PNG${NC}"
            elif [[ -f "$PNG_OUTPUT" ]]; then
                # 占位：使用主 PNG
                cp "$PNG_OUTPUT" "$OUTPUT_DIR/$VARIANT_PNG"
                echo -e "  ${YELLOW}⚠ 未找到 $VARIANT_SVG，使用主图占位${NC}"
            fi

            cat >> "$SHOWCASE_HTML" <<CARD
  <div class="card">
    <img src="${VARIANT_PNG}" alt="${LABEL}">
    <div class="card-label">${LABEL}<span>${VARIANT}</span></div>
  </div>
CARD
        done

        echo '</div>' >> "$SHOWCASE_HTML"
        echo '</body></html>' >> "$SHOWCASE_HTML"

        echo -e "${GREEN}✓ 对比页已生成: $SHOWCASE_HTML${NC}"
    fi
    echo ""
else
    echo -e "${CYAN}[4/4] 跳过多变体（未指定 --multi）${NC}"
    echo ""
fi

# ============================================================
# 汇总
# ============================================================
echo -e "${CYAN}━━━ 完成 ━━━${NC}"
echo -e "输出目录: ${OUTPUT_DIR}/"
echo "文件列表:"
ls -1 "$OUTPUT_DIR/" | sed 's/^/  /'
