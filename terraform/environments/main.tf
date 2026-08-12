module "project_services" {
  source = "../modules/project-services"

  project_id = var.project_id
  services   = var.services
}

module "network" {
  source = "../modules/network"

  vpc_name     = var.vpc_name
  routing_mode = var.routing_mode
  subnets      = var.subnets

  depends_on = [module.project_services]
}

module "firewalls" {
  source = "../modules/firewalls"

  network_name   = module.network.vpc_id
  firewall_rules = var.firewall_rules
}

module "iam" {
  source = "../modules/iam"

  project_id       = var.project_id
  service_accounts = var.service_accounts
  iam_role         = var.iam_role

  depends_on = [module.project_services]
}

module "cloud-run" {
  source = "../modules/cloud-run"

  


}