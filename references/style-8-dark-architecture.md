# Style 8: Dark Architecture

Professional dark-themed architecture diagrams inspired by Cocoon-AI. Semantic color coding per component type, JetBrains Mono font, subtle grid background. Best for system architecture, infrastructure diagrams, and tech blog hero images.

## Colors

```
Background:     #020617  (slate-950)
Grid pattern:   #1e293b  (slate-800), 40px interval, 0.5px stroke
Panel fill:     #0f172a  (slate-900) — opaque background for masking arrows
Panel stroke:   per component type (see Semantic Component Colors)
Box radius:     6px

Text primary:   #ffffff
Text secondary: #94a3b8  (slate-400)
Text muted:     #64748b  (slate-500)
Text tiny:      #475569  (slate-600)
```

### Semantic Component Colors (CRITICAL — color encodes function, not position)

| Component Type | Fill (rgba) | Stroke | Use For |
|---------------|-------------|--------|---------|
| Frontend / Client | `rgba(8, 51, 68, 0.4)` | `#22d3ee` (cyan-400) | Web apps, mobile clients, edge devices, CDN |
| Backend / API | `rgba(6, 78, 59, 0.4)` | `#34d399` (emerald-400) | Servers, APIs, microservices, Lambda |
| Database / Storage / AI/ML | `rgba(76, 29, 149, 0.4)` | `#a78bfa` (violet-400) | Databases, vector stores, ML models, S3 |
| Cloud / Infrastructure | `rgba(120, 53, 15, 0.3)` | `#fbbf24` (amber-400) | AWS, GCP, Azure services, Kubernetes |
| Security / Auth | `rgba(136, 19, 55, 0.4)` | `#fb7185` (rose-400) | Auth, encryption, security groups, firewalls |
| Message Bus / Event | `rgba(251, 146, 60, 0.3)` | `#fb923c` (orange-400) | Kafka, RabbitMQ, event buses, queues |
| External / Generic | `rgba(30, 41, 59, 0.5)` | `#94a3b8` (slate-400) | External systems, third-party, generic |

### Opaque Background Masking (CRITICAL for arrow z-order)

Since component boxes use semi-transparent fills, arrows drawn behind them will show through. To mask arrows cleanly:

```xml
<!-- Step 1: Opaque background rect (same position, masks arrows) -->
<rect x="X" y="Y" width="W" height="H" rx="6" fill="#0f172a"/>
<!-- Step 2: Styled component on top (transparent fill + colored stroke) -->
<rect x="X" y="Y" width="W" height="H" rx="6" fill="rgba(76, 29, 149, 0.4)" stroke="#a78bfa" stroke-width="1.5"/>
```

Always draw in this order: background → grid → arrows → opaque masks → component boxes → labels → legend

## Typography

```
font-family: 'JetBrains Mono', 'SF Mono', 'Fira Code', 'Cascadia Code', monospace
font-size:   12px component names, 9px sublabels, 8px annotations, 7px tiny labels
font-weight: 400 normal, 600 semi-bold for component names, 700 bold for titles
```

Embed via `<style>` (no `@import` — rsvg-convert incompatible):
```xml
<style>
  text { font-family: 'JetBrains Mono', 'SF Mono', 'Fira Code', monospace; fill: #ffffff; }
  .sublabel { fill: #94a3b8; font-size: 9px; }
  .annotation { fill: #64748b; font-size: 8px; }
</style>
```

## Background

```xml
<defs>
  <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
    <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#1e293b" stroke-width="0.5"/>
  </pattern>
</defs>
<rect width="960" height="600" fill="#020617"/>
<rect width="960" height="600" fill="url(#grid)"/>
```

## Component Box Pattern

```xml
<!-- Opaque mask -->
<rect x="X" y="Y" width="W" height="H" rx="6" fill="#0f172a"/>
<!-- Styled box -->
<rect x="X" y="Y" width="W" height="H" rx="6" fill="FILL_RGBA" stroke="STROKE_COLOR" stroke-width="1.5"/>
<!-- Component name -->
<text x="CENTER_X" y="Y+22" fill="white" font-size="12" font-weight="600" text-anchor="middle">Component Name</text>
<!-- Sublabel -->
<text x="CENTER_X" y="Y+38" fill="#94a3b8" font-size="9" text-anchor="middle">Node.js / Python</text>
```

Standard component sizes:
- **Small**: 120×50 (simple service)
- **Standard**: 160×60 (typical service/component)
- **Large**: 200×80 (complex component with sublabel)
- **Extra-wide**: 280×60 (load balancers, gateways)

## Grouping Containers

