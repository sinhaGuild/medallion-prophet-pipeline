FROM python:3.9
RUN pip install --upgrade pip setuptools wheel
WORKDIR /code
COPY requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY . /code
EXPOSE 8000
# CMD [ "uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000" ]
