import json


def test_submit(mock_pika_atlas, mock_permissions, client):
    """Should submit atlas correlation task to the queue"""
    resp = client.post("/dataGroups/5440742/atlas/correlation", json={"pair": 1040398})

    assert resp.status_code == 202
    mock_pika_atlas.publish.assert_called_with(
        json.dumps(
            {
                "image_ref": "/dls/atlas.png",
                "image_mov": "/dls/*.png",
                "pixel_size_ref": 1.0,
                "pixel_size_mov": 1.0,
            }
        ),
        queue="correlative.align_images",
    )

def test_submit_invalid(mock_permissions, client):
    """Should return 404 if group has no atlas"""
    resp = client.post("/dataGroups/5440742/atlas/correlation", json={"pair": 1040407})

    assert resp.status_code == 404
