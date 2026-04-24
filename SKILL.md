---
name: drawio
description: >
  生成技术图表并导出为 PNG/SVG/PDF。三种引擎:(1) draw.io 桌面 CLI(默认,生成可编辑 .drawio XML);
  (2) SVG 直出(风格化/AI 领域图/draw.io 不可用时,使用 rsvg-convert 导出 PNG);
  (3) HTML+CSS 直出(复杂架构图/产品大图/高视觉要求,使用 Chrome headless 截图导出 PNG)。
  支持 14 种 UML 图 + AI/Agent 领域图(RAG Pipeline、Multi-Agent、Memory Architecture 等)。
  Use when: (1) 用户说"画个图"/"画个流程图"/"做个架构图"/"画个关系图",
  (2) 用户说"diagram"/"flowchart"/"visualize"/"draw",
  (3) 解释复杂系统(3+ 组件)或数据流时主动提供图表,
  (4) 用户要求将概念/流程/关系可视化。
  NOT for: 数据图表/chart/柱状图/折线图(用代码或 xlsx 生成)、
  照片/插图/AI生图(用 Gemini 生图 或 Seedream)、
  PPT 内嵌图表(用 frontend-slides 自带能力)。
---

# Draw.io Diagrams - Full-Stack Diagramming Skill

## Overview

| Engine | When to use | Output |
|--------|-------------|--------|
| **draw.io CLI** (default) | Most diagrams; user needs editable .drawio file | `.drawio` + PNG/SVG/PDF |
| **SVG 直出** (fallback) | Stylized/themed diagrams; AI/Agent domain; draw.io not installed | `.svg` + PNG via `rsvg-convert` |
| **HTML+CSS 直出** | 复杂架构图(10+节点)、产品大图、分层架构、高视觉要求 | `.html` + PNG via Chrome headless |

**SVG engine** supports 9 visual styles. Load `references/style-N.md` for exact color tokens.
**HTML+CSS engine** uses CSS flexbox for auto alignment. 🔴 **必须先读 `references/html-css-template.md`**

## 设计原则

1. **画机制,不画"关于机制的图"**:illustrative 类型让读者直觉理解"它怎么工作"
2. **颜色编码语义,不编码位置**:同类步骤用同色,只有语义不同才换色
3. **读者 3 秒测试**:标签本身就能 stand alone,不需要额外解释
4. **数据保真**:源内容中的数据、术语、引用原样保留
5. **先规划再画图**:6+ 节点先输出规划文件,确认后再生成
6. **精确间距优于"适当间距"**:布局用硬编码数字(组件高度 60px、间距 40px)
7. **零留白原则**:标签撑满容器(flex:1),section 宽度按内容量差异化
8. **信息融入标签,不散落文字**:所有信息融入标签或行标题中
9. **视觉自检 > 技术自检**:先检查视觉层面,再检查技术层面
10. **慷慨留白**:图表周围 ≥15% 空白区域。与第7条的区别:内部紧凑 + 外围宽松 = 高级感
11. **视觉张力**:对称布局中引入一处有意的不对称,每张图应有一个视觉锚点

## When to Use

**Explicit triggers:** "画图", "diagram", "visualize", "flowchart", "draw", "架构图", "流程图", "可视化一下", "出图"

**Proactive triggers:** 3+ interacting components; multi-step process/decision tree; comparing architectures

**Skip when:** simple list/table suffices, or quick Q&A flow

## Engine Selection

```
User asks for diagram
       │
       ├─ Complex layered architecture (10+ nodes, 3+ layers)? → HTML+CSS 直出
       ├─ User explicitly wants editable .drawio file? → draw.io CLI
       ├─ User specifies style theme? → SVG 直出
       ├─ AI/Agent domain (RAG/Memory/Multi-Agent)? → SVG 直出
       ├─ draw.io CLI not available? → SVG 直出
       └─ Default → draw.io CLI
```

🚨 **不要在 drawio/SVG 上迭代多轮后才切换 HTML+CSS**。第一轮就应该根据节点数和图表类型做出正确选择。

## 多风格输出（可选）

当用户说「多风格」「对比」「选一个最好的」时启用:
1. **亮色系 1 个**：Style 4 (Notion Clean) 或 Style 9 (Business Whiteboard)
2. **暗色系 1 个**：Style 2 (Dark Terminal) 或 Style 8 (Dark Architecture)
3. **特色风格 1 个**：Style 3 (Blueprint) 或 Style 5 (Glassmorphism)

