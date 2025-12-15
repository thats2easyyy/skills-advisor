#!/bin/bash

# Skills Advisor - SessionStart Hook
# Detects project type and suggests relevant skills with installation status

set -e

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$0")")}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
DATABASE="$PLUGIN_ROOT/data/skills-database.json"
PLUGINS_DIR="${HOME}/.claude/plugins"

# Format star count (e.g., 22800 -> 22.8k)
format_stars() {
    local stars="$1"
    if [[ $stars -ge 1000 ]]; then
        local k=$((stars / 100))
        local decimal=$((k % 10))
        local whole=$((k / 10))
        if [[ $decimal -eq 0 ]]; then
            echo "${whole}k"
        else
            echo "${whole}.${decimal}k"
        fi
    else
        echo "$stars"
    fi
}

# Check if a skill/plugin is installed
is_installed() {
    local skill_name="$1"
    local repo="$2"

    # Check by skill name in plugins directory
    if [[ -d "$PLUGINS_DIR/$skill_name" ]]; then
        return 0
    fi

    # Check by repo name (last part of repo path)
    local repo_name="${repo##*/}"
    if [[ -d "$PLUGINS_DIR/$repo_name" ]]; then
        return 0
    fi

    # Check in skills directory
    if [[ -d "${HOME}/.claude/skills/$skill_name" ]]; then
        return 0
    fi

    return 1
}

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

    # Check for mobile/iOS
    if [[ -d "$PROJECT_DIR/ios" ]] || \
       [[ -d "$PROJECT_DIR/android" ]] || \
       ls "$PROJECT_DIR"/*.xcodeproj 2>/dev/null | head -1 > /dev/null || \
       ls "$PROJECT_DIR"/*.xcworkspace 2>/dev/null | head -1 > /dev/null; then
        types+=("mobile")
    fi

    # Check for database projects
    if [[ -f "$PROJECT_DIR/schema.sql" ]] || \
       [[ -d "$PROJECT_DIR/migrations" ]] || \
       ls "$PROJECT_DIR"/*.prisma 2>/dev/null | head -1 > /dev/null; then
        types+=("database")
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

    if command -v jq &> /dev/null; then
        jq -r --arg type "$type" '.projectTypeMapping[$type] // [] | .[]' "$DATABASE" 2>/dev/null
    fi
}

# Get skill details from database
get_skill_details() {
    local skill_name="$1"

    if command -v jq &> /dev/null && [[ -f "$DATABASE" ]]; then
        jq -r --arg name "$skill_name" '.skills[] | select(.name == $name) | "\(.name)|\(.description)|\(.repo)|\(.stars)|\(.tier)"' "$DATABASE" 2>/dev/null
    fi
}

# Get popular skills
get_popular_skills() {
    if command -v jq &> /dev/null && [[ -f "$DATABASE" ]]; then
        jq -r '.popularSkills[]' "$DATABASE" 2>/dev/null
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
        mobile) echo "Mobile/iOS" ;;
        database) echo "Database" ;;
        *) echo "$type" ;;
    esac
}

# Print a skill line with status and stars
print_skill_line() {
    local name="$1"
    local stars="$2"
    local repo="$3"

    if is_installed "$name" "$repo"; then
        printf "   ⚡ %-22s ★ %-6s (installed)\n" "$name" "$(format_stars "$stars")"
    else
        printf "   📥 %-22s ★ %-6s\n" "$name" "$(format_stars "$stars")"
    fi
}

# Main execution
main() {
    # Check for jq (required for JSON parsing)
    if ! command -v jq &> /dev/null; then
        echo ""
        echo "Skills Advisor: jq not found, suggestions disabled"
        exit 0
    fi

    # Detect project types
    local project_types
    project_types=$(detect_project_types)

    if [[ -z "$project_types" ]]; then
        # No specific project type detected, show popular skills only
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "💡 Skills Advisor"
        echo ""
        echo "   No specific project type detected."
        echo ""
        echo "🔥 Popular skills:"
        echo ""
        while IFS= read -r skill; do
            [[ -z "$skill" ]] && continue
            local details
            details=$(get_skill_details "$skill")
            if [[ -n "$details" ]]; then
                local name desc repo stars tier
                IFS='|' read -r name desc repo stars tier <<< "$details"
                print_skill_line "$name" "$stars" "$repo"
            fi
        done <<< "$(get_popular_skills)"
        echo ""
        echo "   Run /skills-refresh after adding project files."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
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
    echo "📦 Detected: ${type_names[*]}"
    echo ""

    if [[ ${#all_skills[@]} -gt 0 ]]; then
        echo "🎯 Recommended for this project:"
        echo ""

        # Limit to top 5 recommendations
        local count=0
        for skill in "${all_skills[@]}"; do
            [[ $count -ge 5 ]] && break
            local details
            details=$(get_skill_details "$skill")
            if [[ -n "$details" ]]; then
                local name desc repo stars tier
                IFS='|' read -r name desc repo stars tier <<< "$details"
                print_skill_line "$name" "$stars" "$repo"
                ((count++))
            fi
        done
        echo ""
    fi

    # Show popular skills (excluding already recommended)
    echo "🔥 Popular skills:"
    echo ""
    local pop_count=0
    while IFS= read -r skill; do
        [[ -z "$skill" ]] && continue
        [[ $pop_count -ge 3 ]] && break
        # Skip if already in recommendations
        if [[ " ${all_skills[*]} " =~ " ${skill} " ]]; then
            continue
        fi
        local details
        details=$(get_skill_details "$skill")
        if [[ -n "$details" ]]; then
            local name desc repo stars tier
            IFS='|' read -r name desc repo stars tier <<< "$details"
            print_skill_line "$name" "$stars" "$repo"
            ((pop_count++))
        fi
    done <<< "$(get_popular_skills)"
    echo ""

    echo "   Install: /plugin install [repo]"
    echo "   Browse:  /skills-explore"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

main "$@"
