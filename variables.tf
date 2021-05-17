variable "database" {
  description = "The name of the database"
}

variable "schemas" {
  default = ["public"]
}

variable "owner" {
  description = "The name of the owner of the database"
}

variable "owner_password" {
  description = "The password for the owner of the database"
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
  description = "controls the sort order"
}

variable "lc_ctype" {
  default = null
  type    = string
}
