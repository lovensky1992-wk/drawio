# SVG Technical Guide

## SVG Layout Rules & Validation

### Precise Spacing Rules (硬编码,不用模糊措辞)

**组件尺寸标准(SVG 引擎):**

| 组件类型 | 宽度 | 高度 | 说明 |
|---------|------|------|------|
| 简单服务 | 120px | 50px | 无 sublabel |
| 标准组件 | 160px | 60px | 含 sublabel |
| 大组件 | 200px | 80px | 多行内容 |
| 宽组件(LB/Gateway) | 280px | 60px | 跨多列 |

**间距规则:**
- Same-layer nodes: 80px horizontal gap (center-to-center: 80 + avg_width)
- Layer-to-layer: 120px vertical gap (边缘到边缘,不是中心到中心)
- Canvas margins: 40px minimum all sides
- Snap to 8px grid: 120px horizontal/vertical intervals

**垂直堆叠精确计算(防止重叠的关键):**
```
Component A: y=70,  height=60  → bottom edge at y=130
Gap:         y=130 to y=170   → 40px gap
  └─ Inline connector (message bus): y=140, height=20 → centered in gap
Component B: y=170, height=60  → bottom edge at y=230
Gap:         y=230 to y=270   → 40px gap
Component C: y=270, height=60  → bottom edge at y=330
```

**错误示例 vs 正确示例:**
- ❌ `Component A height=60, y=70; Component B y=120` → 只留 10px 间距,组件重叠
- ✅ `Component A height=60, y=70; Component B y=170` → 40px 间距,清晰可读
- ❌ Message bus at y=160 when Component B starts at y=170 → bus 和组件重叠
- ✅ Message bus at y=140 (20px tall), centered in 130-170 gap

**容器/分组的间距:**
- 容器内 padding: 上 40px(为标题留空)、左右 20px、下 20px
- 容器之间: 30px gap
- Legend 必须在所有容器的最下边界 + 20px 之后
- 容器末端超出 → 扩展 SVG viewBox height 容纳

### Arrow Rendering Order (z-order)

**SVG 元素按文档顺序绘制**--先写的在下面,后写的在上面。架构图必须按以下顺序写入 SVG:

```
1. <rect> 背景 + <rect> 网格(最底层)
2. <path>/<line> 箭头连接线(在组件下面)
3. 组件的 opaque mask rect(遮盖穿过的箭头)
4. 组件的 styled rect(带颜色/透明度的外观)
5. <text> 标签文字(最上层)
6. Legend(最上层)
```

**透明填充的遮盖问题:** 当组件使用 `rgba(...)` 半透明填充时,下方的箭头会透出来。解决方法是先画一个与组件同位置的 **opaque rect**(`fill="#0f172a"` 或画布背景色),再叠加半透明的样式 rect:
```xml
<rect x="100" y="100" width="160" height="60" rx="6" fill="#0f172a"/>  <!-- opaque mask -->
<rect x="100" y="100" width="160" height="60" rx="6" fill="rgba(76,29,149,0.4)" stroke="#a78bfa" stroke-width="1.5"/>  <!-- styled -->
```

> 注意:Style 1/4/6/7(白色/浅色背景)通常不需要 opaque mask,因为组件填充本身就是不透明的。Style 2/3/5/8(深色背景 + 半透明填充)需要这个技巧。

**Arrow Labels (CRITICAL):**
- MUST have background rect: `<rect fill="canvas_bg" opacity="0.95"/>` with 4px H / 2px V padding
- Place mid-arrow, ≤3 words, stagger 15-20px when multiple arrows converge
- Maintain 10px safety distance from nodes

**Arrow Routing:**
- Prefer orthogonal (L-shaped) paths to minimize crossings
- Jump-over arcs (5px radius) for unavoidable crossings

**Validation Checklist (run before finalizing):**
1. **Arrow-Component Collision**: Arrows must NOT pass through component interiors
2. **Text Overflow**: All text must fit with 8px padding (`text.length × 7px ≤ shape_width - 16px`)
3. **Arrow-Text Alignment**: Endpoints connect to shape edges; all labels have background rects

## SVG Technical Rules

- ViewBox: `0 0 960 600` default; `0 0 960 800` tall; `0 0 1200 600` wide
- Fonts: embed via `<style>font-family: ...</style>` - no external `@import` (breaks rsvg-convert)
- `<defs>`: arrow markers, gradients, filters, clip paths
- Text: minimum 12px; prefer 13-14px labels, 11px sub-labels, 16-18px titles
- All arrows: `<marker>` with `markerEnd`, `markerWidth="10" markerHeight="7"`
- Drop shadows: `<feDropShadow>` in `<filter>`, sparingly (key nodes only)
- Curved paths: cubic bezier `M x1,y1 C cx1,cy1 cx2,cy2 x2,y2` for loops/feedback
- Clip content: `<clipPath>` if text might overflow a node box

## 图表规划(复杂图表必做)

当图表有 6+ 节点时,先做规划再生成:

### 意图提取 5 步
1. **命名元素**:列出所有独立的参与者/组件/状态/阶段,计数
2. **关系类型**:每对元素之间是顺序(→流程图)、包含(→架构图)、消息交换(→时序图)、还是机制(→示意图)
3. **读者需要**:完成这个句子--"看完这张图,读者理解了___"
4. **标签预检**:每个标签的字符数,中文 >16 字或英文 >30 字的需要缩写
5. **语言**:CJK vs Latin,影响文字宽度计算

### 文字宽度估算
- 中文标题:字数 × 15px + 24px padding
- 英文标题:字符数 × 8px + 24px padding
- 确保每个方块宽度能容纳其标签

## SVG Generation Strategy

**MANDATORY: Python List Method** (always use this to prevent truncation/syntax errors):

```python
python3 << 'EOF'
lines = []
lines.append('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 700">')
lines.append('  <defs>')
# ... each line separately
lines.append('</svg>')

with open('/path/to/output.svg', 'w') as f:
    f.write('\n'.join(lines))
print("SVG generated successfully")
EOF
```

**Pre-Tool-Call Checklist (CRITICAL):**
1. ✅ Can I write out the COMPLETE command/content right now?
2. ✅ Do I have ALL required parameters ready?
3. ✅ Have I checked for syntax errors in my prepared content?

If ANY answer is NO: STOP. Prepare content first.

**Error Recovery Protocol:**
- First error: analyze root cause, targeted fix
- Second error: switch method (Python list → chunked generation)
- Third error: STOP and report to user - do NOT loop endlessly

**Common Syntax Errors to Avoid:**
- ❌ `yt-anchor` → ✅ `y="60" text-anchor="middle"`
- ❌ `x="390` (missing y) → ✅ `x="390" y="250"`
- ❌ `fill=#fff` → ✅ `fill="#ffffff"`
- ❌ `marker-end=` → ✅ `marker-end="url(#arrow)"`
- ❌ `L 29450` → ✅ `L 290,220`
- ❌ Missing `</svg>` at end

**Validation:**
```bash
rsvg-convert file.svg -o /tmp/test.png 2>&1 && echo "✓ Valid" && rm /tmp/test.png
```

**Export PNG:**
```bash
rsvg-convert -w 1920 file.svg -o file.png  # 1920px = 2x retina
```
