# draw.io XML Reference

## File Skeleton

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="drawio" version="26.0.0">
  <diagram name="Page-1">
    <mxGraphModel>
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- user shapes start at id="2" -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

**Rules:**
- `id="0"` and `id="1"` are required root cells - never omit them
- User shapes start at `id="2"` and increment sequentially
- All shapes have `parent="1"` (unless inside a container)
- All text uses `html=1` in style for proper rendering
- All mxCell elements must be **siblings** under `<root>` — never nest mxCell inside another mxCell
- **Never use `--` inside XML comments** - illegal per XML spec
- **Never include XML comments (`<!-- ... -->`)** in generated XML — draw.io strips them, breaking edit patterns
- Escape special characters: `&amp;`, `&lt;`, `&gt;`, `&quot;`

## Shape Types (vertex)

| Style keyword | Use for |
|--------------|---------|
| `rounded=0` | plain rectangle (default) |
| `rounded=1` | rounded rectangle - services, modules |
| `ellipse;` | circles/ovals - start/end, databases |
| `rhombus;` | diamond - decision points |
| `shape=mxgraph.aws4.resourceIcon;` | AWS icons |
| `shape=cylinder3;` | cylinder - databases |
| `swimlane;` | group/container with title bar |

## Required Shape Properties

```xml
<!-- Rectangle / rounded box -->
<mxCell id="2" value="Label" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="160" height="60" as="geometry" />
</mxCell>

<!-- Cylinder (database) -->
<mxCell id="3" value="DB" style="shape=cylinder3;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;" vertex="1" parent="1">
  <mxGeometry x="350" y="100" width="120" height="80" as="geometry" />
</mxCell>

<!-- Diamond (decision) -->
<mxCell id="4" value="Check?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
  <mxGeometry x="100" y="220" width="160" height="80" as="geometry" />
</mxCell>
```

## Containers and Groups

| Type | Style | When to use |
|------|-------|-------------|
| **Group** (invisible) | `group;pointerEvents=0;` | No visual border needed |
| **Swimlane** (titled) | `swimlane;startSize=30;` | Container needs visible title bar |
| **Custom container** | Add `container=1;pointerEvents=0;` to any shape | Any shape acting as container |

```xml
<!-- Swimlane container -->
<mxCell id="svc1" value="User Service" style="swimlane;startSize=30;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="300" height="200" as="geometry"/>
</mxCell>
<!-- Child inside container - coordinates relative to parent -->
<mxCell id="api1" value="REST API" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="svc1">
  <mxGeometry x="20" y="40" width="120" height="60" as="geometry"/>
</mxCell>
```

## Connector (edge)

**CRITICAL:** Every edge `mxCell` must contain a `<mxGeometry relative="1" as="geometry" />` child. Self-closing edge cells are **invalid**.

```xml
<!-- Directed arrow -->
<mxCell id="10" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="2" target="3">
  <mxGeometry relative="1" as="geometry" />
</mxCell>

<!-- Arrow with label + explicit entry/exit points -->
<mxCell id="11" value="HTTP/REST" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="2" target="4">
  <mxGeometry relative="1" as="geometry" />
</mxCell>

<!-- Arrow with waypoints -->
<mxCell id="12" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="3" target="5">
  <mxGeometry relative="1" as="geometry">
    <Array as="points">
      <mxPoint x="500" y="50" />
    </Array>
  </mxGeometry>
</mxCell>
```

**Edge rules (basic):**
- **Always** include `rounded=1;orthogonalLoop=1;jettySize=auto` - enables smart routing
- Pin `exitX/exitY/entryX/entryY` when node has 2+ connections
- Add `<Array as="points">` waypoints for edge detours
- Final segment before target must be ≥20px (else arrowhead overlaps bend)

## Edge Routing Rules (7 条黄金法则)

> 融合自 next-ai-draw-io 项目（27K star）的 prompt 工程实践，经验证对 LLM 生成质量有显著提升。

