---
name: polish-pr
description: Polish a drafted PR unattended - revise its commit messages, run a code review, validate the findings, fold fixes for the real blocking ones into the right commits, force-push, and report back. Use when asked to polish a PR, or to run the post-draft review pass in a separate session.
---

# Polish PR

Take a drafted PR from "opened" to "ready for me to look at" without stopping
for input. Report once, at the end.

## Where this runs

If the user asked for this in a separate session and you are the session that
drafted the PR, do not do the work yourself: start a separate session (or, if
the harness has none, a subagent) whose brief is to run `/polish-pr` on the PR,
naming the repo path, branch, and PR number. Relay its report when it returns.

The separate session works in the same checkout on the PR branch, not a
worktree. While it runs, the session that started it must not write to that
checkout or switch branches.

## Standing permissions

Invoking this skill authorizes, for the PR's branch only:

- rewriting the PR's commits (amend, reword, fixup + autosquash), and
- pushing them with `git push --force-with-lease`.

It does not authorize merging, marking the PR ready for review, enabling
auto-merge, touching other branches, or replying to reviewers.

## Steps

1. **Set up.** Identify the PR, its branch, and its base (`gh pr view`). Check
   out the branch; stop and report if the tree is dirty or the branch is not
   the PR's head. Create a safety branch at the current tip
   (`polish-pr-backup/<branch>`).

2. **Revise commit messages.** Run `/revise-commit-message` on every commit
   in the PR, in unattended mode: apply each rewrite without asking, and keep
   the old and new messages for the report.

3. **Review.** Run `/code-review` on the PR's diff against its base. Do not
   pass `--fix` or `--comment`, and do not use the max or ultra levels.

4. **Validate every finding.** For each one, read the code it points at and
   decide whether it is real: reproduce it with a test or a concrete input
   where that is cheap, otherwise trace the code path. Classify each as:
   - **blocking** - real, and it would make the PR wrong to merge: a
     correctness bug, data loss or corruption, a race, a broken build or
     test, a security hole, a broken documented rule of the repo;
   - **non-blocking** - real, but a nit, style point, or optional cleanup;
   - **dismissed** - not real, with the reason.

5. **Fix the blocking findings only.** Make each fix as a `fixup!` commit
   against the PR commit it belongs to, then fold them in with
   `git rebase --autosquash` onto the base. A fix that belongs to no existing
   commit gets its own commit, with a message in the `/revise-commit-message`
   shape. Leave non-blocking findings unfixed.

6. **Verify.** Build and run the tests covering what changed, at the tip, and
   check that each rewritten commit builds on its own. Confirm that
   `git diff polish-pr-backup/<branch> HEAD` contains only the intended
   fixes. If a fix changed what a commit does, update that commit's message
   to match.

7. **Push.** `git push --force-with-lease` to the PR branch. If the lease
   fails, someone else pushed: do not retry, report it. Then rewrite the PR
   description from the final commit messages, following the PR description
   rule in `/revise-commit-message`.

8. **Report.** One message covering:
   - commit messages: old and new subject for each commit that changed;
   - blocking findings fixed: what was wrong, the fix, which commit it was
     folded into;
   - non-blocking findings: listed, unfixed;
   - dismissed findings: each with the reason;
   - what was built and tested, with the result, and anything not verified;
   - the safety branch name, which is left in place for the user to delete.

## When to stop early

Stop and report rather than pushing if: the rebase conflicts in a way that
is not a mechanical resolution, a blocking finding needs a design decision
or a change well beyond the PR's scope, or the build or tests fail for a
reason the fixes do not address. Leave the branch in a clean state (abort
the rebase, or reset to the safety branch) and say exactly where things
stand.
