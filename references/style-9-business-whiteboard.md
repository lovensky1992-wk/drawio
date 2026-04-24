# Style 9: Business Whiteboard(商务白板)

像资深架构师在白板上画的系统全景图--去装饰化、信息优先、颜色仅做语义标记。
灵感来源:淘宝闪购销售 AI 团队架构图系列(靳浩飞/赤狐)。

**参考样例**:`references/samples/style9-sample-ecosystem.jpeg`(生态网络图)、`references/samples/style9-sample-copilot-arch.jpeg`(Copilot 架构图)。生成前务必先看样例,把握整体气质。

## 设计哲学

1. **去色化**:90% 面积无彩色(白/灰/黑),颜色只出现在有语义区分需求的地方
2. **去装饰化**:零渐变、零阴影、零发光,一切视觉元素都有信息功能
3. **信息优先**:宁可多写字也不省略,图的目的是传递完整信息而非美观
4. **自由画布**:不强制网格对齐,允许有机的松散布局,靠虚线圈组分区
5. **结构化卡片**:节点不是简单标签,而是 key:value 的信息卡
6. **BPMN 混搭**:流程部分用标准 BPMN 元素,架构部分用自由框图

## 色彩系统

```
背景:           #ffffff(纯白)

── 默认/结构 ──
节点填充:       #ffffff(白底)
节点边框:       #d9d9d9(浅灰,1px 实线)
容器边框:       同层主色淡化版(见下方层配色),1px 虚线
标签:           白底 + #d9d9d9 边框,始终统一

── 层配色(每层一个低饱和主色)──
用户层:       横幅 #5b8c6f(草绿)  边框 #b8d4c3  section标题底 #f2f7f4  标题字 #3d6b4f
应用层:       横幅 #8a7a5e(暖棕)  边框 #d4ccb8  section标题底 #f7f5f1  标题字 #6b5c3a
能力层:       横幅 #5a7290(灰蓝)  边框 #b8c8d8  section标题底 #f1f4f8  标题字 #3a5270
基础设施层:   横幅 #6a6a6a(深灰)  边框 #c0c0c0  section标题底 #f3f3f3  标题字 #444

配色逻辑:层横幅用低饱和色(白字),section 标题用同色系极淡底色,标签始终白底灰边。
每层色彩只出现在横幅 + section 标题,其余保持无彩色。

── 语义点缀色(额外强调,按需使用)──
关键数据:       #e67e22(橙)或 #e74c3c(红)- 用于数字强调(3000万+、转化率 xx%)
对比区块A:      #e8f4fd(极淡蓝)- 左右对比时的背景底色
对比区块B:      #e8f8f0(极淡绿)- 左右对比时的背景底色
BPMN 网关:      #f0f0f0(浅灰填充)

── 文字 ──
标题文字:       #1a1a1a(近黑)
正文文字:       #333333(深灰)
标签文字:       #666666(中灰)
注释文字:       #999999(浅灰)
强调文字:       #e67e22(橙红)
```

### 用色规则

- **层配色统一**:每层一个低饱和主色,体现在横幅和 section 标题底色上,其余保持无彩色
- **section 样式统一**:同一层内所有 section 必须用相同的样式,不允许混用特殊强调类(如 ai-highlight / ai-bar)
- **语义点缀**:关键数据用橙红文字,对比分区用极淡底色,人类角色靠图标区分
- **彩色克制**:层配色不算在"3 种彩色"限制内(因为是结构性的),额外语义点缀色最多 2 种

## 字体排版

```
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC",
             "Microsoft YaHei", sans-serif

── 层级(共 6 级)──
L1 页面标题:    24-28px, font-weight: 700, fill: #1a1a1a, text-anchor: middle
L2 副标题:      14-16px, font-weight: 400, fill: #666666, text-anchor: middle
L3 模块标题:    16-18px, font-weight: 600-700, fill: #1a1a1a
L4 卡片内容:    13-14px, font-weight: 400, fill: #333333
L5 标签/tag:    11-12px, font-weight: 400, fill: #666666
L6 注释:        11-12px, font-weight: 400, fill: #999999, font-style: italic(可选)

── 数据强调 ──
关键数字:       16-20px, font-weight: 700, fill: #e67e22 或 #e74c3c
```

