from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from datetime import datetime

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def read_root():
    links = {
        "Services Landing Page": "http://localhost:8080",
        "Grafana": "http://localhost:3000",
        "ArgoCD": "https://localhost:3001",
        "Prometheus": "http://localhost:9090",
        "Alertmanager": "http://localhost:9093"
    }
    
    links_html = "".join([f'<li><a href="{url}" target="_blank">{name}</a></li>' for name, url in links.items()])
    
    content = f"""
    <html>
        <head>
            <title>GKE Services</title>
            <style>
                body {{ font-family: sans-serif; margin: 40px; line-height: 1.6; }}
                h1 {{ color: #333; }}
                ul {{ list-style-type: none; padding: 0; }}
                li {{ margin-bottom: 10px; }}
                a {{ text-decoration: none; color: #007bff; font-weight: bold; }}
                a:hover {{ text-decoration: underline; }}
                .footer {{ margin-top: 20px; font-size: 0.8em; color: #666; }}
            </style>
        </head>
        <body>
            <h1>GKE Services Dashboard</h1>
            <p>Version: 0.5.0</p>
            <ul>
                {links_html}
            </ul>
            <div class="footer">
                Timestamp: {datetime.now().isoformat()}
            </div>
        </body>
    </html>
    """
    return content

@app.get("/health")
def read_health():
    return {"status": "ok"}