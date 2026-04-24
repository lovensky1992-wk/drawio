# HTML+CSS Engine Template & Color Schemes

## When to Use

| Signal | Action |
|--------|--------|
| 复杂分层架构图(10+ 节点,3+ 层) | → HTML+CSS |
| 产品大图 / 跨团队对齐用的架构图 | → HTML+CSS |
| 用户要求「精美」「专业」「好看」 | → HTML+CSS |
| 前几轮 draw.io/SVG 产出被打回「太丑」 | → 切换 HTML+CSS |

**核心优势**:CSS flexbox 自动处理对齐、等高、填充,不需要手动算坐标。修改迭代比 SVG/drawio 快得多。

## Prerequisites

```bash
# Chrome headless 截图(macOS)
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --version
```

## Chrome Headless Screenshot

```bash
# 2x retina 高清截图
NO_PROXY="*" no_proxy="*" \
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new --disable-gpu --no-sandbox \
  --screenshot="output.png" \
  --window-size=1500,1200 \
  --force-device-scale-factor=2 \
  "file:///path/to/diagram.html"
```

**注意**:
- 必须加 `NO_PROXY="*" no_proxy="*"` 绕过代理限制
- `--force-device-scale-factor=2` 确保高清输出

**Viewport 高度经验公式**（避免底部截断）：
```
最小高度 = 层数 × 200px + 标题 80px + 层间箭头 (层数-1) × 30px + 边距 60px
```
| 层数 | 建议 viewport 高度 |
|------|------------------|
| 3 层 | 900px |
| 4 层 | **1150px** |
| 5 层 | 1400px |

宁可多给 100px，也不要截断底部容器边框。
- 每次更新截图用不同文件名(加版本号或时间戳),避免 webchat 图片缓存

## 核心 CSS 结构

```css
/* Layer: 每一层的容器 */
.layer { border-radius: 12px; margin-bottom: 8px; overflow: hidden; }
.layer-header {
  padding: 10px 20px; font-size: 14px; font-weight: 700;
  color: #fff; text-align: center;  /* 层标题必须居中 */
}
.layer-body {
  padding: 10px; display: flex; gap: 7px;
  align-items: stretch;  /* 同层 section 等高 */
}

/* Section: 层内的各个区块 */
.section { border-radius: 8px; display: flex; flex-direction: column; }
.section-title { padding: 5px 10px; font-size: 11px; font-weight: 600; text-align: center; }
.section-body { padding: 6px; flex: 1; display: flex; flex-direction: column; gap: 4px; }

/* Tag Row: 标签行 */
.tag-row { display: flex; gap: 4px; }

/* Tag: 最小单元 */
.tag {
  padding: 4px 6px; border-radius: 4px; font-size: 11px; font-weight: 500;
  flex: 1;  /* 关键:撑满容器,不居中留白 */
  text-align: center; white-space: nowrap;
}

/* Row Label: 行标题(如「分类」「生命周期」) */
.row-label {
  padding: 3px 6px; border-radius: 4px; font-size: 10px; font-weight: 600;
  width: 52px; text-align: center; flex-shrink: 0;
}
```

## 宽度差异化分配

```html
<!-- 内容少的 section 窄,内容多的宽 -->
<div class="section" style="flex:0.7;"> <!-- 窄 section -->
<div class="section" style="flex:1.8;"> <!-- 宽 section -->
<div class="section" style="flex:2.4;"> <!-- 更宽 section -->
```

## 行标题用法(适用于有子分类逻辑的 section)

```html
<div class="tag-row has-label">
  <div class="row-label">分类</div>
  <div class="tag">运营领域 Skill</div>
  <div class="tag">通用运营 Skill</div>
  <div class="tag">通用 Skill</div>
</div>
```

## 层间箭头

```html
<div class="arrow-row">
  <div style="display:flex;flex-direction:column;align-items:center;">
    <div class="arrow-line"></div>
    <div class="arrow-head"></div>
  </div>
  <div class="arrow-label">任务编排 · Skill 调用</div>
</div>
```

## 基础设施层扁平布局(单行平铺,标签含子内容)

```html
<div class="section flat">
  <div class="section-body"> <!-- flex-direction: row -->
    <div class="tag">LLM 调度<span class="tag-sub">多模型路由 · 负载均衡</span></div>
    ...
  </div>
</div>
```

## 配色方案

每层一个色系,层内从深到浅:header(gradient) → body(bg) → section(lighter bg) → tag(white + colored border)。

### 默认:低饱和方案(推荐)

保留四色层级区分但整体压到灰调,简洁专业:

| 层 | Header Gradient | Body BG | Section BG | Tag Border | Text Color |
|------|----------------|---------|------------|------------|------------|
| 鼠尾草绿(用户层) | `#7a9e8a → #6b8f7a` | `#f7f9f7` | `#f2f5f3` | `#d0dbd3` | `#4a6b52` |
| 暖灰(应用层) | `#9a8a6e → #8a7a5e` | `#faf9f6` | `#f5f3ef` | `#d5cfc2` | `#6b5c3a` |
| 灰蓝(能力层) | `#6a82a0 → #5a7290` | `#f5f7fa` | `#f0f2f6` | `#c8d0dc` | `#3a5270` |
| 灰紫(基础设施) | `#7a6e90 → #6a5e80` | `#f8f7fa` | `#f3f1f6` | `#d0c8d8` | `#4a3a60` |

<details>
<summary>备选:高饱和方案(色彩更鲜明,适合内部分享)</summary>

| 层 | Header Gradient | Body BG | Section BG | Tag Border |
|------|----------------|---------|------------|------------|
| 绿色(用户层) | `#5a9e6f → #4a8e5f` | `#f5faf6` | `#eef6ef` | `#c0d8c4` |
| 琥珀(应用层) | `#c49030 → #b08020` | `#fdfaf0` | `#faf5e6` | `#dcc890` |
| 蓝色(能力层) | `#4a80c0 → #3a70b0` | `#f0f5fb` | `#eaf0f8` | `#a8c4e0` |
| 紫色(基础设施) | `#8060a8 → #705098` | `#f6f2fa` | `#f0eaf6` | `#c8b4d8` |

</details>

## 生成前检查项

生成 HTML 后、截图前必做：

1. **样式一致性**：确认同一层内所有 section 用相同的 CSS 类，不混用特殊样式类（如 ai-highlight + 默认）
2. **viewport 高度**：按经验公式设置，4 层架构图至少 1150px
3. **配色统一**：每层横幅色、section 标题底色、边框色是否同色系
4. **标签统一**：所有标签是否用相同的背景/边框/字色

## 常见错误

| 错误 | 修复 |
|------|------|
| 标签居中留白 | 确保 `tag` 有 `flex:1` |
| section 高度不等 | `layer-body` 加 `align-items: stretch` |
| 层标题不居中 | `layer-header` 加 `text-align: center` |
| 左右留白过多 | 标签加 `flex:1`、增大标签间距 |
| 截图缓存旧图 | 每次用不同文件名(加版本号) |
| 底部截断 | viewport 高度不够，按经验公式调大 |
| section 风格混乱 | 同层混用多种 CSS 类，统一为一种 |
| Chrome headless 代理报错 | 加 `NO_PROXY="*" no_proxy="*"` |
| 字体没加载 | 用 `@import url('fonts.googleapis.com/...')` 或本地字体 |
