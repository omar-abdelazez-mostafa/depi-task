from app import create_app


def test_index_returns_expected_response():
    client = create_app().test_client()

    response = client.get("/")

    assert response.status_code == 200
    assert response.get_json() == {"message": "DevOps Flask application"}


def test_health_returns_healthy_status():
    client = create_app().test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json() == {"status": "healthy"}
