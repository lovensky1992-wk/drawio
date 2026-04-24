#!/usr/bin/env python3
"""
Generate diagram showcase images using Gemini Image Generation API.
Renders diagrams on professional backgrounds with micro-typography.

Usage:
    python3 generate_showcase.py <diagram.png> --style editorial --title "My Diagram"
    python3 generate_showcase.py <diagram.png> --all --title "Architecture"
"""

import os
import sys
import json
import base64
import argparse
import urllib.request
import urllib.error
from pathlib import Path

# 6 background styles optimized for diagram showcase
BACKGROUND_STYLES = {
    "void": {
        "name": "THE VOID (绝对虚空)",
        "scene": "tech / infrastructure",
        "prompt": """THE VOID — absolute black (#000000) background with extremely fine silver/white
high-contrast micro noise. Cold, sharp electronic film grain texture.
Minimal atmosphere light — only a faint, icy white or blue glow at the extreme corner,
like distant starlight at the edge of the universe.
The diagram should appear as a luminous, high-contrast element floating in infinite dark space,
with subtle outer glow emphasizing its edges against the void."""
    },
    "frosted": {
        "name": "FROSTED HORIZON (磨砂穹顶)",
        "scene": "premium product / design-focused",
        "prompt": """FROSTED HORIZON — deep titanium gray or midnight slate gray base, not pure black.
Organic film-like dust noise texture, resembling unpolished rough metal or stone surface.
Large area but extremely low saturation cold-toned light halo (low-saturation gray-blue),
edges completely dissolved like mist.
The diagram should be rendered with refined clarity on this textured surface,
as if printed on a brushed titanium panel with soft ambient lighting from above."""
    },
    "editorial": {
        "name": "EDITORIAL PAPER (纸本编辑)",
        "scene": "professional / human-centered",
        "prompt": """EDITORIAL PAPER — off-white, alabaster, or pearl white base (not pure white).
High-grade watercolor or rough art paper texture suggesting physical paper tactile quality.
Natural light diffuse reflection with slight warm gray vignette in corners.
The diagram should appear as if carefully printed on premium art paper,
with the paper texture subtly visible through lighter areas of the diagram.
Humanistic, independent magazine aesthetic."""
    },
    "clinical": {
        "name": "CLINICAL STUDIO (无菌影棚)",
        "scene": "data-centric / algorithm-driven",
        "prompt": """CLINICAL STUDIO — pure white or extremely light cold gray base.
High-frequency sharp cold-toned digital micro noise with enhanced sharpness.
Pure light/shadow structure — large softbox from top/side creating smooth gray-white gradient.
The diagram should be rendered with surgical precision,
floating in sterile space with geometric shadow beneath creating 3D depth in 2D presentation.
Clean, confident, precise."""
    },
    "ui_container": {
        "name": "UI CONTAINER (容器化界面)",
        "scene": "SaaS / digital product",
        "prompt": """UI CONTAINER — clean gradient or solid color background with minimal digital noise.
Frosted glass container effect (like app window or dashboard card) with rounded corners
and subtle transparency. Micro-shadows creating depth illusion.
The diagram sits inside a frosted glass panel with modern interface design language,
suggesting it's a live widget in a dashboard. Rounded corners, subtle border,
backdrop blur effect on the container edges."""
    },
    "swiss_flat": {
        "name": "SWISS FLAT (瑞士扁平)",
        "scene": "classic / institutional",
        "prompt": """SWISS FLAT — 100% pure solid color background — deep vintage green, rich burgundy,
or classic navy. Absolutely no gradients, no noise, no effects.
Pure graphic design with zero tricks. Just perfect color and form.
The diagram should be rendered in high contrast against the solid background,
with extreme confidence and timeless authority. Classic Swiss International Style
with absolute flatness."""
    }
}

# Dark backgrounds use white diagram rendering, light use black
DARK_STYLES = {"void", "frosted"}
LIGHT_STYLES = {"editorial", "clinical", "ui_container", "swiss_flat"}


def build_prompt(style: str, title: str, description: str) -> str:
    """Build the full prompt for a given style."""
    info = BACKGROUND_STYLES[style]
    is_dark = style in DARK_STYLES
    diagram_render = "bright, high-contrast white and light colors" if is_dark else "dark, high-contrast colors"

    return f"""Render the provided technical diagram onto a professional showcase background.
Keep the diagram content exactly as provided — do not modify, simplify, or redraw it.
Place it prominently in the center with generous breathing space.

The diagram should be rendered in {diagram_render} to ensure readability against the background.

BACKGROUND CONSTRUCTION:
{info['prompt']}

TYPOGRAPHY AND LAYOUT (Swiss-style micro-typography):
- Main subject: Place the diagram at the absolute visual center, occupying ~60% of the frame
- Micro-typography in extremely small font (6pt-9pt), clean sans-serif (Inter, Helvetica):
  Top-left corner: {title.upper()}
  Top-right corner: DIAGRAM SHOWCASE // 2026
  Bottom-center: {description.upper() if description else 'TECHNICAL DIAGRAM SYSTEM'}
- All text in low opacity, never competing with the diagram

OUTPUT: 16:9 aspect ratio, 2K resolution, professional showcase quality.

CRITICAL: Preserve the diagram exactly as provided. This is a showcase rendering, not a redraw."""


