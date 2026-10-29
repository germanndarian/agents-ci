# agents-ci

The pull request review my repos get from my Claude Code agents. On every PR into `main`, four agents read the change on Sonnet:
- **Reviewer:** findings by severity.
- **Tester:** what's tested and what's missing.
- **Critic:** what's weak or risky, in one paragraph.
- **Business analyst:** whether it's worth it and who it's for, in one paragraph.

The result is one comment on the PR, which later pushes update.

The agents and everything else live in a private repo. This one is public only because public repos can't use a private repo's workflow. **Don't edit `agents/` here:** it's copied over from the private repo after every commit there.

## Use it in a repo

1. Add the secret `CLAUDE_CODE_OAUTH_TOKEN`, from `claude setup-token`, to the repo:

   ```bash
   gh secret set CLAUDE_CODE_OAUTH_TOKEN --repo germanndarian/<repo>
   ```

2. Add `.github/workflows/agents.yml`:

   ```yaml
   name: Agents
   on:
     pull_request:
       branches: [main]
       types: [opened, synchronize, reopened, ready_for_review]
   jobs:
     agents:
       uses: germanndarian/agents-ci/.github/workflows/agents.yml@main
       permissions:
         contents: read
         pull-requests: write
       secrets:
         CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
   ```

## What's here

- `.github/workflows/agents.yml`: the reusable workflow. It runs `anthropics/claude-code-action@v1` on the subscription token.
  - **Read-only:** Claude only gets tools that read, and the workflow posts the comment itself.
  - **Skipped:** drafts and docs-only changes. A new push cancels the review still running.
- `.github/actions/agents/`: copies `agents/` to `~/.claude/agents` on the runner.
- `agents/`: the four agents, copied from the private repo.
