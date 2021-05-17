resource "postgresql_role" "read_write" {
  name                = "${var.database}_rw"
  skip_reassign_owned = true
}

## Tables
resource "postgresql_grant" "read_write_tables" {
  count = length(postgresql_schema.this)

  role     = postgresql_role.read_write.name
  database = postgresql_database.this.name
  schema   = postgresql_schema.this[count.index].name

  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE"]
}

resource "postgresql_default_privileges" "read_write_tables" {
  count = length(postgresql_schema.this)

  role     = postgresql_role.read_write.name
  database = postgresql_database.this.name
  schema   = postgresql_schema.this[count.index].name

  owner       = postgresql_role.owner.name
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE"]
}

## Sequences
resource "postgresql_grant" "read_write_sequences" {
  count = length(postgresql_schema.this)

  role     = postgresql_role.read_write.name
  database = postgresql_database.this.name
  schema   = postgresql_schema.this[count.index].name

  object_type = "sequence"
  privileges  = ["SELECT", "UPDATE"]
}

resource "postgresql_default_privileges" "read_write_sequences" {
  count = length(postgresql_schema.this)

  role     = postgresql_role.read_write.name
  database = postgresql_database.this.name
  schema   = postgresql_schema.this[count.index].name

  owner       = postgresql_role.owner.name
  object_type = "sequence"
  privileges  = ["SELECT", "UPDATE"]
}
