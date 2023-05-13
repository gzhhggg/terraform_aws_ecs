module "main" {
  source = "./modules/main"

  project  = local.project
  vpc_name = local.vpc_name
  vpc_id   = local.vpc_id

  subnet = local.subnet
}