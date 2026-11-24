---
name: revise-commit-message
description: Review a commit's message against its diff and rewrite it to state the high-level intent of the change. Use when asked to review, revise, polish, or rewrite a commit message, or before finalizing a commit message for a PR.
---

# Revise commit message

Rewrite a commit message so a reviewer learns why the commit exists and what
it changes at a high level, without being walked through the diff.

## Steps

1. Pick the commit: the one the user named, otherwise `HEAD`. Read both the
   message and the change: `git show --stat --patch <commit>`.
2. Work out the intent from the diff: what was wrong or missing before, and
   what the commit does about it. If the diff does not reveal the motivation,
   ask rather than invent one.
3. Rewrite the message in the shape below.
4. Show the old and new messages. Apply the new one only once the user
   approves: `git commit --amend` for `HEAD`, a reword rebase for an older
   commit. If the commit is already pushed, say so before rewriting it.

**Unattended mode.** When invoked by `/polish-pr`, or when the user said to
apply without asking, skip the approval in step 4: apply the rewrite, and
include the old and new messages in the final report instead. If the
motivation cannot be worked out from the diff, leave that message unchanged
and say so in the report rather than asking.

## Shape

```
<area>: <what the commit does, imperative, short>

Previously, <how things worked, and why that was deficient>.

This patch <what changes, at the level of behavior and design>.

<trailers>
```

- First paragraph: the prior behavior and its deficiency. This is the
  motivation, so name the concrete problem (a bug, a missing capability, a
  cost), not just "this was not ideal".
- Second paragraph: what the patch does to address it, described as behavior
  or design. One paragraph is usually enough.
- A commit with no prior deficiency (a pure addition, a mechanical rename) can
  skip "Previously" and just state what it does and why.

## What to leave out

- Low-level detail the diff already shows: lists of functions renamed, files
  touched, fields added, or a step-by-step account of the code.
- The history of how the change was developed: review rounds, abandoned
  approaches, "also fixed a typo".
- Filler and hedging. Keep the body to what a reader needs to judge the
  change.

Keep a low-level detail only when it is surprising or a reader would otherwise
misread the change, such as a subtle invariant or a deliberate non-obvious
tradeoff.

## What to preserve

- The repo's subject-line convention (in CockroachDB, `pkg: summary`,
  lowercase, no trailing period) and line wrapping (72 columns for the body).
- Every trailer and tagged line exactly as written: `Epic:`, `Release note:`,
  `Fixes:`/`Informs:`, `Co-authored-by:`, and similar. Correct a release note
  only if it is now inaccurate, and point that out.
- Facts. Do not add claims about performance, testing, or impact that neither
  the old message nor the diff supports.
