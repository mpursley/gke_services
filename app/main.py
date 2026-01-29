from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World, test2"}

@app.get("/health")
def read_health():
    return {"status": "ok"}
