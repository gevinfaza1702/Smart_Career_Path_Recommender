from flask import Flask, request, jsonify
from recommender import recommend_career

app = Flask(__name__)

@app.route('/predict-career', methods=['POST'])
def predict_career():
    data = request.get_json(silent=True)
    if not data or not isinstance(data.get('skills'), list):
        return jsonify({"error": "Invalid input. Expected JSON with 'skills' as a list."}), 400
    result = recommend_career(data['skills'])
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)
