# Operations

`GET /health` is a read-only readiness check. It returns HTTP 200 with
`{"status":"ok"}` when the database connection is available, or HTTP 503
with a generic status when it is unavailable.

Run `database/migrations/002-query-performance.sql` after the email migration.
The added indexes cover list sorting, sample details, oil values, and fatty-acid
component loading. Search page numbers are limited to 1 through 1000 to avoid
large database offsets.
