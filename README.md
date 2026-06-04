# nix-dmux

The popular `dmux` agent TUI packaged for Nix.

## Shared-checkout guard

This package now wraps upstream `dmux` with a narrow first-slice safety guard:

- launching from a **linked Git worktree** is allowed
- launching from the **primary checkout** is refused by default
- an explicit override remains available for exceptional cases

The goal is to keep shared checkouts read-mostly for agent mutation while the
broader workspace-backend and lease model continues to evolve elsewhere.

### Commands

Check whether the current directory is an allowed launch point:

```bash
dmux preflight
```

By default, `dmux` refuses to launch from the primary checkout of a Git repo and
prints guidance for creating a linked worktree:

```bash
git worktree add ../repo-worktree -b my-task
cd ../repo-worktree
dmux
```

To bypass the guard once from a shared checkout:

```bash
DMUX_ALLOW_SHARED_CHECKOUT=1 dmux --allow-shared-checkout
```

This is intentionally a small launcher-level guard, not the full solution to
claims, leases, workspace backends, cleanup, or rollback.
