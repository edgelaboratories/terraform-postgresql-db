locals {
  vault_roles = var.vault_backend_path == "" ? {} : {
    "${postgresql_database.this.name}-owner" = postgresql_role.owner.name
    "${postgresql_database.this.name}-ro"    = postgresql_role.read_only.name
    "${postgresql_database.this.name}-rw"    = postgresql_role.read_write.name
  }
}

resource "vault_database_secret_backend_role" "owner" {
  for_each = local.vault_roles

  backend = var.vault_backend_path
  name    = each.value
  db_name = var.vault_db_connection_name

  creation_statements = concat([
    "CREATE ROLE \"{{name}}\" IN ROLE ${each.value} LOGIN PASSWORD '{{password}}' INHERIT VALID UNTIL '{{expiration}}';",

    # Automatically SET ROLE to db owner at login
    "ALTER ROLE \"{{name}}\" IN DATABASE ${postgresql_database.this.name} SET ROLE ${each.value}",
  ])

  renew_statements = [
    "ALTER ROLE \"{{name}}\" VALID UNTIL '{{expiration}}';",
  ]

  # `revocation_statements` is not needed as the engine has a default behaviors that do it.

  default_ttl = var.vault_role_default_ttl
}

data "vault_policy_document" "this" {
  for_each = local.vault_roles

  rule {
    path         = "${var.vault_backend_path}/creds/${each.key}"
    capabilities = ["read"]
  }
}

resource "vault_policy" "this" {
  for_each = local.vault_roles

  name   = "postgresql-${each.key}"
  policy = data.vault_policy_document.this[each.key].hcl
}
