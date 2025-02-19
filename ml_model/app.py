from flask import Flask, request, jsonify
from tensorflow import keras
import numpy as np
import pandas as pd
import string

app = Flask(__name__)

# Load the trained ISL model
model = keras.models.load_model("model.h5")

# Define the alphabet and Gujarati mapping
alphabet = ['1', '2', '3', '4', '5', '6', '7', '8', '9'] + list(string.ascii_uppercase)
english_to_gujarati = {
    'A': 'અ', 'B': 'બ', 'C': 'ક', 'D': 'ડ', 'E': 'ઇ', 'F': 'ફ', 'G': 'ગ',
    'H': 'હ', 'I': 'ઈ', 'J': 'જ', 'K': 'ક', 'L': 'લ', 'M': 'મ', 'N': 'ન',
    'O': 'ઓ', 'P': 'પ', 'Q': 'ક', 'R': 'ર', 'S': 'સ', 'T': 'ત', 'U': 'ઉ',
    'V': 'વ', 'W': 'વ', 'X': 'ક', 'Y': 'ય', 'Z': 'ઝ', 
    '1': '૧', '2': '૨', '3': '૩', '4': '૪', '5': '૫', '6': '૬', '7': '૭', 
    '8': '૮', '9': '૯'
}

@app.route('/predict', methods=['POST'])
@app.route('/')
def home():
    return "Flask server is running!"
def predict():
    try:
        # Receive keypoints data from the Flutter app
        data = request.json.get('keypoints', [])
        if not data:
            return jsonify({'error': 'No keypoints provided'}), 400

        # Convert received data to a NumPy array and reshape for model prediction
        keypoints = np.array(data).reshape(1, -1)  # Adjust shape as per your model's input

        # Make a prediction
        predictions = model.predict(keypoints)
        predicted_class = np.argmax(predictions, axis=1)[0]
        label = alphabet[predicted_class]
        gujarati_char = english_to_gujarati.get(label, label)

        # Send back the response with both English and Gujarati characters
        return jsonify({
            'english': label,
            'gujarati': gujarati_char
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
