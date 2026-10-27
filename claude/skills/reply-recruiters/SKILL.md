---
name: reply-recruiters
description: Use when the user wants to reply to recruiter emails in bulk. Goes through both inboxes and drafts replies to all recruiter messages.
version: 1.0.0
---

# Reply to Recruiters

This skill drafts replies to recruiter emails across both inboxes.

## Accounts to Check

- mkbunday@gmail.com
- zenceph@gmail.com

## Process

1. **List all emails in both inboxes:**
   ```bash
   gog gmail search "label:inbox" --account=mkbunday@gmail.com --max=50
   ```
   ```bash
   gog gmail search "label:inbox" --account=zenceph@gmail.com --max=50
   ```

2. **Filter for recruiter emails locally:**
   - Review each email's sender and subject
   - Identify recruiter emails by:
     - Sender domains: linkedin.com, greenhouse.io, lever.co, ashbyhq.com, jobs.*, careers.*, talent.*, recruiting.*
     - Subject patterns: opportunity, role, position, hiring, recruiting, job, career, talent, candidate
     - Content indicating job outreach
   - Include any email that might be recruiter-related to avoid false negatives

3. **For each recruiter email identified:**
   - Read the full thread: `gog gmail thread get THREAD_ID --account=ACCOUNT --full`
   - Note the sender's first name, company, and role details
   - Read the template at `/Users/zen/mail/templates/recruiter.html`

4. **Compose personalized draft reply:**
   - Use the recruiter template structure
   - Fill in `{{ recipient.first_name }}` with the recruiter's first name
   - Fill in `{{ fit_analysis }}` with a personalized 1-2 sentence analysis of:
     - What sounds interesting about the role/company
     - Why it doesn't quite fit right now
   - Follow E-Prime (no forms of "to be")
   - Use "U" instead of "you" (keep "your" as-is)
   - Avoid the use of em-dashes
   - Create draft with: `gog gmail drafts create --account=ACCOUNT --to=SENDER --subject="Re: SUBJECT" --body-html="..." --reply-to-message-id=MESSAGE_ID`

5. **Report summary:**
   - List all drafts created with account, sender, and subject
   - Note any emails skipped and why

## Template Location

`/Users/zen/mail/templates/recruiter.html`

## Example Draft Creation

```bash
gog gmail drafts create --account=mkbunday@gmail.com \
  --to="recruiter@company.com" \
  --subject="Re: Exciting Opportunity at TechCorp" \
  --reply-to-message-id=MESSAGE_ID \
  --body-html='<p><a href="https://zencephalon.com/iluvu">ILUVU</a> Emma,</p>
<p>Thank U for reaching out! I appreciate U thinking of me.</p>
<p>TechCorp sounds like an interesting company—the focus on developer tools aligns with work I enjoy. However, the enterprise sales focus does not quite match my interests.</p>
<p><strong>I will pass for now.</strong> I feel happy with my role at Coinbase and I own a roadmap I want to see through.</p>
...'
```