### Rule 1: 多条边不能共享同一路径
- 两条边连接相同节点对时，**必须**从不同位置出入
- 用 `exitY=0.3` 和 `exitY=0.7` 区分，**不要**都用 `0.5`

```xml
<!-- ✅ 正确：两条边错开 -->
<mxCell id="e1" value="A→B" style="edgeStyle=orthogonalEdgeStyle;exitX=1;exitY=0.3;entryX=0;entryY=0.3;endArrow=classic;" edge="1" parent="1" source="a" target="b">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
<mxCell id="e2" value="B→A" style="edgeStyle=orthogonalEdgeStyle;exitX=0;exitY=0.7;entryX=1;entryY=0.7;endArrow=classic;" edge="1" parent="1" source="b" target="a">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### Rule 2: 双向连接用对面
- A→B：从 A 的右侧出（exitX=1），进 B 的左侧（entryX=0）
- B→A：从 B 的左侧出（exitX=0），进 A 的右侧（entryX=1）

### Rule 3: 始终显式指定 4 个连接点属性
- 每条边**必须**在 style 中设置 `exitX, exitY, entryX, entryY`
- 示例：`style="edgeStyle=orthogonalEdgeStyle;exitX=1;exitY=0.3;entryX=0;entryY=0.3;endArrow=classic;"`

### Rule 4: 边必须绕过中间形状（障碍物避免）🔴 关键！
- 生成边之前，识别所有位于 source 和 target 之间的形状
- 如果直线路径会穿过其他形状，**必须**用 waypoint 绕行
- 对角线连接：沿图表**外围**绕行，不要穿过中间
- Waypoint 距离形状边界至少 20-30px

```xml
<!-- ✅ 正确：绕过中间的 Develop 节点，沿右侧外围路由 -->
<mxCell id="hotfix_to_main" style="edgeStyle=orthogonalEdgeStyle;exitX=0.5;exitY=0;entryX=1;entryY=0.5;endArrow=classic;" edge="1" parent="1" source="hotfix" target="main">
  <mxGeometry relative="1" as="geometry">
    <Array as="points">
      <mxPoint x="750" y="80"/>
      <mxPoint x="750" y="150"/>
    </Array>
  </mxGeometry>
</mxCell>
```

### Rule 5: 先规划布局，再生成 XML
- 按流向组织形状为可视层/区域（列或行）
- 形状间距 150-200px，留出清晰的路由通道
- 心理推演每条边："source 和 target 之间有哪些形状？"
- 优先选择边自然单向流动的布局（左→右或上→下）

### Rule 6: 复杂路由用多个 waypoint
- 一个 waypoint 通常不够——用 2-3 个构造 L 形或 U 形路径
- 每个方向变化需要一个 waypoint（拐角点）
- Waypoint 应形成清晰的水平/垂直线段（正交路由）
- 计算位置：(1) 确定障碍物边界 (2) 加 20-30px 间距

### Rule 7: 根据流向选择自然连接点
- **永远不要**使用角落连接（如 entryX=1, entryY=1）——看起来不自然
- 上→下流向：从底部出（exitY=1），从顶部入（entryY=0）
- 左→右流向：从右侧出（exitX=1），从左侧入（entryX=0）
- 对角线连接：用离目标最近的**边中点**，不用角落

### 生成前心理自检（4 问）
1. "有没有边穿过了非 source/target 的形状？" → 有就加 waypoint
2. "有没有两条边共享同一路径？" → 有就调整出入点
3. "有没有连接点在角落（X 和 Y 都是 0 或 1）？" → 有就改用边中点
4. "能不能重新排列形状来减少边交叉？" → 能就修改布局

## Distributing Connections on a Shape

| Position | exitX/entryX | exitY/entryY |
|----------|-------------|-------------|
| Top center | 0.5 | 0 |
| Top-left | 0.25 | 0 |
| Top-right | 0.75 | 0 |
| Right center | 1 | 0.5 |
| Bottom center | 0.5 | 1 |
| Left center | 0 | 0.5 |

## Color Palette

| Color | fillColor | strokeColor | Use for |
|-------|-----------|-------------|---------|
| Blue | `#dae8fc` | `#6c8ebf` | services, clients |
| Green | `#d5e8d4` | `#82b366` | success, databases |
| Yellow | `#fff2cc` | `#d6b656` | queues, decisions |
| Orange | `#ffe6cc` | `#d79b00` | gateways, APIs |
| Red/Pink | `#f8cecc` | `#b85450` | errors, alerts |
| Grey | `#f5f5f5` | `#666666` | external/neutral |
| Purple | `#e1d5e7` | `#9673a6` | security, auth |

