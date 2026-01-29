from fastapi import FastAPI
from datetime import datetime

app = FastAPI()

@app.get("/")
def read_root():
    return {
        "Hello": "World",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/health")
def read_health():
    return {"status": "ok"}
