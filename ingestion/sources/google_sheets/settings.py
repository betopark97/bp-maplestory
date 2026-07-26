# -------------------------------------------------------------------------------------
# API base URL for Google Sheets API v4
# -------------------------------------------------------------------------------------
BASE_URL = "https://sheets.googleapis.com"

# Read-only scope — the service account only ever reads.
SCOPES = ["https://www.googleapis.com/auth/spreadsheets.readonly"]

# -------------------------------------------------------------------------------------
# Spreadsheet to ingest
# -------------------------------------------------------------------------------------
# The long id from the sheet URL:
# https://docs.google.com/spreadsheets/d/<SPREADSHEET_ID>/edit
SPREADSHEET_ID = "1TblTHmHZ600aavszsnQG-sLxt7jAugk2-z5pmuym0D4"

# Tab (worksheet) names to pull. Each tab becomes its own table.
TABS = [
    "boss_intense_crystals",
]