### 排版规则

- 层级靠**粗细 + 颜色**区分,不靠字体变化(全程同一 font-family)
- 标题居中,内容左对齐
- 标签紧凑排列,用 `|` 分隔符而非换行(如 "正则 | 词表 | Query 改写")
- 注释性文字可直接写在空白处,不必包裹在节点中

## 节点样式

### 1. 标准模块(最常用)
```xml
<rect x="x" y="y" width="w" height="h" rx="6"
      fill="#ffffff" stroke="#4a4a4a" stroke-width="1.5"/>
<text x="cx" y="cy" text-anchor="middle" fill="#1a1a1a"
      font-size="14" font-weight="600">模块名称</text>
```

### 2. 结构化信息卡(作战单元模式)
多行 key:value 结构,用于展示角色/职责/工具:
```xml
<g>
  <!-- 卡片容器 -->
  <rect x="x" y="y" width="200" height="100" rx="6"
        fill="#ffffff" stroke="#4a4a4a" stroke-width="1.5"/>
  <!-- 标题栏(可选墨绿底色表示 AI 角色) -->
  <rect x="x" y="y" width="200" height="28" rx="6"
        fill="#2d9d78" stroke="none"/>
  <rect x="x" y="y+22" width="200" height="6"
        fill="#2d9d78" stroke="none"/>
  <text x="cx" y="y+18" text-anchor="middle" fill="#ffffff"
        font-size="13" font-weight="600">作战单元 (AI)</text>
  <!-- 结构化字段 -->
  <text x="x+12" y="y+46" fill="#333333" font-size="12">
    <tspan font-weight="600">人:</tspan>LLM-based Agent</text>
  <text x="x+12" y="y+64" fill="#333333" font-size="12">
    <tspan font-weight="600">器:</tspan>AI Agent 系统</text>
  <text x="x+12" y="y+82" fill="#333333" font-size="12">
    <tspan font-weight="600">事:</tspan>动态决策对商户开启营业</text>
</g>
```

### 3. 逻辑容器(虚线圈组)
```xml
<rect x="x" y="y" width="w" height="h" rx="8"
      fill="rgba(0,0,0,0.015)" stroke="#999999"
      stroke-width="1" stroke-dasharray="6,4"/>
<text x="x+12" y="y+18" fill="#333333"
      font-size="14" font-weight="600">模块组名称</text>
```

### 4. 层横幅标题
层级标识,低饱和色横幅 + 白字,居中展示:
```xml
<rect x="x" y="y" width="w" height="32" rx="8"
      fill="#5b8c6f" stroke="none"/>
<text x="cx" y="y+21" text-anchor="middle" fill="#ffffff"
      font-size="13" font-weight="600">用户层 · 入口 + 交互</text>
```
配色参考上方「层配色」表,每层一个主色。

### 5. 小标签/tag 组
```xml
<!-- 紧凑排列的能力标签 -->
<rect x="x" y="y" width="auto" height="22" rx="4"
      fill="#f5f5f5" stroke="#d9d9d9" stroke-width="0.5"/>
<text x="x+6" y="y+15" fill="#666666" font-size="11">标签文字</text>
```

### 6. 人物角色
剪影 icon + 文字标签(不用 stick figure):
```xml
<g>
  <!-- 头 -->
  <circle cx="cx" cy="cy-16" r="10" fill="#e8e8e8" stroke="#4a4a4a" stroke-width="1.2"/>
  <!-- 身体/肩膀 -->
  <path d="M cx-14,cy+14 Q cx-14,cy-2 cx,cy-2 Q cx+14,cy-2 cx+14,cy+14"
        fill="#e8e8e8" stroke="#4a4a4a" stroke-width="1.2"/>
  <text x="cx" y="cy+30" text-anchor="middle" fill="#333333"
        font-size="12">角色名称</text>
</g>
```

