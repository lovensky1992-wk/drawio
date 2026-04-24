# 📊 Draw.io Diagrams

生成技术图表并导出为 PNG/SVG/PDF 的 [OpenClaw](https://github.com/openclaw/openclaw) 技能。

三种引擎：
1. **draw.io 桌面 CLI**（默认）— 生成可编辑 `.drawio` XML
2. **SVG 直出** — 风格化/AI 领域图/draw.io 不可用时，使用 `rsvg-convert` 导出 PNG
3. **Mermaid** — 快速流程图/序列图

支持架构图、流程图、序列图、ER 图、思维导图等多种图表类型。

## Prerequisites

- [draw.io Desktop](https://github.com/jgraph/drawio-desktop/releases) (optional but recommended)
- `rsvg-convert` (for SVG → PNG export): `brew install librsvg`

## Installation

```bash
openclaw skills install drawio
```

## License

MIT
