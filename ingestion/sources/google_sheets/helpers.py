from dlt.sources.credentials import GcpServiceAccountCredentials
from dlt.sources.helpers.rest_client.auth import BearerTokenAuth
from google.auth.transport.requests import Request

from .settings import SCOPES


def bearer_auth(credentials: GcpServiceAccountCredentials) -> BearerTokenAuth:
    """Mint a short-lived access token from the service account and wrap it for
    RESTClient. google-auth signs a JWT with the service account's private key,
    exchanges it at Google's OAuth token endpoint, and returns a bearer token."""
    native = credentials.to_native_credentials().with_scopes(SCOPES)
    native.refresh(Request())
    return BearerTokenAuth(native.token)


def rows_from_values(values):
    """The Sheets values endpoint returns a tab as a list-of-lists
    (majorDimension=ROWS). Treat the first row as the header and yield each
    following row as a dict keyed by header. The API drops trailing empty
    cells, so short rows are padded with None to stay rectangular."""
    if not values:
        return
    header = values[0]
    for row in values[1:]:
        row = row + [None] * (len(header) - len(row))
        yield dict(zip(header, row))
