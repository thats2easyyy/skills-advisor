# Skills Explore

Browse the full skills catalog with filtering options.

## Instructions

Read the skills database at `$PLUGIN_ROOT/data/skills-database.json` and present skills in an organized way.

### Display Format

Group skills by tier:

**Official (Anthropic)**
- Show all skills with tier "official"
- These are maintained by Anthropic and highly recommended

**Featured (Community Favorites)**
- Show skills with tier "featured"
- High-quality community skills with significant usage

**Community**
- Show skills with tier "community"
- Useful skills from the broader community

### For Each Skill Show

```
[name] - [description]
  repo: [repo]  |  stars: [formatted_stars]  |  [installed/not installed]
```

### Installation Status

Check if installed by looking for the skill in:
- `~/.claude/plugins/[skill-name]`
- `~/.claude/plugins/[repo-name]`
- `~/.claude/skills/[skill-name]`

### Filtering

If the user provides a category or keyword, filter the results:
- Category matches: projectTypes array
- Keyword matches: name, description, or tags

### Example Output

```
Skills Catalog

OFFICIAL (Anthropic)
  pdf - Read and analyze PDF documents
    anthropics/skills  |  21k  |  installed

  docx - Read and analyze Word documents
    anthropics/skills  |  21k

  ...

FEATURED
  superpowers - TDD workflows, debugging, and collaboration patterns
    obra/superpowers  |  9.8k

  agents - Multi-agent orchestration and coordination
    wshobson/agents  |  22.8k  |  installed

  ...

COMMUNITY
  playwright-skill - Advanced Playwright testing patterns
    lackeyjb/playwright-skill  |  901

  ...

Total: 25 skills (3 installed)

Install: /plugin install [owner/repo]
```

### Interactive Options

After showing the catalog, offer:
- "Show only [category]" - Filter by project type
- "Search for [keyword]" - Search skills
- "Show details for [skill]" - Full info on one skill
