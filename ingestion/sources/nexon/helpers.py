import dlt
import time

from .settings import REQUEST_DELAY


def is_ocid_child(spec):
    """True if the endpoint's only required param is ocid, i.e. it fits the
    uniform 'call with the character's ocid' shape the factory builds."""
    required = [p for p, v in spec.get("params", {}).items() if v == "required"]
    return required == ["ocid"]


def build_ocid_child(name, spec, parent, client):
    """Build a transformer that makes one detail call per upstream character,
    passing its ocid, and writes to its own table named `name`."""

    @dlt.transformer(data_from=parent, name=name, write_disposition="replace")
    def _resource(character):
        time.sleep(REQUEST_DELAY)
        yield client.get(
            path=spec["path"],
            params={"ocid": character["ocid"]},
        ).json()

    return _resource