## Layout Tips

**Spacing - scale with complexity:**

| Complexity | Nodes | H-gap | V-gap |
|-----------|-------|-------|-------|
| Simple | ≤5 | 200px | 150px |
| Medium | 6-10 | 280px | 200px |
| Complex | >10 | 350px | 250px |

**General rules:**
- Plan a grid before assigning x/y - sketch positions mentally first
- Group related nodes in same horizontal/vertical band
- Place heavily-connected "hub" nodes centrally
- Event bus pattern: place Kafka/bus in **center of service row**, not below
- Horizontal connections (`exitX=1` or `exitX=0`) for peer-to-peer and publish
- Leave ~80px routing corridors between shape rows for edge paths
- 从合理的边距开始（如 x=40, y=40），元素紧凑分组
- 大型图表用垂直堆叠或网格布局

## Export

```bash
# macOS - Homebrew
draw.io -x -f png -e -s 2 -o diagram.drawio.png input.drawio

# macOS - full path
/Applications/draw.io.app/Contents/MacOS/draw.io -x -f png -e -s 2 -o diagram.drawio.png input.drawio

# Linux (headless)
xvfb-run -a draw.io -x -f png -e -s 2 -o diagram.drawio.png input.drawio

# SVG / PDF
draw.io -x -f svg -o diagram.svg input.drawio
draw.io -x -f pdf -o diagram.pdf input.drawio
```

**Key flags:** `-x` export mode; `-f` format; `-e` embed XML; `-s` scale (2 recommended); `-o` output path; `-b` border; `-t` transparent PNG

**Check PATH:**
```bash
if command -v draw.io &>/dev/null; then
  DRAWIO="draw.io"
elif [ -f "/Applications/draw.io.app/Contents/MacOS/draw.io" ]; then
  DRAWIO="/Applications/draw.io.app/Contents/MacOS/draw.io"
else
  echo "draw.io not found - falling back to SVG engine"
fi
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Missing `id="0"` and `id="1"` | Always include both at top of `<root>` |
| Shapes not connected | `source`/`target` must match existing shape `id` values |
| Export not found on macOS | Try full path `/Applications/draw.io.app/Contents/MacOS/draw.io` |
| Linux blank output headlessly | Prefix with `xvfb-run -a` |
| Overlapping shapes | Scale spacing 200-350px; leave routing corridors |
| Edges crossing through shapes | Add waypoints, distribute entry/exit points (见 Edge Routing Rule 4) |
| Multiple edges overlapping same path | Use different exitY/entryY values (见 Edge Routing Rule 1) |
| Corner connections (exitX=1,exitY=1) | Use edge center points instead (见 Edge Routing Rule 7) |
| Self-closing edge `mxCell` | Always use expanded form with `<mxGeometry>` child |
| XML comments (`<!-- -->`) | Never include — draw.io strips them, breaks edit patterns |
| `--` inside XML comments | Illegal per XML spec - use single hyphens |
| Arrowhead overlaps bend | Final edge segment ≥20px - increase spacing or add waypoints |
| Nested mxCell elements | All mxCell must be siblings under `<root>`, never nested |
