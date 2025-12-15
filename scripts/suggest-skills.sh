#!/bin/bash

# Skills Advisor - SessionStart Hook
# Detects project type and suggests relevant skills

set -e

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$0")")}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
DATABASE="$PLUGIN_ROOT/data/skills-database.json"

# Detect project types (can be multiple)
detect_project_types() {
    local types=()

    # Check for frontend frameworks (React, Vue, Angular, etc.)
    if [[ -f "$PROJECT_DIR/package.json" ]]; then
        if grep -qE '"(react|vue|angular|svelte|next|nuxt|vite)"' "$PROJECT_DIR/package.json" 2>/dev/null; then
            types+=("frontend")
        fi
        # Check for Node.js backend
        if grep -qE '"(express|fastify|koa|hapi|nest)"' "$PROJECT_DIR/package.json" 2>/dev/null; then
            types+=("node")
        fi
        # If package.json but no specific framework, general development
        if [[ ${#types[@]} -eq 0 ]]; then
            types+=("development")
        fi
    fi

    # Check for Python
    if [[ -f "$PROJECT_DIR/requirements.txt" ]] || \
       [[ -f "$PROJECT_DIR/pyproject.toml" ]] || \
       [[ -f "$PROJECT_DIR/setup.py" ]] || \
       [[ -f "$PROJECT_DIR/Pipfile" ]]; then
        types+=("python")
    fi

    # Check for DevOps
    if [[ -f "$PROJECT_DIR/Dockerfile" ]] || \
       [[ -f "$PROJECT_DIR/docker-compose.yml" ]] || \
       [[ -f "$PROJECT_DIR/docker-compose.yaml" ]] || \
       [[ -d "$PROJECT_DIR/.github/workflows" ]]; then
        types+=("devops")
    fi

    # Check for Kubernetes
    if [[ -d "$PROJECT_DIR/k8s" ]] || \
       [[ -d "$PROJECT_DIR/kubernetes" ]] || \
       [[ -d "$PROJECT_DIR/helm" ]] || \
       [[ -f "$PROJECT_DIR/Chart.yaml" ]]; then
        types+=("kubernetes")
    fi

    # Check for skill/plugin development
    if [[ -f "$PROJECT_DIR/SKILL.md" ]] || \
       [[ -d "$PROJECT_DIR/.claude-plugin" ]]; then
        types+=("skill-dev")
    fi

    # Check for documents
    if ls "$PROJECT_DIR"/*.docx "$PROJECT_DIR"/*.xlsx "$PROJECT_DIR"/*.pptx "$PROJECT_DIR"/*.pdf 2>/dev/null | head -1 > /dev/null; then
        types+=("documents")
    fi

    # Return unique types
    printf '%s\n' "${types[@]}" | sort -u
}

# Get skills for a project type from database
get_skills_for_type() {
    local type="$1"

    if [[ ! -f "$DATABASE" ]]; then
        return
    fi

    # Use jq if available, otherwise fall back to grep
    if command -v jq &> /dev/null; then
        jq -r --arg type "$type" '.projectTypeMapping[$type] // [] | .[]' "$DATABASE" 2>/dev/null
    fi
}

# Get skill details from database
get_skill_details() {
    local skill_name="$1"

    if command -v jq &> /dev/null && [[ -f "$DATABASE" ]]; then
        jq -r --arg name "$skill_name" '.skills[] | select(.name == $name) | "\(.name)|\(.description)|\(.repo)"' "$DATABASE" 2>/dev/null
    fi
}

# Format project type for display
format_project_type() {
    local type="$1"
    case "$type" in
        frontend) echo "Frontend (React/Vue/Angular)" ;;
        node) echo "Node.js Backend" ;;
        python) echo "Python" ;;
        devops) echo "DevOps/Docker" ;;
        kubernetes) echo "Kubernetes" ;;
        documents) echo "Documents" ;;
        skill-dev) echo "Skill/Plugin Development" ;;
        development) echo "Development" ;;
        *) echo "$type" ;;
    esac
}

# Main execution
main() {
    # Check for jq (required for JSON parsing)
    if ! command -v jq &> /dev/null; then
        echo "⚠️  Skills Advisor: jq not found, suggestions disabled"
        exit 0
    fi

    # Detect project types
    local project_types
    project_types=$(detect_project_types)

    if [[ -z "$project_types" ]]; then
        # No specific project type detected, show general message
        echo ""
        echo "💡 Skills Advisor"
        echo "   No specific project type detected."
        echo "   Run /skills-refresh after adding project files."
        echo ""
        exit 0
    fi

    # Collect all recommended skills (deduplicated)
    local all_skills=()
    local type_names=()

    while IFS= read -r type; do
        [[ -z "$type" ]] && continue
        type_names+=("$(format_project_type "$type")")

        while IFS= read -r skill; do
            [[ -z "$skill" ]] && continue
            # Add to array if not already present
            if [[ ! " ${all_skills[*]} " =~ " ${skill} " ]]; then
                all_skills+=("$skill")
            fi
        done <<< "$(get_skills_for_type "$type")"
    done <<< "$project_types"

    # Output suggestions
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 Skills Advisor"
    echo ""
    echo "📦 Project detected: ${type_names[*]}"
    echo ""

    if [[ ${#all_skills[@]} -gt 0 ]]; then
        echo "🎯 Recommended skills for this project:"
        echo ""

        for skill in "${all_skills[@]}"; do
            local details
            details=$(get_skill_details "$skill")
            if [[ -n "$details" ]]; then
                local name desc repo
                IFS='|' read -r name desc repo <<< "$details"
                echo "   • $name"
                echo "     $desc"
                echo ""
            fi
        done

        echo "📥 Install with: /plugin install [repo-name]"
        echo ""
        echo "   Example: /plugin install AshkanAe/dev-browser"
    else
        echo "   No specific skill recommendations for this project type."
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

main "$@"
