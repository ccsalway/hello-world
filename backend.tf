terraform {
  backend "remote" {
    organization = "wework-demo"

    workspaces {
      name = "hello-world"
    }
  }
}