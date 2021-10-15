locals {
  owner = coalesce(var.owner, var.database)
}

resource "postgresql_role" "owner" {
  name     = local.owner
  login    = var.owner_password != null ? true : false
  password = var.owner_password
  roles    = var.roles

  connection_limit = var.connection_limit

  # We don't want to reassign objects especially because it's executed
  # in the current database (so 'postgres') so it makes no sense.
  skip_reassign_owned = true
}

resource "postgresql_database" "this" {
  name  = var.database
  owner = postgresql_role.owner.name

  template = var.template

  lc_collate = var.lc_collate
  lc_ctype   = coalesce(var.lc_ctype, var.lc_collate)
}

resource "postgresql_extension" "this" {
  count = length(var.extensions)

  name     = element(var.extensions, count.index)
  database = postgresql_database.this.name

  # On destroy, force the deletion of the extension even if things not managed by Terraform depend on it.
  # This can happen if a database and/or a schema has been created using
  # Terraform, but tables depending on features of an extension were created
  # outside of Terraform.
  # In that case, it's not possible to drop the extension on the first try.
  drop_cascade = true
}

## Schemas
resource "postgresql_schema" "this" {
  count = length(var.schemas)

  name          = element(var.schemas, count.index)
  owner         = var.schemas[count.index] == "public" ? null : postgresql_role.owner.name
  database      = postgresql_database.this.name
  if_not_exists = true
  drop_cascade  = true
}
