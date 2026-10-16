## Migration workflow

`schema.sql` creates the baseline schema and the `schema_migrations` ledger.
Run incremental scripts from the `database/` directory in filename order. Each
script should be safe to re-run and should record its version in
`schema_migrations`. Before running `migrate-email-login.sql`, resolve the
empty or duplicate email rows returned by its preflight queries; the script
will not invent addresses or delete accounts.

The current incremental scripts are `migrate-email-login.sql` followed by
`migrations/002-query-performance.sql`.

