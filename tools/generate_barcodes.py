
import os
from barcode import EAN13, Code128
from barcode.writer import ImageWriter
import qrcode
from PIL import Image, ImageDraw, ImageFont

# 出力ディレクトリ
OUTPUT_DIR = r"docs\verification_images"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------
def create_canvas(width=600, height=400):
    return Image.new('RGB', (width, height), 'white')

def generate_jan_img(code: str):
    """JANコード画像を生成してImageオブジェクトとして返す(正規)"""
    writer = ImageWriter()
    # module_widthを少し大きくして読みやすくする
    ean = EAN13(code, writer=writer)
    return ean.render(writer_options={'module_width': 0.5, 'module_height': 15.0, 'quiet_zone': 6.5})

def generate_code128_img(code: str):
    """Code128画像を生成してImageオブジェクトとして返す"""
    writer = ImageWriter()
    # Code128は高さを確保し、細くなりすぎないようにする
    c128 = Code128(code, writer=writer)
    return c128.render(writer_options={'module_width': 0.6, 'module_height': 15.0, 'quiet_zone': 5.0})

def generate_qr_img(data: str):
    """QRコード画像を生成してImageオブジェクトとして返す"""
    qr = qrcode.QRCode(box_size=12, border=2) # box_sizeを大きく
    qr.add_data(data)
    qr.make(fit=True)
    return qr.make_image(fill_color="black", back_color="white").convert('RGB')

def save_image(img, filename):
    path = os.path.join(OUTPUT_DIR, filename + ".png")
    img.save(path)
    print(f"Generated: {path}")

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------
def main():
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    # 共通キャンバス設定: 800x600 (大きめにする)
    C_W, C_H = 800, 600
    
    # Case 1: 2D 1個 (OK)
    img = create_canvas(C_W, C_H)
    qr = generate_qr_img('QR-SAMPLE-001') # w=~350
    # QRをリサイズせずに貼る(必要なら縮小)
    if qr.width > C_W // 2: qr = qr.resize((C_W // 2, C_W // 2))
    img.paste(qr, ((C_W - qr.width)//2, (C_H - qr.height)//2))
    save_image(img, 'ok_qr_single')

    # Case 2: 2D 複数
    img = create_canvas(C_W, C_H)
    qr = generate_qr_img('QR-SAMPLE-001')
    qr = qr.resize((250, 250))
    img.paste(qr, (100, 150))
    img.paste(qr, (450, 150))
    save_image(img, 'ok_qr_multiple')

    # Case 3: 2D + 1D (Mixed)
    img = create_canvas(C_W, C_H)
    qr = generate_qr_img('QR-SAMPLE-001').resize((200, 200))
    jan = generate_jan_img('490123456789') # そのまま使う
    if jan.width > 500: jan = jan.resize((500, int(jan.height * (500/jan.width))))
    img.paste(qr, (300, 50))
    img.paste(jan, ((C_W - jan.width)//2, 300))
    save_image(img, 'ok_mixed_qr_jan')

    # Case 4: 1D 1個 (OK)
    img = create_canvas(C_W, C_H)
    jan = generate_jan_img('490123456789')
    img.paste(jan, ((C_W - jan.width)//2, (C_H - jan.height)//2))
    save_image(img, 'ok_jan_single')

    # Case 5: 1D 複数
    img = create_canvas(C_W, C_H)
    jan = generate_jan_img('123456789012')
    if jan.width > 400: jan = jan.resize((400, int(jan.height * (400/jan.width))))
    img.paste(jan, (200, 50))
    img.paste(jan, (200, 350))
    save_image(img, 'ok_jan_multiple')

    # ------------------------------------------
    # Error Mock Cases (Code128で太く生成)
    # ------------------------------------------

    # Case 6: 1D CD Error (4901234567890) 
    # CD=4だが0で終わる => Code128 "4901234567890" using Code128
    img = create_canvas(C_W, C_H)
    c128 = generate_code128_img('4901234567890')
    # リサイズ無しで貼ってみる。大きすぎるようなら縮小
    if c128.width > 700: c128 = c128.resize((700, int(c128.height * (700/c128.width))))
    img.paste(c128, ((C_W - c128.width)//2, 100))
    
    draw = ImageDraw.Draw(img)
    draw.text((50, 50), "CD ERROR TEST: 4901234567890", fill="red")
    save_image(img, 'error_cd_jan13')

    # Case 7: Parity Error Mock -> 'P-ERR'
    img = create_canvas(C_W, C_H)
    c128 = generate_code128_img('P-ERR')
    # 短いのでリサイズ不要
    img.paste(c128, ((C_W - c128.width)//2, 100))
    draw = ImageDraw.Draw(img)
    draw.text((50, 50), "PARITY (P-ERR)", fill="red")
    save_image(img, 'error_parity_mock')

    # Case 8: Missing Start -> 'NO-START-49123'
    img = create_canvas(C_W, C_H)
    c128 = generate_code128_img('NO-START-49123')
    if c128.width > 750: c128 = c128.resize((750, int(c128.height * (750/c128.width))))
    img.paste(c128, ((C_W - c128.width)//2, 100))
    draw = ImageDraw.Draw(img)
    draw.text((50, 50), "NO START (NO-START...)", fill="red")
    save_image(img, 'error_missing_start')

    # Case 9: Missing Stop -> '49123-NO-STOP'
    img = create_canvas(C_W, C_H)
    c128 = generate_code128_img('49123-NO-STOP')
    if c128.width > 750: c128 = c128.resize((750, int(c128.height * (750/c128.width))))
    img.paste(c128, ((C_W - c128.width)//2, 100))
    draw = ImageDraw.Draw(img)
    draw.text((50, 50), "NO STOP (...NO-STOP)", fill="red")
    save_image(img, 'error_missing_stop')

    # Case 10: Missing Both -> 'NO-BOTH'
    img = create_canvas(C_W, C_H)
    c128 = generate_code128_img('NO-BOTH')
    img.paste(c128, ((C_W - c128.width)//2, 100))
    draw = ImageDraw.Draw(img)
    draw.text((50, 50), "NO BOTH", fill="red")
    save_image(img, 'error_missing_both')

    # Case 11: JAN-8 CD Error -> '49012345'
    img = create_canvas(C_W, C_H)
    c128 = generate_code128_img('49012345')
    img.paste(c128, ((C_W - c128.width)//2, 100))
    draw = ImageDraw.Draw(img)
    draw.text((50, 50), "JAN-8 CD ERR (49012345)", fill="red")
    save_image(img, 'error_cd_jan8')

if __name__ == "__main__":
    main()
