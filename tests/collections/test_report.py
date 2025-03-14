from unittest.mock import patch

from pato.crud.collection_report import ReportPDF


def fake_image(self, img: str, x: int | str, y: int, h: int = 0, w: int = 0):
    pass

# TODO: add more tests for no motion correction, no 2D classes, no refinement
@patch.object(ReportPDF, "image", fake_image)
def test_generate_report(mock_permissions, client):
    """Get estimated resolution frequency data for a data collection"""
    resp = client.get("/dataCollections/6017406/report")

    assert resp.status_code == 200


def test_no_step(mock_permissions, client):
    """Should return 404 if no suitable processing steps are found for collection"""
    resp = client.get("/dataCollections/6017411/report")

    assert resp.status_code == 404