### 7. 机器人/AI 助手 icon
```xml
<g>
  <!-- 方形头部 -->
  <rect x="cx-14" y="cy-18" width="28" height="24" rx="4"
        fill="#ffffff" stroke="#4a4a4a" stroke-width="1.5"/>
  <!-- 眼睛 -->
  <circle cx="cx-6" cy="cy-8" r="3" fill="#4a4a4a"/>
  <circle cx="cx+6" cy="cy-8" r="3" fill="#4a4a4a"/>
  <!-- 天线 -->
  <line x1="cx" y1="cy-18" x2="cx" y2="cy-24" stroke="#4a4a4a" stroke-width="1.5"/>
  <circle cx="cx" cy="cy-26" r="2.5" fill="#2d9d78"/>
  <text x="cx" y="cy+16" text-anchor="middle" fill="#333333"
        font-size="12" font-weight="600">AI助手</text>
</g>
```

### 8. 数据库/资产库
经典圆柱体,灰色系:
```xml
<ellipse cx="cx" cy="top" rx="40" ry="10" fill="#f0f0f0" stroke="#4a4a4a" stroke-width="1.5"/>
<rect x="cx-40" y="top" width="80" height="40" fill="#f0f0f0" stroke="none"/>
<line x1="cx-40" y1="top" x2="cx-40" y2="top+40" stroke="#4a4a4a" stroke-width="1.5"/>
<line x1="cx+40" y1="top" x2="cx+40" y2="top+40" stroke="#4a4a4a" stroke-width="1.5"/>
<ellipse cx="cx" cy="top+40" rx="40" ry="10" fill="#e8e8e8" stroke="#4a4a4a" stroke-width="1.5"/>
<text x="cx" y="top+25" text-anchor="middle" fill="#333333"
      font-size="12" font-weight="600">数据库名</text>
```

## 节点内容指引

Style 9 信息密度高,节点内容要**具体**不要抽象:

**结构化卡片**:使用「人/器/事」三要素或自定义 key:value
- 人:谁执行(AI Agent / BD / 运营小二)
- 器:用什么工具/系统(Agent 系统 / CRM / 外呼平台)
- 事:具体做什么(动态决策 / 跟进处理 / 数据分析)

**标准模块**:标题 + 1-2 行子说明
- ✅ 好:"意图识别" + "正则 | 词表 | Query 改写 | Qwen-14B/72B"
- ❌ 差:"处理模块"(太模糊)

**数据区块**:嵌入具体数字,用橙红色强调关键指标
- ✅ 好:"商户池: 1000家 → 达成: 320家(转化率32%)"
- ❌ 差:"转化分析"(无数据)

**注释文字**:直接写在画布空白处,补充流程说明或设计决策
- 位置:紧贴相关模块,偏移 10-15px
- 样式:L6 注释(11-12px, `#999999`)
- 可用于:时效说明、成本数据、方案对比、定位说明

## 渠道/平台 Icon 组

多个小图标横排,表示多渠道接入(如 IM/企微/外呼/公开渠道):
```xml
<g>
  <!-- 渠道组容器 -->
  <text x="x" y="y" fill="#333333" font-size="13" font-weight="600">渠道接入</text>
  <!-- 横排圆角小方块,间距 6px -->
  <rect x="x" y="y+8" width="36" height="28" rx="4"
        fill="#f5f5f5" stroke="#d9d9d9" stroke-width="0.5"/>
  <text x="x+18" y="y+26" text-anchor="middle"
        fill="#666" font-size="10">IM</text>
  <rect x="x+42" y="y+8" width="36" height="28" rx="4"
        fill="#f5f5f5" stroke="#d9d9d9" stroke-width="0.5"/>
  <text x="x+60" y="y+26" text-anchor="middle"
        fill="#666" font-size="10">企微</text>
  <!-- 更多渠道同理追加... -->
</g>
```

