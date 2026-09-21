-- Execute once in Supabase SQL Editor. All access is server-side via restricted DB role.
CREATE TABLE IF NOT EXISTS public.kf_users(id uuid PRIMARY KEY,email text NOT NULL UNIQUE,hash text NOT NULL,role text NOT NULL CHECK(role IN ('consument','vakman')),name text NOT NULL,trade text NOT NULL DEFAULT '',postcode text NOT NULL DEFAULT '');
CREATE TABLE IF NOT EXISTS public.kf_sessions(token_hash text PRIMARY KEY,user_id uuid NOT NULL REFERENCES public.kf_users(id) ON DELETE CASCADE,expires bigint NOT NULL);
CREATE TABLE IF NOT EXISTS public.kf_cases(id uuid PRIMARY KEY,owner_id uuid NOT NULL REFERENCES public.kf_users(id),category text NOT NULL,description text NOT NULL,postcode text NOT NULL,analysis jsonb NOT NULL,status text NOT NULL DEFAULT 'open',created timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.kf_requests(id uuid PRIMARY KEY,case_id uuid NOT NULL REFERENCES public.kf_cases(id),trade_id uuid NOT NULL REFERENCES public.kf_users(id),status text NOT NULL DEFAULT 'nieuw',created timestamptz NOT NULL DEFAULT now(),UNIQUE(case_id,trade_id));
CREATE TABLE IF NOT EXISTS public.kf_quotes(id uuid PRIMARY KEY,request_id uuid NOT NULL UNIQUE REFERENCES public.kf_requests(id),trade_id uuid NOT NULL REFERENCES public.kf_users(id),amount_cents integer NOT NULL CHECK(amount_cents BETWEEN 100 AND 100000000),details text NOT NULL,status text NOT NULL DEFAULT 'aangeboden',created timestamptz NOT NULL DEFAULT now());
CREATE INDEX IF NOT EXISTS kf_sessions_user ON public.kf_sessions(user_id);
CREATE INDEX IF NOT EXISTS kf_cases_owner ON public.kf_cases(owner_id,created DESC);
CREATE INDEX IF NOT EXISTS kf_requests_trade ON public.kf_requests(trade_id,created DESC);
CREATE INDEX IF NOT EXISTS kf_quotes_trade ON public.kf_quotes(trade_id,created DESC);
ALTER TABLE public.kf_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_quotes ENABLE ROW LEVEL SECURITY;
-- Do not expose these tables through Supabase Data API: revoke client roles.
REVOKE ALL ON public.kf_users,public.kf_sessions,public.kf_cases,public.kf_requests,public.kf_quotes FROM anon,authenticated;
-- Server uses a direct Postgres connection. No public RLS policies are created.
