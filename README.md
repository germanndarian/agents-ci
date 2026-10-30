# agents-ci

The pull request review my repos get from my Claude Code agents. On every PR into `main`, four agents read the change on Sonnet:
- **Reviewer:** findings by severity.
- **Tester:** what's tested and what's missing.
- **Critic:** what's weak or risky, in one paragraph.
- **Business analyst:** whether it's worth it and who it's for, in one paragraph.

The result is one comment on the PR, which later pushes update.

The agents and everything else live in a private repo. This one is public only because public repos can't use a private repo's workflow. **Don't edit `agents/` here:** it's copied over from the private repo after every commit there.


## Versions

Repos use `@v1`, a branch that moves only when I release it, so a push to `main` here changes no repo's review.
- **Changes land on `main` first:** new agents arrive after every commit in the private repo.
- **Releasing:** `release-ci.sh` in the private repo fast-forwards `v1` to `main`. From then on, every repo's next review uses it.

## What's here

- `.github/workflows/agents.yml`: the reusable workflow. It runs `anthropics/claude-code-action@v1` on the subscription token.
  - **Read-only:** Claude only gets tools that read, and the workflow posts the comment itself.
  - **Skipped:** drafts and docs-only changes. A new push cancels the review still running.
- `.github/actions/agents/`: copies `agents/` to `~/.claude/agents` on the runner.
- `agents/`: the four agents, copied from the private repo.