用于:Agent 渠道适配器、多触点接入、平台矩阵等场景。图标可替换为实际 emoji 或 SVG mini icon。

## BPMN 元素(流程部分使用)

### 开始/结束事件
```xml
<!-- 开始事件:细边框圆 -->
<circle cx="cx" cy="cy" r="16" fill="#ffffff" stroke="#4a4a4a" stroke-width="1.5"/>

<!-- 结束事件:粗边框圆 -->
<circle cx="cx" cy="cy" r="16" fill="#ffffff" stroke="#4a4a4a" stroke-width="3"/>
```

### 排他网关(菱形)
```xml
<polygon points="cx,cy-20 cx+20,cy cx,cy+20 cx-20,cy"
         fill="#f0f0f0" stroke="#4a4a4a" stroke-width="1.5"/>
<!-- 内部 X 标记 -->
<line x1="cx-7" y1="cy-7" x2="cx+7" y2="cy+7" stroke="#4a4a4a" stroke-width="2"/>
<line x1="cx+7" y1="cy-7" x2="cx-7" y2="cy+7" stroke="#4a4a4a" stroke-width="2"/>
```

### 并行网关(菱形 + 十字)
```xml
<polygon points="cx,cy-20 cx+20,cy cx,cy+20 cx-20,cy"
         fill="#f0f0f0" stroke="#4a4a4a" stroke-width="1.5"/>
<line x1="cx" y1="cy-8" x2="cx" y2="cy+8" stroke="#4a4a4a" stroke-width="2"/>
<line x1="cx-8" y1="cy" x2="cx+8" y2="cy" stroke="#4a4a4a" stroke-width="2"/>
```

## 箭头与连接

```xml
<defs>
  <!-- 主箭头:深灰 -->
  <marker id="arrow-gray" markerWidth="10" markerHeight="7"
          refX="9" refY="3.5" orient="auto">
    <polygon points="0 0, 10 3.5, 0 7" fill="#4a4a4a"/>
  </marker>
  <!-- AI 链路箭头:墨绿 -->
  <marker id="arrow-green" markerWidth="10" markerHeight="7"
          refX="9" refY="3.5" orient="auto">
    <polygon points="0 0, 10 3.5, 0 7" fill="#2d9d78"/>
  </marker>
  <!-- 数据强调箭头:橙红 -->
  <marker id="arrow-orange" markerWidth="10" markerHeight="7"
          refX="9" refY="3.5" orient="auto">
    <polygon points="0 0, 10 3.5, 0 7" fill="#e67e22"/>
  </marker>
</defs>
```

| 类型 | 颜色 | 粗细 | 虚实 | 用途 |
|------|------|------|------|------|
| 主流程 | `#4a4a4a` 深灰 | 1.5-2px | 实线 | 默认连接 |
| AI 链路 | `#2d9d78` 墨绿 | 2px | 实线 | AI/Agent 相关流向 |
| 辅助/反馈 | `#999999` 灰 | 1px | 虚线 `4,3` | 辅助信息流、反馈 |
| 数据强调 | `#e67e22` 橙 | 1.5px | 实线 | 关键数据链路 |
| 人机交互 | `#4a4a4a` 深灰 | 1.5px | 双向箭头 | 人与 AI 的交互 |

### 箭头标注规则

**裸写文字,不加背景色块**--这是与其他 Style 最大的视觉差异:
```xml
<!-- ✅ Style 9 正确做法:裸写标注 -->
<text x="mid_x" y="mid_y - 8" text-anchor="middle"
      fill="#666666" font-size="12">标注文字</text>

<!-- ❌ 其他 Style 做法(Style 9 不用):带背景色块 -->
<!-- <rect fill="#ffffff" opacity="0.95"/> -->
```

