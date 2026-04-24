# SVG 装饰模式库 — 图表场景专用

为 drawio 图表输出提供 4 种 SVG 装饰模式，用于提升图表的展示品质。
所有模式使用 `currentColor` 以适配亮/暗主题。

---

## 1. 点阵背景纹理

**用途**: 作为图表底色装饰，在纯色背景上增加微妙的质感和精密感。

**适用场景**: 架构图底层、技术文档配图背景、Dashboard 图表区域

```svg
<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
  <defs>
    <pattern id="dot-grid" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse">
      <circle cx="10" cy="10" r="1" fill="currentColor" opacity="0.08"/>
    </pattern>
  </defs>
  <rect width="100%" height="100%" fill="url(#dot-grid)"/>
</svg>
```

**变体 — 交错点阵**（更精细，适合高密度图表）：

```svg
<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
  <defs>
    <pattern id="dot-grid-staggered" x="0" y="0" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="2" cy="2" r="0.8" fill="currentColor" opacity="0.06"/>
      <circle cx="10" cy="10" r="0.8" fill="currentColor" opacity="0.06"/>
    </pattern>
  </defs>
  <rect width="100%" height="100%" fill="url(#dot-grid-staggered)"/>
</svg>
```

**参数调节**:
- `r="1"` → 点半径，0.5–1.5 范围，越小越精细
- `opacity="0.08"` → 透明度，0.04–0.12 范围，越低越微妙
- `width/height="20"` → 间距，12–24 范围，越大越稀疏

---

## 2. 几何边框

**用途**: 为图表外围添加装饰性边框，增加展示层次感和完成度。

**适用场景**: 单图展示、演示文稿配图、文档封面图表

**圆角矩形边框 + 角标**：

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 600">
  <!-- 外层装饰框 -->
  <rect x="16" y="16" width="768" height="568" rx="12"
        fill="none" stroke="currentColor" stroke-width="1" opacity="0.15"/>
  <!-- 内层主框 -->
  <rect x="32" y="32" width="736" height="536" rx="8"
        fill="none" stroke="currentColor" stroke-width="1.5" opacity="0.25"/>
  <!-- 四角装饰点 -->
  <circle cx="32" cy="32" r="3" fill="currentColor" opacity="0.3"/>
  <circle cx="768" cy="32" r="3" fill="currentColor" opacity="0.3"/>
  <circle cx="32" cy="568" r="3" fill="currentColor" opacity="0.3"/>
  <circle cx="768" cy="568" r="3" fill="currentColor" opacity="0.3"/>
</svg>
```

**技术线框边框**（适合架构图）：

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 600">
  <!-- 外框 -->
  <rect x="8" y="8" width="784" height="584" rx="4"
        fill="none" stroke="currentColor" stroke-width="0.5" opacity="0.1"/>
  <!-- 角标线 — 左上 -->
  <line x1="8" y1="40" x2="40" y2="40" stroke="currentColor" stroke-width="1" opacity="0.2"/>
  <line x1="40" y1="8" x2="40" y2="40" stroke="currentColor" stroke-width="1" opacity="0.2"/>
  <!-- 角标线 — 右上 -->
  <line x1="760" y1="8" x2="760" y2="40" stroke="currentColor" stroke-width="1" opacity="0.2"/>
  <line x1="760" y1="40" x2="792" y2="40" stroke="currentColor" stroke-width="1" opacity="0.2"/>
  <!-- 角标线 — 左下 -->
  <line x1="8" y1="560" x2="40" y2="560" stroke="currentColor" stroke-width="1" opacity="0.2"/>
  <line x1="40" y1="560" x2="40" y2="592" stroke="currentColor" stroke-width="1" opacity="0.2"/>
  <!-- 角标线 — 右下 -->
  <line x1="760" y1="560" x2="760" y2="592" stroke="currentColor" stroke-width="1" opacity="0.2"/>
  <line x1="760" y1="592" x2="792" y2="592" stroke="currentColor" stroke-width="1" opacity="0.2"/>
</svg>
```

**参数调节**:
- `rx="12"` → 圆角半径，4–16 范围
- `stroke-width` → 外层 0.5–1，内层 1–2
- `opacity` → 外层 0.1–0.15，内层 0.2–0.3

---

## 3. 线条分隔线

**用途**: 在多层图表或分区图表中，作为层间的视觉分隔装饰。

**适用场景**: 分层架构图（前端/后端/数据层）、泳道图层间、图表与标注之间

