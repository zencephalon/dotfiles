---
name: send-drafts
description: Sends all drafted replies for emails still in the inbox, then archives those threads. Use after reviewing drafts created by /reply-recruiters.
version: 1.0.0
---

# Send Drafts and Archive

This skill sends drafted replies and archives the original threads.

## Accounts to Check

- mkbunday@gmail.com
- zenceph@gmail.com

## Process

1. **List all drafts for both accounts:**
   ```bash
   gog gmail drafts list --account=mkbunday@gmail.com
   ```
   ```bash
   gog gmail drafts list --account=zenceph@gmail.com
   ```

2. **For each draft found:**
   - Note the draft ID and thread ID
   - Check if the thread is still in the inbox by examining thread labels
   - If the thread has the INBOX label, proceed; otherwise skip

3. **Send the draft:**
   ```bash
   gog gmail drafts send DRAFT_ID --account=ACCOUNT
   ```

4. **Archive the thread (remove from inbox):**
   ```bash
   gog gmail thread modify THREAD_ID --account=ACCOUNT --remove="INBOX"
   ```

5. **Report summary:**
   - List all drafts sent with recipient and subject
   - List all threads archived
   - Note any drafts skipped (thread not in inbox) and why

## Safety

- Only sends drafts where the original thread is still in the inbox
- This prevents accidentally sending replies to already-handled emails
- Review drafts in Gmail before running this command if unsure

## Example Output

```
Sent 3 drafts and archived 3 threads:

mkbunday@gmail.com:
  - Sent reply to Emma Bennett (Salient AI) - archived thread
  - Sent reply to John Smith (Acme Corp) - archived thread

zenceph@gmail.com:
  - Sent reply to Sarah Jones (TechStartup) - archived thread

Skipped 1 draft:
  - Draft to Mike Lee - thread no longer in inbox
```
