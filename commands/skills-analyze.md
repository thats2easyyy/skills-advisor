# Skills Analyze

Analyze conversation history to identify patterns and recommend skills.

## Instructions

You will analyze the user's conversation history to:
1. Identify repeated patterns and workflows
2. Recommend existing skills that match their patterns
3. Suggest skills they should create for patterns without existing solutions

### Step 1: Extract History

Run the extraction script to get the user's prompts from the last 30 days:

```bash
bash $PLUGIN_ROOT/scripts/extract-history.sh
```

### Step 2: Analyze Patterns

Read through the extracted prompts and identify:

**Task Patterns:**
- What types of tasks appear multiple times?
- Look for semantic similarity, not just keywords
- Examples: bug fixing, feature implementation, testing, documentation, git/PR workflows

**Workflow Patterns:**
- Multi-step processes that repeat
- Specific output formats requested multiple times
- Common file types or tools used

**Skill-Worthy Candidates:**
A pattern is skill-worthy if:
- It appears 3+ times
- It involves multiple steps or specific requirements
- It could benefit from standardized instructions

### Step 3: Cross-Reference Skills

Read the skills database:
```
$PLUGIN_ROOT/data/skills-database.json
```

For each detected pattern, check if an existing skill matches:
- Match by description and tags, not just name
- Consider partial matches

### Step 4: Generate Output

Format your analysis as:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Skills Analysis

Based on your last 30 days of work:

📊 Your patterns:
   • [Pattern 1] (N times)
   • [Pattern 2] (N times)
   • [Pattern 3] (N times)

💡 Recommended skills:
   [skill-name] - [why it matches your patterns]
   [skill-name] - [why it matches your patterns]

🛠️ Skills you should create:
   • "[Suggested skill name]" - [Description of the pattern]
   • "[Suggested skill name]" - [Description of the pattern]

   Use skill-creator to build these.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Important Notes

- Use semantic reasoning to identify patterns, not keyword matching
- "fix login bug" and "debug authentication issue" are the same pattern
- Only surface patterns that appear 3+ times
- Be specific about why a skill matches a pattern
- For skill creation suggestions, explain what the skill would do
