# Skills Advisor

**Contextual skill discovery and workflow coaching for Claude Code**

Skills Advisor brings skill discovery INTO your workflow. It suggests relevant skills based on your project AND recognizes when you should create new ones.

## Two Modes

### 1. Discovery Mode (`/skills-refresh`)

Suggests relevant skills based on your project type:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Skills Discovery

   Detected: Frontend (React/Vue/Angular)

   Recommended for this project:
   webapp-testing - 21k stars
   dev-browser (installed) - 500 stars

   Popular skills:
   superpowers - 9.8k stars
   agents - 22.8k stars

   Install: /plugin install [repo]
   Browse:  /skills-explore
   Analyze: /skills-analyze
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 2. Hybrid Analysis Mode (`/skills-analyze`)

Combines project-specific analysis with cross-project patterns:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Skills Analysis

📂 THIS PROJECT:

   Patterns detected:
   • 5 Zustand stores (task, chat, credit, user, memory)
   • 8 interactive cards in src/components/interactive/
   • Figma token sync comments in tailwind.config.js

   Existing skills that match:
   • webapp-testing - for your component testing patterns

   Skills you should create:
   • "Zustand Store Generator" - scaffold stores following your pattern
   • "Interactive Component Scaffolder" - 8 cards share structure

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌐 ACROSS ALL PROJECTS:

   Patterns detected:
   • Bug fixing (23 times)
   • Local testing workflows (15 times)
   • PR creation (12 times)

   Existing skills that match:
   • superpowers - matches debugging patterns
   • webapp-testing - matches testing patterns

   Skills you should create:
   • "Weekly status report" - done 4 times with similar format

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Why hybrid?**
- **THIS PROJECT** analyzes git log and codebase for concrete, actionable recommendations
- **ACROSS ALL PROJECTS** analyzes conversation history for workflow patterns

Neither alone is complete. Conversation history shows HOW you work. Git/codebase shows WHAT you've built.

## Installation

```bash
/plugin install thats2easyyy/skills-advisor
```

## What You Get

| Feature | What It Does |
|---------|-------------|
| **Project detection** | Identifies React, Python, DevOps, K8s, mobile, and more |
| **Smart recommendations** | Skills matched to your actual project type |
| **Installation status** | See which skills you already have |
| **Star counts** | Know which skills are popular |
| **Popular skills section** | Trending skills regardless of project |
| **Workflow coaching** | Recognizes when to suggest skill creation |

## Commands

### `/skills-refresh`
Re-run skill detection and recommendations.

### `/skills-explore`
Browse the full skills catalog with filtering by category or keyword.

## Supported Project Types

| Type | Detection |
|------|-----------|
| Frontend | package.json with react/vue/angular/svelte/next |
| Node.js | package.json with express/fastify/koa/nest |
| Python | requirements.txt, pyproject.toml, setup.py, Pipfile |
| DevOps | Dockerfile, docker-compose.yml, .github/workflows |
| Kubernetes | k8s/, helm/, Chart.yaml |
| Mobile | ios/, android/, .xcodeproj |
| Database | schema.sql, migrations/, .prisma |
| Documents | .docx, .xlsx, .pptx, .pdf files |
| Skill Dev | SKILL.md, .claude-plugin/ |

## Skills Database

**25 curated skills** across tiers:

**Official (Anthropic):**
- pdf, docx, xlsx, pptx - Document handling
- webapp-testing - Playwright E2E testing
- skill-creator - Create new skills
- mcp-builder - Build MCP servers
- algorithmic-art, canvas-design - Creative tools

**Featured (Community Favorites):**
- superpowers (9.8k) - TDD, debugging, brainstorming
- agents (22.8k) - Multi-agent orchestration
- claude-mem (6.3k) - Persistent memory

**Community:**
- playwright-skill, ios-simulator-skill, pg-aiguide
- coderunner, claude-hooks, and more

## Requirements

- `jq` for JSON parsing
- Claude Code with plugin support

## The Philosophy

> "Skills are Claude's superpower, but discovery is broken."

skillsmp.com exists but it's external - you have to know to go looking. Skills Advisor brings discovery INTO the workflow.

**Discovery tells you WHAT exists. Coaching tells you WHAT SHOULD exist.**

## Author

Tyler Nishida
