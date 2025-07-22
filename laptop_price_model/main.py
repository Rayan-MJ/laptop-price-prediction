from flask import Flask, request
from flask_cors import CORS
from script.process_raw_data import processRawData
from pathlib import Path
import joblib


cwd = Path().resolve()
model_path = cwd / 'model' / 'Laptop_price_predict_model'
model = joblib.load(model_path)


app = Flask(__name__)
CORS(app)
# Home route
@app.route('/')
def home():
    return "Welcome to Flask!"


@app.route('/Predict', methods=['POST'])
def predict():
    raw_data = request.get_json()

    ordered_keys = [
        'Brand', 'Type', 'Screen Size', 'Screen Specs', 'CPU',
        'RAM', 'Hard Disk', 'GPU', 'Operating System', 'Weight'
    ]


    values_list = [raw_data[key] for key in ordered_keys]


    final_list = [values_list]
    print(final_list)
    Processed_data = processRawData(final_list,True)
    prediction = model.predict(Processed_data)
    print(prediction)
    return f"{prediction[0]:.2f}", 201

if __name__ == '__main__':
    app.run(debug=True)
