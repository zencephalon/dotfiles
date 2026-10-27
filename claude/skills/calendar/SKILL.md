---
name: calendar
description: This skill should be used when the user asks about "calendar", "schedule", "meetings", "events", "appointments", "availability", "free time", "busy", "conflicts", "book a meeting", "what's on my calendar", or discusses scheduling. Provides Google Calendar management via gogcli (`gog`).
version: 1.0.0
---

# Google Calendar Management with gogcli

Manage Google Calendar using the `gog` CLI tool.

**Default account:** mkbunday@gmail.com (override with `--account` if user specifies different)

## Viewing Events

**List today's events:**
```bash
gog calendar events --account=mkbunday@gmail.com --today
```

**List events for a specific day:**
```bash
# IMPORTANT: --to must be the NEXT day to capture all events on the target date
gog calendar events --account=mkbunday@gmail.com --from="YYYY-MM-DD" --to="YYYY-MM-DD+1"
```

**List upcoming events (next 7 days):**
```bash
gog calendar events --account=mkbunday@gmail.com --from="$(date +%Y-%m-%d)" --to="$(date -v+8d +%Y-%m-%d)"
```

**Search events:**
```bash
gog calendar events --account=mkbunday@gmail.com --query="SEARCH_TERM"
```

**List all calendars:**
```bash
gog calendar calendars --account=mkbunday@gmail.com
```

## Creating Events

**Create a timed event:**
```bash
gog calendar create primary --account=mkbunday@gmail.com --summary="EVENT_TITLE" --from="YYYY-MM-DDTHH:MM:SS" --to="YYYY-MM-DDTHH:MM:SS"
```

**Create all-day event:**
```bash
gog calendar create primary --account=mkbunday@gmail.com --summary="EVENT_TITLE" --from="YYYY-MM-DD" --to="YYYY-MM-DD" --all-day
```

**Create event with location:**
```bash
gog calendar create primary --account=mkbunday@gmail.com --summary="EVENT_TITLE" --from="YYYY-MM-DDTHH:MM:SS" --to="YYYY-MM-DDTHH:MM:SS" --location="Conference Room A"
```

**Create event with attendees:**
```bash
gog calendar create primary --account=mkbunday@gmail.com --summary="EVENT_TITLE" --from="YYYY-MM-DDTHH:MM:SS" --to="YYYY-MM-DDTHH:MM:SS" --attendees="person1@example.com,person2@example.com"
```

**Create event with description:**
```bash
gog calendar create primary --account=mkbunday@gmail.com --summary="EVENT_TITLE" --from="YYYY-MM-DDTHH:MM:SS" --to="YYYY-MM-DDTHH:MM:SS" --description="Meeting agenda and notes"
```

## Modifying Events

**Update an event:**
```bash
gog calendar update primary EVENT_ID --account=mkbunday@gmail.com --summary="NEW_TITLE"
```

**Delete an event:**
```bash
gog calendar delete primary EVENT_ID --account=mkbunday@gmail.com
```

**Respond to invitation:**
```bash
gog calendar respond primary EVENT_ID --account=mkbunday@gmail.com --status=accepted
gog calendar respond primary EVENT_ID --account=mkbunday@gmail.com --status=declined
gog calendar respond primary EVENT_ID --account=mkbunday@gmail.com --status=tentative
```

## Scheduling Helpers

**Check for conflicts:**
```bash
gog calendar conflicts --account=mkbunday@gmail.com
```

**Check free/busy time:**
```bash
gog calendar freebusy --account=mkbunday@gmail.com --from="YYYY-MM-DDTHH:MM:SS" --to="YYYY-MM-DDTHH:MM:SS"
```

**Create focus time:**
```bash
gog calendar focus-time --account=mkbunday@gmail.com --from="YYYY-MM-DDTHH:MM:SS" --to="YYYY-MM-DDTHH:MM:SS"
```

**Set out of office:**
```bash
gog calendar out-of-office --account=mkbunday@gmail.com --from="YYYY-MM-DD" --to="YYYY-MM-DD"
```

## Notes

- Use `primary` as the calendar ID for the main calendar
- Add `--json` flag for JSON output when needed for scripting
- Event times should be in ISO 8601 format (YYYY-MM-DDTHH:MM:SS)
- For all-day events, use date only format (YYYY-MM-DD)
- Event IDs are returned when listing events
- **Date range quirk:** The `--to` date is exclusive, so to get events for a single day, set `--to` to the following day (e.g., for Jan 30, use `--from="2026-01-30" --to="2026-01-31"`)