**渐隐实线**：

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 4">
  <defs>
    <linearGradient id="fade-line" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="currentColor" stop-opacity="0"/>
      <stop offset="20%" stop-color="currentColor" stop-opacity="0.3"/>
      <stop offset="50%" stop-color="currentColor" stop-opacity="0.3"/>
      <stop offset="80%" stop-color="currentColor" stop-opacity="0.3"/>
      <stop offset="100%" stop-color="currentColor" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <line x1="0" y1="2" x2="800" y2="2" stroke="url(#fade-line)" stroke-width="1"/>
</svg>
```

**点线分隔**：

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 4">
  <line x1="40" y1="2" x2="760" y2="2"
        stroke="currentColor" stroke-width="1"
        stroke-dasharray="2 8" stroke-linecap="round" opacity="0.2"/>
</svg>
```

**居中菱形分隔**：

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 16">
  <line x1="80" y1="8" x2="370" y2="8"
        stroke="currentColor" stroke-width="0.5" opacity="0.15"/>
  <polygon points="400,2 406,8 400,14 394,8"
           fill="currentColor" opacity="0.2"/>
  <line x1="430" y1="8" x2="720" y2="8"
        stroke="currentColor" stroke-width="0.5" opacity="0.15"/>
</svg>
```

**参数调节**:
- `stroke-dasharray="2 8"` → 点间距，"1 6" 更密，"4 12" 更疏
- `opacity` → 0.1–0.3，层间分隔宜轻不宜重

---

## 4. 渐变装饰带

**用途**: 在图表顶部或底部添加装饰条，为输出增加品牌感和完整度。

**适用场景**: 图表封面、导出 PNG 的顶/底边框、演示文稿中的图表标题区

**顶部渐变带**：

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 6">
  <defs>
    <linearGradient id="top-band" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="currentColor" stop-opacity="0"/>
      <stop offset="15%" stop-color="currentColor" stop-opacity="0.4"/>
      <stop offset="50%" stop-color="currentColor" stop-opacity="0.6"/>
      <stop offset="85%" stop-color="currentColor" stop-opacity="0.4"/>
      <stop offset="100%" stop-color="currentColor" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <rect x="0" y="0" width="800" height="3" fill="url(#top-band)"/>
</svg>
```

**双色渐变带**（可搭配色彩主题使用）：

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 4">
  <defs>
    <linearGradient id="dual-band" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#2666CF" stop-opacity="0"/>
      <stop offset="30%" stop-color="#2666CF" stop-opacity="0.8"/>
      <stop offset="50%" stop-color="#00E5FF" stop-opacity="0.9"/>
      <stop offset="70%" stop-color="#2666CF" stop-opacity="0.8"/>
      <stop offset="100%" stop-color="#2666CF" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <rect x="0" y="0" width="800" height="3" rx="1.5" fill="url(#dual-band)"/>
</svg>
```

> 上例使用 Cyber Blue 主题色值，替换为其他主题色即可适配不同领域。

**底部消散带**：

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 24">
  <defs>
    <linearGradient id="bottom-fade" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="currentColor" stop-opacity="0.12"/>
      <stop offset="100%" stop-color="currentColor" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <rect x="0" y="0" width="800" height="24" fill="url(#bottom-fade)"/>
</svg>
```

**参数调节**:
- `height="3"` → 装饰带粗细，2–6 范围
- 渐变 `stop-opacity` → 中段 0.4–0.8，两端始终为 0（渐隐效果）
- 双色带需按所选色彩主题替换具体色值

---

## 组合使用示例

以下展示如何在一张图表输出中组合使用多种装饰模式：

```
┌─────────────────────────────────┐
│ ▓▓▓▓▓▓ 顶部渐变装饰带 ▓▓▓▓▓▓▓  │  ← 渐变装饰带
├─────────────────────────────────┤
│ ┌───────────────────────────┐   │
│ │  · · · · · · · · · · · ·  │   │  ← 点阵背景 + 几何边框
│ │  · · ┌───────────┐ · · ·  │   │
│ │  · · │  图表内容  │ · · ·  │   │
│ │  · · └───────────┘ · · ·  │   │
│ │  · · · · · · · · · · · ·  │   │
│ │ ─ ─ ─ ◇ ─ ─ ─ ─ ─ ─ ─   │   │  ← 线条分隔线
│ │  · · ┌───────────┐ · · ·  │   │
│ │  · · │  图表内容  │ · · ·  │   │
│ │  · · └───────────┘ · · ·  │   │
│ └───────────────────────────┘   │
│ ░░░░░░ 底部消散装饰带 ░░░░░░░  │  ← 底部消散带
└─────────────────────────────────┘
```

**使用原则**:
- 装饰永远服务于内容，不喧宾夺主
- 同一图表最多使用 2–3 种装饰模式
- 所有 opacity 值保持在 0.3 以下，确保不干扰图表可读性
