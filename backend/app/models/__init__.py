"""Row models: the shape of what comes back from Postgres.

Not ORM classes. Each model mirrors one table or query result, and `crud`
validates rows into them so `dict[str, Any]` never escapes the data layer.
Wire-facing shapes live in `app.schemas`.
"""