用同一份图表数据生成 3 种风格 SVG → 各自转 PNG → 汇总到 diagram-showcase.html。默认仍是单一最适合的风格。

---

# Part 1: draw.io CLI Engine (Default)

## Prerequisites

```bash
# macOS
brew install --cask drawio
draw.io --version
# 或 /Applications/draw.io.app/Contents/MacOS/draw.io --version
```

## Workflow

1. **Check deps** - verify `draw.io --version` succeeds
2. **Plan** - identify shapes, relationships, layout (LR or TB), group by tier/layer
3. **Generate** - write `.drawio` XML file. 🔴 **必须先读 `references/drawio-xml-reference.md`**
4. **Export draft** - run CLI to produce PNG for preview
5. **Self-check** - read exported PNG, catch issues, auto-fix (max 2 rounds)
6. **Review loop** - show image to user, collect feedback, targeted XML edits, re-export
7. **Final export** - export approved version to all requested formats

### Step 5: Self-Check

| Check | What to look for | Auto-fix action |
|-------|-----------------|-----------------|
| Overlapping shapes | Shapes stacked | Shift apart by ≥200px |
| Clipped labels | Text cut off | Increase shape width/height |
| Missing connections | Arrows don't connect | Verify source/target ids |
| Off-canvas shapes | Negative coordinates | Move to positive |
| Edge-shape overlap | Arrow crosses unrelated shape | Add waypoints to route around (见 `drawio-xml-reference.md` Edge Routing Rule 4) |
| Stacked edges | Edges overlap same path | Distribute entry/exit points (见 Rule 1) |
| Corner connections | exitX+exitY both at 0 or 1 | Use edge center points (见 Rule 7) |
| Missing exit/entry attrs | Edge has no explicit connection points | Always set all 4: exitX/exitY/entryX/entryY (见 Rule 3) |

### Step 6: Targeted Edit Rules

| User request | XML edit action |
|-------------|----------------|
| Change color | Update `fillColor`/`strokeColor` in style |
| Add node | Append `mxCell` vertex with next id |
| Remove node | Delete vertex + connected edges |
| Move/Resize | Update `x`/`y` or `width`/`height` in `mxGeometry` |
| Add arrow | Append `mxCell` edge with source/target |
| Change layout direction | **Full regeneration** |

Rules: single-element → edit in place; layout-wide → regenerate; overwrite same PNG each iteration; after 5 rounds → suggest user open `.drawio` in desktop app.

> 🔴 **draw.io XML 结构、形状/连接器代码示例、颜色板、布局间距 → 详见 `references/drawio-xml-reference.md`**

---

# Part 2: SVG 直出 Engine

Use when: stylized theme, AI/Agent domain diagram, or draw.io CLI not available.

## Helper Scripts

| Script | Usage | Purpose |
|--------|-------|---------|
| `scripts/generate-diagram.sh` | `<output-name> [width] [height] [output-dir]` | Generate SVG + PNG with validation |
| `scripts/validate-svg.sh` | `<svg-file>` | Check XML syntax, tags, markers, paths |
| `scripts/test-all-styles.sh` | `[output-dir]` | Batch test all styles with report |

## SVG Workflow

1. **Classify** diagram type. 🔴 **必须先读 `references/diagram-types.md`**
2. **Extract structure** - identify layers, nodes, edges, flows, semantic groups
3. **Plan layout** - apply layout rules for the diagram type
4. **Load style** - default `references/style-1-flat-icon.md`; or matching `references/style-N.md`
5. **Map nodes to shapes**. 🔴 **必须先读 `references/shape-vocabulary.md`**
6. **Check icon needs** - load `references/icons.md` for known products
7. **Write SVG** using Python list method. 🔴 **必须先读 `references/svg-technical-guide.md`**
8. **Validate**: `rsvg-convert file.svg -o /dev/null 2>&1`
9. **Export PNG**: `rsvg-convert -w 1920 file.svg -o file.png`
10. **Report** file paths

## Visual Styles (SVG Engine)

