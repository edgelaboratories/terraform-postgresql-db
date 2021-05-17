# terraform-postgresql-db

This module offers default conventions when creating a new PostgreSQL database.

In particular:

- It creates a database :wave:
- It creates a "owner" role, [that owns the database (in PostgreSQL parlance)](https://www.postgresql.org/docs/current/ddl-priv.html) and have all the permissions there.
- It creates a set of default roles that can be assumed when working on the database:

  - A "read-only" role `${DBNAME}_ro`, that is only able to read objects
  - A "read-write" role `${DBNAME}_rw`, that is only able to write into that database, but not create objects.

  These roles can be assumed by developers or operators, when they have been granted the right to do so. These persons then have automatically the associated rights on that database.

## Usage

```hcl
module "foo" {
  source = "git@github.com:edgelaboratories/terraform-modules//postgresql/db?ref=v0.1.0"

  database       = "foo"
  owner          = "admin"
  owner_password = "admin"
}
```
