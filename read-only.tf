resource "postgresql_role" "read_only" {
  name                = "${var.database}_ro"
  skip_reassign_owned = true
}

## Tables
resource "postgresql_grant" "read_only_tables" {
  count = length(postgresql_schema.schema)

  role     = postgresql_role.read_only.name
  database = postgresql_database.db.name
  schema   = postgresql_schema.schema[count.index].name

  object_type = "table"
  privileges  = ["SELECT"]
}

resource "postgresql_default_privileges" "read_only_tables" {
  count = length(postgresql_schema.schema)

  role     = postgresql_role.read_only.name
  database = postgresql_database.db.name
  schema   = postgresql_schema.schema[count.index].name

  owner       = postgresql_role.owner.name
  object_type = "table"
  privileges  = ["SELECT"]
}

## Sequences
resource "postgresql_grant" "read_only_sequences" {
  count = length(postgresql_schema.schema)

  role     = postgresql_role.read_only.name
  database = postgresql_database.db.name
  schema   = postgresql_schema.schema[count.index].name

  object_type = "sequence"
  privileges  = ["SELECT"]
}

resource "postgresql_default_privileges" "read_only_sequences" {
  count = length(postgresql_schema.schema)

  role     = postgresql_role.read_only.name
  database = postgresql_database.db.name
  schema   = postgresql_schema.schema[count.index].name

  owner       = postgresql_role.owner.name
  object_type = "sequence"
  privileges  = ["SELECT"]
}
