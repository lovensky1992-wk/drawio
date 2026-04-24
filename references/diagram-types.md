# Diagram Types & Layout Rules

## Architecture Diagram
Nodes = services/components. Group into **horizontal layers** (top→bottom or left→right).
- Typical layers: Client → Gateway/LB → Services → Data/Storage
- Use `<rect>` dashed containers for related services in the same layer
- Arrow direction follows data/request flow
- ViewBox: `0 0 960 600` standard, `0 0 960 800` for tall stacks

## Data Flow Diagram
- Label every arrow with the data type (e.g., "embeddings", "query", "context")
- Wider arrows (`stroke-width: 2.5`) for primary data paths
- Dashed arrows for control/trigger flows

## Flowchart / Process Flow
- Top-to-bottom preferred; left-to-right for wide flows
- Diamond shapes for decisions, rounded rects for processes, parallelograms for I/O
- Keep node labels ≤3 words; x positions snap to 120px intervals, y to 80px

## Agent Architecture Diagram
Key conceptual layers:
- **Input**: User, query, trigger
- **Agent core**: LLM, reasoning loop, planner
- **Memory**: Short-term (context window), Long-term (vector/graph DB), Episodic
- **Tool**: Tool calls, APIs, search, code execution
- **Output**: Response, action, side-effects
Use cyclic arrows to show iterative reasoning. Separate memory types visually.

## Memory Architecture Diagram (Mem0, MemGPT-style)
- Show memory **write path** and **read path** separately (different arrow colors)
- Memory tiers: Working → Short-term → Long-term → External Store
- Label memory operations: `store()`, `retrieve()`, `forget()`, `consolidate()`

## Sequence Diagram
- Participants as vertical **lifelines** (top labels + vertical dashed lines)
- Messages as horizontal arrows, top-to-bottom time order
- Activation boxes on lifeline show active processing
- ViewBox height = 80 + (num_messages × 50)

## Comparison / Feature Matrix
- Column headers = systems, row headers = attributes
- Row height: 40px; column width: min 120px; header row: 50px
- Checked cell: `#dcfce7` + `✓`; alternating row fills for readability
- Max 5 columns; split into two diagrams beyond that

## Timeline / Gantt
- X-axis = time; Y-axis = items/phases
- Bars: rounded rects, colored by category
- Milestone markers: diamond at x position
- ViewBox: `0 0 960 400` typical

## Mind Map / Concept Map
- Central node at `cx=480, cy=280`
- First-level branches: evenly distributed (360/N degrees)
- Use cubic bezier curves for branches

## Class Diagram (UML)
Static structure showing classes, attributes, methods, and relationships.
- **Class box**: 3-compartment rect (name / attributes / methods), min width 160px
  - Top compartment: class name, bold, centered (abstract = *italic*)
  - Middle: attributes with visibility (`+` public, `-` private, `#` protected)
  - Bottom: method signatures, same visibility notation
- **Relationships**:
  - Inheritance (extends): solid line + hollow triangle arrowhead, child → parent
  - Implementation (interface): dashed line + hollow triangle, class → interface
  - Association: solid line + open arrowhead, label with multiplicity (1, 0..*, 1..*)
  - Aggregation: solid line + hollow diamond on container side
  - Composition: solid line + filled diamond on container side
  - Dependency: dashed line + open arrowhead
- **Interface**: `<<interface>>` stereotype above name, or circle/lollipop notation
- **Enum**: compartment rect with `<<enumeration>>` stereotype, values in bottom
- Layout: parent classes top, children below; interfaces to the left/right of implementors
- ViewBox: `0 0 960 600` standard; `0 0 960 800` for deep hierarchies

## Use Case Diagram (UML)
System functionality from user perspective.
- **Actor**: stick figure (circle head + body line) placed outside system boundary
  - Label below figure, 13-14px
  - Primary actors on left, secondary/supporting on right
- **Use case**: ellipse with label centered inside, min 140×60px
  - Keep names verb phrases: "Create Order", "Process Payment"
- **System boundary**: large rect with dashed border + system name in top-left
- **Relationships**:
  - Include: dashed arrow `<<include>>` from base to included use case
  - Extend: dashed arrow `<<extend>>` from extension to base use case
  - Generalization: solid line + hollow triangle (specialized → general)
- Layout: system boundary centered, actors outside, use cases inside
- ViewBox: `0 0 960 600` standard

## State Machine Diagram (UML)
Lifecycle states and transitions of an entity.
- **State**: rounded rect with state name, min 120×50px
  - Internal activities: small text `entry/ action`, `exit/ action`, `do/ activity`
  - **Initial state**: filled black circle (r=8), one outgoing arrow
  - **Final state**: filled circle (r=8) inside hollow circle (r=12)
  - **Choice**: small hollow diamond, guard labels on outgoing arrows `[condition]`
