"""Generate a simple pixel-art tileset for the Pokemon-like game."""
from PIL import Image, ImageDraw
import os

TILE_SIZE = 32
TILES_PER_ROW = 12

# Tile definitions: (name, draw_function_key)
TILES = [
    "grass",       # 0 - walkable
    "tall_grass",  # 1 - walkable, wild encounters
    "dirt_path",   # 2 - walkable
    "water",       # 3 - blocked
    "sand",        # 4 - walkable
    "tree_trunk",  # 5 - blocked
    "tree_top",    # 6 - blocked
    "house_wall",  # 7 - blocked
    "house_roof",  # 8 - blocked
    "door",        # 9 - walkable/interactive
    "fence_h",     # 10 - blocked
    "fence_v",     # 11 - blocked
]

img = Image.new("RGBA", (TILE_SIZE * TILES_PER_ROW, TILE_SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)


def noise(base_color, amount=30):
    """Add slight random variation to a color."""
    import random
    r = max(0, min(255, base_color[0] + random.randint(-amount, amount)))
    g = max(0, min(255, base_color[1] + random.randint(-amount, amount)))
    b = max(0, min(255, base_color[2] + random.randint(-amount, amount)))
    return (r, g, b)


def draw_grass(x, y):
    base = (100, 180, 80)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            c = noise(base, 20)
            draw.point((x + px, y + py), fill=c)


def draw_tall_grass(x, y):
    base = (60, 140, 40)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            c = noise(base, 15)
            draw.point((x + px, y + py), fill=c)
    import random
    # Add grass blade details
    for _ in range(25):
        bx = x + random.randint(2, 29)
        by = y + random.randint(2, 29)
        shade = min(255, base[0] + random.randint(30, 80))
        draw.point((bx, by), fill=(shade, min(255, base[1] + 40), base[2]))


def draw_dirt_path(x, y):
    base = (180, 150, 110)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            c = noise(base, 15)
            draw.point((x + px, y + py), fill=c)
    import random
    # Small pebble details
    for _ in range(10):
        px = x + random.randint(2, 29)
        py = y + random.randint(2, 29)
        shade = base[0] - random.randint(20, 40)
        draw.point((px, py), fill=(shade, shade - 30, shade - 60))


def draw_water(x, y):
    base = (40, 100, 200)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            c = noise(base, 15)
            draw.point((x + px, y + py), fill=c)
    import random
    # Wave highlights
    for row in range(0, TILE_SIZE, 4):
        offset = random.randint(-2, 2)
        for px in range(TILE_SIZE):
            wx = x + ((px + offset) % TILE_SIZE)
            wy = y + row
            highlight = (min(255, base[0] + 60), min(255, base[1] + 60), min(255, base[2] + 40))
            draw.point((wx, wy), fill=highlight)


def draw_sand(x, y):
    base = (220, 210, 150)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            c = noise(base, 15)
            draw.point((x + px, y + py), fill=c)


def draw_tree_trunk(x, y):
    base = (120, 80, 40)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            c = noise(base, 20)
            draw.point((x + px, y + py), fill=c)


def draw_tree_top(x, y):
    base = (30, 130, 40)
    cx, cy = TILE_SIZE // 2, TILE_SIZE // 2
    radius = TILE_SIZE // 2 - 2
    import random
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            dist = ((px - cx) ** 2 + (py - cy) ** 2) ** 0.5
            if dist <= radius + 2:
                c = noise(base, 25)
                draw.point((x + px, y + py), fill=c)
            else:
                draw.point((x + px, y + py), fill=(0, 0, 0, 0))
    # Highlight spots
    for _ in range(20):
        hx = x + random.randint(4, 27)
        hy = y + random.randint(4, 27)
        if ((hx - x - cx) ** 2 + (hy - y - cy) ** 2) ** 0.5 <= radius:
            draw.point((hx, hy), fill=(min(255, base[0] + 60), min(255, base[1] + 60), base[2]))


def draw_house_wall(x, y):
    base = (200, 190, 170)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            c = noise(base, 8)
            draw.point((x + px, y + py), fill=c)
    import random
    # Brick lines
    for row in range(0, TILE_SIZE, 8):
        for px in range(TILE_SIZE):
            draw.point((x + px, y + row), fill=(160, 150, 130))
    for col in range(0, TILE_SIZE, 16):
        for py in range(0, TILE_SIZE, 8):
            offset = 8 if (col // 16) % 2 == 0 else 0
            for dy in range(4):
                yy = y + py + offset + dy
                if yy < y + TILE_SIZE:
                    draw.point((x + col, yy), fill=(160, 150, 130))


def draw_house_roof(x, y):
    base = (200, 80, 30)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            c = noise(base, 15)
            draw.point((x + px, y + py), fill=c)
    import random
    # Roof tile lines
    for row in range(0, TILE_SIZE, 4):
        line_color = (160, 60, 20)
        for px in range(TILE_SIZE):
            draw.point((x + px, y + row), fill=line_color)


def draw_door(x, y):
    base = (100, 70, 30)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            c = noise(base, 10)
            draw.point((x + px, y + py), fill=c)
    # Door frame
    for px in range(TILE_SIZE):
        draw.point((x + px, y), fill=(60, 40, 15))
        draw.point((x + px, y + TILE_SIZE - 1), fill=(60, 40, 15))
    for py in range(TILE_SIZE):
        draw.point((x, y + py), fill=(60, 40, 15))
        draw.point((x + TILE_SIZE - 1, y + py), fill=(60, 40, 15))
    import random
    # Door knob
    draw.point((x + TILE_SIZE - 5, y + TILE_SIZE // 2), fill=(220, 200, 50))


def draw_fence_h(x, y):
    base = (160, 130, 80)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            # Horizontal fence pattern
            if 10 <= py <= 12 or 20 <= py <= 22:
                c = noise((140, 110, 60), 10)
            elif 6 <= py <= 26:
                c = noise(base, 12)
            else:
                c = noise((100, 180, 80), 20)  # grass below
            draw.point((x + px, y + py), fill=c)
    # Posts
    for col in [3, 16, 28]:
        for py in range(4, 28):
            draw.point((x + col, y + py), fill=(120, 90, 50))


def draw_fence_v(x, y):
    base = (160, 130, 80)
    for py in range(TILE_SIZE):
        for px in range(TILE_SIZE):
            # Vertical fence pattern
            if 10 <= px <= 12 or 20 <= px <= 22:
                c = noise((140, 110, 60), 10)
            elif 6 <= px <= 26:
                c = noise(base, 12)
            else:
                c = noise((100, 180, 80), 20)  # grass below
            draw.point((x + px, y + py), fill=c)
    # Posts
    for row in [3, 16, 28]:
        for px in range(4, 28):
            draw.point((x + px, y + row), fill=(120, 90, 50))


draw_fns = {
    "grass": draw_grass,
    "tall_grass": draw_tall_grass,
    "dirt_path": draw_dirt_path,
    "water": draw_water,
    "sand": draw_sand,
    "tree_trunk": draw_tree_trunk,
    "tree_top": draw_tree_top,
    "house_wall": draw_house_wall,
    "house_roof": draw_house_roof,
    "door": draw_door,
    "fence_h": draw_fence_h,
    "fence_v": draw_fence_v,
}

for i, tile_name in enumerate(TILES):
    x = i * TILE_SIZE
    y = 0
    draw_fns[tile_name](x, y)
    print(f"  Drew tile {i}: {tile_name}")

# Save
out_path = os.path.join(os.path.dirname(__file__), "..", "assets", "tiles", "tileset.png")
img.save(out_path)
print(f"\nTileset saved to: {out_path}")
print(f"Size: {img.size}")
