# Shape Vocabulary & Arrow Semantics

## Shape Vocabulary

| Concept | Shape | Notes |
|---------|-------|-------|
| User / Human | Circle + body path | Stick figure or avatar |
| LLM / Model | Rounded rect with gradient fill | Use accent color |
| Agent / Orchestrator | Hexagon or double-border rounded rect | Signals "active controller" |
| Memory (short-term) | Rounded rect, dashed border | Ephemeral = dashed |
| Memory (long-term) | Cylinder | Persistent = solid cylinder |
| Vector Store | Cylinder with grid lines | Add 3 horizontal lines inside |
| Graph DB | Circle cluster (3 overlapping circles) | |
| Tool / Function | Gear-like rect or wrench icon rect | |
| API / Gateway | Hexagon (single border) | |
| Queue / Stream | Horizontal tube (pipe shape) | |
| File / Document | Folded-corner rect | |
| Browser / UI | Rect with 3-dot titlebar | |
| Decision | Diamond | Flowcharts only |
| External Service | Rect with cloud icon or dashed border | |
| Data / Artifact | Parallelogram | I/O in flowcharts |

## Arrow Semantics

Always assign arrow meaning, not just color. Include a **legend** when 2+ arrow types are used.

| Flow Type | Color | Stroke | Dash | Meaning |
|-----------|-------|--------|------|---------|
| Primary data flow | blue `#2563eb` | 2px solid | - | Main request/response path |
| Control / trigger | orange `#ea580c` | 1.5px solid | - | One system triggering another |
| Memory read | green `#059669` | 1.5px solid | - | Retrieval from store |
| Memory write | green `#059669` | 1.5px | `5,3` | Write/store operation |
| Async / event | gray `#6b7280` | 1.5px | `4,2` | Non-blocking, event-driven |
| Embedding / transform | purple `#7c3aed` | 1px solid | - | Data transformation |
| Feedback / loop | purple `#7c3aed` | 1.5px curved | - | Iterative reasoning loop |

## AI/Agent Domain Patterns

Common patterns - internalize these for fast diagram generation:

**RAG Pipeline**: Query → Embed → VectorSearch → Retrieve → Augment → LLM → Response

**Agentic RAG**: adds Agent loop with Tool use between Query and LLM

**Agentic Search**: Query → Planner → [Search Tool / Calculator / Code] → Synthesizer → Response

**Mem0 / Memory Layer**: Input → Memory Manager → [Write: VectorDB + GraphDB] / [Read: Retrieve+Rank] → Context

**Agent Memory Types**: Sensory (raw input) → Working (context window) → Episodic (past interactions) → Semantic (facts) → Procedural (skills)

**Multi-Agent**: Orchestrator → [SubAgent A / SubAgent B / SubAgent C] → Aggregator → Output

**Tool Call Flow**: LLM → Tool Selector → Tool Execution → Result Parser → LLM (loop)

SVG templates for these patterns are in `templates/`. Load the matching `.svg` file as a starting point.

**参考样本**: `templates/agentloop-core.svg` 是一个完整的 Agent Loop 架构图示例（101 行 SVG），展示了语义箭头（蓝=数据流、绿=记忆读写、橙=工具调用、紫=反馈循环）、形状词汇（圆=用户、双边框矩形=Agent Loop、虚线矩形=短期记忆、椭圆=长期存储）、箭头标签背景色、和图例的标准用法。生成 AI/Agent 领域图时可作为参考。
