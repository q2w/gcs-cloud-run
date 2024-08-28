module "bucket" {
  source      = "github.com/q2w/terraform-google-cloud-storage//modules/simple_bucket?ref=cloud-run"
  name        = var.bucket_name
  project_id  = var.project_id
  location    = var.region
  force_destroy = var.bucket_force_destroy
  iam_members = [{ role : var.bucket_iam_members[0].role, member : module.cloud_run.service_account_id.member }]
}

module "cloud_run" {
  source       = "github.com/q2w/terraform-google-cloud-run//modules/v2?ref=gcs"
  project_id   = var.project_id
  location     = var.region
  service_name = var.cloud_run_service_name
  containers   = var.cloud_run_containers
  volumes      = [{ name : var.cloud_run_volumes[0].name, gcs : { bucket : module.bucket.name } }]
}