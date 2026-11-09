#!/usr/bin/env python3
"""Scrape product images for ByteBudget components using Python."""

import asyncio
import aiohttp
import re
import os
from pathlib import Path
from urllib.parse import quote_plus
from bs4 import BeautifulSoup

# Component data matching component_data_service.dart
COMPONENTS = [
    {
        "id": "kb_001",
        "name": "Apex Pro TKL",
        "brand": "SteelSeries",
        "category": "keyboard",
    },
    {
        "id": "kb_002",
        "name": "G915 TKL Lightspeed",
        "brand": "Logitech G",
        "category": "keyboard",
    },
    {
        "id": "mouse_001",
        "name": "DeathAdder V3 Pro",
        "brand": "Razer",
        "category": "mouse",
    },
    {
        "id": "mouse_002",
        "name": "GPW Superlight 2",
        "brand": "Logitech G",
        "category": "mouse",
    },
    {
        "id": "mon_001",
        "name": "PG27AQDM",
        "brand": "ASUS",
        "category": "monitor",
    },
    {
        "id": "mon_002",
        "name": "XG27ACS",
        "brand": "Acer",
        "category": "monitor",
    },
    {
        "id": "aud_001",
        "name": "HD 600",
        "brand": "Sennheiser",
        "category": "audio",
    },
    {
        "id": "aud_002",
        "name": "AT2020USB-X",
        "brand": "Audio-Technica",
        "category": "audio",
    },
    {
        "id": "cam_001",
        "name": "Facecam Pro",
        "brand": "Elgato",
        "category": "camera",
    },
    {
        "id": "cam_002",
        "name": "Yeti GX",
        "brand": "Blue",
        "category": "audio",
    },
]

RETAILER_URLS = {
    'SteelSeries': 'https://steelseries.com',
    'Logitech G': 'https://www.logitechg.com',
    'Razer': 'https://www.razer.com',
    'Corsair': 'https://www.corsair.com',
    'HyperX': 'https://www.hyperxgaming.com',
    'ASUS': 'https://rog.asus.com',
    'Acer': 'https://www.acer.com',
    'BenQ': 'https://www.benq.com',
    'LG': 'https://www.lg.com',
    'Samsung': 'https://www.samsung.com',
    'Sennheiser': 'https://www.sennheiser.com',
    'Audio-Technica': 'https://www.audio-technica.com',
    'Blue': 'https://www.bluemic.com',
    'Elgato': 'https://www.elgato.com',
}

USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
OUTPUT_DIR = Path("assets/images")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

async def search_duckduckgo(session, product_name, brand, category):
    """Search DuckDuckGo for product image."""
    query = quote_plus(f'{brand} {product_name} {category} product image')
    url = f'https://duckduckgo.com/html/?q={query}&kl=us-en'
    
    try:
        async with session.get(url, headers={'User-Agent': USER_AGENT}, timeout=10) as resp:
            if resp.status != 200:
                return None
            html = await resp.text()
            
        soup = BeautifulSoup(html, 'html.parser')
        # Find result images
        for img in soup.select('img.result__image__img'):
            src = img.get('data-src') or img.get('src')
            if src and src.startswith('http'):
                return src
        
        # Alternative selector
        for img in soup.select('img[src^="http"]'):
            src = img.get('src')
            if src and 'duckduckgo' not in src and 'icon' not in src and 'logo' not in src:
                return src
                
    except Exception as e:
        print(f"  DuckDuckGo error for {product_name}: {e}")
    return None

async def search_google_images(session, product_name, brand, category):
    """Search Google Images (HTML fallback)."""
    query = quote_plus(f'{brand} {product_name} {category} site:amazon.com OR site:newegg.com OR site:bestbuy.com')
    url = f'https://www.google.com/search?q={query}&tbm=isch'
    
    try:
        async with session.get(url, headers={
            'User-Agent': USER_AGENT,
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        }, timeout=10) as resp:
            if resp.status != 200:
                return None
            html = await resp.text()
            
        soup = BeautifulSoup(html, 'html.parser')
        scripts = soup.find_all('script')
        for script in scripts:
            text = script.string or ''
            if 'AF_initDataCallback' in text and '"ou"' in text:
                matches = re.findall(r'"ou":"([^"]+)"', text)
                for url in matches:
                    if url.startswith('http'):
                        return url
    except Exception as e:
        print(f"  Google error for {product_name}: {e}")
    return None

