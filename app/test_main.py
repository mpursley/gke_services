from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "K8s Services Dashboard" in response.text
    assert "http://localhost:8080" in response.text
    assert "http://localhost:3000" in response.text

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}
