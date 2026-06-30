# Security and secrets

- Never commit `.env`, `.env.ps1`, database backups, private keys, keystores, or production data.
- Run `setup.ps1` locally. The MySQL `root` password is used only for setup and is never saved.
- The application uses `petcare_app`, which only has `SELECT`, `INSERT`, `UPDATE`, and `DELETE` access to `petcare_db`.
- `.env.example` contains names and placeholders only. It must never contain working credentials.
- Before pushing, run `git diff --cached` and search staged files for secrets.
- If a secret is committed, rotate/revoke it immediately. Removing it in a later commit does not remove it from Git history.
- Do not put customer records or production database dumps in this repository. Use synthetic development data only.