- 标注文字紧贴箭头,偏移 5-8px
- 字号 12px,颜色 `#666666`
- 密集区域可用更小字号 11px 避免重叠
- 箭头标注尽量短(≤4 个字),复杂说明用注释文字块

## 布局规则

### 布局模式(两种兼容)

Style 9 支持两种布局模式,根据图表类型选择:

**模式 A:分层结构**(产品架构图、技术架构图)
- 水平分层,每层一个虚线容器 + 层横幅标题
- 层内 section 用 flexbox 水平排列,自动等高
- 层间用箭头连接,严格上下流向
- 适合:分层明确的系统架构

**模式 B:自由画布**(生态网络图、Agent 协作图、流程图)
- 虚线矩形圈组自由分布,不强制水平分层
- 模块间用箭头自由连接,允许斜线
- 注释性文字直接写在空白处
- 适合:多角色协作、非线性流程

两种模式共享相同的配色、节点、箭头规范。

### 间距参考

```
页面边距:       40-60px
模块间距:       80-120px(大呼吸感)
模块内节点间距:  15-25px(紧凑)
标签间距:       4-8px
箭头与节点间距:  5-10px
注释文字偏移:   10-15px
```

### 典型页面结构

```
┌──────────────────────────────────────────────────────────┐
│  [L1] 页面标题(居中,24-28px Bold)                        │
│  [L2] 副标题/说明(居中,14px,灰色)                        │
│                                                          │
│  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐    ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐           │
│  ╎  虚线圈组 A       ╎    ╎  虚线圈组 B          ╎           │
│  ╎  ┌────┐  ┌────┐ ╎───>╎  ┌─────────────┐  ╎           │
│  ╎  │节点│  │节点│ ╎    ╎  │ 信息卡(人器事)│  ╎           │
│  ╎  └────┘  └────┘ ╎    ╎  └─────────────┘  ╎           │
│  ╎  [tag] [tag]    ╎    ╎                    ╎           │
│  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘    └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘           │
│                                                          │
│  注释性文字:xxxx说明xxxx                                   │
│                                                          │
│  ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐  │
│  ╎  虚线圈组 C(大区域)                                  ╎  │
│  ╎  ○───>□───>◇───>□───>○                            ╎  │
│  ╎       (BPMN 流程)                                   ╎  │
│  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘  │
│                                                          │
│  成本分析:  商户池 1000家 → 达成 xxx家(转化率 xx%)          │
│           花费成本: xx元    平均时效: xx小时                  │
│                                                          │
│  ── 底部基础设施层(可选)──                                 │
│  [基建A] [基建B] [基建C] [基建D]                            │
│                                                          │
│  [图例]  ── 主流程  ╌╌ 辅助链路  ━━ AI链路                  │
└──────────────────────────────────────────────────────────┘
```

## 图例(Legend)

当使用 2+ 种箭头类型时,在右上角或右下角放图例:

```xml
<g transform="translate(760, 50)">
  <!-- 图例框(可选,也可以不加框) -->
  <line x1="0" y1="10" x2="30" y2="10" stroke="#4a4a4a" stroke-width="1.5"
        marker-end="url(#arrow-gray)"/>
  <text x="40" y="14" fill="#666666" font-size="11">主流程</text>

  <line x1="0" y1="30" x2="30" y2="30" stroke="#2d9d78" stroke-width="2"
        marker-end="url(#arrow-green)"/>
  <text x="40" y="34" fill="#666666" font-size="11">AI 链路</text>

  <line x1="0" y1="50" x2="30" y2="50" stroke="#999999" stroke-width="1"
        stroke-dasharray="4,3"/>
  <text x="40" y="54" fill="#666666" font-size="11">辅助/反馈</text>
</g>
```

