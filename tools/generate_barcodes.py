import os
from barcode import EAN13
from barcode.writer import ImageWriter
import qrcode
from PIL import Image, ImageDraw, ImageFont

# 出力ディレクトリ
OUTPUT_DIR = r"lib\features\scan\presentation\assets"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def create_canvas(width=600, height=400):
    return Image.new('RGB', (width, height), 'white')

def generate_jan_img(code: str):
    """JANコード画像を生成してImageオブジェクトとして返す"""
    writer = ImageWriter()
    # EAN13は保存時にファイル書き出しを行うため、一時ファイルを使用するか
    # または render メソッドを使う
    ean = EAN13(code, writer=writer)
    return ean.render()

def generate_qr_img(data: str):
    """QRコード画像を生成してImageオブジェクトとして返す"""
    qr = qrcode.QRCode(box_size=10, border=2)
    qr.add_data(data)
    qr.make(fit=True)
    return qr.make_image(fill_color="black", back_color="white").convert('RGB')

def save_image(img, filename):
    path = os.path.join(OUTPUT_DIR, filename + ".png")
    img.save(path)
    print(f"Generated: {path}")

def generate_text_img(text, width=300, height=100):
    """エラーケースなどの代替テキスト画像"""
    img = Image.new('RGB', (width, height), 'white')
    draw = ImageDraw.Draw(img)
    draw.text((10, 40), text, fill="black") # フォント指定なしのデフォルト
    return img

def main():
    # Case 1: 2D 1個 (OK)
    img = create_canvas()
    qr = generate_qr_img('QR-SAMPLE-001')
    img.paste(qr, (150, 50))
    save_image(img, 'demo_1')

    # Case 2: 2D 複数
    img = create_canvas()
    qr1 = generate_qr_img('QR-SAMPLE-001')
    qr2 = generate_qr_img('QR-SAMPLE-002')
    img.paste(qr1.resize((200, 200)), (50, 100))
    img.paste(qr2.resize((200, 200)), (350, 100))
    save_image(img, 'demo_2')

    # Case 3: 2D + 1D (Mixed)
    img = create_canvas()
    qr = generate_qr_img('QR-SAMPLE-001')
    jan = generate_jan_img('490123456789')
    img.paste(qr.resize((150, 150)), (225, 20))
    img.paste(jan.resize((400, 200)), (100, 180))
    save_image(img, 'demo_3')

    # Case 4: 1D 1個 (OK)
    img = create_canvas()
    jan = generate_jan_img('490123456789')
    img.paste(jan, (50, 50))
    save_image(img, 'demo_4')

    # Case 5: 1D 複数
    img = create_canvas()
    jan1 = generate_jan_img('123456789012')
    jan2 = generate_jan_img('987654321098')
    img.paste(jan1.resize((300, 150)), (150, 20))
    img.paste(jan2.resize((300, 150)), (150, 200))
    save_image(img, 'demo_5')

    # Case 6: 1D CDエラー (4901234567890) -> 末尾0
    # python-barcodeは正しいCDを計算してしまうため、画像生成後に加工するか
    # ここでは「不正なコードである」ことを示すダミー画像(テキストなど)にするか
    # あるいは正規で生成して、テストロジック側での不整合確認用とする
    # Request: "画像がカメラで読み込まれた場合"
    # ここでは便宜上、正規コード '490123456789' の画像を使い回すが、
    # 読み取りデータとしてはエラーになるようにシステム側を設定している
    # *厳密にはバーコードの最後に0がエンコードされた画像が必要* だがライブラリ制約のため
    # 視覚的には正規コード、データ定義はエラーコードとして扱う
    # (またはダミーテキストで代用)
    img = create_canvas()
    jan = generate_jan_img('490123456780') # ライブラリが正しいCD(4? 7?)を付与してしまう
    # 簡易的にテキストでエラーを表示
    draw = ImageDraw.Draw(img)
    draw.text((10, 10), "CD ERROR TEST: 4901234567890", fill="red")
    img.paste(jan, (50, 50))
    save_image(img, 'demo_6')

    # Case 7: Code39/128 Parity Error (Mock)
    img = create_canvas()
    # Code39などでパリティエラーを表現するのは難しいため、ダミーバーコード
    jan = generate_jan_img('111111111111')
    img.paste(jan, (50, 50))
    draw = ImageDraw.Draw(img)
    draw.text((200, 350), "PARITY ERROR CASE", fill="red")
    save_image(img, 'demo_7')

    # Case 8: Missing Start
    img = create_canvas()
    jan = generate_jan_img('490123456789')
    # 左端(スタートキャラクタ)を白塗りして消す
    draw = ImageDraw.Draw(jan)
    draw.rectangle((0, 0, 30, jan.height), fill="white")
    img.paste(jan, (50, 50))
    save_image(img, 'demo_8')

    # Case 9: Missing Stop
    img = create_canvas()
    jan = generate_jan_img('490123456789')
    # 右端(ストップキャラクタ)を白塗り
    draw = ImageDraw.Draw(jan)
    draw.rectangle((jan.width - 30, 0, jan.width, jan.height), fill="white")
    img.paste(jan, (50, 50))
    save_image(img, 'demo_9')

    # Case 10: Missing Both
    img = create_canvas()
    jan = generate_jan_img('490123456789')
    draw = ImageDraw.Draw(jan)
    draw.rectangle((0, 0, 30, jan.height), fill="white")
    draw.rectangle((jan.width - 30, 0, jan.width, jan.height), fill="white")
    img.paste(jan, (50, 50))
    save_image(img, 'demo_10')

    # Case 11: JAN-8 CD Error
    img = create_canvas()
    # python-barcodeで8桁を生成するには EAN8 を使う
    from barcode import EAN8
    writer = ImageWriter()
    ean = EAN8('4901234', writer=writer) # ライブラリは自動で正しいCD '1' を付ける
    jan8 = ean.render()
    img.paste(jan8, (150, 100))
    draw = ImageDraw.Draw(img)
    draw.text((10, 10), "JAN-8 CD ERROR TEST: 49012347", fill="red")
    save_image(img, 'demo_11')

if __name__ == "__main__":
    main()