def generate_showcase(diagram_path: str, style: str, output_path: str,
                      title: str, description: str,
                      api_key: str, api_base: str, model: str) -> bool:
    """Generate a single showcase image via Gemini Chat Completions API (idealab-compatible)."""
    if style not in BACKGROUND_STYLES:
        print(f"Error: unknown style '{style}'. Available: {list(BACKGROUND_STYLES.keys())}", file=sys.stderr)
        return False

    # Load diagram image
    try:
        with open(diagram_path, 'rb') as f:
            img_b64 = base64.b64encode(f.read()).decode()
    except Exception as e:
        print(f"Error loading diagram: {e}", file=sys.stderr)
        return False

    prompt = build_prompt(style, title, description)

    # Build Chat Completions request body with image input
    messages = [{
        "role": "user",
        "content": [
            {
                "type": "image_url",
                "image_url": {"url": f"data:image/png;base64,{img_b64}"}
            },
            {
                "type": "text",
                "text": prompt
            }
        ]
    }]

    req_body = json.dumps({
        "model": model,
        "messages": messages,
        "max_tokens": 4096
    }).encode()

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }

    print(f"[{style}] Generating showcase...", file=sys.stderr)

    try:
        req = urllib.request.Request(api_base, data=req_body, headers=headers)
        resp = json.loads(urllib.request.urlopen(req, timeout=180).read())

        choices = resp.get("choices", [])
        if not choices:
            print(f"[{style}] No choices in response", file=sys.stderr)
            return False

        content = choices[0].get("message", {}).get("content", "")

        # Extract base64 image from response (array or string format)
        img_data = None
        if isinstance(content, list):
            for item in content:
                b64 = (item.get("image_url") or {}).get("url") or item.get("b64_json")
                if b64:
                    b64 = b64.split("base64,")[-1] if "base64," in b64 else b64
                    img_data = base64.b64decode(b64)
                    break
        elif isinstance(content, str):
            import re
            m = re.search(r"data:image/[^;]+;base64,([A-Za-z0-9+/=]+)", content)
            if m:
                img_data = base64.b64decode(m.group(1))

        if img_data:
            Path(output_path).parent.mkdir(parents=True, exist_ok=True)
            with open(output_path, "wb") as f:
                f.write(img_data)
            print(f"[{style}] Saved: {output_path} ({len(img_data)} bytes)", file=sys.stderr)
            return True

        print(f"[{style}] No image data in response", file=sys.stderr)
        return False

    except urllib.error.HTTPError as e:
        body = e.read().decode()[:300]
        print(f"[{style}] HTTP {e.code}: {body}", file=sys.stderr)
        return False
    except Exception as e:
        print(f"[{style}] Error: {e}", file=sys.stderr)
        return False


def main():
    parser = argparse.ArgumentParser(description="Generate diagram showcase images")
    parser.add_argument("diagram", help="Path to diagram PNG")
    parser.add_argument("--style", choices=list(BACKGROUND_STYLES.keys()),
                        default="editorial", help="Background style (default: editorial)")
    parser.add_argument("--all", action="store_true", help="Generate all 6 styles")
    parser.add_argument("--title", "-t", default="Diagram", help="Diagram title")
    parser.add_argument("--description", "-d", default="", help="Diagram description")
    parser.add_argument("--output-dir", "-o", default="output", help="Output directory")
    parser.add_argument("--api-key", default=None, help="API key (or env IDEALAB_API_KEY)")
    parser.add_argument("--api-base", default=None, help="API base URL")
    parser.add_argument("--model", default="gemini-3.1-flash-image-preview", help="Model name")

    args = parser.parse_args()

    if not Path(args.diagram).exists():
        print(f"Error: diagram file not found: {args.diagram}", file=sys.stderr)
        sys.exit(1)

    api_key = args.api_key or os.getenv("IDEALAB_API_KEY", "")
    api_base = args.api_base or os.getenv("IDEALAB_API_BASE",
                "https://idealab.alibaba-inc.com/api/openai/v1/chat/completions")

    if not api_key:
        print("Error: no API key. Set IDEALAB_API_KEY or pass --api-key", file=sys.stderr)
        sys.exit(1)

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    stem = Path(args.diagram).stem

    if args.all:
        ok = 0
        for s in BACKGROUND_STYLES:
            out = output_dir / f"{stem}_{s}.png"
            if generate_showcase(args.diagram, s, str(out), args.title, args.description,
                                 api_key, api_base, args.model):
                ok += 1
        print(f"\nGenerated {ok}/{len(BACKGROUND_STYLES)} showcase images", file=sys.stderr)
        sys.exit(0 if ok > 0 else 1)
    else:
        out = output_dir / f"{stem}_{args.style}.png"
        ok = generate_showcase(args.diagram, args.style, str(out), args.title, args.description,
                               api_key, api_base, args.model)
        sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
