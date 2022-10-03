from fastapi import FastAPI
import pandas as pd
from prophet.serialize import model_from_json

app = FastAPI()

with open('prophet_serialized.json', 'r') as fin:
    model = model_from_json(fin.read())  # Load model


@app.get("/")
async def root():
    return {"message": "Hello World from inside api."}


@app.get("/predict/{date}")
async def predict_sales(date: str):
    date_f = pd.to_datetime(date, infer_datetime_format=True, errors="raise")
    future_date = pd.DataFrame({'ds': [date_f]})
    prediction_singleton = model.predict(future_date)
    return {"message": f"Sucessfully Generated Prediction for {date_f}", "prediction_data": prediction_singleton}
