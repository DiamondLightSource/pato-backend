def test_redirect(mock_permissions, client):
    """Get sample handling redirect"""
    resp = client.get("/proposals/cm14451/sessions/1/sampleHandling", follow_redirects=False)
    assert resp.headers["location"] == "https://ebic-sample-handling.diamond.ac.uk/proposals/cm14451/sessions/1"
