from flask import Flask, request, jsonify
from flask_cors import CORS
import base64
import os
import logging

app = Flask(__name__)
CORS(app)  # CORS'u etkinleştir

# Loglama ayarları
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        logger.info('Yeni istek alındı')
        
        # JSON verisi al
        data = request.json
        if not data:
            logger.error('JSON verisi bulunamadı')
            return jsonify({'error': 'JSON verisi bulunamadı'}), 400
        
        # Base64 formatındaki görüntüyü al
        image_base64 = data.get('image')
        if not image_base64:
            logger.error('Görüntü verisi bulunamadı')
            return jsonify({'error': 'Görüntü bulunamadı'}), 400

        logger.info('Base64 görüntü alındı, decode ediliyor...')

        try:
            # Base64'ü decode et
            image_data = base64.b64decode(image_base64.split(',')[1] if ',' in image_base64 else image_base64)
        except Exception as e:
            logger.error(f'Base64 decode hatası: {str(e)}')
            return jsonify({'error': 'Geçersiz base64 formatı'}), 400
        
        logger.info('Görüntü başarıyla decode edildi')
        
        # Test için görüntüyü kaydet
        try:
            with open('received_image.jpg', 'wb') as f:
                f.write(image_data)
            logger.info('Görüntü başarıyla kaydedildi')
        except Exception as e:
            logger.error(f'Dosya kaydetme hatası: {str(e)}')
            return jsonify({'error': 'Dosya kaydedilemedi'}), 500
        
        # Test yanıtı
        response_data = {
            'success': True,
            'message': 'Görüntü başarıyla alındı',
            'size': len(image_data)
        }
        logger.info(f'İşlem başarılı: {response_data}')
        return jsonify(response_data)

    except Exception as e:
        error_message = str(e)
        logger.error(f'Beklenmeyen hata: {error_message}')
        return jsonify({'error': error_message}), 500

if __name__ == '__main__':
    # IP adresini ve portu yazdır
    import socket
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    port = 5001
    
    print(f'\n{"="*50}')
    print(f'API şu adreste çalışıyor: http://{local_ip}:{port}')
    print(f'Bu IP adresini Flutter uygulamasında kullanın')
    print(f'{"="*50}\n')
    
    app.run(host='0.0.0.0', port=port, debug=True) 