## SVG 模板

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 800"
     width="1200" height="800">
  <style>
    text {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI",
                   "PingFang SC", "Microsoft YaHei", sans-serif;
    }
  </style>
  <defs>
    <marker id="arrow-gray" markerWidth="10" markerHeight="7"
            refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#4a4a4a"/>
    </marker>
    <marker id="arrow-green" markerWidth="10" markerHeight="7"
            refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#2d9d78"/>
    </marker>
    <marker id="arrow-orange" markerWidth="10" markerHeight="7"
            refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#e67e22"/>
    </marker>
  </defs>

  <!-- 纯白背景 -->
  <rect width="1200" height="800" fill="#ffffff"/>

  <!-- 标题 -->
  <text x="600" y="40" text-anchor="middle" fill="#1a1a1a"
        font-size="24" font-weight="700">图表标题</text>
  <text x="600" y="62" text-anchor="middle" fill="#666666"
        font-size="14">副标题说明文字</text>

  <!-- 虚线容器示例 -->
  <!-- 节点示例 -->
  <!-- 箭头示例 -->
  <!-- 图例 -->
</svg>
```

### ViewBox 推荐

| 复杂度 | ViewBox | 说明 |
|--------|---------|------|
| 简单(5-10 节点) | `0 0 960 600` | 标准尺寸 |
| 中等(10-20 节点) | `0 0 1200 800` | 推荐默认 |
| 复杂(20-40 节点) | `0 0 1400 1000` | 大画布 |
| 超复杂(40+ 节点) | `0 0 1600 1200` | 全景图 |

Style 9 信息密度高,**默认使用 `0 0 1200 800`**(比其他 Style 的 960x600 更大)。

### HTML 引擎截图高度经验公式

分层架构图的 viewport 高度估算:
```
最小高度 = 层数 × 200px + 标题区 80px + 层间箭头 (层数-1) × 30px + 下边距 60px
```
| 层数 | 最小 viewport 高度 | 建议值 |
|------|------------------|--------|
| 3 层 | 810px | 900px |
| 4 层 | 1040px | **1150px** |
| 5 层 | 1270px | 1400px |

宁可多给 100px,也不要截断底部虚线框。

## 适用场景

| 场景 | 适合度 | 说明 |
|------|--------|------|
| 产品/业务架构图 | ⭐⭐⭐⭐⭐ | 最佳场景,白板全景图 |
| Agent 协作网络 | ⭐⭐⭐⭐⭐ | 人机协作、多角色协同 |
| 流程图(含 BPMN) | ⭐⭐⭐⭐ | BPMN 元素天然适配 |
| 成本/转化分析图 | ⭐⭐⭐⭐ | 内嵌数据区块 |
| 技术架构/微服务 | ⭐⭐⭐ | 可用,但偏商务不偏技术 |
| 对比/矩阵图 | ⭐⭐⭐ | 左右对比模式 |
| 纯 UML 图 | ⭐⭐ | 偏简洁,不如 Style 3/4 正式 |
| 产品展示/演示 | ⭐⭐ | 太素,不如 Style 5/6 有视觉冲击力 |

## 反面模式（Don't）

- ❌ 不要给标签加彩色填充底色（标签始终白底灰边）
- ❌ 不要加阴影、渐变、发光效果
- ❌ 不要给箭头标注加背景色块
- ❌ 不要用 stick figure 表示人物（用剪影 icon）
- ❌ 不要为了“好看”省略信息（信息 > 美观）
- ❌ 不要同一层内混用多种 section 样式（如 ai-highlight + 默认混用）
- ❌ 不要截图时用过小的 viewport 高度（参考上方经验公式）

## 与 HTML+CSS 引擎配合

Style 9 因为自由布局特点,**同样适合 HTML+CSS 引擎**实现:
- 用 `position: absolute` 做自由定位(而非 flexbox 分层)
- 虚线容器用 `border: 1px dashed #999; border-radius: 8px`
- 结构化卡片用 HTML `<div>` + key:value 排版更方便
- 适合 20+ 节点的复杂图(HTML 比 SVG 手算坐标高效)

HTML 模式下建议用 CSS Grid 或 Flexbox 处理局部对齐,全局用 absolute 定位保持自由画布感。
