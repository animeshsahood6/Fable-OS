# PRIVACY - Data Classification (drives ADR-011 / ADR-025)

Living document (ADR-016 registry tier). Every directory is classified before
anything is stored in it. The tier decides what may leave the machine.

| Path | Tier | May leave the machine? |
|---|---|---|
| *.md at root, decisions\, reviews\, skills\, install\, tests\ | public-capable docs | git push allowed (public or private remote) |
| config\ (except vault\ and secrets) | private config | private git remote only |
| config\vault\ | private inventory (names, never values) | private git remote only |
| config\secrets.env, Credential Manager entries | SECRET | never - not in git, not in backups in plaintext |
| data\memory\, data\journal\ | PERSONAL | never unencrypted - restic only (Phase 3) |
| data\memory\_quarantine\ | PERSONAL + untrusted | never leaves; excluded from recall until reviewed (ADR-013) |
| projects\<name>\ | per-project (classify at creation) | own remote, mandated at creation |
| Consoles (tablet/phone) | render-only | hold no canonical state, ever (ADR-026) |