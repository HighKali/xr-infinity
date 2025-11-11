#!/usr/bin/env python3
import qrcode
from PIL import Image, ImageDraw

# Link alla dashboard
url = "http://127.0.0.1:8080/"

# Genera QR base
qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_H,
    box_size=10,
    border=4,
)
qr.add_data(url)
qr.make(fit=True)

# Crea immagine QR
img = qr.make_image(fill_color="#00FFAA", back_color="black").convert("RGB")

# Aggiunge bordo verde
border = Image.new("RGB", (img.size[0]+20, img.size[1]+20), "black")
border.paste(img, (10, 10))

# Salva
border.save("eco_qr.png")
print("✅ eco_qr.png generato con link:", url)
