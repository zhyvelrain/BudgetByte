#!/usr/bin/env python3
"""Generate professional gradient placeholder images for ByteBudget components."""

from PIL import Image, ImageDraw, ImageFont
import os

# Component data
COMPONENTS = [
    {"id": "kb_001", "name": "Apex Pro TKL", "brand": "SteelSeries", "category": "keyboard", "color": (58, 143, 214)},
    {"id": "kb_002", "name": "G915 TKL", "brand": "Logitech G", "category": "keyboard", "color": (90, 159, 232)},
    {"id": "mouse_001", "name": "DeathAdder V3 Pro", "brand": "Razer", "category": "mouse", "color": (0, 212, 0)},
    {"id": "mouse_002", "name": "GPW Superlight 2", "brand": "Logitech G", "category": "mouse", "color": (90, 159, 232)},
    {"id": "mon_001", "name": "PG27AQDM", "brand": "ASUS", "category": "monitor", "color": (42, 169, 161)},
    {"id": "mon_002", "name": "XG27ACS", "brand": "Acer", "category": "monitor", "color": (42, 169, 161)},
    {"id": "aud_001", "name": "HD 600", "brand": "Sennheiser", "category": "audio", "color": (74, 163, 214)},
    {"id": "aud_002", "name": "AT2020USB-X", "brand": "Audio-Technica", "category": "audio", "color": (74, 163, 214)},
    {"id": "cam_001", "name": "Facecam Pro", "brand": "Elgato", "category": "camera", "color": (58, 127, 214)},
    {"id": "cam_002", "name": "Yeti GX", "brand": "Blue", "category": "audio", "color": (74, 163, 214)},
]

OUTPUT_DIR = "assets/images"
os.makedirs(OUTPUT_DIR, exist_ok=True)

CATEGORY_ICONS = {
    "keyboard": "⌨",
    "mouse": "🖱",
    "monitor": "🖥",
    "audio": "🎧",
    "camera": "📷",
}

def create_gradient_image(component, size=(400, 400)):
    """Create a professional gradient placeholder image."""
    img = Image.new('RGB', size, (255, 255, 255))
    draw = ImageDraw.Draw(img)
    
    # Base color
    r, g, b = component["color"]
    
    # Create gradient background (diagonal)
    for y in range(size[1]):
        for x in range(size[0]):
            # Diagonal gradient
            factor = (x + y) / (size[0] + size[1])
            # Light to slightly darker
            nr = int(240 + (r - 240) * factor * 0.3)
            ng = int(245 + (g - 245) * factor * 0.3)
            nb = int(250 + (b - 250) * factor * 0.3)
            draw.point((x, y), fill=(nr, ng, nb))
    
    # Add subtle pattern overlay (diagonal lines)
    for i in range(-size[0], size[0] * 2, 40):
        draw.line([(i, 0), (i + size[1], size[1])], 
                 fill=(r, g, b, 30), width=1)
    
    # Add category icon area (circle)
    center_x, center_y = size[0] // 2, size[1] // 2 - 30
    radius = 80
    
    # Gradient circle background
    for rad in range(radius, 0, -1):
        alpha = int(255 * (1 - rad / radius) * 0.15)
        color = (r, g, b)
        draw.ellipse([center_x - rad, center_y - rad, center_x + rad, center_y + rad],
                    outline=color + (alpha,))
    
    # Solid circle with gradient
    for rad in range(radius, 0, -1):
        factor = rad / radius
        nr = int(255 - (255 - r) * factor)
        ng = int(255 - (255 - g) * factor)
        nb = int(255 - (255 - b) * factor)
        draw.ellipse([center_x - rad, center_y - rad, center_x + rad, center_y + rad],
                    fill=(nr, ng, nb))
    
    # Add category icon text (using emoji as fallback since we don't have font)
    icon = CATEGORY_ICONS.get(component["category"], "📦")
    
    # Try to use a default font
    try:
        font_large = ImageFont.truetype("arial.ttf", 48)
        font_medium = ImageFont.truetype("arial.ttf", 24)
        font_small = ImageFont.truetype("arial.ttf", 18)
    except:
        font_large = ImageFont.load_default()
        font_medium = ImageFont.load_default()
        font_small = ImageFont.load_default()
    
    # Draw category icon (as text)
    draw.text((center_x, center_y - 10), icon, fill=(255, 255, 255), 
              font=font_large, anchor="mm")
    
    # Brand name
    draw.text((center_x, center_y + radius + 20), component["brand"].upper(), 
              fill=(r, g, b), font=font_medium, anchor="mm")
    
    # Product name
    draw.text((center_x, center_y + radius + 55), component["name"], 
              fill=(45, 45, 45), font=font_small, anchor="mm")
    
    # Subtle bottom accent bar
    draw.rectangle([0, size[1] - 4, size[0], size[1]], 
                  fill=(r, g, b))
    
    return img

def main():
    print(f"Generating {len(COMPONENTS)} professional gradient images...")
    for comp in COMPONENTS:
        img = create_gradient_image(comp)
        path = os.path.join(OUTPUT_DIR, f"{comp['id']}.jpg")
        img.save(path, "JPEG", quality=90)
        print(f"  Created: {path}")
    print("Done!")

if __name__ == "__main__":
    main()