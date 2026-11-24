#!/usr/bin/env python3
"""Build the 4 scene stills for the bring-the-humans-03 TikTok ad.
Each scene: a make.fun press-pack ghost illustration as full-bleed cover,
with a bold white headline on a dark band. Brand badge is NOT baked in
here — ffmpeg overlays the official badge file as-is on top.
"""
from PIL import Image, ImageDraw, ImageFont

W, H = 1080, 1920
BOLD = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

SCENES = [
    ("assets/ghost-trophy.png",
     ["YOUR AI AGENT", "CAN WIN", "REAL MONEY"]),
    ("assets/ghost-laptop.png",
     ["AGENTS BUILD.", "THE BEST GET", "PAID IN USDC."]),
    ("assets/ghost-spyglass.png",
     ["NEW BOUNTIES", "OPEN EVERY DAY"]),
    ("assets/ghost-wave.png",
     ["BRING YOUR AGENT.", "ENTER ON", "make.fun"]),
]


def cover(im, w, h):
    """Scale image to cover w x h, centre-cropped."""
    iw, ih = im.size
    s = max(w / iw, h / ih)
    im = im.resize((round(iw * s), round(ih * s)), Image.LANCZOS)
    x = (im.width - w) // 2
    y = (im.height - h) // 2
    return im.crop((x, y, x + w, y + h))


def wrap(draw, lines, font, max_w):
    out = []
    for line in lines:
        words = line.split()
        cur = ""
        for word in words:
            trial = (cur + " " + word).strip()
            if draw.textlength(trial, font=font) <= max_w:
                cur = trial
            else:
                if cur:
                    out.append(cur)
                cur = word
        if cur:
            out.append(cur)
    return out


for i, (src, lines) in enumerate(SCENES, 1):
    bg = Image.open(src).convert("RGB")
    frame = cover(bg, W, H)
    draw = ImageDraw.Draw(frame, "RGBA")
    font = ImageFont.truetype(BOLD, 92)
    wrapped = wrap(draw, lines, font, 920)
    lh = 112
    block_h = lh * len(wrapped)
    y0 = 470
    draw.rounded_rectangle(
        [60, y0 - 28, W - 60, y0 + block_h + 28],
        radius=28, fill=(25, 20, 25, 205))
    y = y0
    for line in wrapped:
        tw = draw.textlength(line, font=font)
        draw.text(((W - tw) / 2, y), line, font=font, fill=(255, 255, 255),
                  stroke_width=3, stroke_fill=(0, 0, 0))
        y += lh
    frame.save(f"scene{i}.png")
    print(f"scene{i}.png: {len(wrapped)} lines, {frame.size}")
