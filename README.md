# KlusFix — Supabase PostgreSQL

## Safe deployment
1. Keep the current Render service unchanged until a staging deployment works. Back up any surviving SQLite data before deleting anything. This package starts with an empty PostgreSQL database; it does not import old data.
2. In Supabase SQL Editor execute `schema.sql` once. The schema uses separate `kf_` tables, enables RLS and revokes anon/authenticated access. Never use the Supabase service-role key in browser code.
3. Supabase > Connect > Transaction pooler: copy the COMPLETE URI (port 6543) and replace its password with your database password, percent-encoding reserved characters. Store the entire URI only as `DATABASE_URL` in Render Environment. Do not put it in GitHub, screenshots, or chat. The code uses TLS and unnamed parameterized queries.
4. Upload this package's files to the repository root, replacing old `server.js`, `app.js`, `Dockerfile`, `sw.js`; retain your existing `index.html`, `style.css`, `icon.svg`, and `manifest.webmanifest` supplied in this package. Set Render runtime Docker, Dockerfile path `./Dockerfile`, and `DATABASE_URL`, optionally `GEMINI_API_KEY`. Do not use `DB_PATH` or SQLite on this deployment. `PORT` can be set to 8080.
5. Prefer a separate staging Render service and test account registration, login, logout, reporting, matching, request, quote, quote acceptance, and login again after redeploy. Only then switch the live service. Existing SQLite accounts do not automatically migrate.
6. Backups: arrange periodic Supabase database backups/exports and test restores; retention and availability depend on your Supabase plan.

## Security notes
This is a private-test implementation, not a security-audited public marketplace. Add verified email, password reset, abuse controls, rate limiting, moderation, data retention, and privacy/consent documentation before public launch. Database access is via server-only credentials. No Supabase Auth migration is implied: existing KlusFix password hashes remain in the application-managed `kf_users` table, and new users use the same hashing method. For tighter least privilege, create a dedicated restricted PostgreSQL login with table-specific permissions and use its connection URI rather than the default administrative database account.
