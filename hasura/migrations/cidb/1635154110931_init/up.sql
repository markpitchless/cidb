
SET check_function_bodies = false;
CREATE TABLE public.builds (
    build_id text NOT NULL,
    repository text NOT NULL,
    revision text NOT NULL,
    branch text NOT NULL,
    builder text NOT NULL,
    builder_url text NOT NULL
);
CREATE TABLE public.test_cases (
    build_id text NOT NULL,
    suite_name text NOT NULL,
    classname text NOT NULL,
    name text NOT NULL,
    "time" double precision DEFAULT 0.0 NOT NULL,
    skipped boolean DEFAULT false NOT NULL,
    failed boolean DEFAULT true NOT NULL
);
CREATE TABLE public.test_suites (
    build_id text NOT NULL,
    name text NOT NULL,
    "timestamp" timestamp with time zone,
    tests integer DEFAULT 0 NOT NULL,
    failures integer DEFAULT 0 NOT NULL,
    errors integer DEFAULT 0 NOT NULL,
    "time" numeric DEFAULT 0.0 NOT NULL
);
ALTER TABLE ONLY public.builds
    ADD CONSTRAINT builds_pkey PRIMARY KEY (build_id);
ALTER TABLE ONLY public.test_cases
    ADD CONSTRAINT test_cases_pkey PRIMARY KEY (build_id, suite_name, classname, name);
ALTER TABLE ONLY public.test_suites
    ADD CONSTRAINT test_suites_pkey PRIMARY KEY (build_id, name);

SET check_function_bodies = false;
CREATE TABLE public.builds (
    build_id text NOT NULL,
    repository text NOT NULL,
    revision text NOT NULL,
    branch text NOT NULL,
    builder text NOT NULL,
    builder_url text NOT NULL
);
CREATE TABLE public.test_cases (
    build_id text NOT NULL,
    suite_name text NOT NULL,
    classname text NOT NULL,
    name text NOT NULL,
    "time" double precision DEFAULT 0.0 NOT NULL,
    skipped boolean DEFAULT false NOT NULL,
    failed boolean DEFAULT true NOT NULL
);
CREATE TABLE public.test_suites (
    build_id text NOT NULL,
    name text NOT NULL,
    "timestamp" timestamp with time zone,
    tests integer DEFAULT 0 NOT NULL,
    failures integer DEFAULT 0 NOT NULL,
    errors integer DEFAULT 0 NOT NULL,
    "time" numeric DEFAULT 0.0 NOT NULL
);
ALTER TABLE ONLY public.builds
    ADD CONSTRAINT builds_pkey PRIMARY KEY (build_id);
ALTER TABLE ONLY public.test_cases
    ADD CONSTRAINT test_cases_pkey PRIMARY KEY (build_id, suite_name, classname, name);
ALTER TABLE ONLY public.test_suites
    ADD CONSTRAINT test_suites_pkey PRIMARY KEY (build_id, name);
ALTER TABLE ONLY public.test_cases
    ADD CONSTRAINT test_cases_build_id_fkey FOREIGN KEY (build_id) REFERENCES public.builds(build_id) ON UPDATE CASCADE ON DELETE CASCADE;