| # | Name | Background | Best For |
|---|------|-----------|----------|
| 1 | **Flat Icon** (default) | White | Blogs, docs, presentations |
| 2 | **Dark Terminal** | `#0f0f1a` | GitHub, dev articles |
| 3 | **Blueprint** | `#0a1628` | Architecture docs |
| 4 | **Notion Clean** | White, minimal | Notion-style docs |
| 5 | **Glassmorphism** | Dark gradient | Product sites, keynotes |
| 6 | **Claude Official** | Warm cream `#f8f6f3` | Anthropic-style diagrams |
| 7 | **OpenAI Official** | Pure white `#ffffff` | OpenAI-style diagrams |
| 8 | **Dark Architecture** | Slate-950 `#020617` + grid | Tech blogs, infra docs, hero images |
| 9 | **Business Whiteboard** | Pure white `#ffffff` | 产品/业务架构图, 商务汇报 |

Load `references/style-N.md` for exact color tokens. Load `references/style-diagram-matrix.md` for style-to-diagram-type recommendations.

### Style 9 快速参考
- **90% 无彩色**:白底灰边为主,颜色仅做语义标记(AI=墨绿 `#2d9d78`)
- **结构化信息卡**:节点是 key:value 信息卡(人/器/事模式)
- **自由画布布局**:虚线矩形圈组分区,默认 ViewBox `0 0 1200 800`
- 详见 `references/style-9-business-whiteboard.md`

### Style 8 快速参考
- **语义配色**:前端=cyan、后端=emerald、数据库=violet、云=amber
- **JetBrains Mono** 等宽字体,40px 网格背景,半透明填充 + 彩色描边
- 详见 `references/style-8-dark-architecture.md`

---

# Part 3: HTML+CSS Engine

🔴 **完整 CSS 模板、配色方案、Chrome headless 截图命令 → 必须先读 `references/html-css-template.md`**

## Workflow

1. **Plan** - 确定层数、每层 section、每个 section 内的标签行
2. **Write HTML** - 用 `references/html-css-template.md` 中的模板生成 HTML 文件
3. **Screenshot** - Chrome headless 2x 截图
4. **Visual check** - 按视觉自检清单检查
5. **Iterate** - 用 edit 工具精确修改 HTML,重新截图
6. **Deliver** - 交付 HTML(可编辑)+ PNG(高清)

---

# 生成后检查清单

## 技术检查

- [ ] 所有文字在方块内不溢出
- [ ] 箭头没有穿过不相关的方块
- [ ] viewBox/画布大小覆盖所有元素(留 20px buffer)
- [ ] 没有孤立节点(每个节点至少有一条连接)
- [ ] 垂直堆叠的组件间距 ≥ 40px(用数字验算)
- [ ] 深色主题(Style 2/3/5/8)半透明组件有 opaque mask
- [ ] Legend 在所有容器最下方 + 20px 之后

## 视觉自检(优先于技术检查)

- [ ] 颜色编码语义一致(同类用同色)
- [ ] 图表能在 3 秒内被理解
- [ ] 同层 section 等高对齐
- [ ] 标签尺寸统一(同层内宽高一致)
- [ ] 没有过多留白
- [ ] 整体像成品还是草稿?(草稿感 = 不可交付)
- [ ] 没有零散的文字说明
- [ ] 每行标签格式统一
- [ ] 层标题居中

**视觉不过关的信号**:标签居中两侧留白、section 高度参差不齐、散落文字、标签尺寸不统一。命中任一 → 先修再给用户。

---

# References 路由表

| 需要时 | 读取 |
|--------|------|
| 图表类型规格 + 复杂度管理 + 动词路由 | `references/diagram-types.md` |
| 形状词汇 + 箭头语义 + AI/Agent 模式 | `references/shape-vocabulary.md` |
| SVG 间距规则 + 生成策略 + 规划方法 | `references/svg-technical-guide.md` |
| draw.io XML 结构 + 代码示例 + 颜色板 + 布局 + 导出 | `references/drawio-xml-reference.md` |
| HTML+CSS 模板 + 配色方案 + Chrome 截图 | `references/html-css-template.md` |
| 风格 N 的精确色值 | `references/style-N.md` (N=1-9) |
| 风格-图表类型推荐矩阵 | `references/style-diagram-matrix.md` |
| 图标库 | `references/icons.md` |
| SVG 布局最佳实践 | `references/svg-layout-best-practices.md` |
| 装饰性图案 | `references/decorative-patterns.md` |
| 展示页背景 | `references/showcase-backgrounds.md` |
| 纹理效果 | `references/texture-effects.md` |
