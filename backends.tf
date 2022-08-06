terraform {
  cloud {
    organization = "ruzza-development"

    workspaces {
      name = "anr-dev"
    }
  }
} 