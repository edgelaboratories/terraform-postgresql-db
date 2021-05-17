resource "postgresql_role" "owner" {
  name     = var.owner
  login    = true
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

  # CREATE DATABASE uses template1 by default, but the Terraform provider uses template0.
  # In RDS, the owner of the schema 'public' is 'postgres' in template1, so we can manage owner of tables
  # but 'rdsadmin' in template0 so we don't have all the permissions.
  template = "template1"

  lc_collate = var.lc_collate
  lc_ctype   = coalesce(var.lc_ctype, var.lc_collate)
}

resource "postgresql_extension" "extension" {
  count = length(var.extensions)

  name     = element(var.extensions, count.index)
  database = postgresql_database.db.name

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
  database      = postgresql_database.db.name
  if_not_exists = true
  drop_cascade  = true
}
