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

Format your analysis with TWO sections. Use plain text only inside the box (no markdown like **bold**).

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Skills Analysis

📂 THIS PROJECT:

   Patterns detected:
   • [Pattern] (specific files/counts)
   • [Pattern] (specific files/counts)

   Existing skills that match:
   [skill-name] - [why it matches]
   [skill-name] - [why it matches]

   Skills you should create (copy and paste):

   "[skill-name]"
   /skill-creator "[Concise description with specific files and what to automate]"

   "[skill-name]"
   /skill-creator "[Concise description]"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌐 ACROSS ALL PROJECTS:

   Patterns detected:
   • [Pattern] (N times)
   • [Pattern] (N times)

   Existing skills that match:
   [skill-name] - [why it matches]

   Skills you should create (copy and paste):

   "[skill-name]"
   /skill-creator "[Concise workflow description]"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Important Notes

- **NO EXECUTION** - Only analyze and recommend. Do not create files or run tasks.
- Use semantic reasoning to identify patterns, not keyword matching
- Only surface patterns that appear 3+ times
- THIS PROJECT patterns should be concrete and actionable (specific files, counts)
- ACROSS ALL PROJECTS patterns show cross-project workflow habits
- Be specific about why a skill matches a pattern
- For skill creation suggestions, put the `/skill-creator` command on its own line (no "Run:" prefix) so users can easily copy it
- Keep descriptions concise - one line when possible