### Security Group
```xml
<rect x="X" y="Y" width="W" height="H" rx="8"
      fill="none" stroke="#fb7185" stroke-width="1" stroke-dasharray="4,4"/>
<text x="X+8" y="Y+14" fill="#fb7185" font-size="8" font-weight="600">🔒 Security Group</text>
```

### Region / Cloud Boundary
```xml
<rect x="X" y="Y" width="W" height="H" rx="12"
      fill="none" stroke="#fbbf24" stroke-width="1" stroke-dasharray="8,4"/>
<text x="X+12" y="Y+16" fill="#fbbf24" font-size="9" font-weight="600">AWS us-east-1</text>
```

### Cluster Boundary
```xml
<rect x="X" y="Y" width="W" height="H" rx="8"
      fill="rgba(30, 41, 59, 0.15)" stroke="#64748b" stroke-width="1" stroke-dasharray="6,3"/>
<text x="X+8" y="Y+14" fill="#64748b" font-size="8" font-weight="600">Kubernetes Cluster</text>
```

## Message Bus / Event Bus (inline connector)

```xml
<rect x="X" y="Y" width="120" height="20" rx="4"
      fill="rgba(251, 146, 60, 0.3)" stroke="#fb923c" stroke-width="1"/>
<text x="CENTER_X" y="Y+14" fill="#fb923c" font-size="7" text-anchor="middle" font-weight="600">Kafka / RabbitMQ</text>
```

Place in the gap between vertically stacked components (see Spacing Rules).

## Arrows

```xml
<defs>
  <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
    <polygon points="0 0, 10 3.5, 0 7" fill="#64748b"/>
  </marker>
  <marker id="arrowhead-cyan" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
    <polygon points="0 0, 10 3.5, 0 7" fill="#22d3ee"/>
  </marker>
  <marker id="arrowhead-rose" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
    <polygon points="0 0, 10 3.5, 0 7" fill="#fb7185"/>
  </marker>
</defs>

<!-- Standard connection -->
<path d="M x1,y1 L x2,y2" stroke="#64748b" stroke-width="1.5" fill="none" marker-end="url(#arrowhead)"/>

<!-- Auth/security flow (dashed, rose) -->
<path d="M x1,y1 L x2,y2" stroke="#fb7185" stroke-width="1" stroke-dasharray="4,3" fill="none" marker-end="url(#arrowhead-rose)"/>
```

## Header Pattern

```xml
<!-- Title bar with pulsing status indicator -->
<text x="40" y="36" fill="white" font-size="18" font-weight="700">System Architecture</text>
<circle cx="24" cy="32" r="4" fill="#34d399">
  <!-- Optional: animate for presentations -->
</circle>
<text x="40" y="52" fill="#94a3b8" font-size="10">Production Environment • v2.1</text>
```

## Summary Cards (below diagram, optional)

Three info cards at the bottom for key details:

```xml
<!-- Card container -->
<rect x="X" y="Y" width="280" height="120" rx="8" fill="#0f172a" stroke="#1e293b" stroke-width="1"/>
<!-- Card header -->
<circle cx="X+16" cy="Y+16" r="4" fill="#22d3ee"/>
<text x="X+28" y="Y+20" fill="white" font-size="11" font-weight="600">Infrastructure</text>
<!-- Card items -->
<text x="X+16" y="Y+40" fill="#94a3b8" font-size="9">• 3 availability zones</text>
<text x="X+16" y="Y+56" fill="#94a3b8" font-size="9">• Auto-scaling 2-10 instances</text>
```

## Legend Placement (CRITICAL)

Place legend OUTSIDE all boundary boxes:
1. Calculate where all boundaries end (lowest y + height)
2. Place legend at least 20px below the lowest boundary
3. Expand SVG viewBox height to accommodate

```
Boundary ends at y=490 → Legend starts at y=510
SVG viewBox height: at least 560
```

## SVG Template

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 700" width="960" height="700">
  <style>
    text { font-family: 'JetBrains Mono', 'SF Mono', 'Fira Code', monospace; fill: #ffffff; }
    .sublabel { fill: #94a3b8; font-size: 9px; }
  </style>
  <defs>
    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#1e293b" stroke-width="0.5"/>
    </pattern>
    <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#64748b"/>
    </marker>
  </defs>
  <!-- Background + grid -->
  <rect width="960" height="700" fill="#020617"/>
  <rect width="960" height="700" fill="url(#grid)"/>
  <!-- Title -->
  <!-- Arrows (drawn first, behind components) -->
  <!-- Opaque masks + Component boxes -->
  <!-- Labels -->
  <!-- Summary cards (optional) -->
  <!-- Legend -->
</svg>
```
