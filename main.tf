module "main" {
  source = "./modules/main"

  project  = local.project
  vpc_name = local.vpc_name
  vpc_cidr = local.vpc_cidr

  subnet = local.subnet
}