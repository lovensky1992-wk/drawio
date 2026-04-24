# SVG 质感效果库

为图表增加物理质感，从"数字感"变成"高级感"。微小改动，显著提升画面品质。

## 1. 噪点质感（Grain Texture）

在暗色/渐变风格上叠加 3% 透明度的 fractalNoise，模拟胶片颗粒感。

```xml
<!-- 在 SVG <defs> 中定义 -->
<filter id="grain">
  <feTurbulence type="fractalNoise" baseFrequency="0.65" numOctaves="3" stitchTiles="stitch"/>
  <feColorMatrix type="saturate" values="0"/>
  <feBlend in="SourceGraphic" mode="multiply"/>
</filter>

<!-- 在 SVG 最外层叠加（放在所有内容之后） -->
<rect width="100%" height="100%" filter="url(#grain)" opacity="0.03"/>
```

### 使用规则
- ✅ **适用风格**：Style 2 (Dark Terminal)、Style 5 (Glassmorphism)、Style 8 (Dark Architecture)、任何暗色/渐变背景
- ❌ **不适用**：Style 4 (Notion Clean)、Style 9 (Business Whiteboard)、纯白背景风格——噪点在白色上看起来脏而不是高级
- 📐 **透明度**：固定 0.03（3%），太高会模糊内容，太低无感知

## 2. 微光晕（Subtle Glow）

给关键节点添加柔和光晕，建立视觉层次。

```xml
<filter id="glow">
  <feGaussianBlur in="SourceGraphic" stdDeviation="4" result="blur"/>
  <feColorMatrix in="blur" type="matrix"
    values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 0.3 0"/>
  <feMerge>
    <feMergeNode/>
    <feMergeNode in="SourceGraphic"/>
  </feMerge>
</filter>

<!-- 仅应用到核心组件 -->
<rect ... filter="url(#glow)"/>
```

### 使用规则
- 仅用于图表中的 1-2 个核心组件（视觉锚点）
- 配合第 11 条设计原则「视觉张力」使用
- stdDeviation 4-6 之间，不要太夸张

## 3. 渐变蒙版（Gradient Fade）

图表边缘渐隐效果，用于截断过长的图表或营造聚焦感。

```xml
<linearGradient id="fadeMask" x1="0" y1="0" x2="0" y2="1">
  <stop offset="0%" stop-color="white"/>
  <stop offset="85%" stop-color="white"/>
  <stop offset="100%" stop-color="black"/>
</linearGradient>
<mask id="fade">
  <rect width="100%" height="100%" fill="url(#fadeMask)"/>
</mask>

<!-- 应用到包含所有内容的 <g> -->
<g mask="url(#fade)">
  <!-- 图表内容 -->
</g>
```

## 集成清单

生成 SVG 图表时的质感增强检查：
1. 背景是暗色/渐变？→ 加噪点质感（#grain）
2. 有明确的核心组件？→ 考虑微光晕（#glow）
3. 图表很长需要截断？→ 用渐变蒙版（#fade）
4. 以上都不是？→ 不加效果，保持干净
