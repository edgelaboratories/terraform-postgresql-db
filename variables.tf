variable "database" {
  description = "The name of the database"
}

variable "template" {
  # CREATE DATABASE uses template1 by default, but the Terraform provider uses template0.
  # In RDS, the owner of the schema 'public' is 'postgres' in template1, so we can manage owner of tables
  # but 'rdsadmin' in template0 so we don't have all the permissions.
  default = "template1"
}

variable "schemas" {
  description = "The schemas to create"
  default     = ["public"]
}

variable "owner" {
  description = "The name of the owner of the database, default to database name"
  default     = ""
}

variable "owner_password" {
  description = "The password for the owner of the database"
  type        = string
  default     = null
}

variable "roles" {
  type        = list(string)
  description = "A list of roles to grant to the owner of the database"
  default     = []
}

variable "extensions" {
  type        = list(string)
  description = "A list of PostgreSQL extensions to install in the database"
  default     = []
}

variable "connection_limit" {
  default     = -1
  description = "Maximum number of connections for the owner role"
}

variable "lc_collate" {
  default     = "en_US.UTF-8"
  description = "Controls the sort order"
}

variable "lc_ctype" {
  default = null
  type    = string
}

variable "vault_backend_path" {
  default = ""
}

variable "vault_db_connection_name" {
  default = ""
}

variable "vault_role_default_ttl" {
  default = 3600
}
