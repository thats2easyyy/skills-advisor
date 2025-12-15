# Skills Advisor

**Contextual skill recommendations for Claude Code**

Skills Advisor automatically suggests relevant Claude Code skills based on your project type. No more searching Twitter or Discord to find useful skills - they come to you.

## The Problem

Claude Code skills are powerful, but discovering them is hard:
- No centralized directory
- Word-of-mouth discovery only
- You have to already know what you're looking for
- Skills don't surface when they'd actually help

## The Solution

Skills Advisor uses a SessionStart hook to:
1. Detect your project type (React, Python, DevOps, etc.)
2. Match against a curated skills database
3. Show relevant recommendations automatically

**Like Neo in The Matrix** - the right capabilities are suggested based on context.

## Installation

```bash
/plugin install tylernishida/skills-advisor
```

## What You'll See

When you open Claude Code in a React project:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💡 Skills Advisor

📦 Project detected: Frontend (React/Vue/Angular)

🎯 Recommended skills for this project:

   • dev-browser
     Control a real browser for testing, screenshots, and web automation

   • frontend-design
     Guidance on typography, spacing, animations, and visual details

   • webapp-testing
     Automated testing for web applications with Playwright

📥 Install with: /plugin install [repo-name]

   Example: /plugin install AshkanAe/dev-browser

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Supported Project Types

| Project Type | Detection Signal |
|-------------|------------------|
| Frontend | package.json with react/vue/angular/svelte |
| Node.js Backend | package.json with express/fastify/koa |
| Python | requirements.txt, pyproject.toml, setup.py |
| DevOps | Dockerfile, docker-compose.yml, .github/workflows |
| Kubernetes | k8s/, kubernetes/, helm/, Chart.yaml |
| Documents | .docx, .xlsx, .pptx, .pdf files present |
| Skill Development | SKILL.md or .claude-plugin/ present |

## Commands

### `/skills-refresh`

Manually re-run skill suggestions. Useful if:
- You added new project files
- You want to see recommendations again
- Initial detection missed something

## Skills Database

The plugin includes a curated database of skills:

**Official (Anthropic):**
- docx, xlsx, pptx, pdf - Document handling
- skill-creator - Create new skills
- mcp-builder - Build MCP integrations

**Community:**
- dev-browser - Browser automation (Sawyer Hood)
- frontend-design - UI/UX patterns
- superpowers - TDD/debugging (Jesse Vincent)
- devops-automation-pack - CI/CD workflows
- kubernetes-operations - K8s management
- python-development - Python best practices

## Requirements

- `jq` must be installed for JSON parsing
- Claude Code with plugin support

## How It Works

```
SessionStart hook fires
       ↓
Script checks for project signals:
  - package.json dependencies
  - requirements.txt
  - Dockerfile
  - etc.
       ↓
Matches project type to skills database
       ↓
Outputs formatted recommendations
```

## Author

Tyler Nishida

## Why This Exists

Skills are Claude Code's superpower, but they're invisible. This plugin makes them discoverable by surfacing the right skills at the right time.

> "A directory solves WHERE. Context solves WHEN and WHY."
