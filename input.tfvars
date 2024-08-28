project_id = "abhiwa-test-30112023"
region     = "us-central1"

bucket_name        = "abhiwa-bucket"
bucket_iam_members = [{ role : "roles/storage.objectAdmin" }]

cloud_run_service_name = "abhiwa-cloud-run"
cloud_run_containers = [
  {
    container_image : "gcr.io/abhiwa-test-30112023/gcs_cloud_run:latest",
    volume_mounts : [{ name : "gcs-volume", mount_path : "/app" }]
  }
]
cloud_run_volumes = [{name: "gcs-volume"}]