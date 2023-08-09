FROM python:alpine3.18

EXPOSE 5000

ADD . .

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "app.py"]