async def fetch_product_page_image(session, product_url):
    """Fetch product page and extract main image."""
    try:
        async with session.get(product_url, headers={'User-Agent': USER_AGENT}, timeout=10) as resp:
            if resp.status != 200:
                return None
            html = await resp.text()
            
        soup = BeautifulSoup(html, 'html.parser')
        
        # Try Open Graph image
        og = soup.select_one('meta[property="og:image"]')
        if og and og.get('content'):
            return og['content']
            
        # Try Twitter card
        twitter = soup.select_one('meta[name="twitter:image"]')
        if twitter and twitter.get('content'):
            return twitter['content']
            
        # Try common product image selectors
        selectors = [
            '.product-image img', '#product-image img', '.main-image img',
            '[data-testid="product-image"] img', '.product-gallery img',
            '.gallery-image img', 'img.product-image', 'img[id*="product"]', 'img[class*="product"]',
        ]
        for selector in selectors:
            img = soup.select_one(selector)
            if img and img.get('src') and img['src'].startswith('http'):
                return img['src']
                
        # Fallback: largest image
        all_images = soup.select('img[src^="http"]')
        best = None
        max_area = 0
        for img in all_images:
            src = img.get('src')
            if not src or 'icon' in src or 'logo' in src:
                continue
            w = int(img.get('width', 0) or 0)
            h = int(img.get('height', 0) or 0)
            if w * h > max_area:
                max_area = w * h
                best = src
        return best
    except Exception as e:
        print(f"  Product page error: {e}")
    return None

async def download_image(session, image_url, component_id):
    """Download and save image."""
    try:
        async with session.get(image_url, headers={'User-Agent': USER_AGENT}, timeout=15) as resp:
            if resp.status == 200:
                content = await resp.read()
                if content:
                    # Determine extension
                    content_type = resp.headers.get('content-type', '')
                    if 'jpeg' in content_type or 'jpg' in content_type:
                        ext = 'jpg'
                    elif 'png' in content_type:
                        ext = 'png'
                    elif 'webp' in content_type:
                        ext = 'webp'
                    else:
                        ext = 'jpg'
                    
                    file_path = OUTPUT_DIR / f"{component_id}.{ext}"
                    file_path.write_bytes(content)
                    return str(file_path)
    except Exception as e:
        print(f"  Download error for {component_id}: {e}")
    return None

async def scrape_component(session, component):
    """Scrape image for a single component."""
    print(f"Scraping: {component['name']} ({component['brand']})")
    
    image_url = None
    
    # Try retailer site first
    retailer = RETAILER_URLS.get(component['brand'])
    if retailer:
        search_url = f"{retailer}/search?q={quote_plus(component['name'])}"
        image_url = await fetch_product_page_image(session, search_url)
    
    # Fallback to DuckDuckGo
    if not image_url:
        image_url = await search_duckduckgo(session, component['name'], component['brand'], component['category'])
    
    # Fallback to Google
    if not image_url:
        image_url = await search_google_images(session, component['name'], component['brand'], component['category'])
    
    if image_url:
        print(f"  Found: {image_url[:80]}...")
        local_path = await download_image(session, image_url, component['id'])
        if local_path:
            print(f"  Saved: {local_path}")
            return local_path
    else:
        print(f"  No image found")
    return None

async def main():
    print(f"Starting image scraping for {len(COMPONENTS)} components...")
    print(f"Output directory: {OUTPUT_DIR.absolute()}")
    
    connector = aiohttp.TCPConnector(limit=5)
    timeout = aiohttp.ClientTimeout(total=30)
    
    async with aiohttp.ClientSession(connector=connector, timeout=timeout) as session:
        tasks = [scrape_component(session, c) for c in COMPONENTS]
        results = await asyncio.gather(*tasks)
        
        success = sum(1 for r in results if r)
        print(f"\nDone! {success}/{len(COMPONENTS)} images downloaded.")

if __name__ == "__main__":
    asyncio.run(main())