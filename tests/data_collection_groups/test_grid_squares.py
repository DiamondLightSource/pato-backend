def test_get(mock_permissions, client):
    """Get all grid squares in data collection group (including uncollected)"""
    resp = client.get("/dataGroups/5440742/grid-squares")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 2


def test_get_empty(mock_permissions, client):
    """Only get collected grid squares"""
    resp = client.get("/dataGroups/5440742/grid-squares", params="hideSquares=true")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1


def test_get_empty_search_maps(mock_permissions, client):
    """Only get populated search maps"""
    resp = client.get(
        "/dataGroups/5440742/grid-squares", params="hideEmptySearchMaps=true"
    )
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1
