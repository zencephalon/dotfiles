---
name: gmail
description: This skill should be used when the user asks to "check email", "read emails", "send email", "search emails", "manage inbox", "find messages", "draft email", "reply to email", discusses Gmail, or mentions unread messages. Provides Gmail management via gogcli (`gog`).
version: 1.0.0
---

# Gmail Management with gogcli

Manage Gmail using the `gog` CLI tool.

**Default account:** mkbunday@gmail.com (override with `--account` if user specifies different)

## Searching Email

**Search recent emails:**
```bash
gog gmail search 'newer_than:1d' --account=mkbunday@gmail.com
```

**Search by sender:**
```bash
gog gmail search 'from:someone@example.com' --account=mkbunday@gmail.com
```

**Search by subject:**
```bash
gog gmail search 'subject:meeting' --account=mkbunday@gmail.com
```

**Search unread messages:**
```bash
gog gmail search 'is:unread' --account=mkbunday@gmail.com
```

**Search in specific label/folder:**
```bash
gog gmail search 'in:inbox is:unread' --account=mkbunday@gmail.com
```

**Search with multiple criteria:**
```bash
gog gmail search 'from:boss@company.com newer_than:7d has:attachment' --account=mkbunday@gmail.com
```

**Limit results:**
```bash
gog gmail search 'is:unread' --account=mkbunday@gmail.com --max=10
```

## Reading Email Content

**Get thread details (full conversation):**
```bash
gog gmail thread THREAD_ID --account=mkbunday@gmail.com
```

Note: Use the thread ID from search results to read full message content. There is no separate "messages get" command.

## Sending Email

**Send a simple email:**
```bash
gog gmail send --account=mkbunday@gmail.com --to="recipient@example.com" --subject="Subject line" --body="Email body text"
```

**Send with CC/BCC:**
```bash
gog gmail send --account=mkbunday@gmail.com --to="recipient@example.com" --cc="cc@example.com" --bcc="bcc@example.com" --subject="Subject" --body="Body"
```

**Send HTML email:**
```bash
gog gmail send --account=mkbunday@gmail.com --to="recipient@example.com" --subject="Subject" --body-html="<h1>HTML content</h1>"
```

**Send with attachment:**
```bash
gog gmail send --account=mkbunday@gmail.com --to="recipient@example.com" --subject="Subject" --body="See attached" --attach="/path/to/file.pdf"
```

**Reply to a thread:**
```bash
gog gmail send --account=mkbunday@gmail.com --to="recipient@example.com" --subject="Re: Original Subject" --body="Reply text" --thread=THREAD_ID
```

## Managing Labels

**List all labels:**
```bash
gog gmail labels list --account=mkbunday@gmail.com
```

**Add label to thread:**
```bash
gog gmail thread modify THREAD_ID --account=mkbunday@gmail.com --add="LABEL_NAME"
```

**Remove label from thread:**
```bash
gog gmail thread modify THREAD_ID --account=mkbunday@gmail.com --remove="LABEL_NAME"
```

**Mark as read:**
```bash
gog gmail thread modify THREAD_ID --account=mkbunday@gmail.com --remove="UNREAD"
```

**Mark as unread:**
```bash
gog gmail thread modify THREAD_ID --account=mkbunday@gmail.com --add="UNREAD"
```

**Archive thread (remove from inbox):**
```bash
gog gmail thread modify THREAD_ID --account=mkbunday@gmail.com --remove="INBOX"
```

**Move to trash:**
```bash
gog gmail messages trash MESSAGE_ID --account=mkbunday@gmail.com
```

## Draft Management

**Create draft:**
```bash
gog gmail drafts create --account=mkbunday@gmail.com --to="recipient@example.com" --subject="Draft subject" --body="Draft content"
```

**Create HTML draft:**
```bash
gog gmail drafts create --account=mkbunday@gmail.com --to="recipient@example.com" --subject="Draft subject" --body-html="<p>HTML content</p>"
```

**Create draft reply to existing thread:**
```bash
gog gmail drafts create --account=mkbunday@gmail.com --to="recipient@example.com" --subject="Re: Original Subject" --body="Reply text" --reply-to-message-id=MESSAGE_ID
```

**List drafts:**
```bash
gog gmail drafts list --account=mkbunday@gmail.com
```

**Send draft:**
```bash
gog gmail drafts send DRAFT_ID --account=mkbunday@gmail.com
```

## Common Search Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `from:` | Sender address | `from:john@example.com` |
| `to:` | Recipient address | `to:me@example.com` |
| `subject:` | Subject contains | `subject:invoice` |
| `has:attachment` | Has attachment | `has:attachment` |
| `filename:` | Attachment name | `filename:report.pdf` |
| `is:unread` | Unread messages | `is:unread` |
| `is:starred` | Starred messages | `is:starred` |
| `is:important` | Important messages | `is:important` |
| `in:inbox` | In inbox | `in:inbox` |
| `in:sent` | Sent messages | `in:sent` |
| `in:trash` | Trashed messages | `in:trash` |
| `in:spam` | Spam messages | `in:spam` |
| `newer_than:` | Recent messages | `newer_than:2d` (days), `newer_than:1w` (weeks) |
| `older_than:` | Older messages | `older_than:1m` (months), `older_than:1y` (years) |
| `after:` | After date | `after:2024/01/01` |
| `before:` | Before date | `before:2024/12/31` |
| `larger:` | Size larger than | `larger:5M` |
| `smaller:` | Size smaller than | `smaller:1M` |

## Notes

- Add `--json` flag for JSON output when parsing results programmatically
- Thread IDs and Message IDs are returned in search results
- Use `--max=N` to limit the number of results returned
- Combine search operators with spaces (AND) or `OR` keyword
- Wrap phrases in quotes: `subject:"weekly report"`
