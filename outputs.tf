output "database" {
  value = postgresql_database.this.name
}

output "owner" {
  value = postgresql_role.owner.name
}

output "role_ro" {
  value = postgresql_role.read_only.name
}

output "role_rw" {
  value = postgresql_role.read_write.name
}
