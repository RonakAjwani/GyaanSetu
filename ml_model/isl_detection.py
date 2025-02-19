import cv2
import mediapipe as mp
import copy
import itertools
from tensorflow import keras
import numpy as np
import pandas as pd
import string
from PIL import Image, ImageDraw, ImageFont

# Load the saved model from file
model = keras.models.load_model("model.h5")

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_hands = mp.solutions.hands

alphabet = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
alphabet += list(string.ascii_uppercase)

# Mapping from English alphabets to Gujarati characters
english_to_gujarati = {
    'A': 'અ', 'B': 'બ', 'C': 'ક', 'D': 'ડ', 'E': 'ઇ', 'F': 'ફ', 'G': 'ગ',
    'H': 'હ', 'I': 'ઈ', 'J': 'જ', 'K': 'ક', 'L': 'લ', 'M': 'મ', 'N': 'ન',
    'O': 'ઓ', 'P': 'પ', 'Q': 'ક', 'R': 'ર', 'S': 'સ', 'T': 'ત', 'U': 'ઉ',
    'V': 'વ', 'W': 'વ', 'X': 'ક', 'Y': 'ય', 'Z': 'ઝ', 
    '1': '૧', '2': '૨', '3': '૩', '4': '૪', '5': '૫', '6': '૬', '7': '૭', 
    '8': '૮', '9': '૯'
}

# Define the function to use custom fonts with error handling
def put_text_with_custom_font(image, text, position, font_path, font_size, color):
    try:
        # Convert the image to PIL format
        pil_image = Image.fromarray(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
        draw = ImageDraw.Draw(pil_image)

        # Load the custom font
        font = ImageFont.truetype(font_path, font_size)

        # Add text to image
        draw.text(position, text, font=font, fill=color)

        # Convert back to OpenCV format
        image = cv2.cvtColor(np.array(pil_image), cv2.COLOR_RGB2BGR)
    except OSError as e:
        print(f"Error loading font: {e}")
        # Use default font if custom font fails
        image = put_text_with_default_font(image, text, position, font_size, color)
    return image

def put_text_with_default_font(image, text, position, font_size, color):
    try:
        # Convert the image to PIL format
        pil_image = Image.fromarray(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
        draw = ImageDraw.Draw(pil_image)

        # Use default PIL font
        font = ImageFont.load_default()

        # Add text to image
        draw.text(position, text, font=font, fill=color)

        # Convert back to OpenCV format
        image = cv2.cvtColor(np.array(pil_image), cv2.COLOR_RGB2BGR)
    except Exception as e:
        print(f"Error: {e}")
    return image

# Paths to font files
gujarati_font_path = r"shruti.ttf"
english_font_path = r"C:\Windows\Fonts\arial.ttf"  # Path to default font on Windows

# Functions
def calc_landmark_list(image, landmarks):
    image_width, image_height = image.shape[1], image.shape[0]
    landmark_point = []
    for _, landmark in enumerate(landmarks.landmark):
        landmark_x = min(int(landmark.x * image_width), image_width - 1)
        landmark_y = min(int(landmark.y * image_height), image_height - 1)
        landmark_point.append([landmark_x, landmark_y])
    return landmark_point

def pre_process_landmark(landmark_list):
    temp_landmark_list = copy.deepcopy(landmark_list)
    base_x, base_y = 0, 0
    for index, landmark_point in enumerate(temp_landmark_list):
        if index == 0:
            base_x, base_y = landmark_point[0], landmark_point[1]
        temp_landmark_list[index][0] = temp_landmark_list[index][0] - base_x
        temp_landmark_list[index][1] = temp_landmark_list[index][1] - base_y
    temp_landmark_list = list(itertools.chain.from_iterable(temp_landmark_list))
    max_value = max(list(map(abs, temp_landmark_list)))
    def normalize_(n):
        return n / max_value
    temp_landmark_list = list(map(normalize_, temp_landmark_list))
    return temp_landmark_list

# For webcam input:
cap = cv2.VideoCapture(0)
with mp_hands.Hands(
    model_complexity=0,
    max_num_hands=2,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5) as hands:
    while cap.isOpened():
        success, image = cap.read()
        image = cv2.flip(image, 1)
        if not success:
            print("Ignoring empty camera frame.")
            continue

        image.flags.writeable = False
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = hands.process(image)

        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        debug_image = copy.deepcopy(image)

        if results.multi_hand_landmarks:
            for hand_landmarks, handedness in zip(results.multi_hand_landmarks, results.multi_handedness):
                landmark_list = calc_landmark_list(debug_image, hand_landmarks)
                pre_processed_landmark_list = pre_process_landmark(landmark_list)
                
                # Draw only landmarks without connections and without circles
                mp_drawing.draw_landmarks(
                    image,
                    hand_landmarks,
                    landmark_drawing_spec=mp_drawing.DrawingSpec(color=(0, 255, 0), thickness=4, circle_radius=1)  # Custom style
                )
                
                overlay = image.copy()
                cv2.rectangle(overlay, (0, 0), (image.shape[1], 100), (0, 0, 0), -1)
                cv2.addWeighted(overlay, 0.6, image, 0.4, 0, image)  # Adjust transparency
                df = pd.DataFrame(pre_processed_landmark_list).transpose()
                predictions = model.predict(df, verbose=0)
                predicted_classes = np.argmax(predictions, axis=1)
                label = alphabet[predicted_classes[0]]
                gujarati_char = english_to_gujarati.get(label, label)  # Default to English if no Gujarati mapping
                
                # Display both English and Gujarati characters
                english_text = f"{label}"
                gujarati_text = f"{gujarati_char}"
                image = put_text_with_custom_font(image, english_text, (50, 50), english_font_path, 40, (255, 255, 255))
                image = put_text_with_custom_font(image, gujarati_text, (50, 100), gujarati_font_path, 40, (255, 255, 255))

        cv2.imshow('Indian Sign Language Detector', image)
        if cv2.waitKey(5) & 0xFF == 27:
            break
cap.release()
cv2.destroyAllWindows()
