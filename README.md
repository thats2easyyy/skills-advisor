# Skills Advisor

**Contextual skill discovery and workflow coaching for Claude Code**

Skills Advisor brings skill discovery INTO your workflow. It suggests relevant skills based on your project AND recognizes when you should create new ones.

## Two Modes

### 1. Discovery Mode (SessionStart)

Automatically suggests relevant skills when you start Claude Code:

```
Skills Advisor

Detected: Frontend (React/Vue/Angular)

Recommended for this project:

   webapp-testing           21k
   dev-browser              500
   playwright-skill         901

Popular skills:

   agents                   22.8k
   superpowers              9.8k
   claude-mem               6.3k

Install: /plugin install [repo]
Browse:  /skills-explore
```

### 2. Coaching Mode (During Conversation)

Recognizes when you're describing a repeatable workflow and suggests creating a skill:

> "I noticed this looks like a repeatable workflow. If you do this regularly, I can help package it as a reusable skill."

**Trigger signals:**
- "like I always do" / "as usual" / "every time"
- Template uploads with "use this format"
- Multi-step instructions with specific output requirements
- Consistent correction patterns ("always put X first")

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
