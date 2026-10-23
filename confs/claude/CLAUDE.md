# Personal preferences

## Branches, not worktrees

When a task requires writing to a codebase, create a new git branch in the
existing checkout. Do not create a git worktree (no `EnterWorktree`, no
`git worktree add`).

By default, branch off local `master`, after bringing it in sync with the
remote's `master`:

1. Fetch the remote and fast-forward local `master` to the remote's `master`.
   If local `master` has diverged (it has commits the remote lacks), stop and
   ask me rather than resetting or merging.
2. `git checkout -b <branch> master`.

Only branch off something else when I say to branch off an existing branch.

If another Claude session is currently writing to a branch in the same checkout,
wait for it to finish before switching branches or writing. Concurrent sessions
in one checkout clobber each other's uncommitted changes and branch state.

## Commit structure

When a multi-commit PR splits a mechanical refactor commit from a feature
commit, keep the feature commit purely additive. Behavior-preserving extractions
(helper extractions, dedup, moving code into helpers) that exist only to support
the new feature belong in the refactor commit, not the feature commit.

After any history surgery, verify the end tree is unchanged
(`git diff <safety-branch> HEAD` is empty) and that each commit builds on its
own.

## Pull requests

When opening a PR for the first time, open it as a draft and assign it to me
(`gh pr create --draft --assignee @me`).
