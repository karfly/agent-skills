#!/bin/bash
# Worktree helper functions for .zshrc or .bashrc
# Source this file or copy the functions to your shell config

# Create worktree with a new feature branch
# Usage: wt <feature-name>
# Example: wt auth-refactor
#   - Creates branch: feat/auth-refactor
#   - Creates worktree: ../repo-wt-auth-refactor
#   - Stores parent branch in git config
#   - cd's into the new worktree
wt() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "Error: Not in a git repository"
        return 1
    fi

    if [[ -z "$1" ]]; then
        echo "Usage: wt <feature-name>"
        return 1
    fi

    local feature_name="$1"
    local branch_name="feat/${feature_name}"
    local current_branch=$(git branch --show-current)
    local repo_root=$(git rev-parse --show-toplevel)
    local repo_name=$(basename "$repo_root")
    local worktree_path="$(dirname "$repo_root")/${repo_name}-wt-${feature_name}"

    # Create worktree with new branch from current
    git worktree add -b "$branch_name" "$worktree_path"

    if [[ $? -eq 0 ]]; then
        # Store parent branch in git config for future reference
        git -C "$worktree_path" config branch."$branch_name".parent "$current_branch"

        cd "$worktree_path"
        echo "Created: $worktree_path"
        echo "Branch: $branch_name (parent: $current_branch)"
    fi
}

# Show parent branch (where to merge back)
# Usage: wt-parent
# Returns the parent branch name stored when the worktree was created
wt-parent() {
    local branch=$(git branch --show-current)
    local parent=$(git config branch."$branch".parent)

    if [[ -n "$parent" ]]; then
        echo "$parent"
    else
        echo "Parent branch not found for $branch"
        return 1
    fi
}

# List all worktrees
# Usage: wt-list
wt-list() {
    git worktree list
}

# Remove a worktree and optionally its branch
# Usage: wt-remove <worktree-path> [--delete-branch]
wt-remove() {
    if [[ -z "$1" ]]; then
        echo "Usage: wt-remove <worktree-path> [--delete-branch]"
        return 1
    fi

    local worktree_path="$1"
    local delete_branch="$2"

    # Get branch name before removing worktree
    local branch=$(git -C "$worktree_path" branch --show-current 2>/dev/null)

    git worktree remove "$worktree_path"

    if [[ $? -eq 0 && "$delete_branch" == "--delete-branch" && -n "$branch" ]]; then
        git branch -d "$branch"
        echo "Deleted branch: $branch"
    fi
}
