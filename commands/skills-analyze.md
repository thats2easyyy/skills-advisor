# Skills Analyze

Hybrid analysis of your project AND conversation history to identify patterns and recommend skills.

**IMPORTANT: This is analysis only. Do NOT execute any tasks, create any files, or take any actions. Only analyze and output recommendations.**

## Instructions

You will perform a hybrid analysis:
1. **THIS PROJECT** - git log + codebase scan for concrete, actionable recommendations
2. **ACROSS ALL PROJECTS** - conversation history for workflow patterns

---

## Part 1: THIS PROJECT Analysis

### Step 1.1: Git History Analysis

Run to see recent commit patterns:
```bash
git log --oneline -30
```

Look for:
- What types of changes happen frequently (feature, fix, refactor, test, docs)?
- Are there patterns in what gets committed together?
- Any repeated areas of the codebase being touched?

### Step 1.2: Codebase Structure Scan

Use file patterns to identify structural patterns:

**State management:**
```bash
find . -name "*.ts" -o -name "*.tsx" | xargs grep -l "create.*Store\|useStore\|createSlice" 2>/dev/null | head -20
```

**Component patterns:**
```bash
ls -la src/components/*/ 2>/dev/null || ls -la components/*/ 2>/dev/null || echo "No component dirs found"
```

**Configuration comments (design token sync, etc.):**
```bash
grep -r "Figma\|design.token\|sync" *.config.* 2>/dev/null | head -10
```

Look for:
- Repeated file structures (multiple stores, similar components)
- Configuration patterns that could be automated
- Areas where scaffolding would help

---

## Part 2: ACROSS ALL PROJECTS Analysis

### Step 2.1: Extract Conversation History

Run the extraction script to get prompts from the last 30 days:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/extract-history.sh
```

### Step 2.2: Analyze Patterns Semantically

Read through the extracted prompts and identify:

**Task Patterns:**
- What types of tasks appear multiple times?
- Look for semantic similarity, not just keywords
- "fix login bug" and "debug authentication issue" are the same pattern

**Workflow Patterns:**
- Multi-step processes that repeat
- Specific output formats requested multiple times
- Common tools or file types used

---

## Part 3: Cross-Reference with Skills Database

Read the skills database:
```
${CLAUDE_PLUGIN_ROOT}/data/skills-database.json
```

For each detected pattern, check if an existing skill matches:
- Match by description and tags, not just name
- Consider partial matches

---

## Part 4: Generate Output

Structure your analysis with TWO main sections:

1. **This Project** - Based on git log and codebase scan
2. **Across All Projects** - Based on conversation history

Each section should include:
- **Patterns detected** - Specific patterns with evidence (file counts, commit counts)
- **Existing skills that match** - Skills from the database that fit these patterns
- **Skills you should create** - Custom skills with `/skill-creator` commands

For skill creation suggestions, put each `/skill-creator` command on its own line for easy copy-paste.

---

## Important Notes

- **NO EXECUTION** - Only analyze and recommend. Do not create files or run tasks.
- Use semantic reasoning to identify patterns, not keyword matching
- Only surface patterns that appear 3+ times
- THIS PROJECT patterns should be concrete and actionable (specific files, counts)
- ACROSS ALL PROJECTS patterns show cross-project workflow habits
- Be specific about why a skill matches a pattern
