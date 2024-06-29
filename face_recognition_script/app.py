# pip install Flask opencv-python deepface numpy

from flask import Flask, request, jsonify, after_this_request
import cv2
from deepface import DeepFace
import numpy as np

app = Flask(__name__)

face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")

def disable_caching(response):
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

@app.route('/detect_emotion', methods=['POST'])
def detect_emotion():
    print('Request received at')
    print('Request URL: ', request.url)
    try:
        if 'image' not in request.files:
            print('No image file in request')
            return jsonify({"error": "No image file in request"}), 400

        image_files = request.files.getlist('image')

        if len(image_files) != 1:
            print('Please upload exactly one image file')
            return jsonify({"error": "Please upload exactly one image file"}), 400

        file = image_files[0]

        if file.filename == '':
            print('No selected file')
            return jsonify({"error": "No selected file"}), 400

        npimg = np.fromfile(file, np.uint8)
        frame = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)

        analyze = None
        for (x, y, w, h) in faces:
            try:
                roi_color = frame[y:y+h, x:x+w]
                analyze = DeepFace.analyze(roi_color, actions=['emotion'], enforce_detection=False)
                
                print(f"Analysis result: {analyze}")
                return jsonify(analyze), 200
            except Exception as e:
                return jsonify({"error": "Internal Server Error"}), 400

        if len(faces) == 0:
            print("No face detected")
            return jsonify({"error": "No face detected"}), 400

    except Exception as e:
        print(f"Error processing request: {e}")
        return jsonify({"error": str(e)}), 500

@app.after_request
def after_request(response):
    return disable_caching(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)