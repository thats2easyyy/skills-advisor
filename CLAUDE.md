# Skills Advisor - Contextual Skill Recommendations

A Claude Code plugin that automatically suggests relevant skills based on your project context.

## The Vision

Remember The Matrix, when Neo plugs in and learns kung fu in seconds? "I know kung fu." Then he fights Morpheus and suddenly has capabilities he didn't have before.

That's what skills could be for Claude Code. Instant capability upgrades, triggered by context—not by browsing a catalog.

## The Design Principle

Alan Kay: "Simple things should be simple, complex things should be possible."

Claude Code has powerful structures for complex things: hooks, skills, agentic workflows. But that power should also make simple things simple. You shouldn't need to know what skills exist or remember to invoke them. The right capability should surface when it's relevant.

**The insight:** "A directory solves WHERE. It doesn't solve WHEN or WHY."

## Project Plans (Obsidian)

**Path:** `/Users/tyler/Desktop/notes/Projects/Skills Discovery/`

### The plan is the program

Plans are not documentation written before work. They ARE the work surface—where intent is shaped, execution is steered, and outcomes are judged. Maintain plans as living artifacts that coordinate between human and machine.

### What plans must be

1. **Reviewable** - A plan doesn't need to be complete to be useful. It needs to be inspectable and correctable. Write plans that invite adjustment.

2. **Legible** - Anyone reading the plan should understand the intent, even if they'd have written it differently. Clarity over cleverness.

3. **Atomic** - Plans can stand alone or nest inside other plans. They can be provisional (might be discarded) or durable (encode decisions that persist).

4. **Merge-aware** - When work splits into parallel tracks, the plan must describe how pieces come back together. Avoid "painted doors"—progress that looks productive but doesn't integrate.

### What to capture

Plans encode three things:

- **Intent** - What we're trying to achieve and why
- **Constraints** - What we can't do, what we're choosing not to do, and why
- **Decision history** - What was considered, what was chosen, what was learned

Traceability matters more than prediction. Capture what ran, what changed, what was reviewed—not estimates or points.

### The planning loop

Planning is a loop, not a phase:

```
Propose → Review → Execute → Observe → Refine → (repeat)
```

Update plans after execution reveals new information. A plan survives only as long as it remains useful.

### When to update plans

- **Before starting work** - Propose what you intend to do, so it can be reviewed
- **After significant execution** - Record what actually happened vs. what was planned
- **When direction changes** - Capture the pivot and why
- **When a question gets answered** - Move it from open to resolved with the decision

### Note format

```markdown
# [Number]-[topic].md

**Date:** YYYY-MM-DD
**Status:** [Proposed | In Progress | Resolved | Superseded]

## Intent
What are we trying to achieve and why does it matter?

## Current Plan
The reviewable, executable plan. Specific enough to act on.

## Constraints
What we're NOT doing and why.

## Decision Log
| Date | Decision | Rationale |
|------|----------|-----------|

## Open Questions
- [ ] Unresolved items that block or shape the plan

## Execution Notes
What actually happened. Deviations from plan. What we learned.
```

### Naming

Sequential: `05-topic.md`, `06-topic.md`. Check existing files for next number.

## Multi-Repo Coordination

This project evolved across multiple Claude Code sessions and repos:

| Repo | Purpose | Status |
|------|---------|--------|
| `skills-advisor` (this repo) | Contextual plugin - the main piece | Active |
| `skills-discovery` (in claude-code clone) | TUI directory - shows process evolution | Complete |
| `claude-code` clone | Official repo clone, plugin development workspace | Reference |

**Multiple Claude instances have worked on this.** The Obsidian notes tell the full story—from initial TUI prototype to the contextual pivot. When starting work:
- Read all existing notes first (00-09+)
- Continue the narrative by creating the next numbered note
- Check recent notes—another instance may have updated context

## How It Works

The plugin uses a SessionStart hook to:
- Detect project type automatically (React, Python, DevOps, etc.)
- Match against curated skills database
- Show relevant recommendations without user action

When you start Claude Code in a React project, you'll see frontend-related skills suggested. In a Python project, Python skills. The right tools for the job you're actually doing.

## Plugin Structure

```
skills-advisor/
├── .claude-plugin/
│   └── plugin.json         # Plugin metadata
├── hooks/
│   └── hooks.json          # SessionStart hook config
├── scripts/
│   └── suggest-skills.sh   # Detection and suggestion logic
├── data/
│   └── skills-database.json # Curated skills (14)
├── commands/
│   └── skills-refresh.md   # Manual trigger
└── README.md
```
