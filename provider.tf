terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }

    postgresql = {
      source = "cyrilgdn/postgresql"
    }

    vault = {
      source = "cyrilgdn/vault"
    }
  }
}
