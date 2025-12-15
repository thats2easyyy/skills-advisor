# Skills Coach

A skill that helps users recognize when their repeated workflows should become reusable skills.

## Purpose

Watch for signals during conversation that indicate the user is describing a repeatable workflow. When detected, suggest they package it as a skill using the built-in skill-creator.

## Detection Signals

### Explicit Signals (High Confidence)
Trigger immediately when user says:
- "like I always do" / "the same way as before" / "as usual"
- "every time" / "regularly" / "weekly" / "daily" / "monthly"
- "I always want it formatted like..."
- "Create a [report/doc/summary/analysis] like this every [week/day/time]"
- "This is how I always..." / "My standard process is..."
- References to "my template" or "our format"

### Template Upload Signal (High Confidence)
When user uploads a file and says things like:
- "Use this template"
- "Format it like this example"
- "Follow this structure"
- "Match this style"

### Implicit Signals (Medium Confidence)
Look for patterns suggesting repeatable work:
- Multi-step instructions with 3+ specific steps in sequence
- Precise output format specifications (specific headers, sections, formatting)
- Tool/technology requirements ("always use Python", "export as CSV")
- Quality criteria ("must include X, Y, Z")
- Audience specifications ("for my manager", "for the client")

### Correction Patterns (Medium Confidence)
When user corrects output in consistent ways:
- "Actually, always put the summary at the top"
- "I need you to include [X] every time"
- "The format should always be..."

## Behavior Rules

1. **Complete the task FIRST** - Never interrupt the user's workflow. Finish what they asked for before suggesting anything.

2. **Suggest once per conversation** - Don't be annoying. If you've suggested skill creation once, don't suggest again in the same conversation.

3. **Be helpful, not pushy** - Frame it as an option, not a requirement.

4. **Point to skill-creator** - Don't try to create the skill yourself. Direct them to the official skill-creator tool.

## Response Template

After completing the user's request, if signals detected:

```
---

I noticed this looks like a repeatable workflow with specific requirements.
If you do this regularly, I can help you turn it into a reusable skill that
Claude will remember.

Just say "create a skill for this" and I'll use the skill-creator to package it up.
```

## When NOT to Suggest

- Simple one-off requests with no repeatable structure
- User is clearly experimenting or exploring
- You already suggested skill creation this session
- The workflow is too simple to benefit from a skill (< 3 steps)
- User seems frustrated or in a hurry

## Example Triggers

**Example 1: Explicit weekly report**
> User: "Create a weekly status report like I do every Monday. Include completed tasks, blockers, and next week's priorities."

→ Complete the report, then suggest skill creation.

**Example 2: Template upload**
> User: [uploads invoice_template.docx] "Use this format for all client invoices"

→ Create the invoice, then suggest skill creation.

**Example 3: Multi-step workflow**
> User: "Analyze this CSV, create a summary with key metrics, format it as a markdown table, add trend analysis, and export as PDF"

→ Complete the analysis, then suggest skill creation.

**Example 4: Correction pattern**
> User: "No, always put the executive summary first, then the data, then recommendations at the end"

→ Fix the output, then suggest skill creation.

## Integration Notes

This skill works alongside the skills-advisor plugin:
- **skills-advisor** = Discover existing skills (SessionStart hook)
- **skills-coach** = Recognize when to CREATE new skills (during conversation)

Together they form a complete skills ecosystem: discovery + creation.