- **Transition**: arrow with optional label `event [guard] / action`
  - Guard conditions in square brackets
  - Actions after `/`
- **Composite/nested state**: larger rect containing sub-states, with name tab
- **Fork/join**: thick horizontal or vertical black bar (synchronization)
- Layout: initial state top-left, final state bottom-right, flow top-to-bottom
- ViewBox: `0 0 960 600` standard

## ER Diagram (Entity-Relationship)
Database schema and data relationships.
- **Entity**: rect with entity name in header (bold), attributes below
  - Primary key attribute: underlined
  - Foreign key: italic or marked with (FK)
  - Min width: 160px; attribute font-size: 12px
- **Relationship**: diamond shape on connecting line
  - Label inside diamond: "has", "belongs to", "enrolls in"
  - Cardinality labels near entity: `1`, `N`, `0..1`, `0..*`, `1..*`
- **Weak entity**: double-bordered rect with double diamond relationship
- **Associative entity**: diamond + rect hybrid (rect with diamond inside)
- Line style: solid for identifying relationships, dashed for non-identifying
- Layout: entities in 2-3 rows, relationships between related entities
- ViewBox: `0 0 960 600` standard; wider `0 0 1200 600` for many entities

## Network Topology
Physical or logical network infrastructure.
- **Devices**: icon-like rects or rounded rects
  - Router: circle with cross arrows
  - Switch: rect with arrow grid
  - Server: stacked rect (rack icon)
  - Firewall: brick-pattern rect or shield shape
  - Load Balancer: horizontal split rect with arrows
  - Cloud: cloud path (overlapping arcs)
- **Connections**: lines between device centers
  - Ethernet/wired: solid line, label bandwidth
  - Wireless: dashed line with WiFi symbol
  - VPN: dashed line with lock icon
- **Subnets/Zones**: dashed rect containers with zone label (DMZ, Internal, External)
- **Labels**: device hostname + IP below, 12-13px
- Layout: tiered top-to-bottom (Internet → Edge → Core → Access → Endpoints)
- ViewBox: `0 0 960 600` standard

## UML Coverage Map

| UML Diagram | Supported As | Notes |
|-------------|-------------|-------|
| Class | Class Diagram | Full UML notation |
| Component | Architecture Diagram | Colored fills per component type |
| Deployment | Architecture Diagram | Add node/instance labels |
| Package | Architecture Diagram | Dashed grouping containers |
| Use Case | Use Case Diagram | Full actor/ellipse/relationship |
| Activity | Flowchart | Add fork/join bars |
| State Machine | State Machine Diagram | Full UML notation |
| Sequence | Sequence Diagram | Add alt/opt/loop frames |
| ER Diagram | ER Diagram | Chen/Crow's foot notation |
| Timing | Timeline | Adapt time axis |

## 动词路由指南

根据用户说的**动词/意图词**自动选择图表类型,而不仅是看主题名词:

| 用户说 | 应选类型 | 画什么 |
|--------|---------|-------|
| "XX怎么工作" / "解释XX" | 示意图 | 机制的直觉化表达 |
| "XX的架构" / "XX组件" | 架构图 | 模块包含关系 |
| "XX的步骤" / "XX流程" | 流程图 | 步骤序列 |
| "A和B之间的交互" / "XX协议" | 时序图 | 消息交换顺序 |
| "XX的继承关系" / "XX数据模型" | 类图 | 类型和关系 |

**关键判断**:
- "XX怎么工作" 默认选示意图,不选流程图(除非用户明确要步骤)
- 如果 prompt 中出现 ≥2 个独立参与者(User+Server、Client+Auth),优先选时序图
- 同一主题用不同动词会得到不同图表类型--这是正确的

## 复杂度管理

### 节点数量建议

| 图表类型 | 推荐数量 | 最大数量 | 超限处理 |
|---------|---------|---------|----------|
| 架构图 | 5-10 | 15 | 拆为高层 + 子系统详图 |
| 流程图步骤 | 3-10 | 15 | 合并相似步骤 |
| 时序图参与者 | 3-6 | 8 | 拆为多个交互场景 |
| 思维导图分支 | 4-6 | 8 | 分支内子项 2-4 个 |
| 类图 | 4-8 | 12 | 拆为模块级类图 |
| ER图实体 | 4-8 | 12 | 拆为子域 |

**超限时的标准回复模板:**
```
你的需求包含 N 个组件。为了可读性,建议:
1. 先出一张高层架构图(6 个主要模块)
2. 需要哪个模块的详图再单独画

要先从高层视图开始吗?
```

### 拆分策略

当节点数 > 推荐最大值时:
1. **层级拆分**:高层图只画模块边界,内部细节另出一张
2. **场景拆分**:时序图按用户操作场景拆(登录流、下单流、支付流)
3. **域拆分**:ER图按业务域拆(用户域、订单域、库存域)
