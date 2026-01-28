---
name: wt-merge
description: Create a pull request from the current git worktree branch to its parent branch. Use when a user wants to merge their worktree feature branch back to the branch it was created from. Determines the parent branch from git config, asks the user if not found, then creates a PR for review.
metadata:
  short-description: Create PR from worktree to parent branch
---

# Worktree Merge (PR)

## Overview

Create a pull request from the current worktree's feature branch to its parent branch (the branch it was originally created from).

Parent branch info is stored in `git config branch.<branch>.parent`.

## Prerequisites

- Require GitHub CLI `gh`. Check `gh --version`. If missing, ask the user to install it.
- Require authenticated `gh` session. Run `gh auth status`. If not authenticated, ask the user to run `gh auth login`.
- Must be inside a git repository (can be a worktree).

## Workflow

1. **Verify environment**
   - Run `gh auth status` to confirm GitHub CLI is authenticated.
   - Run `git rev-parse --is-inside-work-tree` to confirm we're in a git repo.

2. **Get current branch**
   - Run `git branch --show-current` to get the current branch name.

3. **Determine parent branch**
   - Try to read parent from git config: `git config branch.<current-branch>.parent`
   - If parent is not set, ask the user which branch to merge into (common options: main, master, develop).
   - Confirm the parent branch exists: `git rev-parse --verify <parent-branch>`

4. **Check for uncommitted changes**
   - Run `git status --porcelain`
   - If there are uncommitted changes, warn the user and ask if they want to continue or commit first.

5. **Push current branch**
   - Ensure the current branch is pushed to remote: `git push -u origin $(git branch --show-current)`

6. **Show summary and ask for confirmation**
   - Display:
     - Current branch name
     - Parent/target branch name
     - Number of commits ahead of parent: `git rev-list --count <parent>..<current>`
     - Brief diff stat: `git diff --stat <parent>..HEAD`
   - Ask user to confirm before creating PR.

7. **Create pull request**
   - Run: `gh pr create --base <parent-branch> --head <current-branch> --fill`
   - If `--fill` produces poor results, use `--title` and `--body` with a summary of changes.
   - Output the PR URL to the user.

8. **Optionally save parent for future**
   - If parent was manually specified, offer to save it: `git config branch.<current-branch>.parent <parent-branch>`

## Example Usage

```
User: merge this worktree
Agent:
1. Checks current branch is `feat/auth-refactor`
2. Finds parent is `main` from git config
3. Shows: "Creating PR: feat/auth-refactor -> main (3 commits)"
4. Asks for confirmation
5. Creates PR and returns URL
```
