from flask import Flask


def create_app() -> Flask:
    """Application factory for the DevOps Flask service."""
    app = Flask(__name__)

    @app.get("/")
    def index():
        return {"message": "DevOps Flask application"}

    @app.get("/health")
    def health():
        return {"status": "healthy"}

    return app
