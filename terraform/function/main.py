import base64
import json
import os

import google.auth
from googleapiclient.discovery import build


def gke_control(data, context):  # 引数2つ必要
    request_json = base64.b64decode(data["data"]).decode("utf-8")
    request_json = json.loads(request_json)
    action = request_json.get("action")

    cluster_id = os.environ.get("CLUSTER_ID")

    credentials, _ = google.auth.default()
    service = build("container", "v1", credentials=credentials)

    if action == "delete":
        # GKEクラスタを削除する
        print("In delete start")
        # 完全なリソース名を指定
        cluster_name = f"projects/{project_id}/locations/{location}/clusters/{cluster_id}"
        response = service.projects().locations().clusters().delete(name=cluster_name).execute()
        print(f"Delete response: {response}")
        print("In delete end")

    print("GKE Cluster delete process completed")
    return "GKE Cluster deleted"
