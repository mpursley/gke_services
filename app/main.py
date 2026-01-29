from fastapi import FastAPI
from datetime import datetime

app = FastAPI()

@app.get("/")
def read_root():
    return {
        "Hello": "World",
        "version": "0.4.0",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/health")
def read_health():
    return {"status": "ok"}
