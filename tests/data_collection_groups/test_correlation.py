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
