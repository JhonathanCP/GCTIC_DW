--
-- PostgreSQL database dump
--

-- Dumped from database version 14.12 (Ubuntu 14.12-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 15.6 (Ubuntu 15.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: AccessAudits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AccessAudits" (
    id integer NOT NULL,
    "createdAt" timestamp with time zone,
    success boolean DEFAULT true,
    "publicIp" character varying(255) NOT NULL,
    "privateIp" character varying(255) NOT NULL,
    system character varying(255) NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "UserId" integer,
    "ReportId" integer
);


ALTER TABLE public."AccessAudits" OWNER TO postgres;

--
-- Name: AccessAudits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."AccessAudits_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AccessAudits_id_seq" OWNER TO postgres;

--
-- Name: AccessAudits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."AccessAudits_id_seq" OWNED BY public."AccessAudits".id;


--
-- Name: AccessRequestReport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AccessRequestReport" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "AccessRequestId" integer NOT NULL,
    "ReportId" integer NOT NULL
);


ALTER TABLE public."AccessRequestReport" OWNER TO postgres;

--
-- Name: AccessRequests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AccessRequests" (
    id integer NOT NULL,
    justification character varying(255) NOT NULL,
    cargo character varying(255) NOT NULL,
    "nombreJefe" character varying(255) NOT NULL,
    "cargoJefe" character varying(255) NOT NULL,
    "pdfBlob" bytea,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    active boolean DEFAULT true,
    message character varying(255),
    "StateId" integer,
    "UserId" integer
);


ALTER TABLE public."AccessRequests" OWNER TO postgres;

--
-- Name: AccessRequests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."AccessRequests_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AccessRequests_id_seq" OWNER TO postgres;

--
-- Name: AccessRequests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."AccessRequests_id_seq" OWNED BY public."AccessRequests".id;


--
-- Name: Dependencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Dependencies" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    "createdAt" timestamp with time zone,
    active boolean DEFAULT true,
    "updatedAt" timestamp with time zone NOT NULL,
    "MainDependencyId" integer
);


ALTER TABLE public."Dependencies" OWNER TO postgres;

--
-- Name: Dependencies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Dependencies_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Dependencies_id_seq" OWNER TO postgres;

--
-- Name: Dependencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Dependencies_id_seq" OWNED BY public."Dependencies".id;


--
-- Name: GroupTags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."GroupTags" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."GroupTags" OWNER TO postgres;

--
-- Name: GroupTags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."GroupTags_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."GroupTags_id_seq" OWNER TO postgres;

--
-- Name: GroupTags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."GroupTags_id_seq" OWNED BY public."GroupTags".id;


--
-- Name: Groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Groups" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    active boolean DEFAULT true,
    icon character varying(255) NOT NULL
);


ALTER TABLE public."Groups" OWNER TO postgres;

--
-- Name: Groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Groups_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Groups_id_seq" OWNER TO postgres;

--
-- Name: Groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Groups_id_seq" OWNED BY public."Groups".id;


--
-- Name: ImplementationRequests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ImplementationRequests" (
    id integer NOT NULL,
    justification character varying(255) NOT NULL,
    "createdAt" timestamp with time zone,
    estado character varying(255) NOT NULL,
    "pdfBlob" bytea,
    "updatedAt" timestamp with time zone,
    message character varying(255),
    "StateId" integer,
    "UserId" integer
);


ALTER TABLE public."ImplementationRequests" OWNER TO postgres;

--
-- Name: ImplementationRequests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ImplementationRequests_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ImplementationRequests_id_seq" OWNER TO postgres;

--
-- Name: ImplementationRequests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ImplementationRequests_id_seq" OWNED BY public."ImplementationRequests".id;


--
-- Name: LoginAudits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."LoginAudits" (
    id integer NOT NULL,
    "createdAt" timestamp with time zone,
    success boolean DEFAULT true,
    "publicIp" character varying(255) NOT NULL,
    "privateIp" character varying(255) NOT NULL,
    system character varying(255) NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "UserId" integer
);


ALTER TABLE public."LoginAudits" OWNER TO postgres;

--
-- Name: LoginAudits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."LoginAudits_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."LoginAudits_id_seq" OWNER TO postgres;

--
-- Name: LoginAudits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."LoginAudits_id_seq" OWNED BY public."LoginAudits".id;


--
-- Name: MainDependencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MainDependencies" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    "createdAt" timestamp with time zone,
    active boolean DEFAULT true,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."MainDependencies" OWNER TO postgres;

--
-- Name: MainDependencies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."MainDependencies_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."MainDependencies_id_seq" OWNER TO postgres;

--
-- Name: MainDependencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."MainDependencies_id_seq" OWNED BY public."MainDependencies".id;


--
-- Name: Modules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Modules" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    active boolean DEFAULT true,
    icon character varying(255) NOT NULL
);


ALTER TABLE public."Modules" OWNER TO postgres;

--
-- Name: Modules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Modules_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Modules_id_seq" OWNER TO postgres;

--
-- Name: Modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Modules_id_seq" OWNED BY public."Modules".id;


--
-- Name: Notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Notifications" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "shortDescription" character varying(255),
    description character varying(255),
    "createdAt" timestamp with time zone,
    link character varying(255),
    opened boolean DEFAULT false,
    "openedAt" timestamp with time zone,
    "updatedAt" timestamp with time zone NOT NULL,
    "UserId" integer
);


ALTER TABLE public."Notifications" OWNER TO postgres;

--
-- Name: Notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Notifications_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Notifications_id_seq" OWNER TO postgres;

--
-- Name: Notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Notifications_id_seq" OWNED BY public."Notifications".id;


--
-- Name: Reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reports" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    version character varying(255) NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    active boolean DEFAULT true,
    icon character varying(255) NOT NULL,
    link character varying(255) NOT NULL,
    free boolean DEFAULT false,
    limited boolean DEFAULT false,
    restricted boolean DEFAULT false,
    "ModuleId" integer NOT NULL,
    "GroupId" integer NOT NULL
);


ALTER TABLE public."Reports" OWNER TO postgres;

--
-- Name: Reports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Reports_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Reports_id_seq" OWNER TO postgres;

--
-- Name: Reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Reports_id_seq" OWNED BY public."Reports".id;


--
-- Name: Roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Roles" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    active boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Roles" OWNER TO postgres;

--
-- Name: Roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Roles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Roles_id_seq" OWNER TO postgres;

--
-- Name: Roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Roles_id_seq" OWNED BY public."Roles".id;


--
-- Name: States; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."States" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    active boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."States" OWNER TO postgres;

--
-- Name: States_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."States_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."States_id_seq" OWNER TO postgres;

--
-- Name: States_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."States_id_seq" OWNED BY public."States".id;


--
-- Name: TagReport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TagReport" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "TagId" integer NOT NULL,
    "ReportId" integer NOT NULL
);


ALTER TABLE public."TagReport" OWNER TO postgres;

--
-- Name: Tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Tags" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "GroupTagId" integer
);


ALTER TABLE public."Tags" OWNER TO postgres;

--
-- Name: Tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Tags_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Tags_id_seq" OWNER TO postgres;

--
-- Name: Tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Tags_id_seq" OWNED BY public."Tags".id;


--
-- Name: UserModule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserModule" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "UserId" integer NOT NULL,
    "ModuleId" integer NOT NULL
);


ALTER TABLE public."UserModule" OWNER TO postgres;

--
-- Name: UserReport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserReport" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "UserId" integer NOT NULL,
    "ReportId" integer NOT NULL
);


ALTER TABLE public."UserReport" OWNER TO postgres;

--
-- Name: Users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users" (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    firstname character varying(255),
    lastname character varying(255),
    dni character varying(255),
    email character varying(255) NOT NULL,
    password character varying(255),
    cargo character varying(255),
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    active boolean DEFAULT true,
    ldap boolean DEFAULT true,
    "RoleId" integer,
    "DependencyId" integer
);


ALTER TABLE public."Users" OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Users_id_seq" OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Users_id_seq" OWNED BY public."Users".id;


--
-- Name: AccessAudits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessAudits" ALTER COLUMN id SET DEFAULT nextval('public."AccessAudits_id_seq"'::regclass);


--
-- Name: AccessRequests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessRequests" ALTER COLUMN id SET DEFAULT nextval('public."AccessRequests_id_seq"'::regclass);


--
-- Name: Dependencies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dependencies" ALTER COLUMN id SET DEFAULT nextval('public."Dependencies_id_seq"'::regclass);


--
-- Name: GroupTags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."GroupTags" ALTER COLUMN id SET DEFAULT nextval('public."GroupTags_id_seq"'::regclass);


--
-- Name: Groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Groups" ALTER COLUMN id SET DEFAULT nextval('public."Groups_id_seq"'::regclass);


--
-- Name: ImplementationRequests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ImplementationRequests" ALTER COLUMN id SET DEFAULT nextval('public."ImplementationRequests_id_seq"'::regclass);


--
-- Name: LoginAudits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LoginAudits" ALTER COLUMN id SET DEFAULT nextval('public."LoginAudits_id_seq"'::regclass);


--
-- Name: MainDependencies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MainDependencies" ALTER COLUMN id SET DEFAULT nextval('public."MainDependencies_id_seq"'::regclass);


--
-- Name: Modules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Modules" ALTER COLUMN id SET DEFAULT nextval('public."Modules_id_seq"'::regclass);


--
-- Name: Notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notifications" ALTER COLUMN id SET DEFAULT nextval('public."Notifications_id_seq"'::regclass);


--
-- Name: Reports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reports" ALTER COLUMN id SET DEFAULT nextval('public."Reports_id_seq"'::regclass);


--
-- Name: Roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Roles" ALTER COLUMN id SET DEFAULT nextval('public."Roles_id_seq"'::regclass);


--
-- Name: States id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."States" ALTER COLUMN id SET DEFAULT nextval('public."States_id_seq"'::regclass);


--
-- Name: Tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tags" ALTER COLUMN id SET DEFAULT nextval('public."Tags_id_seq"'::regclass);


--
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- Data for Name: AccessAudits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."AccessAudits" (id, "createdAt", success, "publicIp", "privateIp", system, "updatedAt", "UserId", "ReportId") FROM stdin;
1	2024-05-27 13:55:57.122+00	t	10.0.28.15	192.168.48.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 13:55:57.122+00	86	10
2	2024-05-27 13:57:55.745+00	t	10.0.28.15	192.168.48.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 13:57:55.745+00	86	10
3	2024-05-27 16:45:26.559+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:45:26.559+00	86	13
4	2024-05-27 16:45:26.567+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:45:26.567+00	86	13
5	2024-05-27 16:46:22.238+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:46:22.238+00	86	1
6	2024-05-27 16:46:22.246+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:46:22.246+00	86	1
7	2024-05-27 16:46:41.787+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:46:41.787+00	86	2
8	2024-05-27 16:46:41.795+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:46:41.795+00	86	2
9	2024-05-27 16:47:25.977+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:47:25.977+00	86	3
10	2024-05-27 16:47:25.985+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:47:25.985+00	86	3
11	2024-05-27 16:48:10.025+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:48:10.025+00	86	1
12	2024-05-27 16:48:10.034+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:48:10.034+00	86	1
13	2024-05-27 22:36:47.022+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 22:36:47.022+00	86	1
14	2024-05-27 22:36:47.979+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:36:47.979+00	88	15
15	2024-05-27 22:37:05.049+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:37:05.049+00	88	15
16	2024-05-27 22:37:11.497+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:37:11.498+00	88	11
17	2024-05-27 22:37:33.314+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:37:33.314+00	88	4
18	2024-05-27 22:47:57.658+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:47:57.658+00	88	36
19	2024-05-27 22:48:42.517+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:48:42.518+00	88	36
20	2024-05-27 22:49:12.268+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:49:12.269+00	88	36
21	2024-05-27 22:49:25.419+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:49:25.419+00	88	36
22	2024-05-27 22:52:43.644+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:52:43.644+00	88	36
23	2024-05-27 22:54:41.784+00	t	10.0.16.28	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:54:41.784+00	10	28
24	2024-05-27 23:42:20.624+00	t	10.0.29.11	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 23:42:20.624+00	4	13
25	2024-05-27 23:43:30.425+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 23:43:30.425+00	3	50
26	2024-05-27 23:44:35.771+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 23:44:35.771+00	3	50
27	2024-05-28 13:04:22.159+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:04:22.159+00	3	13
28	2024-05-28 13:04:35.666+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:04:35.666+00	3	13
29	2024-05-28 13:04:57.995+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 13:04:57.995+00	55	36
30	2024-05-28 13:05:09.462+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:05:09.462+00	3	10
31	2024-05-28 13:05:58.968+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 13:05:58.968+00	55	11
32	2024-05-28 13:13:07.44+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:13:07.44+00	55	11
33	2024-05-28 13:13:43.392+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:13:43.392+00	55	13
34	2024-05-28 13:14:01.016+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:14:01.016+00	55	14
35	2024-05-28 13:14:26.621+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:14:26.621+00	54	31
36	2024-05-28 13:14:39.139+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:14:39.139+00	55	15
37	2024-05-28 13:14:43.475+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:14:43.475+00	54	29
38	2024-05-28 13:15:04.482+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:15:04.482+00	54	30
39	2024-05-28 13:15:04.875+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:15:04.875+00	55	16
40	2024-05-28 13:15:32.752+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:15:32.752+00	54	32
41	2024-05-28 13:15:45.45+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:15:45.45+00	54	33
42	2024-05-28 13:17:38.623+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:17:38.623+00	58	43
43	2024-05-28 13:18:30.959+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:18:30.959+00	58	32
44	2024-05-28 13:18:44.562+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:18:44.562+00	58	33
45	2024-05-28 13:19:12.343+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:19:12.343+00	58	17
46	2024-05-28 13:19:48.472+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:19:48.472+00	58	15
47	2024-05-28 13:20:01.944+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:20:01.944+00	58	16
48	2024-05-28 13:20:21.695+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:20:21.695+00	58	17
49	2024-05-28 13:45:28.287+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:45:28.287+00	55	11
50	2024-05-28 13:50:56.164+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:50:56.164+00	40	37
51	2024-05-28 13:51:00.61+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:51:00.61+00	40	39
52	2024-05-28 13:51:21.692+00	t	10.0.28.219	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-28 13:51:21.692+00	90	11
53	2024-05-28 13:53:21.36+00	t	10.0.28.219	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-28 13:53:21.36+00	90	40
54	2024-05-28 13:53:25.268+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:53:25.268+00	40	38
55	2024-05-28 13:56:21.914+00	t	10.0.28.219	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-28 13:56:21.914+00	90	28
56	2024-05-28 13:57:02.044+00	t	10.0.28.219	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-28 13:57:02.045+00	90	36
57	2024-05-28 14:02:09.395+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:02:09.395+00	58	17
58	2024-05-28 14:02:55.714+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:02:55.714+00	58	45
59	2024-05-28 14:05:28.715+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:05:28.715+00	58	45
60	2024-05-28 14:07:10.66+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:07:10.66+00	58	45
61	2024-05-28 14:12:10.072+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:12:10.072+00	58	31
62	2024-05-28 14:16:00.281+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:16:00.281+00	58	43
63	2024-05-28 14:20:52.439+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:20:52.439+00	58	43
64	2024-05-28 14:23:02.712+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:23:02.712+00	58	43
65	2024-05-28 14:23:43.429+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:23:43.429+00	58	45
66	2024-05-28 14:43:53.934+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:43:53.934+00	40	37
67	2024-05-28 14:53:01.837+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:53:01.837+00	40	19
68	2024-05-28 14:59:46.548+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 14:59:46.548+00	40	39
69	2024-05-28 15:00:07.356+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:00:07.356+00	40	49
70	2024-05-28 15:02:31.126+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:02:31.126+00	3	13
71	2024-05-28 15:06:47.537+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:06:47.537+00	89	36
72	2024-05-28 15:06:57.899+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:06:57.899+00	40	39
73	2024-05-28 15:07:18.12+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:07:18.12+00	40	39
74	2024-05-28 15:08:54.52+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:08:54.52+00	40	39
75	2024-05-28 15:21:32.85+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:21:32.85+00	40	39
76	2024-05-28 15:23:38.356+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:23:38.356+00	40	39
77	2024-05-28 15:36:43.053+00	t	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:36:43.053+00	14	37
78	2024-05-28 15:39:31.538+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:39:31.538+00	40	47
79	2024-05-28 15:51:05.135+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:51:05.135+00	54	17
80	2024-05-28 15:51:34.29+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:51:34.29+00	54	15
81	2024-05-28 15:51:45.307+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:51:45.307+00	54	16
82	2024-05-28 15:55:12.214+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:55:12.214+00	54	42
83	2024-05-28 15:55:42.418+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:55:42.418+00	54	15
84	2024-05-28 15:55:55.214+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:55:55.214+00	54	16
85	2024-05-28 15:56:40.345+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:56:40.345+00	54	17
86	2024-05-28 15:56:49.738+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:56:49.738+00	54	15
87	2024-05-28 15:57:00.282+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:57:00.282+00	54	16
88	2024-05-28 15:57:19.875+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:57:19.875+00	54	16
89	2024-05-28 15:57:30.293+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:57:30.293+00	54	16
90	2024-05-28 15:57:48.13+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:57:48.13+00	54	36
91	2024-05-28 15:58:06.627+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:58:06.627+00	54	37
92	2024-05-28 15:58:21.202+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:58:21.203+00	54	38
93	2024-05-28 15:58:33.099+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:58:33.099+00	54	39
94	2024-05-28 15:58:51.639+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:58:51.639+00	54	40
95	2024-05-28 15:59:26.619+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:59:26.619+00	54	31
96	2024-05-28 15:59:35.961+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:59:35.961+00	54	29
97	2024-05-28 15:59:54.645+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:59:54.645+00	54	30
98	2024-05-28 16:00:13.624+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:00:13.624+00	54	32
99	2024-05-28 16:00:23.612+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:00:23.612+00	54	33
100	2024-05-28 16:01:04.387+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:01:04.387+00	40	44
101	2024-05-28 16:01:25.2+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:01:25.2+00	40	46
102	2024-05-28 16:02:13.893+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:02:13.893+00	54	42
103	2024-05-28 16:04:06.517+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:04:06.517+00	89	36
104	2024-05-28 16:04:56.804+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:04:56.804+00	54	31
105	2024-05-28 16:05:12.163+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:05:12.163+00	54	29
106	2024-05-28 16:05:38.043+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:05:38.043+00	54	30
107	2024-05-28 16:05:44.992+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:05:44.992+00	54	32
108	2024-05-28 16:05:52.447+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:05:52.447+00	54	33
109	2024-05-28 16:10:10.775+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:10:10.775+00	40	48
110	2024-05-28 16:18:20.124+00	t	10.0.61.168	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:18:20.124+00	91	10
111	2024-05-28 16:28:39.441+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:28:39.441+00	88	15
112	2024-05-28 16:29:30.103+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:29:30.103+00	89	36
113	2024-05-28 16:29:59.506+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:29:59.506+00	89	29
114	2024-05-28 16:40:37.777+00	t	10.0.61.168	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:40:37.777+00	91	11
115	2024-05-28 16:43:34.784+00	t	10.0.61.168	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:43:34.784+00	91	13
116	2024-05-28 16:45:18.979+00	t	10.0.61.168	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:45:18.979+00	91	13
117	2024-05-28 16:45:56.196+00	t	10.0.61.168	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:45:56.196+00	91	14
118	2024-05-28 16:46:40.85+00	t	10.0.61.168	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:46:40.85+00	91	15
119	2024-05-28 16:51:31.319+00	t	10.0.61.168	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:51:31.319+00	91	16
120	2024-05-28 17:05:15.619+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 17:05:15.619+00	89	29
121	2024-05-28 17:06:54.211+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 17:06:54.211+00	89	30
122	2024-05-28 17:08:48.826+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 17:08:48.826+00	89	29
123	2024-05-28 18:08:13.753+00	t	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 18:08:13.753+00	24	27
124	2024-05-28 18:09:31.586+00	t	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 18:09:31.586+00	24	40
125	2024-05-28 18:10:42.202+00	t	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 18:10:42.203+00	24	15
126	2024-05-28 18:12:39.298+00	t	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 18:12:39.298+00	24	3
127	2024-05-28 18:16:15.459+00	t	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 18:16:15.46+00	24	11
128	2024-05-28 18:16:57.125+00	t	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 18:16:57.125+00	24	25
129	2024-05-28 18:17:34.108+00	t	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 18:17:34.108+00	24	26
130	2024-05-28 18:30:16.916+00	t	132.251.1.180	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 18:30:16.916+00	24	25
131	2024-05-28 18:44:38.682+00	t	132.251.1.180	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 18:44:38.682+00	24	3
132	2024-05-28 18:45:38.622+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 18:45:38.622+00	89	29
133	2024-05-28 18:47:30.647+00	t	10.0.36.151	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 18:47:30.647+00	92	36
134	2024-05-28 18:47:42.742+00	t	10.0.36.151	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 18:47:42.742+00	92	28
135	2024-05-28 19:00:55.039+00	t	132.251.1.180	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:00:55.039+00	24	26
136	2024-05-28 19:35:30.763+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:35:30.763+00	40	39
137	2024-05-28 19:49:32.685+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:49:32.685+00	54	18
138	2024-05-28 19:49:54.616+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:49:54.616+00	54	42
139	2024-05-28 19:53:59.689+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:53:59.689+00	89	29
140	2024-05-28 19:59:21.691+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:59:21.692+00	89	32
141	2024-05-28 20:17:18.193+00	t	132.251.1.180	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 20:17:18.193+00	24	3
142	2024-05-28 20:47:24.912+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 20:47:24.912+00	54	17
143	2024-05-28 20:48:18.449+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 20:48:18.449+00	54	16
144	2024-05-28 20:49:02.335+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 20:49:02.335+00	54	30
145	2024-05-28 20:57:07.549+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 20:57:07.549+00	40	39
146	2024-05-28 21:10:45.919+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 21:10:45.919+00	40	39
147	2024-05-28 21:11:16.432+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 21:11:16.432+00	40	39
148	2024-05-28 21:50:59.95+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 21:50:59.95+00	40	39
149	2024-05-28 22:06:00.503+00	t	132.251.1.180	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 22:06:00.503+00	24	3
150	2024-05-28 22:06:57.487+00	t	132.251.1.180	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 22:06:57.487+00	24	28
151	2024-05-28 23:47:04.557+00	t	132.251.0.165	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-28 23:47:04.557+00	2	19
152	2024-05-28 23:47:26.187+00	t	132.251.0.165	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-28 23:47:26.187+00	2	19
153	2024-05-29 00:55:57.182+00	t	38.25.17.97	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 00:55:57.182+00	2	20
154	2024-05-29 13:03:31.843+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 13:03:31.843+00	58	45
155	2024-05-29 13:08:36.268+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 13:08:36.268+00	58	45
156	2024-05-29 13:33:10.993+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 13:33:10.993+00	86	45
157	2024-05-29 13:47:38.243+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 13:47:38.243+00	40	38
158	2024-05-29 14:03:51.761+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:03:51.762+00	40	37
159	2024-05-29 14:18:08.992+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:18:08.992+00	40	19
160	2024-05-29 14:19:04.458+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:19:04.458+00	40	19
161	2024-05-29 14:21:36.138+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:21:36.138+00	40	19
162	2024-05-29 14:30:15.782+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 14:30:15.782+00	86	43
163	2024-05-29 14:39:55.88+00	t	132.251.2.147	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:39:55.88+00	24	3
164	2024-05-29 14:41:55.411+00	t	132.251.2.147	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:41:55.411+00	24	41
165	2024-05-29 14:42:16.827+00	t	132.251.2.147	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:42:16.827+00	24	3
166	2024-05-29 14:54:40.564+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:54:40.564+00	40	44
167	2024-05-29 15:02:54.36+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 15:02:54.36+00	40	39
168	2024-05-29 15:50:34.731+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 15:50:34.731+00	40	39
169	2024-05-29 15:50:42.639+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 15:50:42.639+00	40	46
170	2024-05-29 15:51:21.415+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 15:51:21.415+00	40	47
171	2024-05-29 15:51:37.854+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 15:51:37.854+00	40	48
172	2024-05-29 16:03:23.887+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:03:23.887+00	88	26
173	2024-05-29 16:07:34.286+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:07:34.286+00	89	43
174	2024-05-29 16:08:29.65+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:08:29.65+00	89	45
175	2024-05-29 16:09:49.424+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:09:49.424+00	89	45
176	2024-05-29 16:11:08.094+00	t	132.251.2.147	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:11:08.095+00	24	3
177	2024-05-29 16:11:38.894+00	t	132.251.2.147	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:11:38.895+00	24	10
178	2024-05-29 16:12:16.576+00	t	132.251.2.147	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:12:16.576+00	24	37
179	2024-05-29 16:17:33.593+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:17:33.593+00	58	45
180	2024-05-29 16:18:37.796+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:18:37.796+00	58	43
181	2024-05-29 16:21:52.37+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:21:52.37+00	46	10
182	2024-05-29 16:23:31.45+00	t	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:23:31.45+00	14	37
183	2024-05-29 16:25:24.473+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 16:25:24.473+00	93	28
184	2024-05-29 16:31:57.395+00	t	10.0.37.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:31:57.395+00	94	10
185	2024-05-29 16:32:18.244+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 16:32:18.244+00	93	10
186	2024-05-29 16:33:00.525+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 16:33:00.525+00	93	28
187	2024-05-29 16:41:28.265+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:41:28.265+00	54	45
188	2024-05-29 16:42:01.534+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:42:01.534+00	89	45
189	2024-05-29 16:56:06.903+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:56:06.903+00	54	45
190	2024-05-29 16:57:50.152+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:57:50.152+00	88	51
191	2024-05-29 16:58:41.756+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:58:41.756+00	88	12
192	2024-05-29 16:59:19.598+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:59:19.598+00	88	50
193	2024-05-29 17:00:23.484+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 17:00:23.484+00	89	45
194	2024-05-29 17:05:51.97+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 17:05:51.971+00	89	45
195	2024-05-29 17:26:41.72+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 17:26:41.72+00	89	45
196	2024-05-29 17:30:41.035+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 17:30:41.035+00	89	45
197	2024-05-29 17:33:04.543+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 17:33:04.543+00	54	45
198	2024-05-29 17:50:46.577+00	t	172.24.34.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 17:50:46.577+00	95	28
199	2024-05-29 18:01:39.207+00	t	172.24.34.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 18:01:39.207+00	95	28
200	2024-05-29 19:00:39.016+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:00:39.016+00	54	43
201	2024-05-29 19:20:23.101+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:20:23.101+00	89	45
202	2024-05-29 19:22:20.031+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:22:20.031+00	89	45
203	2024-05-29 19:48:52.93+00	t	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:48:52.93+00	14	4
204	2024-05-29 19:49:25.425+00	t	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:49:25.425+00	14	37
205	2024-05-29 19:49:55.227+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:49:55.227+00	89	45
206	2024-05-29 19:55:40.295+00	t	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:55:40.295+00	14	18
207	2024-05-29 20:07:04.532+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 20:07:04.532+00	89	45
208	2024-05-29 20:42:27.46+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 20:42:27.46+00	89	45
209	2024-05-29 21:03:05.653+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 21:03:05.653+00	89	45
210	2024-05-29 21:19:13.858+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 21:19:13.858+00	46	39
211	2024-05-29 21:19:53.263+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 21:19:53.263+00	46	28
212	2024-05-29 21:25:49.136+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 21:25:49.136+00	89	45
213	2024-05-29 21:46:36.089+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 21:46:36.089+00	89	45
214	2024-05-29 22:40:28.148+00	t	10.0.16.28	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 22:40:28.148+00	10	4
215	2024-05-29 22:42:09.868+00	t	10.0.16.28	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 22:42:09.868+00	10	15
216	2024-05-29 22:48:55.305+00	t	10.0.16.28	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 22:48:55.305+00	10	29
217	2024-05-30 12:00:45.456+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 12:00:45.457+00	54	43
218	2024-05-30 13:18:51.342+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 13:18:51.342+00	89	45
219	2024-05-30 14:00:45.465+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-30 14:00:45.465+00	86	50
220	2024-05-30 14:03:27.084+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:03:27.084+00	40	38
221	2024-05-30 14:03:57.083+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:03:57.083+00	40	37
222	2024-05-30 14:16:58.641+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:16:58.641+00	40	19
223	2024-05-30 14:18:03.306+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:18:03.306+00	58	42
224	2024-05-30 14:18:42.756+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:18:42.756+00	58	33
225	2024-05-30 14:18:52.62+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:18:52.62+00	58	32
226	2024-05-30 14:26:31.755+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 14:26:31.755+00	93	40
227	2024-05-30 14:28:55.324+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 14:28:55.324+00	93	28
228	2024-05-30 14:33:30.833+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:33:30.833+00	40	49
229	2024-05-30 14:35:28.845+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:35:28.845+00	58	42
230	2024-05-30 14:35:57.473+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:35:57.473+00	89	43
231	2024-05-30 14:36:54.929+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:36:54.929+00	58	42
232	2024-05-30 14:38:09.697+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:38:09.697+00	58	33
233	2024-05-30 14:39:18.337+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:39:18.337+00	58	32
234	2024-05-30 14:47:17.902+00	t	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:47:17.902+00	96	10
235	2024-05-30 14:48:22.259+00	t	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:48:22.259+00	96	36
236	2024-05-30 14:51:12.108+00	t	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:51:12.108+00	96	13
237	2024-05-30 14:52:06.546+00	t	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:52:06.546+00	96	40
238	2024-05-30 14:52:23.503+00	t	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:52:23.503+00	96	28
239	2024-05-30 14:52:49.063+00	t	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:52:49.063+00	96	16
240	2024-05-30 14:53:38.115+00	t	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:53:38.115+00	96	15
241	2024-05-30 14:59:11.808+00	t	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:59:11.808+00	96	11
242	2024-05-30 15:03:31.91+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:03:31.91+00	40	44
243	2024-05-30 15:11:53.655+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:11:53.655+00	40	39
244	2024-05-30 15:31:31.685+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:31:31.685+00	89	33
245	2024-05-30 15:32:05.419+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:32:05.419+00	89	28
246	2024-05-30 15:33:36.681+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:33:36.681+00	89	32
247	2024-05-30 15:33:56.681+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:33:56.681+00	89	33
248	2024-05-30 15:36:04.39+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:36:04.39+00	50	42
249	2024-05-30 15:37:04.076+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:37:04.076+00	50	42
250	2024-05-30 15:41:04.838+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:41:04.839+00	50	42
251	2024-05-30 15:45:17.37+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:45:17.37+00	50	42
252	2024-05-30 15:48:03.799+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:48:03.799+00	50	42
253	2024-05-30 15:49:01.993+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:49:01.993+00	50	32
254	2024-05-30 15:50:01.882+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:50:01.882+00	50	32
255	2024-05-30 15:51:12.862+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:51:12.862+00	50	32
256	2024-05-30 15:53:40.786+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:53:40.786+00	50	33
257	2024-05-30 15:54:14.115+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:54:14.115+00	50	32
258	2024-05-30 15:54:20.213+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:54:20.213+00	40	47
259	2024-05-30 15:55:49.816+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:55:49.817+00	40	46
260	2024-05-30 15:56:07.021+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:56:07.021+00	40	48
261	2024-05-30 15:58:25.945+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:58:25.945+00	50	32
262	2024-05-30 16:07:25.417+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 16:07:25.417+00	50	32
263	2024-05-30 16:09:05.241+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 16:09:05.242+00	50	42
264	2024-05-30 16:15:40.368+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 16:15:40.368+00	50	42
265	2024-05-30 16:53:13.845+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 16:53:13.846+00	88	26
266	2024-05-30 16:57:02.732+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 16:57:02.732+00	58	42
267	2024-05-30 16:57:55.376+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 16:57:55.376+00	88	2
268	2024-05-30 17:00:47.13+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 17:00:47.131+00	50	32
269	2024-05-30 17:10:11.458+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 17:10:11.458+00	50	45
270	2024-05-30 17:11:10.414+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 17:11:10.414+00	50	43
271	2024-05-30 17:12:01.565+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 17:12:01.565+00	50	33
272	2024-05-30 19:31:53.864+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:31:53.864+00	89	43
273	2024-05-30 19:47:18.782+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:47:18.782+00	40	39
274	2024-05-30 19:49:56.022+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:49:56.022+00	40	19
275	2024-05-30 19:50:33.267+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:50:33.267+00	93	28
276	2024-05-30 19:50:52.936+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:50:52.936+00	93	16
277	2024-05-30 19:51:45.647+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:51:45.647+00	40	20
278	2024-05-30 19:52:23.175+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:52:23.176+00	93	15
279	2024-05-30 19:52:55.834+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:52:55.834+00	40	37
280	2024-05-30 19:54:51.436+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:54:51.436+00	40	38
281	2024-05-30 19:55:05.909+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:55:05.909+00	93	11
282	2024-05-30 19:55:32.26+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:55:32.26+00	40	39
283	2024-05-30 19:56:28.098+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:56:28.098+00	40	44
284	2024-05-30 19:56:33.296+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:56:33.296+00	93	10
285	2024-05-30 19:56:53.346+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:56:53.346+00	93	14
286	2024-05-30 19:57:54.551+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:57:54.551+00	93	13
287	2024-05-30 19:58:34.03+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:58:34.03+00	93	11
288	2024-05-30 19:58:37.38+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:58:37.381+00	50	18
289	2024-05-30 19:58:53.01+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:58:53.01+00	93	28
290	2024-05-30 19:59:52.485+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:59:52.485+00	40	46
291	2024-05-30 20:05:14.44+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:05:14.44+00	40	19
292	2024-05-30 20:13:00.918+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:13:00.918+00	50	32
293	2024-05-30 20:19:13.267+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:19:13.267+00	50	32
294	2024-05-30 20:41:40.995+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:41:40.995+00	50	10
295	2024-05-30 20:48:51.745+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:48:51.745+00	50	30
296	2024-05-30 20:59:53.499+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:59:53.499+00	50	32
297	2024-05-30 21:40:10.458+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 21:40:10.458+00	50	42
298	2024-05-30 21:40:30.099+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 21:40:30.099+00	50	45
299	2024-05-30 23:07:45.704+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 23:07:45.704+00	88	2
300	2024-05-30 23:08:12.617+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 23:08:12.617+00	88	26
301	2024-05-31 00:29:27.356+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 00:29:27.356+00	3	36
302	2024-05-31 00:29:52.541+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 00:29:52.541+00	3	13
303	2024-05-31 00:32:28.599+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 00:32:28.599+00	3	10
304	2024-05-31 00:32:50.721+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 00:32:50.721+00	3	12
305	2024-05-31 00:34:36.703+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 00:34:36.703+00	3	12
306	2024-05-31 12:45:04.428+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 12:45:04.428+00	50	42
307	2024-05-31 13:14:23.316+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 13:14:23.316+00	86	32
308	2024-05-31 13:14:26.553+00	t	172.26.13.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:14:26.553+00	81	10
309	2024-05-31 13:14:49.425+00	t	172.26.13.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:14:49.425+00	81	10
310	2024-05-31 13:14:51.228+00	t	172.26.13.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:14:51.228+00	81	10
311	2024-05-31 13:14:52.454+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 13:14:52.454+00	86	32
312	2024-05-31 13:15:03.17+00	t	172.26.13.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:15:03.17+00	81	17
313	2024-05-31 13:15:19.197+00	t	172.26.13.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:15:19.197+00	81	19
314	2024-05-31 13:16:04.84+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 13:16:04.84+00	86	42
315	2024-05-31 13:37:53.092+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:37:53.092+00	88	13
316	2024-05-31 13:50:15.75+00	t	132.191.1.241	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:50:15.75+00	24	26
317	2024-05-31 14:02:54.893+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:02:54.893+00	40	38
318	2024-05-31 14:04:01.827+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:04:01.827+00	40	37
319	2024-05-31 14:06:06.861+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:06:06.862+00	40	19
320	2024-05-31 14:07:06.894+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:07:06.894+00	40	19
321	2024-05-31 14:07:23.204+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:07:23.204+00	40	19
322	2024-05-31 14:13:33.354+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:13:33.354+00	40	49
323	2024-05-31 14:13:49.242+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:13:49.242+00	40	19
324	2024-05-31 14:32:25.711+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:32:25.711+00	40	39
325	2024-05-31 14:32:42.2+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:32:42.2+00	40	19
326	2024-05-31 14:43:17.866+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:43:17.866+00	40	44
327	2024-05-31 14:52:21.017+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:52:21.018+00	40	47
328	2024-05-31 16:00:39.18+00	t	38.25.25.92	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:00:39.18+00	85	4
329	2024-05-31 16:01:23.671+00	t	38.25.25.92	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:01:23.671+00	85	15
330	2024-05-31 16:01:31.115+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 16:01:31.115+00	88	32
331	2024-05-31 16:11:25.228+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 16:11:25.228+00	86	13
332	2024-05-31 16:16:50.84+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:16:50.84+00	58	17
333	2024-05-31 16:17:43.484+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:17:43.484+00	58	45
334	2024-05-31 16:18:46.688+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:18:46.688+00	58	45
335	2024-05-31 16:20:24.002+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:20:24.002+00	40	48
336	2024-05-31 16:21:03.618+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:21:03.618+00	40	46
337	2024-05-31 16:46:33.562+00	t	132.191.1.241	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:46:33.562+00	24	15
338	2024-05-31 16:51:38.455+00	t	10.0.28.134	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0	2024-05-31 16:51:38.455+00	99	10
339	2024-05-31 16:54:19.053+00	t	10.0.28.134	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0	2024-05-31 16:54:19.053+00	99	10
340	2024-05-31 16:54:36.09+00	t	10.0.28.134	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0	2024-05-31 16:54:36.09+00	99	10
341	2024-05-31 16:54:50.175+00	t	10.0.28.134	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0	2024-05-31 16:54:50.175+00	99	10
342	2024-05-31 16:55:11.966+00	t	10.0.28.134	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0	2024-05-31 16:55:11.966+00	99	11
343	2024-05-31 16:58:31.368+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-31 16:58:31.368+00	2	11
344	2024-05-31 17:17:25.189+00	t	10.0.25.243	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-31 17:17:25.189+00	45	39
345	2024-05-31 17:17:40.172+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 17:17:40.173+00	97	36
346	2024-05-31 17:18:20.015+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 17:18:20.015+00	97	36
347	2024-05-31 17:43:07.986+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 17:43:07.986+00	86	45
348	2024-05-31 18:57:46.841+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 18:57:46.841+00	46	39
349	2024-05-31 19:32:39.618+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:32:39.618+00	89	45
350	2024-05-31 19:44:30.827+00	t	10.0.28.14	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:44:30.827+00	98	40
351	2024-05-31 19:59:03.048+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:59:03.048+00	40	10
352	2024-05-31 19:59:30.361+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:59:30.361+00	40	11
353	2024-05-31 20:00:00.072+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 20:00:00.072+00	40	13
354	2024-05-31 20:00:16.553+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 20:00:16.554+00	40	14
355	2024-05-31 20:00:38.092+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 20:00:38.092+00	40	15
356	2024-05-31 20:01:07.94+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 20:01:07.94+00	40	16
357	2024-05-31 20:02:12.593+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 20:02:12.593+00	40	36
358	2024-05-31 20:46:03.078+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 20:46:03.078+00	50	45
359	2024-05-31 21:07:09.163+00	t	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 21:07:09.163+00	75	50
360	2024-05-31 22:57:44.327+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 22:57:44.327+00	46	39
361	2024-05-31 23:15:27.617+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 23:15:27.617+00	46	39
362	2024-05-31 23:42:49.87+00	t	10.0.28.192	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 23:42:49.87+00	37	43
363	2024-05-31 23:45:25.883+00	t	10.0.28.192	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 23:45:25.883+00	37	30
364	2024-06-02 04:11:42.219+00	t	38.253.146.110	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:11:42.219+00	24	26
365	2024-06-02 04:11:43.253+00	t	190.237.130.29	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:11:43.253+00	24	26
366	2024-06-02 04:16:23.412+00	t	38.253.146.110	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:16:23.412+00	24	15
367	2024-06-02 04:16:47.432+00	t	190.237.130.29	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:16:47.432+00	24	15
368	2024-06-02 04:18:59.623+00	t	38.253.146.110	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:18:59.623+00	24	19
369	2024-06-02 04:19:28.871+00	t	38.253.146.110	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:19:28.871+00	24	15
370	2024-06-02 04:23:21.809+00	t	38.253.146.110	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:23:21.81+00	24	39
371	2024-06-02 04:24:00.001+00	t	38.253.146.110	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:24:00.001+00	24	38
372	2024-06-03 12:54:31.501+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 12:54:31.501+00	89	43
373	2024-06-03 12:54:50.779+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 12:54:50.779+00	89	45
374	2024-06-03 13:46:46.457+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 13:46:46.457+00	89	45
375	2024-06-03 13:47:26.61+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 13:47:26.61+00	50	32
376	2024-06-03 13:48:01.091+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 13:48:01.091+00	50	42
377	2024-06-03 14:14:28.79+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 14:14:28.79+00	50	32
378	2024-06-03 14:15:24.522+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 14:15:24.522+00	50	42
379	2024-06-03 14:29:47.71+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 14:29:47.711+00	40	37
380	2024-06-03 14:30:18.582+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 14:30:18.582+00	40	19
381	2024-06-03 14:30:48.17+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 14:30:48.17+00	40	49
382	2024-06-03 14:31:12.23+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 14:31:12.23+00	40	38
383	2024-06-03 14:52:19.373+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 14:52:19.373+00	40	44
384	2024-06-03 14:52:45.598+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 14:52:45.598+00	40	44
385	2024-06-03 15:29:44.268+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 15:29:44.268+00	40	39
386	2024-06-03 15:30:05.588+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 15:30:05.589+00	40	47
387	2024-06-03 15:38:57.313+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 15:38:57.314+00	40	46
388	2024-06-03 15:51:39.947+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 15:51:39.948+00	40	48
389	2024-06-03 16:01:00.071+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:01:00.071+00	40	39
390	2024-06-03 16:06:29.631+00	t	10.0.29.11	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:06:29.631+00	4	36
391	2024-06-03 16:13:49.823+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:13:49.823+00	3	3
392	2024-06-03 16:13:58.928+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:13:58.928+00	3	10
393	2024-06-03 16:17:11.342+00	t	10.0.29.11	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:17:11.342+00	4	13
394	2024-06-03 16:36:17.122+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:36:17.122+00	46	39
395	2024-06-03 16:38:55.776+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:38:55.776+00	88	51
396	2024-06-03 16:57:52.227+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-03 16:57:52.227+00	86	43
397	2024-06-03 17:05:23.608+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 17:05:23.608+00	54	30
398	2024-06-03 17:13:52.341+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 17:13:52.341+00	40	20
399	2024-06-03 17:28:35.062+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-03 17:28:35.062+00	86	43
400	2024-06-03 17:28:40.017+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-03 17:28:40.017+00	86	50
401	2024-06-03 17:43:18.709+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 17:43:18.709+00	88	36
402	2024-06-03 19:10:02.115+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 19:10:02.115+00	89	45
403	2024-06-03 19:23:53.545+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 19:23:53.545+00	89	43
404	2024-06-03 19:59:52.142+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 19:59:52.142+00	46	39
405	2024-06-03 20:01:03.72+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:01:03.72+00	46	20
406	2024-06-03 20:06:08.781+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:06:08.781+00	46	39
407	2024-06-03 20:08:18.755+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:08:18.755+00	88	12
408	2024-06-03 20:08:37.194+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:08:37.194+00	88	51
409	2024-06-03 20:26:39.24+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:26:39.24+00	89	43
410	2024-06-03 20:28:30.458+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:28:30.458+00	89	43
411	2024-06-03 20:56:56.266+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:56:56.267+00	89	43
412	2024-06-03 21:30:55.841+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 21:30:55.841+00	46	39
413	2024-06-03 21:48:29.101+00	t	10.0.28.182	192.168.128.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 21:48:29.102+00	88	51
414	2024-06-03 21:51:36.335+00	t	10.0.28.108	192.168.128.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-03 21:51:36.335+00	86	45
415	2024-06-03 21:54:50.624+00	t	10.0.25.210	192.168.144.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 21:54:50.624+00	46	39
416	2024-06-03 21:55:31.479+00	t	10.0.25.210	192.168.144.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 21:55:31.479+00	46	39
417	2024-06-03 21:55:42.523+00	t	10.0.25.210	192.168.144.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 21:55:42.523+00	46	39
418	2024-06-03 22:01:07.156+00	t	10.0.25.210	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 22:01:07.157+00	46	39
419	2024-06-03 22:04:48.188+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 22:04:48.188+00	88	51
420	2024-06-03 22:15:03.327+00	t	10.0.61.173	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 22:15:03.327+00	89	43
421	2024-06-03 22:19:28.479+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 22:19:28.48+00	88	51
422	2024-06-03 22:28:14.128+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 22:28:14.128+00	88	51
423	2024-06-03 22:31:09.031+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 22:31:09.031+00	88	51
424	2024-06-03 22:32:08.807+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 22:32:08.807+00	88	51
425	2024-06-03 22:37:44.774+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 22:37:44.774+00	88	51
426	2024-06-03 23:45:24.314+00	t	10.0.27.29	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 23:45:24.314+00	13	2
427	2024-06-04 13:45:51.277+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 13:45:51.277+00	40	38
428	2024-06-04 13:46:47.099+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 13:46:47.099+00	40	37
429	2024-06-04 13:47:15.284+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 13:47:15.284+00	40	19
430	2024-06-04 13:47:39.113+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 13:47:39.113+00	40	20
431	2024-06-04 13:47:59.002+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 13:47:59.002+00	88	51
432	2024-06-04 13:48:07.945+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 13:48:07.946+00	40	19
433	2024-06-04 13:48:30.111+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 13:48:30.112+00	40	49
434	2024-06-04 14:05:30.06+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 14:05:30.06+00	40	44
435	2024-06-04 14:15:41.243+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 14:15:41.243+00	40	47
436	2024-06-04 14:24:20.777+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 14:24:20.777+00	40	46
437	2024-06-04 14:30:29.629+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 14:30:29.629+00	40	48
438	2024-06-04 14:47:31.694+00	t	10.6.66.93	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 14:47:31.694+00	100	10
439	2024-06-04 14:48:15.58+00	t	10.6.66.93	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 14:48:15.58+00	100	36
440	2024-06-04 15:01:45.384+00	t	10.0.28.187	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:01:45.384+00	3	11
441	2024-06-04 15:14:18.775+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:14:18.775+00	88	11
442	2024-06-04 15:20:36.389+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 15:20:36.389+00	86	11
443	2024-06-04 15:40:33.284+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:40:33.284+00	88	11
444	2024-06-04 15:42:30.504+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:42:30.504+00	88	11
445	2024-06-04 15:46:07.164+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:46:07.164+00	40	39
446	2024-06-04 16:15:12.173+00	t	10.0.28.219	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:15:12.173+00	90	30
447	2024-06-04 16:29:07.394+00	t	10.0.37.224	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:29:07.395+00	102	15
448	2024-06-04 16:29:20.194+00	t	10.0.36.42	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 16:29:20.194+00	27	15
449	2024-06-04 16:29:40.126+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:29:40.126+00	86	11
450	2024-06-04 16:31:22.341+00	t	10.0.37.224	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:31:22.341+00	102	15
451	2024-06-04 17:31:18.011+00	t	10.0.25.105	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 17:31:18.011+00	46	46
452	2024-06-04 17:32:35.345+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 17:32:35.345+00	40	39
453	2024-06-04 17:58:24.459+00	t	10.0.28.15	192.168.176.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 17:58:24.459+00	2	11
454	2024-06-04 19:38:03.69+00	t	10.0.61.165	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 19:38:03.69+00	54	30
455	2024-06-04 19:39:21.217+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 19:39:21.217+00	88	11
456	2024-06-04 19:48:21.815+00	t	10.0.29.11	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 19:48:21.815+00	4	11
457	2024-06-04 20:03:31.067+00	t	10.0.28.187	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 20:03:31.067+00	3	11
458	2024-06-04 20:04:18.128+00	t	10.0.28.187	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 20:04:18.128+00	3	11
459	2024-06-04 20:27:27.988+00	t	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 20:27:27.988+00	38	11
460	2024-06-04 20:41:17.767+00	t	10.0.25.210	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 20:41:17.767+00	46	39
461	2024-06-04 20:45:05.606+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 20:45:05.606+00	40	46
462	2024-06-04 20:46:37.088+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 20:46:37.088+00	86	11
463	2024-06-04 21:08:39.144+00	t	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 21:08:39.144+00	38	11
464	2024-06-04 21:20:38.883+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 21:20:38.883+00	88	51
465	2024-06-04 22:22:43.421+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 22:22:43.421+00	88	53
466	2024-06-04 22:28:07.194+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 22:28:07.194+00	88	13
467	2024-06-04 22:43:10.003+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 22:43:10.003+00	86	11
468	2024-06-04 22:56:52.719+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 22:56:52.719+00	88	13
469	2024-06-04 23:42:02.227+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 23:42:02.227+00	86	11
470	2024-06-04 23:46:43.044+00	t	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 23:46:43.044+00	38	11
471	2024-06-05 00:00:31.694+00	t	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 00:00:31.694+00	38	11
472	2024-06-05 00:01:49.209+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 00:01:49.21+00	88	11
473	2024-06-05 00:06:32.29+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 00:06:32.29+00	86	11
474	2024-06-05 00:27:26.011+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 00:27:26.011+00	88	11
475	2024-06-05 00:27:54.208+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 00:27:54.208+00	88	11
476	2024-06-05 00:29:31.058+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 00:29:31.058+00	88	11
477	2024-06-05 00:29:39.898+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 00:29:39.898+00	88	11
478	2024-06-05 00:30:22.716+00	t	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 00:30:22.716+00	38	11
479	2024-06-05 12:45:43.974+00	t	10.0.62.66	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 12:45:43.974+00	66	30
480	2024-06-05 12:46:23.062+00	t	10.0.62.101	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 12:46:23.062+00	65	30
481	2024-06-05 13:03:46.342+00	t	10.0.61.173	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 13:03:46.342+00	89	32
482	2024-06-05 13:25:05.55+00	t	172.26.13.35	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 13:25:05.55+00	81	13
483	2024-06-05 13:25:54.041+00	t	172.26.13.35	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 13:25:54.042+00	81	37
484	2024-06-05 14:07:18.71+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 14:07:18.71+00	88	51
485	2024-06-05 16:57:41.679+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 16:57:41.679+00	1	12
486	2024-06-05 16:57:41.684+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 16:57:41.684+00	1	12
487	2024-06-05 16:57:58.633+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 16:57:58.633+00	1	12
488	2024-06-05 16:57:58.64+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 16:57:58.64+00	1	12
489	2024-06-05 17:04:12.7+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:04:12.701+00	1	12
490	2024-06-05 17:04:12.706+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:04:12.706+00	1	12
491	2024-06-05 17:10:28.406+00	t	::ffff:10.0.28.182	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 17:10:28.406+00	88	29
492	2024-06-05 17:10:28.419+00	t	::ffff:10.0.28.182	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 17:10:28.42+00	88	29
493	2024-06-05 17:11:53.863+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:11:53.863+00	1	12
494	2024-06-05 17:11:53.871+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:11:53.871+00	1	12
495	2024-06-05 17:12:06.632+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:12:06.632+00	1	22
496	2024-06-05 17:12:06.637+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:12:06.638+00	1	22
497	2024-06-05 17:17:29.893+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:17:29.893+00	1	12
498	2024-06-05 17:17:29.9+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:17:29.901+00	1	12
499	2024-06-05 17:59:13.296+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-06-05 17:59:13.296+00	2	10
500	2024-06-05 17:59:13.309+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-06-05 17:59:13.309+00	2	10
501	2024-06-05 18:15:48.657+00	t	10.0.28.182	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:15:48.657+00	88	53
502	2024-06-05 18:16:06.163+00	t	10.0.28.182	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:16:06.163+00	88	12
503	2024-06-05 18:20:01.689+00	t	10.0.29.29	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:20:01.689+00	103	13
504	2024-06-05 18:45:32.559+00	t	10.0.37.82	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:45:32.559+00	104	13
505	2024-06-05 18:46:17.7+00	t	10.0.37.82	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:46:17.7+00	104	32
506	2024-06-05 18:46:48.858+00	t	10.0.37.82	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:46:48.858+00	104	28
507	2024-06-05 18:48:26.154+00	t	10.0.37.82	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:48:26.155+00	104	28
508	2024-06-05 18:48:51.744+00	t	10.0.37.82	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:48:51.744+00	104	28
509	2024-06-05 19:28:40.265+00	t	10.0.60.87	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 19:28:40.265+00	106	10
510	2024-06-05 19:30:23.291+00	t	10.0.60.87	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 19:30:23.291+00	106	13
511	2024-06-05 19:33:15.253+00	t	10.0.28.108	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 19:33:15.253+00	86	15
\.


--
-- Data for Name: AccessRequestReport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."AccessRequestReport" ("createdAt", "updatedAt", "AccessRequestId", "ReportId") FROM stdin;
\.


--
-- Data for Name: AccessRequests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."AccessRequests" (id, justification, cargo, "nombreJefe", "cargoJefe", "pdfBlob", "createdAt", "updatedAt", active, message, "StateId", "UserId") FROM stdin;
\.


--
-- Data for Name: Dependencies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Dependencies" (id, name, description, "createdAt", active, "updatedAt", "MainDependencyId") FROM stdin;
\.


--
-- Data for Name: GroupTags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."GroupTags" (id, name, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Groups" (id, name, description, "createdAt", "updatedAt", active, icon) FROM stdin;
1	Estratégico	Herramientas utilizadas para planificar a largo plazo y tomar decisiones importantes que afectan a toda la institución.	2024-05-27 06:52:56.379+00	2024-05-27 06:52:56.379+00	t	bar-chart
2	Táctico	Herramientas utilizadas para la ejecución de estrategias a mediano plazo y en la gestión de recursos específicos para alcanzar objetivos concretos de la Gerencia Central o afines.	2024-05-27 06:53:22.635+00	2024-05-27 06:53:22.635+00	t	journal-check
3	Operativo	Herramientas orientadas a la implementación diaria de procesos y actividades para garantizar la eficiencia y el cumplimiento de objetivos a corto plazo.	2024-05-27 06:53:41.271+00	2024-05-27 06:53:41.271+00	t	gear
\.


--
-- Data for Name: ImplementationRequests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ImplementationRequests" (id, justification, "createdAt", estado, "pdfBlob", "updatedAt", message, "StateId", "UserId") FROM stdin;
\.


--
-- Data for Name: LoginAudits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."LoginAudits" (id, "createdAt", success, "publicIp", "privateIp", system, "updatedAt", "UserId") FROM stdin;
1	2024-05-27 06:44:15.801+00	t	135.148.232.71	172.31.0.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	2024-05-27 06:44:15.801+00	1
2	2024-05-27 06:44:39.24+00	t	135.148.232.71	172.31.0.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	2024-05-27 06:44:39.24+00	2
3	2024-05-27 06:50:50.527+00	f	135.148.232.71	172.31.0.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	2024-05-27 06:50:50.527+00	2
4	2024-05-27 06:50:56.495+00	t	135.148.232.71	172.31.0.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	2024-05-27 06:50:56.495+00	2
5	2024-05-27 08:32:14.736+00	t	38.25.16.23	172.31.0.2	python-requests/2.25.1	2024-05-27 08:32:14.736+00	1
6	2024-05-27 08:32:28.093+00	t	38.25.16.23	172.31.0.2	python-requests/2.25.1	2024-05-27 08:32:28.093+00	1
7	2024-05-27 08:33:56.246+00	t	38.25.16.23	172.31.0.2	python-requests/2.25.1	2024-05-27 08:33:56.247+00	1
8	2024-05-27 08:35:43.724+00	t	38.25.16.23	172.31.0.2	python-requests/2.25.1	2024-05-27 08:35:43.724+00	1
9	2024-05-27 08:38:46.386+00	t	38.25.16.23	172.31.0.2	python-requests/2.25.1	2024-05-27 08:38:46.386+00	1
10	2024-05-27 08:40:36.708+00	t	38.25.16.23	172.31.0.2	python-requests/2.25.1	2024-05-27 08:40:36.708+00	1
11	2024-05-27 08:43:50.934+00	t	38.25.16.23	192.168.0.2	python-requests/2.25.1	2024-05-27 08:43:50.935+00	1
12	2024-05-27 08:45:48.86+00	t	38.25.16.23	192.168.16.2	python-requests/2.25.1	2024-05-27 08:45:48.861+00	1
13	2024-05-27 08:47:14.642+00	t	38.25.16.23	192.168.16.2	python-requests/2.25.1	2024-05-27 08:47:14.642+00	1
14	2024-05-27 08:48:43.823+00	t	38.25.16.23	192.168.32.2	python-requests/2.25.1	2024-05-27 08:48:43.824+00	1
15	2024-05-27 13:52:54.867+00	f	10.0.28.15	192.168.48.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 13:52:54.868+00	2
16	2024-05-27 13:52:58.646+00	t	10.0.28.15	192.168.48.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 13:52:58.646+00	2
17	2024-05-27 13:53:23.073+00	t	10.0.28.15	192.168.48.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 13:53:23.073+00	86
18	2024-05-27 13:59:58.881+00	f	10.0.28.143	192.168.48.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 13:59:58.881+00	40
19	2024-05-27 14:00:36.152+00	f	10.0.28.15	192.168.48.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 14:00:36.152+00	86
20	2024-05-27 16:41:08.52+00	t	::ffff:10.0.28.108	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 16:41:08.521+00	86
21	2024-05-27 16:43:23.007+00	t	::ffff:10.0.28.15	10.0.28.15	PostmanRuntime/7.37.3	2024-05-27 16:43:23.007+00	1
22	2024-05-27 16:57:15.119+00	t	::ffff:10.0.28.187	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 16:57:15.12+00	3
23	2024-05-27 20:05:59.431+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 20:05:59.431+00	2
24	2024-05-27 21:19:22.4+00	f	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 21:19:22.4+00	\N
25	2024-05-27 21:19:25.849+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 21:19:25.849+00	1
26	2024-05-27 22:12:47.651+00	t	::ffff:10.0.28.15	10.0.28.15	PostmanRuntime/7.37.3	2024-05-27 22:12:47.651+00	1
27	2024-05-27 22:28:08.538+00	f	10.0.28.15	192.168.96.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 22:28:08.538+00	\N
28	2024-05-27 22:28:10.91+00	t	10.0.28.15	192.168.96.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 22:28:10.91+00	1
29	2024-05-27 22:28:11.489+00	f	10.0.28.108	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 22:28:11.489+00	86
30	2024-05-27 22:28:11.721+00	t	10.0.28.108	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 22:28:11.722+00	86
31	2024-05-27 22:28:18.791+00	f	10.0.28.15	192.168.96.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 22:28:18.791+00	\N
32	2024-05-27 22:28:21.624+00	f	10.0.28.15	192.168.96.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 22:28:21.624+00	\N
33	2024-05-27 22:28:25.988+00	f	10.0.28.15	192.168.96.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 22:28:25.988+00	\N
34	2024-05-27 22:28:33.678+00	f	10.0.28.15	192.168.96.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 22:28:33.678+00	\N
35	2024-05-27 22:28:38.975+00	t	10.0.28.15	192.168.96.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 22:28:38.976+00	2
36	2024-05-27 22:29:00.97+00	f	10.0.28.81	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36	2024-05-27 22:29:00.97+00	\N
37	2024-05-27 22:29:08.825+00	f	10.0.28.81	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36	2024-05-27 22:29:08.825+00	\N
38	2024-05-27 22:29:26.491+00	f	10.0.28.182	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:29:26.491+00	\N
39	2024-05-27 22:29:27.878+00	f	10.0.28.182	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:29:27.878+00	\N
40	2024-05-27 22:29:30.404+00	t	10.0.28.81	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36	2024-05-27 22:29:30.404+00	87
41	2024-05-27 22:29:38.133+00	t	10.0.28.182	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:29:38.133+00	88
42	2024-05-27 22:32:29.582+00	t	10.0.28.15	192.168.96.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-27 22:32:29.583+00	2
43	2024-05-27 22:32:58.869+00	t	10.0.28.182	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:32:58.869+00	88
44	2024-05-27 22:33:14.886+00	t	10.0.28.182	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:33:14.886+00	88
45	2024-05-27 22:33:24.396+00	t	10.0.28.108	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 22:33:24.396+00	86
46	2024-05-27 22:34:01.549+00	t	10.0.28.182	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:34:01.549+00	88
47	2024-05-27 22:35:06.786+00	t	10.0.28.108	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 22:35:06.786+00	86
48	2024-05-27 22:35:09.846+00	t	10.0.28.182	192.168.96.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:35:09.846+00	88
49	2024-05-27 22:36:34.315+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-27 22:36:34.316+00	86
50	2024-05-27 22:36:40.992+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:36:40.992+00	88
51	2024-05-27 22:47:55.487+00	t	132.251.0.247	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-27 22:47:55.487+00	2
52	2024-05-27 22:53:23.065+00	f	10.0.16.28	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:53:23.065+00	10
53	2024-05-27 22:53:43.633+00	t	10.0.16.28	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 22:53:43.633+00	10
54	2024-05-27 23:02:01.935+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 23:02:01.935+00	88
55	2024-05-27 23:41:46.48+00	t	10.0.29.11	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 23:41:46.48+00	4
56	2024-05-27 23:42:26.74+00	f	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 23:42:26.74+00	3
57	2024-05-27 23:42:30.321+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 23:42:30.321+00	3
58	2024-05-27 23:42:31.595+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-27 23:42:31.595+00	3
59	2024-05-28 00:46:19.125+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:19.125+00	2
60	2024-05-28 00:46:21.202+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:21.202+00	2
61	2024-05-28 00:46:23.425+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:23.425+00	2
62	2024-05-28 00:46:31.808+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:31.808+00	2
63	2024-05-28 00:46:35.86+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:35.86+00	2
64	2024-05-28 00:46:40.87+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:40.87+00	2
65	2024-05-28 00:46:49.758+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:49.758+00	2
66	2024-05-28 00:46:50.722+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:50.722+00	2
67	2024-05-28 00:46:51.082+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:51.082+00	2
68	2024-05-28 00:46:51.434+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:51.434+00	2
69	2024-05-28 00:46:51.745+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:51.746+00	2
70	2024-05-28 00:46:52.047+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:52.047+00	2
71	2024-05-28 00:46:52.357+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:52.357+00	2
72	2024-05-28 00:46:52.659+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:46:52.659+00	2
73	2024-05-28 00:47:01.523+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:47:01.523+00	2
74	2024-05-28 00:47:16.634+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:47:16.634+00	2
75	2024-05-28 00:47:26.675+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:47:26.675+00	2
76	2024-05-28 00:47:33.09+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:47:33.09+00	1
77	2024-05-28 00:47:43.918+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:47:43.918+00	2
78	2024-05-28 00:47:47.872+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:47.873+00	2
79	2024-05-28 00:47:49.081+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:49.081+00	2
80	2024-05-28 00:47:50.406+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:50.406+00	2
81	2024-05-28 00:47:50.743+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:50.743+00	2
82	2024-05-28 00:47:51.061+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:51.061+00	2
83	2024-05-28 00:47:51.385+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:51.385+00	2
84	2024-05-28 00:47:51.66+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:51.661+00	2
85	2024-05-28 00:47:52.015+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:52.016+00	2
86	2024-05-28 00:47:52.325+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:52.326+00	2
87	2024-05-28 00:47:58.351+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:47:58.351+00	2
88	2024-05-28 00:48:18.333+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:48:18.333+00	2
89	2024-05-28 00:48:24.077+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:48:24.077+00	2
90	2024-05-28 00:48:38.925+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:48:38.925+00	2
91	2024-05-28 00:48:40.699+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:48:40.7+00	2
92	2024-05-28 00:48:53.146+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:48:53.146+00	1
93	2024-05-28 00:49:00.876+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 00:49:00.876+00	2
94	2024-05-28 00:49:11.538+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:49:11.538+00	2
95	2024-05-28 00:49:45.92+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 00:49:45.92+00	2
96	2024-05-28 00:49:58.35+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-28 00:49:58.35+00	2
97	2024-05-28 01:35:49.948+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 01:35:49.949+00	2
98	2024-05-28 01:36:02.8+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 01:36:02.8+00	1
99	2024-05-28 02:08:03.238+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:08:03.238+00	2
100	2024-05-28 02:08:04.757+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:08:04.757+00	\N
101	2024-05-28 02:08:05.372+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:08:05.372+00	\N
102	2024-05-28 02:08:05.61+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:08:05.611+00	\N
103	2024-05-28 02:08:05.934+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:08:05.934+00	\N
104	2024-05-28 02:08:06.238+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:08:06.238+00	\N
105	2024-05-28 02:08:06.507+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:08:06.507+00	\N
106	2024-05-28 02:08:06.808+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:08:06.808+00	\N
107	2024-05-28 02:08:08.162+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:08:08.162+00	2
108	2024-05-28 02:09:26.348+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:26.348+00	2
109	2024-05-28 02:09:27.798+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:27.798+00	2
110	2024-05-28 02:09:29.274+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:29.274+00	2
111	2024-05-28 02:09:30.582+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:30.582+00	2
112	2024-05-28 02:09:31.902+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:31.902+00	2
113	2024-05-28 02:09:33.36+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:33.361+00	2
114	2024-05-28 02:09:37.257+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:37.257+00	2
115	2024-05-28 02:09:41.52+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:41.52+00	\N
116	2024-05-28 02:09:42.193+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:42.193+00	\N
117	2024-05-28 02:09:42.542+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:42.542+00	\N
118	2024-05-28 02:09:42.851+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:42.851+00	\N
119	2024-05-28 02:09:43.156+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:43.156+00	\N
120	2024-05-28 02:09:43.485+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:43.485+00	\N
121	2024-05-28 02:09:45.254+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:45.254+00	2
122	2024-05-28 02:09:46.68+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:46.68+00	\N
123	2024-05-28 02:09:50.424+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:09:50.424+00	2
124	2024-05-28 02:11:00.663+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:11:00.663+00	2
125	2024-05-28 02:11:00.839+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:11:00.839+00	2
126	2024-05-28 02:11:04.611+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:11:04.611+00	2
127	2024-05-28 02:11:09.192+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:11:09.192+00	2
128	2024-05-28 02:11:13.497+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:11:13.498+00	2
129	2024-05-28 02:11:14.945+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:11:14.945+00	\N
130	2024-05-28 02:11:18.278+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:11:18.279+00	\N
131	2024-05-28 02:11:42.039+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:11:42.039+00	2
132	2024-05-28 02:11:46.777+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:11:46.777+00	2
133	2024-05-28 02:11:48.797+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 02:11:48.797+00	2
134	2024-05-28 02:12:47.412+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:12:47.412+00	2
135	2024-05-28 02:12:50.879+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:12:50.879+00	2
136	2024-05-28 02:12:53.376+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:12:53.376+00	2
137	2024-05-28 02:12:57.743+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:12:57.743+00	2
138	2024-05-28 02:13:00.966+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:13:00.966+00	2
139	2024-05-28 02:13:03.757+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:13:03.757+00	2
140	2024-05-28 02:14:13.526+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:14:13.526+00	2
141	2024-05-28 02:15:04.66+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:15:04.66+00	2
142	2024-05-28 02:15:08.72+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:15:08.72+00	2
143	2024-05-28 02:15:12.765+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:15:12.765+00	2
144	2024-05-28 02:15:15.518+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:15:15.518+00	2
145	2024-05-28 02:15:22.496+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:15:22.496+00	2
146	2024-05-28 02:15:27.002+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:15:27.002+00	2
147	2024-05-28 02:15:34.756+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:15:34.756+00	2
148	2024-05-28 02:15:50.624+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:15:50.624+00	2
149	2024-05-28 02:15:56.703+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:15:56.703+00	1
150	2024-05-28 02:16:03.211+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:16:03.212+00	\N
151	2024-05-28 02:16:06.21+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:16:06.21+00	\N
152	2024-05-28 02:16:07.614+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:16:07.614+00	\N
153	2024-05-28 02:16:07.938+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:16:07.938+00	\N
154	2024-05-28 02:16:08.221+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:16:08.221+00	\N
155	2024-05-28 02:16:08.529+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:16:08.529+00	\N
156	2024-05-28 02:16:30.218+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:16:30.218+00	2
157	2024-05-28 02:16:47.398+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:16:47.399+00	2
158	2024-05-28 02:16:52.667+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:16:52.667+00	2
159	2024-05-28 02:17:04.769+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:04.77+00	2
160	2024-05-28 02:17:06.623+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:06.623+00	2
161	2024-05-28 02:17:08.729+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:08.73+00	2
162	2024-05-28 02:17:11.902+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:11.902+00	2
163	2024-05-28 02:17:13.59+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:13.59+00	2
164	2024-05-28 02:17:16.166+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:16.167+00	2
165	2024-05-28 02:17:17.955+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:17.955+00	2
166	2024-05-28 02:17:23.958+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:23.959+00	\N
167	2024-05-28 02:17:24.862+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:24.863+00	\N
168	2024-05-28 02:17:25.559+00	f	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:25.559+00	\N
169	2024-05-28 02:17:34.04+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:34.04+00	1
170	2024-05-28 02:17:38.419+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 02:17:38.42+00	2
171	2024-05-28 03:08:50.042+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-28 03:08:50.042+00	2
172	2024-05-28 11:38:08.361+00	f	179.6.82.73	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-28 11:38:08.362+00	81
173	2024-05-28 11:38:46.627+00	t	179.6.82.73	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-28 11:38:46.628+00	81
174	2024-05-28 12:29:45.488+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-28 12:29:45.488+00	86
175	2024-05-28 13:02:46.194+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:02:46.194+00	3
176	2024-05-28 13:03:05.765+00	f	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 13:03:05.765+00	55
177	2024-05-28 13:03:09.53+00	f	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 13:03:09.531+00	\N
178	2024-05-28 13:03:20.3+00	f	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 13:03:20.3+00	55
179	2024-05-28 13:04:32.166+00	f	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 13:04:32.166+00	55
180	2024-05-28 13:04:43.905+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 13:04:43.905+00	55
181	2024-05-28 13:09:34.836+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 13:09:34.837+00	55
182	2024-05-28 13:10:22.771+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:10:22.771+00	89
183	2024-05-28 13:11:40.564+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:11:40.564+00	54
184	2024-05-28 13:12:09.673+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:12:09.674+00	55
185	2024-05-28 13:17:07.467+00	f	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:17:07.467+00	58
186	2024-05-28 13:17:14.929+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:17:14.929+00	58
187	2024-05-28 13:28:24.21+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:28:24.21+00	88
188	2024-05-28 13:45:17.363+00	t	10.0.61.174	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:45:17.363+00	55
189	2024-05-28 13:49:44.281+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:49:44.282+00	40
190	2024-05-28 13:49:54.962+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 13:49:54.963+00	40
191	2024-05-28 13:50:40.474+00	f	10.0.28.219	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-28 13:50:40.474+00	\N
192	2024-05-28 13:50:52.753+00	t	10.0.28.219	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-28 13:50:52.753+00	90
193	2024-05-28 15:02:19.505+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:02:19.505+00	3
194	2024-05-28 15:19:30.769+00	t	10.0.61.168	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:19:30.77+00	91
195	2024-05-28 15:21:04.53+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:21:04.53+00	2
196	2024-05-28 15:21:27.194+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:21:27.194+00	2
197	2024-05-28 15:21:28.984+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:21:28.984+00	2
198	2024-05-28 15:21:33.546+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:21:33.547+00	1
199	2024-05-28 15:30:50.883+00	f	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:30:50.883+00	14
200	2024-05-28 15:31:01.291+00	t	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:31:01.291+00	14
201	2024-05-28 15:33:25.398+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:33:25.398+00	2
202	2024-05-28 15:39:57.759+00	t	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:39:57.759+00	14
203	2024-05-28 15:41:28.996+00	t	135.148.232.242	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 15:41:28.996+00	2
204	2024-05-28 15:41:32.535+00	t	135.148.232.242	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 15:41:32.535+00	2
205	2024-05-28 15:41:33.104+00	t	135.148.232.242	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 15:41:33.104+00	2
206	2024-05-28 15:42:41.616+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:42:41.616+00	54
207	2024-05-28 15:45:55.117+00	t	135.148.232.242	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 15:45:55.118+00	2
208	2024-05-28 15:45:55.672+00	t	135.148.232.242	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 15:45:55.673+00	2
209	2024-05-28 15:46:01.468+00	t	135.148.232.242	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 15:46:01.468+00	2
210	2024-05-28 15:46:07.657+00	t	135.148.232.242	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 15:46:07.657+00	2
211	2024-05-28 15:46:11.596+00	t	135.148.232.242	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 15:46:11.596+00	2
212	2024-05-28 15:46:22.704+00	t	135.148.232.242	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:46:22.704+00	2
213	2024-05-28 15:48:45.515+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:48:45.515+00	88
214	2024-05-28 15:50:14.172+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:14.173+00	40
215	2024-05-28 15:50:15.908+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:15.908+00	40
216	2024-05-28 15:50:16.882+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:16.882+00	40
217	2024-05-28 15:50:35.496+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:35.496+00	40
218	2024-05-28 15:50:36.706+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:36.706+00	40
219	2024-05-28 15:50:37.513+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:37.513+00	40
220	2024-05-28 15:50:38.063+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:38.064+00	40
221	2024-05-28 15:50:38.583+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:38.583+00	40
222	2024-05-28 15:50:39.702+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:39.702+00	40
223	2024-05-28 15:50:40.163+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:40.163+00	40
224	2024-05-28 15:50:40.393+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:40.393+00	40
225	2024-05-28 15:50:40.605+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:40.605+00	40
226	2024-05-28 15:50:40.76+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:40.76+00	40
227	2024-05-28 15:50:40.914+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:40.914+00	40
228	2024-05-28 15:50:41.093+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:41.093+00	40
229	2024-05-28 15:50:41.227+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:41.227+00	40
230	2024-05-28 15:50:41.403+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:41.403+00	40
231	2024-05-28 15:50:41.555+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:41.555+00	40
232	2024-05-28 15:50:41.708+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:41.709+00	40
233	2024-05-28 15:50:41.889+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:41.889+00	40
234	2024-05-28 15:50:42.063+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:42.063+00	40
235	2024-05-28 15:50:42.218+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 15:50:42.218+00	40
236	2024-05-28 16:00:38.064+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:00:38.064+00	40
237	2024-05-28 16:00:39.737+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:00:39.737+00	40
238	2024-05-28 16:00:41.871+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:00:41.871+00	40
239	2024-05-28 16:00:43.207+00	f	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:00:43.207+00	40
240	2024-05-28 16:00:50.866+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:00:50.866+00	40
241	2024-05-28 16:03:59.999+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:03:59.999+00	89
242	2024-05-28 16:28:26.918+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:28:26.918+00	88
243	2024-05-28 16:32:01.18+00	t	10.255.1.160	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 16:32:01.18+00	2
244	2024-05-28 17:05:05.022+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 17:05:05.022+00	89
245	2024-05-28 17:16:10.891+00	t	10.255.0.226	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 17:16:10.891+00	2
246	2024-05-28 17:20:45.711+00	t	10.255.0.226	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 17:20:45.711+00	2
247	2024-05-28 17:38:45.744+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 17:38:45.744+00	54
248	2024-05-28 18:06:28.527+00	f	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 18:06:28.527+00	24
249	2024-05-28 18:06:35.253+00	t	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-28 18:06:35.253+00	24
250	2024-05-28 18:18:53.543+00	t	38.25.16.23	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-28 18:18:53.544+00	2
251	2024-05-28 18:20:35.742+00	t	132.251.1.180	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 18:20:35.742+00	24
252	2024-05-28 18:26:26.565+00	t	10.255.0.226	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-05-28 18:26:26.565+00	2
253	2024-05-28 18:41:01.429+00	t	190.235.38.201	192.168.112.2	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/25.0 Chrome/121.0.0.0 Mobile Safari/537.36	2024-05-28 18:41:01.429+00	88
254	2024-05-28 18:46:35.911+00	f	10.0.36.151	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 18:46:35.911+00	\N
255	2024-05-28 18:46:44.248+00	t	10.0.36.151	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 18:46:44.248+00	92
256	2024-05-28 19:09:58.719+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:09:58.719+00	88
257	2024-05-28 19:24:49.134+00	f	10.0.24.33	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:24:49.134+00	\N
258	2024-05-28 19:24:52.683+00	f	10.0.24.33	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:24:52.683+00	\N
259	2024-05-28 19:24:56.548+00	f	10.0.24.33	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:24:56.548+00	\N
260	2024-05-28 19:24:59.029+00	f	10.0.24.33	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:24:59.029+00	\N
261	2024-05-28 19:35:24.979+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:35:24.98+00	40
262	2024-05-28 19:49:08.873+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:49:08.873+00	54
263	2024-05-28 19:50:17.506+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:50:17.506+00	89
264	2024-05-28 19:59:11.29+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 19:59:11.29+00	89
265	2024-05-28 20:46:33.089+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 20:46:33.089+00	54
266	2024-05-28 21:11:11.893+00	f	132.251.1.180	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 21:11:11.893+00	24
267	2024-05-28 21:50:22.202+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 21:50:22.202+00	40
268	2024-05-28 22:02:32.461+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 22:02:32.461+00	88
269	2024-05-28 22:05:49.945+00	t	132.251.1.180	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 22:05:49.945+00	24
270	2024-05-28 23:30:48.666+00	f	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 23:30:48.666+00	46
271	2024-05-28 23:31:37.956+00	f	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 23:31:37.956+00	46
272	2024-05-28 23:33:40.587+00	f	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 23:33:40.587+00	46
273	2024-05-28 23:40:55.285+00	f	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-28 23:40:55.285+00	46
274	2024-05-28 23:45:57.998+00	t	132.251.0.165	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-28 23:45:57.998+00	2
275	2024-05-28 23:46:34.484+00	t	132.251.0.165	192.168.112.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-05-28 23:46:34.484+00	2
276	2024-05-29 00:51:38.73+00	t	38.25.17.97	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 00:51:38.73+00	2
277	2024-05-29 11:21:05.89+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 11:21:05.891+00	40
278	2024-05-29 12:39:00.991+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 12:39:00.991+00	89
279	2024-05-29 12:39:18.372+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 12:39:18.372+00	89
280	2024-05-29 13:03:16.643+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 13:03:16.643+00	58
281	2024-05-29 13:04:36.457+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 13:04:36.458+00	54
282	2024-05-29 13:06:26.675+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 13:06:26.675+00	50
283	2024-05-29 13:06:50.353+00	t	10.0.37.206	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 13:06:50.353+00	24
284	2024-05-29 13:28:05.078+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 13:28:05.079+00	89
285	2024-05-29 13:32:06.579+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 13:32:06.579+00	86
286	2024-05-29 13:47:26.81+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 13:47:26.81+00	40
287	2024-05-29 13:50:36.444+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 13:50:36.444+00	2
288	2024-05-29 14:03:39.38+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:03:39.38+00	40
289	2024-05-29 14:04:13.512+00	f	172.22.52.109	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:04:13.513+00	\N
290	2024-05-29 14:04:18.876+00	f	172.22.52.109	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:04:18.877+00	\N
291	2024-05-29 14:29:51.345+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 14:29:51.345+00	86
292	2024-05-29 14:39:26.442+00	t	132.251.2.147	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 14:39:26.442+00	24
293	2024-05-29 15:04:59.728+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 15:04:59.728+00	54
294	2024-05-29 15:28:23.822+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 15:28:23.822+00	89
295	2024-05-29 15:31:57.66+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 15:31:57.66+00	89
296	2024-05-29 15:52:59.98+00	f	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 15:52:59.98+00	88
297	2024-05-29 15:53:10.126+00	f	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 15:53:10.126+00	88
298	2024-05-29 15:53:14.05+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 15:53:14.05+00	88
299	2024-05-29 16:02:40.547+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:02:40.547+00	88
300	2024-05-29 16:07:09.561+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:07:09.561+00	89
301	2024-05-29 16:08:16.71+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:08:16.71+00	89
302	2024-05-29 16:09:41.21+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:09:41.21+00	89
303	2024-05-29 16:10:56.196+00	t	132.251.2.147	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:10:56.196+00	24
304	2024-05-29 16:17:30.431+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:17:30.431+00	58
305	2024-05-29 16:20:56.689+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 16:20:56.689+00	86
306	2024-05-29 16:21:28.547+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:21:28.548+00	46
307	2024-05-29 16:23:22.182+00	t	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:23:22.183+00	14
308	2024-05-29 16:24:15.209+00	f	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 16:24:15.21+00	\N
309	2024-05-29 16:25:02.618+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 16:25:02.618+00	93
310	2024-05-29 16:25:52.555+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-29 16:25:52.556+00	88
311	2024-05-29 16:25:59.121+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 16:25:59.121+00	2
312	2024-05-29 16:26:06.089+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 16:26:06.089+00	2
313	2024-05-29 16:26:18.407+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 16:26:18.407+00	2
314	2024-05-29 16:27:09.145+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-29 16:27:09.145+00	2
315	2024-05-29 16:31:46.214+00	t	10.0.37.23	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:31:46.215+00	94
316	2024-05-29 16:39:25.714+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:39:25.714+00	54
317	2024-05-29 16:41:43.055+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 16:41:43.055+00	89
318	2024-05-29 17:47:28.451+00	f	172.24.34.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 17:47:28.451+00	\N
319	2024-05-29 17:49:13.021+00	t	172.24.34.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 17:49:13.022+00	95
320	2024-05-29 19:00:11.714+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:00:11.714+00	54
321	2024-05-29 19:20:18.197+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:20:18.197+00	89
322	2024-05-29 19:48:38.325+00	t	172.24.34.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 19:48:38.325+00	14
323	2024-05-29 21:19:05.605+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 21:19:05.605+00	46
324	2024-05-29 21:25:43.037+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 21:25:43.037+00	89
325	2024-05-29 22:39:59.407+00	t	10.0.16.28	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-29 22:39:59.407+00	10
326	2024-05-30 12:00:32.676+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 12:00:32.677+00	54
327	2024-05-30 13:12:13.447+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 13:12:13.447+00	89
328	2024-05-30 14:00:40.389+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-30 14:00:40.389+00	86
329	2024-05-30 14:01:25.09+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:01:25.09+00	88
330	2024-05-30 14:03:19.657+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:03:19.657+00	40
331	2024-05-30 14:17:56.407+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:17:56.407+00	58
332	2024-05-30 14:26:06.618+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 14:26:06.618+00	93
333	2024-05-30 14:35:52.141+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:35:52.141+00	89
334	2024-05-30 14:46:13.249+00	f	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:46:13.249+00	1
335	2024-05-30 14:46:59.423+00	t	10.0.28.9	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 14:46:59.423+00	96
336	2024-05-30 15:06:19.276+00	f	10.0.37.128	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:06:19.276+00	\N
337	2024-05-30 15:29:44.631+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:29:44.631+00	89
338	2024-05-30 15:35:55.36+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 15:35:55.36+00	50
339	2024-05-30 16:52:55.311+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 16:52:55.311+00	88
340	2024-05-30 16:56:04.899+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 16:56:04.899+00	58
341	2024-05-30 19:31:33.791+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:31:33.791+00	89
342	2024-05-30 19:31:41.299+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:31:41.299+00	89
343	2024-05-30 19:34:42.722+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:34:42.722+00	50
344	2024-05-30 19:35:09.484+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:35:09.485+00	89
345	2024-05-30 19:37:33.418+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:37:33.418+00	50
346	2024-05-30 19:37:38.929+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:37:38.929+00	50
347	2024-05-30 19:38:04.375+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:38:04.375+00	89
348	2024-05-30 19:42:07.391+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:42:07.391+00	89
349	2024-05-30 19:42:27.442+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:42:27.443+00	50
350	2024-05-30 19:42:34.509+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:42:34.509+00	50
351	2024-05-30 19:42:43.986+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:42:43.986+00	50
352	2024-05-30 19:42:51.432+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:42:51.432+00	50
353	2024-05-30 19:47:13.836+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:47:13.836+00	40
354	2024-05-30 19:49:48.082+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:49:48.082+00	40
355	2024-05-30 19:50:25.195+00	t	10.0.37.223	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-30 19:50:25.195+00	93
356	2024-05-30 19:56:01.92+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:56:01.92+00	89
357	2024-05-30 19:58:29.575+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 19:58:29.576+00	50
358	2024-05-30 20:01:09.303+00	f	10.0.36.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:01:09.303+00	22
359	2024-05-30 20:01:14.551+00	f	10.0.36.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:01:14.551+00	22
360	2024-05-30 20:01:15.613+00	f	10.0.36.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:01:15.613+00	22
361	2024-05-30 20:01:16.538+00	f	10.0.36.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:01:16.538+00	22
362	2024-05-30 20:01:20.863+00	f	10.0.36.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:01:20.864+00	22
363	2024-05-30 20:02:47.499+00	f	10.0.62.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:02:47.499+00	61
364	2024-05-30 20:02:52.089+00	f	10.0.62.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:02:52.089+00	61
365	2024-05-30 20:03:08.091+00	f	10.0.62.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 20:03:08.091+00	61
366	2024-05-30 22:37:09.612+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 22:37:09.612+00	97
367	2024-05-30 22:37:18.976+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 22:37:18.976+00	46
368	2024-05-30 23:07:32.046+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-30 23:07:32.046+00	88
369	2024-05-31 00:28:43.789+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 00:28:43.789+00	3
370	2024-05-31 12:44:44.273+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 12:44:44.273+00	50
371	2024-05-31 13:08:13.116+00	f	10.0.44.121	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:08:13.116+00	\N
372	2024-05-31 13:08:17.753+00	f	10.0.44.121	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:08:17.754+00	\N
373	2024-05-31 13:12:34.243+00	f	172.26.13.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:12:34.243+00	81
374	2024-05-31 13:12:44.541+00	f	172.26.13.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:12:44.541+00	81
375	2024-05-31 13:13:45.687+00	t	172.26.13.35	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:13:45.687+00	81
376	2024-05-31 13:14:03.2+00	f	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 13:14:03.2+00	86
377	2024-05-31 13:14:04.892+00	f	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 13:14:04.892+00	86
378	2024-05-31 13:14:10.494+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 13:14:10.494+00	86
379	2024-05-31 13:37:43.186+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:37:43.186+00	88
380	2024-05-31 13:50:00.06+00	t	132.191.1.241	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 13:50:00.06+00	24
381	2024-05-31 14:02:24.869+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:02:24.869+00	40
382	2024-05-31 14:10:19.81+00	f	10.0.16.47	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:10:19.81+00	30
383	2024-05-31 14:10:24.564+00	f	10.0.16.47	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:10:24.564+00	30
384	2024-05-31 14:12:28.549+00	f	10.0.36.59	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 14:12:28.549+00	22
385	2024-05-31 15:20:38.117+00	f	38.25.25.92	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 15:20:38.117+00	85
386	2024-05-31 15:20:43.082+00	f	38.25.25.92	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 15:20:43.083+00	85
387	2024-05-31 15:20:43.319+00	f	38.25.25.92	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 15:20:43.319+00	85
388	2024-05-31 15:20:43.6+00	f	38.25.25.92	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 15:20:43.6+00	85
389	2024-05-31 15:20:53.819+00	f	38.25.25.92	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 15:20:53.819+00	85
390	2024-05-31 15:22:00.057+00	f	38.25.25.92	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 15:22:00.057+00	85
391	2024-05-31 15:24:22.448+00	f	172.25.50.7	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	2024-05-31 15:24:22.448+00	84
392	2024-05-31 15:26:07.748+00	t	172.25.50.7	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	2024-05-31 15:26:07.749+00	84
393	2024-05-31 15:59:03.366+00	f	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 15:59:03.367+00	88
394	2024-05-31 15:59:16.338+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 15:59:16.338+00	88
395	2024-05-31 15:59:40.719+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 15:59:40.719+00	86
396	2024-05-31 16:00:19.043+00	t	38.25.25.92	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:00:19.043+00	85
397	2024-05-31 16:00:27.021+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 16:00:27.021+00	88
398	2024-05-31 16:11:19.086+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 16:11:19.086+00	86
399	2024-05-31 16:16:32.924+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:16:32.924+00	58
400	2024-05-31 16:20:16.143+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:20:16.143+00	40
401	2024-05-31 16:29:03.367+00	t	10.0.28.136	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-31 16:29:03.368+00	86
402	2024-05-31 16:37:33.405+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-31 16:37:33.405+00	98
403	2024-05-31 16:38:07.97+00	f	10.1.40.51	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:38:07.97+00	\N
404	2024-05-31 16:39:39.861+00	f	10.1.40.8	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 16:39:39.861+00	\N
405	2024-05-31 16:39:52.174+00	f	10.1.40.8	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 16:39:52.175+00	\N
406	2024-05-31 16:39:53.185+00	f	10.1.40.8	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 16:39:53.185+00	\N
407	2024-05-31 16:40:03.647+00	f	10.1.40.8	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 16:40:03.647+00	\N
408	2024-05-31 16:46:26.174+00	t	132.191.1.241	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:46:26.174+00	24
409	2024-05-31 16:50:31.263+00	f	10.0.28.134	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0	2024-05-31 16:50:31.263+00	\N
410	2024-05-31 16:50:45.371+00	f	10.0.28.134	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0	2024-05-31 16:50:45.371+00	\N
411	2024-05-31 16:51:19.022+00	t	10.0.28.134	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0	2024-05-31 16:51:19.022+00	99
412	2024-05-31 16:54:44.346+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:54:44.347+00	3
413	2024-05-31 16:56:01.071+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 16:56:01.071+00	3
414	2024-05-31 16:56:37.234+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-31 16:56:37.235+00	2
415	2024-05-31 17:07:50.425+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 17:07:50.425+00	3
416	2024-05-31 17:16:20.347+00	t	10.0.25.243	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-05-31 17:16:20.347+00	45
417	2024-05-31 17:17:03.474+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 17:17:03.474+00	97
418	2024-05-31 17:23:40.238+00	f	154.47.24.154	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 17:23:40.239+00	61
419	2024-05-31 17:36:04.559+00	t	10.0.28.14	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 17:36:04.559+00	98
420	2024-05-31 17:45:30.284+00	t	154.47.24.154	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 17:45:30.284+00	61
421	2024-05-31 17:48:39.763+00	f	154.47.24.154	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 17:48:39.763+00	61
422	2024-05-31 17:48:40.111+00	t	154.47.24.154	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 17:48:40.111+00	61
423	2024-05-31 17:48:40.196+00	t	154.47.24.154	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 17:48:40.197+00	61
424	2024-05-31 17:48:40.496+00	t	154.47.24.154	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 17:48:40.496+00	61
425	2024-05-31 18:47:11.133+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:47:11.133+00	75
426	2024-05-31 18:47:12.638+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:47:12.639+00	75
427	2024-05-31 18:48:12.772+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:48:12.772+00	75
428	2024-05-31 18:48:14.811+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:48:14.812+00	75
429	2024-05-31 18:48:52.516+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:48:52.516+00	75
430	2024-05-31 18:48:53.914+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:48:53.914+00	75
431	2024-05-31 18:50:19.668+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:50:19.668+00	75
432	2024-05-31 18:50:21.418+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:50:21.419+00	75
433	2024-05-31 18:50:54.116+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:50:54.116+00	75
434	2024-05-31 18:51:01.046+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:51:01.046+00	75
435	2024-05-31 18:51:26.065+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:51:26.065+00	75
436	2024-05-31 18:52:55.853+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:52:55.854+00	75
437	2024-05-31 18:52:59.995+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 18:52:59.995+00	75
438	2024-05-31 18:57:27.469+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-05-31 18:57:27.469+00	46
439	2024-05-31 19:32:35.737+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:32:35.737+00	89
440	2024-05-31 19:36:08.326+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:36:08.327+00	50
441	2024-05-31 19:36:18.268+00	f	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:36:18.268+00	50
442	2024-05-31 19:36:23.977+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:36:23.977+00	50
443	2024-05-31 19:44:16.713+00	t	10.0.28.14	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:44:16.713+00	98
444	2024-05-31 19:58:58.904+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 19:58:58.904+00	40
445	2024-05-31 20:34:22.011+00	f	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 20:34:22.011+00	75
446	2024-05-31 21:05:18.429+00	t	10.0.16.49	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 21:05:18.429+00	75
447	2024-05-31 21:49:57.898+00	t	154.47.24.154	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 21:49:57.898+00	61
448	2024-05-31 21:49:58.266+00	t	154.47.24.154	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 21:49:58.266+00	61
449	2024-05-31 21:49:58.466+00	t	154.47.24.154	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 21:49:58.466+00	61
450	2024-05-31 22:03:33.539+00	t	190.234.22.198	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 22:03:33.54+00	61
451	2024-05-31 22:57:33.59+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 22:57:33.59+00	46
452	2024-05-31 22:59:28.21+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 22:59:28.211+00	97
453	2024-05-31 23:15:23.584+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 23:15:23.584+00	46
454	2024-05-31 23:42:21.083+00	t	10.0.28.192	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-05-31 23:42:21.084+00	37
455	2024-06-01 00:59:05.869+00	t	10.0.61.172	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-01 00:59:05.869+00	58
456	2024-06-02 04:06:24.502+00	t	38.253.146.110	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:06:24.502+00	24
457	2024-06-02 04:07:12.678+00	f	190.237.130.29	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:07:12.678+00	\N
458	2024-06-02 04:08:01.668+00	f	190.237.130.29	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:08:01.668+00	\N
459	2024-06-02 04:09:12.88+00	f	190.237.130.29	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:09:12.88+00	\N
460	2024-06-02 04:09:21.163+00	f	190.237.130.29	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:09:21.163+00	\N
461	2024-06-02 04:09:59.58+00	f	190.237.130.29	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:09:59.58+00	\N
462	2024-06-02 04:10:35.018+00	t	190.237.130.29	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-02 04:10:35.018+00	24
463	2024-06-03 12:54:26.428+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 12:54:26.428+00	89
464	2024-06-03 13:46:55.893+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 13:46:55.893+00	50
465	2024-06-03 14:29:41.821+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 14:29:41.821+00	40
466	2024-06-03 16:06:22.212+00	t	10.0.29.11	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:06:22.212+00	4
467	2024-06-03 16:13:13.595+00	t	10.0.28.187	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:13:13.595+00	3
468	2024-06-03 16:36:07.485+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:36:07.486+00	46
469	2024-06-03 16:38:45.053+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 16:38:45.053+00	88
470	2024-06-03 16:46:09.552+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-03 16:46:09.553+00	2
471	2024-06-03 16:57:44.392+00	t	10.0.28.108	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-03 16:57:44.392+00	86
472	2024-06-03 17:05:01.538+00	t	10.0.61.165	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 17:05:01.538+00	54
473	2024-06-03 17:11:56.029+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 17:11:56.029+00	40
474	2024-06-03 17:46:54.116+00	f	10.0.62.111	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 17:46:54.116+00	66
475	2024-06-03 17:47:10.767+00	f	10.0.62.111	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 17:47:10.767+00	66
476	2024-06-03 17:47:32.11+00	f	10.0.62.111	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 17:47:32.11+00	66
477	2024-06-03 19:09:58.812+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 19:09:58.812+00	89
478	2024-06-03 19:19:19.093+00	f	10.0.36.243	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 19:19:19.093+00	\N
479	2024-06-03 19:20:32.727+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-03 19:20:32.728+00	2
480	2024-06-03 19:59:45.844+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 19:59:45.844+00	46
481	2024-06-03 20:06:04.558+00	t	10.0.25.105	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:06:04.558+00	46
482	2024-06-03 20:08:07.943+00	t	10.0.28.182	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:08:07.943+00	88
483	2024-06-03 20:12:10.809+00	t	10.0.28.15	192.168.112.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-03 20:12:10.809+00	2
484	2024-06-03 20:26:34.643+00	t	10.0.61.173	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 20:26:34.643+00	89
485	2024-06-03 21:30:48.161+00	t	10.0.25.210	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 21:30:48.161+00	46
486	2024-06-03 21:34:23.642+00	t	10.0.28.143	192.168.112.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 21:34:23.642+00	40
487	2024-06-03 21:51:31.239+00	t	10.0.28.108	192.168.128.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-03 21:51:31.24+00	86
488	2024-06-03 21:54:41.572+00	t	10.0.25.210	192.168.144.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 21:54:41.573+00	46
489	2024-06-03 21:55:21.571+00	t	10.0.25.210	192.168.144.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 21:55:21.571+00	46
490	2024-06-03 21:57:12.481+00	t	132.191.1.15	192.168.176.2	Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/125.0.6422.80 Mobile/15E148 Safari/604.1	2024-06-03 21:57:12.482+00	2
491	2024-06-03 21:57:31.761+00	t	10.0.28.15	192.168.176.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-03 21:57:31.762+00	2
492	2024-06-03 22:04:29.805+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 22:04:29.805+00	88
493	2024-06-03 23:45:09.871+00	f	10.0.27.29	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 23:45:09.871+00	13
494	2024-06-03 23:45:16.836+00	t	10.0.27.29	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-03 23:45:16.836+00	13
495	2024-06-04 12:13:25.725+00	f	10.0.36.59	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 12:13:25.725+00	22
496	2024-06-04 13:45:31.944+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 13:45:31.945+00	40
497	2024-06-04 13:47:53.391+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 13:47:53.391+00	88
498	2024-06-04 14:47:13.806+00	t	10.6.66.93	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 14:47:13.806+00	100
499	2024-06-04 14:50:27.708+00	t	10.0.28.15	192.168.176.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 14:50:27.708+00	2
500	2024-06-04 15:01:34.087+00	t	10.0.28.187	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:01:34.087+00	3
501	2024-06-04 15:19:39.692+00	f	181.176.72.253	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:19:39.692+00	\N
502	2024-06-04 15:19:50.521+00	f	181.176.72.253	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:19:50.521+00	\N
503	2024-06-04 15:20:29.52+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 15:20:29.52+00	86
504	2024-06-04 15:22:06.707+00	f	181.176.72.253	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:22:06.707+00	\N
505	2024-06-04 15:45:59.201+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:45:59.202+00	40
506	2024-06-04 15:51:29.187+00	t	10.0.27.41	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 15:51:29.187+00	101
507	2024-06-04 16:14:51.372+00	t	10.0.28.219	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:14:51.373+00	90
508	2024-06-04 16:28:45.476+00	f	10.0.37.224	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:28:45.476+00	\N
509	2024-06-04 16:28:52.371+00	t	10.0.37.224	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:28:52.371+00	102
510	2024-06-04 16:29:00.894+00	f	10.0.36.42	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 16:29:00.894+00	27
511	2024-06-04 16:29:09.198+00	t	10.0.36.42	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 16:29:09.198+00	27
512	2024-06-04 16:29:21.8+00	f	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:29:21.8+00	86
513	2024-06-04 16:29:23.791+00	f	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:29:23.791+00	86
514	2024-06-04 16:29:31.355+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 16:29:31.355+00	86
515	2024-06-04 17:31:03.458+00	t	10.0.25.105	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 17:31:03.458+00	46
516	2024-06-04 17:58:10.572+00	t	10.0.28.15	192.168.176.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 17:58:10.572+00	2
517	2024-06-04 19:37:35.858+00	t	10.0.61.165	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 19:37:35.858+00	54
518	2024-06-04 19:39:15.905+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 19:39:15.905+00	88
519	2024-06-04 19:47:57.296+00	t	10.0.29.11	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 19:47:57.296+00	4
520	2024-06-04 20:03:01.518+00	t	10.0.28.15	192.168.176.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 20:03:01.518+00	2
521	2024-06-04 20:03:24.978+00	t	10.0.28.187	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 20:03:24.978+00	3
522	2024-06-04 20:15:23.438+00	f	172.31.147.6	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 20:15:23.439+00	\N
523	2024-06-04 20:15:54.007+00	f	172.31.147.6	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 20:15:54.007+00	\N
524	2024-06-04 20:27:16.453+00	t	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 20:27:16.453+00	38
525	2024-06-04 20:41:11.071+00	t	10.0.25.210	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 20:41:11.071+00	46
526	2024-06-04 20:45:00.347+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 20:45:00.348+00	40
527	2024-06-04 20:46:31.14+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 20:46:31.141+00	86
528	2024-06-04 21:47:40.11+00	t	10.0.28.143	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 21:47:40.111+00	40
529	2024-06-04 22:22:27.598+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-04 22:22:27.598+00	88
530	2024-06-04 22:43:05.591+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-04 22:43:05.591+00	86
531	2024-06-04 23:46:09.137+00	f	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 23:46:09.138+00	\N
532	2024-06-04 23:46:15.565+00	f	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 23:46:15.565+00	\N
533	2024-06-04 23:46:26.81+00	f	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 23:46:26.81+00	\N
534	2024-06-04 23:46:37.571+00	t	10.0.28.63	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-04 23:46:37.571+00	38
535	2024-06-05 00:06:26.291+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 00:06:26.292+00	86
536	2024-06-05 00:27:20.829+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 00:27:20.829+00	88
537	2024-06-05 12:45:04.283+00	t	10.0.62.101	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 12:45:04.283+00	65
538	2024-06-05 12:45:09.155+00	t	10.0.62.66	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 12:45:09.155+00	66
539	2024-06-05 12:57:25.004+00	t	10.0.61.173	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 12:57:25.004+00	89
540	2024-06-05 13:24:43.719+00	t	10.0.28.108	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 13:24:43.719+00	86
541	2024-06-05 13:24:45.62+00	t	172.26.13.35	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 13:24:45.62+00	81
542	2024-06-05 13:48:02.419+00	t	10.0.28.182	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 13:48:02.419+00	88
543	2024-06-05 14:22:41.131+00	f	10.0.62.105	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 14:22:41.131+00	\N
544	2024-06-05 14:23:16.895+00	f	10.0.62.105	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 14:23:16.895+00	61
545	2024-06-05 14:24:31.898+00	f	10.0.62.105	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 14:24:31.898+00	61
546	2024-06-05 14:48:58.21+00	f	10.0.27.29	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 14:48:58.21+00	13
547	2024-06-05 14:49:07.488+00	t	10.0.27.29	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 14:49:07.488+00	13
548	2024-06-05 14:52:20.5+00	t	10.0.28.15	192.168.176.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 14:52:20.5+00	2
549	2024-06-05 14:52:34.211+00	f	10.0.27.29	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 14:52:34.211+00	13
550	2024-06-05 14:52:34.384+00	f	10.0.27.29	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 14:52:34.384+00	13
551	2024-06-05 14:52:34.572+00	t	10.0.27.29	192.168.176.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 14:52:34.572+00	13
552	2024-06-05 15:16:07.769+00	f	::ffff:10.0.28.182	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 15:16:07.77+00	\N
553	2024-06-05 15:16:17.059+00	t	::ffff:10.0.28.182	10.0.28.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 15:16:17.059+00	88
554	2024-06-05 15:40:15.151+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 15:40:15.151+00	2
555	2024-06-05 15:40:22.3+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 15:40:22.3+00	1
556	2024-06-05 16:59:06.242+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 16:59:06.242+00	2
557	2024-06-05 17:40:35.053+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:40:35.053+00	2
558	2024-06-05 17:40:48.921+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:40:48.921+00	1
559	2024-06-05 17:56:41.253+00	t	::ffff:10.0.28.15	10.0.28.15	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 17:56:41.253+00	2
560	2024-06-05 18:15:25.375+00	t	10.0.28.15	192.168.224.2	Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1	2024-06-05 18:15:25.376+00	2
561	2024-06-05 18:15:36.081+00	t	10.0.28.182	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:15:36.081+00	88
562	2024-06-05 18:15:52.531+00	t	10.0.28.182	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:15:52.532+00	88
563	2024-06-05 18:16:01.367+00	t	10.0.28.182	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:16:01.368+00	88
564	2024-06-05 18:19:14.488+00	t	10.0.29.29	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:19:14.488+00	103
565	2024-06-05 18:45:01.307+00	f	10.0.37.82	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:45:01.307+00	\N
566	2024-06-05 18:45:07.878+00	f	10.0.37.82	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:45:07.879+00	\N
567	2024-06-05 18:45:20.656+00	t	10.0.37.82	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 18:45:20.656+00	104
568	2024-06-05 19:23:01.097+00	f	10.0.28.15	192.168.224.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 19:23:01.098+00	1
569	2024-06-05 19:23:04.914+00	t	10.0.28.15	192.168.224.2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	2024-06-05 19:23:04.914+00	1
570	2024-06-05 19:26:07.312+00	t	10.0.13.113	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 19:26:07.312+00	105
571	2024-06-05 19:28:05.454+00	t	10.0.13.113	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 19:28:05.454+00	105
572	2024-06-05 19:28:26.468+00	t	10.0.60.87	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 19:28:26.468+00	106
573	2024-06-05 19:31:24.09+00	f	10.0.60.232	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 19:31:24.09+00	\N
574	2024-06-05 19:31:35.816+00	t	10.0.60.232	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	2024-06-05 19:31:35.816+00	107
575	2024-06-05 19:32:15.16+00	t	10.0.28.108	192.168.224.2	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	2024-06-05 19:32:15.161+00	86
\.


--
-- Data for Name: MainDependencies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MainDependencies" (id, name, description, "createdAt", active, "updatedAt") FROM stdin;
\.


--
-- Data for Name: Modules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Modules" (id, name, description, "createdAt", "updatedAt", active, icon) FROM stdin;
1	Administrativo	Administrativo	2024-05-27 06:54:59.342+00	2024-05-27 06:54:59.342+00	t	laptop
2	Aseguramiento	Aseguramiento	2024-05-27 06:55:30.651+00	2024-05-27 06:55:30.651+00	t	heart-pulse
3	Prestaciones de salud	Prestaciones de salud	2024-05-27 06:55:58.05+00	2024-05-27 06:55:58.05+00	t	hospital
4	Prestaciones Económicas	Prestaciones Económicas	2024-05-27 06:56:34.852+00	2024-05-27 06:56:34.853+00	t	graph-up-arrow
5	CEABE y Logística	CEABE y Logística	2024-05-27 06:57:43.351+00	2024-05-27 06:57:43.351+00	t	clipboard-data
6	Capital Humano	Capital Humano	2024-05-27 06:58:12.952+00	2024-05-27 06:58:12.952+00	t	person-gear
7	Fenómeno del Niño	Fenómeno del Niño	2024-05-27 06:58:38.435+00	2024-05-27 06:58:38.436+00	t	cloud-rain
8	IETSI	IETSI	2024-05-27 06:59:09.539+00	2024-05-27 06:59:09.539+00	t	file-earmark-text
9	Ex UGAD	Ex UGAD	2024-05-27 06:59:38.846+00	2024-05-27 06:59:38.846+00	t	bar-chart
10	Proyectos en construcción	Proyectos en construcción	2024-05-27 07:00:15.354+00	2024-05-27 07:00:15.354+00	t	easel
\.


--
-- Data for Name: Notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Notifications" (id, name, "shortDescription", description, "createdAt", link, opened, "openedAt", "updatedAt", "UserId") FROM stdin;
1	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.325+00	\N	f	\N	2024-05-27 16:42:43.326+00	1
2	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	4
3	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	5
4	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	6
5	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	7
6	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	8
7	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	10
8	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	11
9	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	12
10	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	13
11	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	14
12	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	17
13	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.326+00	\N	f	\N	2024-05-27 16:42:43.326+00	15
14	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	16
16	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	19
15	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	18
17	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	21
18	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	20
19	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	22
20	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	23
21	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	36
22	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	37
23	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	38
24	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	41
25	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	44
26	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	49
27	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	50
28	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	51
29	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	52
30	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	53
31	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	54
32	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	55
33	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	56
34	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	57
35	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	58
36	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	59
37	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.327+00	\N	f	\N	2024-05-27 16:42:43.327+00	60
38	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.328+00	\N	f	\N	2024-05-27 16:42:43.328+00	61
39	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.328+00	\N	f	\N	2024-05-27 16:42:43.328+00	62
40	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.328+00	\N	f	\N	2024-05-27 16:42:43.328+00	63
41	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.328+00	\N	f	\N	2024-05-27 16:42:43.328+00	64
42	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.328+00	\N	f	\N	2024-05-27 16:42:43.328+00	65
43	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.328+00	\N	f	\N	2024-05-27 16:42:43.328+00	66
44	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.328+00	\N	f	\N	2024-05-27 16:42:43.328+00	67
45	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.328+00	\N	f	\N	2024-05-27 16:42:43.328+00	68
46	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.328+00	\N	f	\N	2024-05-27 16:42:43.329+00	69
47	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	70
48	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	71
53	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	84
60	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.764+00	\N	f	\N	2024-05-27 16:42:53.764+00	6
64	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.764+00	\N	f	\N	2024-05-27 16:42:53.764+00	11
69	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	16
74	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	21
80	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	41
83	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	50
88	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	55
93	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	60
98	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	65
103	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	70
108	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	81
49	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	73
54	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	85
59	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.764+00	\N	f	\N	2024-05-27 16:42:53.764+00	5
65	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.764+00	\N	f	\N	2024-05-27 16:42:53.764+00	12
72	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	19
77	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	36
84	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	51
89	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	56
94	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	61
99	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	66
104	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	71
109	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	84
50	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	75
55	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	3
58	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.764+00	\N	f	\N	2024-05-27 16:42:53.764+00	4
63	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.764+00	\N	f	\N	2024-05-27 16:42:53.764+00	10
68	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	15
73	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	20
78	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	37
85	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	52
90	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	57
95	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	62
100	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	67
105	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	73
110	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	85
51	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	78
56	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	86
57	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.764+00	\N	f	\N	2024-05-27 16:42:53.764+00	1
62	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.764+00	\N	f	\N	2024-05-27 16:42:53.764+00	8
67	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	14
71	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	18
76	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	23
81	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	44
87	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	54
91	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	58
96	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	63
101	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	68
106	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	75
111	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	3
52	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:43.329+00	\N	f	\N	2024-05-27 16:42:43.329+00	81
61	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.764+00	\N	f	\N	2024-05-27 16:42:53.764+00	7
66	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	13
70	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	17
75	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.765+00	22
79	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.765+00	\N	f	\N	2024-05-27 16:42:53.766+00	38
82	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	49
86	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.766+00	\N	f	\N	2024-05-27 16:42:53.766+00	53
92	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	59
97	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	64
102	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	69
107	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	78
112	Cambios en reporte	El reporte Indicadores de Salud Renal ha sido actualizado en el módulo 1	\N	2024-05-27 16:42:53.767+00	\N	f	\N	2024-05-27 16:42:53.767+00	86
113	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.284+00	\N	f	\N	2024-05-29 16:26:35.284+00	1
114	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.284+00	\N	f	\N	2024-05-29 16:26:35.284+00	3
115	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.284+00	\N	f	\N	2024-05-29 16:26:35.284+00	4
116	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.284+00	\N	f	\N	2024-05-29 16:26:35.284+00	5
117	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.284+00	\N	f	\N	2024-05-29 16:26:35.284+00	6
118	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.284+00	\N	f	\N	2024-05-29 16:26:35.285+00	7
120	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	10
119	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	8
121	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	11
123	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	13
122	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	12
124	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	14
125	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	15
126	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	16
127	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	17
128	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	18
129	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	19
130	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	20
131	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	21
132	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	22
133	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	23
134	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.285+00	36
135	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.285+00	\N	f	\N	2024-05-29 16:26:35.286+00	37
136	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	38
137	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	41
138	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	43
139	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	44
140	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	47
141	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	49
142	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	50
143	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	51
144	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	52
145	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	53
146	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	54
147	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	55
148	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	56
149	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	57
153	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	61
157	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	65
161	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	69
165	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	74
169	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	82
173	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.288+00	\N	f	\N	2024-05-29 16:26:35.288+00	2
150	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	58
154	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	62
158	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	66
162	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	70
166	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	75
170	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	84
174	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.288+00	\N	f	\N	2024-05-29 16:26:35.288+00	88
151	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	59
155	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	63
159	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	67
163	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	71
167	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	77
171	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	85
175	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.288+00	\N	f	\N	2024-05-29 16:26:35.288+00	91
152	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.286+00	\N	f	\N	2024-05-29 16:26:35.286+00	60
160	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	68
168	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	78
176	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.288+00	\N	f	\N	2024-05-29 16:26:35.288+00	89
156	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	64
164	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.287+00	73
172	Cambios en reporte	El reporte Transacciones OSPES ha sido actualizado en el módulo 17	\N	2024-05-29 16:26:35.287+00	\N	f	\N	2024-05-29 16:26:35.288+00	86
177	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.214+00	\N	f	\N	2024-05-31 16:01:16.214+00	1
178	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.214+00	\N	f	\N	2024-05-31 16:01:16.214+00	4
179	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.214+00	\N	f	\N	2024-05-31 16:01:16.214+00	5
180	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.214+00	\N	f	\N	2024-05-31 16:01:16.214+00	21
181	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	22
182	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	23
183	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	37
184	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	38
185	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	41
186	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	49
187	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	50
188	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	51
189	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	53
190	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	52
191	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	54
192	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	55
193	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	56
194	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	57
195	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	58
196	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	59
197	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	61
198	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	62
199	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.215+00	63
200	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.215+00	\N	f	\N	2024-05-31 16:01:16.216+00	64
201	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	65
202	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	66
203	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	67
204	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	68
205	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	69
206	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	70
207	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	71
208	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	73
209	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	74
210	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	75
211	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	82
212	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	84
213	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	85
214	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	3
215	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	86
216	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	88
219	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	4
225	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	38
229	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	51
233	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	55
237	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	59
241	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	64
245	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	68
250	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	74
254	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	85
258	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.421+00	\N	f	\N	2024-05-31 16:01:23.421+00	2
217	Cambios en reporte	El reporte Solicitudes procesadas, días y subsidios otorgados ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:16.216+00	\N	f	\N	2024-05-31 16:01:16.216+00	2
218	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	1
223	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	23
231	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	53
239	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	62
248	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	71
256	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.421+00	\N	f	\N	2024-05-31 16:01:23.421+00	86
220	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	5
226	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	41
230	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	52
234	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	56
238	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	61
242	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	65
246	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	69
251	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	75
255	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.421+00	\N	f	\N	2024-05-31 16:01:23.421+00	3
222	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	22
224	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	37
228	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.42+00	50
232	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	54
236	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	58
240	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	63
244	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	67
249	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	73
253	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	84
257	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.421+00	\N	f	\N	2024-05-31 16:01:23.421+00	88
221	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	21
227	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.419+00	\N	f	\N	2024-05-31 16:01:23.419+00	49
235	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	57
243	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	66
247	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	70
252	Cambios en reporte	El reporte Boletines estadísticos de Prestaciones Económicas ha sido actualizado en el módulo 11	\N	2024-05-31 16:01:23.42+00	\N	f	\N	2024-05-31 16:01:23.42+00	82
\.


--
-- Data for Name: Reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Reports" (id, name, description, version, "createdAt", "updatedAt", active, icon, link, free, limited, restricted, "ModuleId", "GroupId") FROM stdin;
36	Seguimiento de trámites - Externo	Reporte que muestra información actualizada sobre el estado de los trámites externos realizados con EsSalud.	1.0	2024-05-27 07:52:00+00	2024-05-27 07:52:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNjdiOGQ5ZTgtNWUzNC00ZjU4LTkxNzgtNDc0NzNhNzMxNzBmIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	1	3
42	Gasto Operativo por Redes Asistenciales	Reporte que informa sobre el gasto operativo asistencial y administrativo ejecutado por redes y centros asistenciales según análisis y distribución del gasto.	1.0	2024-05-27 07:58:00+00	2024-05-27 07:58:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiYWVhZjcyYmItZjA5ZS00NzQ3LTk5NzAtYTA1NmFhOGI3Y2M4IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	4	3
43	Transacciones OSPES	Reporte utilizado para el seguimiento y análisis de las transacciones realizadas en las OSPES.	1.0	2024-05-27 07:59:00+00	2024-05-27 07:59:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMjQ0ODkwMTctMjA0Yy00NmE5LTgzN2ItMTlkNjA0NzYyODNhIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	4	3
44	Ingresos y Distribución de Bienes Estratégicos en Almacenes	Reporte operativo que monitorea el movimiento de ingresos (proveedores o redistribución) y distribución de bienes estratégicos a IPRESS de EsSalud.	1.0	2024-05-27 08:01:00+00	2024-05-27 08:01:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZTkyMzZkNzctYmUzYy00YmFjLTgxZTItMWU2NjcwMjU3OTJiIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	10	3
45	Médicos por Nivel de IPRESS	Muestra la cantidad de médicos por nivel de atención de las IPRESS según Red, IPRESS, periodo.	1.0	2024-05-27 08:02:00+00	2024-05-27 08:02:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZmQ2NmFiMmEtNDA2Mi00MzI0LWEwZjUtYTRlZGRlNjVkOTY3IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	10	3
46	Monitoreo de Contratos de Bienes Estratégicos	Reporte operativo que monitorea el avance de los contratos de bienes estratégicos suscritos con proveedores	1.0	2024-05-27 08:03:00+00	2024-05-27 08:03:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNzI5ODZhMTYtZGExNC00OWEyLWFjOGQtNDI3MzQzNzdlYWVlIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	10	3
47	Monitoreo de Entrega de Pedidos de Bienes Estratégicos	Reporte operativo que monitorea el estado situacional de la entrega de ordenes de compra y transferencia de bienes estratégicos en Almacenes	1.0	2024-05-27 08:04:00+00	2024-05-27 08:04:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZjMyYjEwOTMtOGQzNy00ODNkLTgyZjgtMzIwNTlmMDZlMzJiIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	10	3
1	Estado Situacional - Cardiología	Reporte que permite ver el estado situacional de Cardiología a nivel institucional.	1.0	2024-05-27 07:06:00+00	2024-05-27 07:06:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMDhiOGRhZDMtYjQ0Mi00MTI1LTg0ZDMtNWUxYWU1NjQwNGVlIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	3	1
48	Monitoreo del Consumo del Mes de Bienes Estratégicos	Reporte operativo que monitorea el avance del consumo en el mes de los bienes estratégicos a nivel nacional, redes asistenciales e IPRESS	1.0	2024-05-27 08:04:00+00	2024-05-27 08:04:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNjM3OTljOTQtMDU1Mi00ZGJjLWI5N2ItYzcyYTBiMWUwMDk3IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	10	3
49	Monitoreo del Sobrestock y Gestión de Redistribución	Reporte operativo que monitorea el sobrestock de bienes estratégicos a nivel nacional y por redes asistenciales, y favorece la gestión de redistribución	1.0	2024-05-27 08:05:00+00	2024-05-27 08:05:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiOTNkYTFiODYtMDE4MS00OTFhLWI2MmMtNmFiYzFmODFlMGJjIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	10	3
50	Seguimiento de Control Simultáneo y Posterior de la Gerencia General	Reporte utilizado para realizar el seguimiento a los informes de control simultáneos y posteriores de la Gerencia General.	1.0	2024-05-27 08:06:00+00	2024-05-27 08:06:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZGIyNGU0OWQtZDhiNy00MDk4LWIwMjYtMWI3NzY5MmI5YTg3IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	f	t	10	3
51	Seguimiento de resoluciones: Designación de personal	Reporte que permite conocer el estado de trámite registrado en el Sistema de Gestión Documental.	1.0	2024-05-27 08:06:00+00	2024-05-27 08:06:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNzY0ODYyMjgtMzBjYy00ZjlmLTkwZDUtZDI3MmE1MjlhZmVhIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	f	t	10	3
3	Estado situacional - Oncología	Reporte que permite observar el estado situacional por Oncología en EsSalud.	1.0	2024-05-27 07:11:00+00	2024-05-27 07:11:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNmZlZDcxM2QtZWYxNC00ODFmLTgwNzQtMzY2Mjk5YjQ1ZWMxIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	3	1
20	Monitoreo de Riesgo de Vencimiento de bienes estratégicos	Reporte estratégico que permite ver información sobre los lotes de bienes estratégicos en riesgo de vencimiento (próximos 06 meses) en Almacenes e IPRESS de EsSalud	1.0	2024-05-27 07:27:00+00	2024-05-27 07:27:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiOGM3NjQ5MTYtZTEzMi00YTI0LThiMjAtNmMxYWU4NzhiNjFjIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	5	2
2	Estado situacional - Dengue (Interno)	Reporte que describe la situación actual del dengue en EsSalud, incluyendo el número de casos, hospitalizaciones, defunciones y medidas de control implementadas para prevenir su propagación	1.0	2024-05-27 07:11:00+00	2024-05-27 07:11:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiYmNjNDVhNjAtNzY0Yy00Njg3LWFlZjctZGY0NjIxZTMwNzkxIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	3	1
4	Estado situacional de locadores	Reporte que muestra información sobre el estado situacional de locadores por redes, función y profesión.	1.0	2024-05-27 07:12:00+00	2024-05-27 07:12:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNThkNDgxNTctZjg1Yy00NGVmLWJmNDItOGVjYjUwYjczM2M4IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	5	1
5	Estado situacional del Dengue - Pruebas	Estado situacional del Dengue - Pruebas	1.0	2024-05-27 07:13:00+00	2024-05-27 07:13:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiYzZjM2RiMWEtYzEwZC00YzdmLWI3YTQtY2M2MmNkNmIzNTU1IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	10	1
6	Indicadores de prestaciones de salud - SES	Indicadores de prestaciones de salud - SES	1.0	2024-05-27 07:15:00+00	2024-05-27 07:15:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNDYxZmMxMWEtZjI5Yy00OTlkLWE2NDAtNTY4ZDk5YmFhZmYzIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	9	1
7	Indicadores de Salud Renal	Reporte según tratamiento de sustitución renal, vigilancia en salud renal y, pacientes y tratamiento muestra indicadores de estructura, indicadores de proceso e indicadores de resultado para cada caso.	1.0	2024-05-27 07:15:00+00	2024-05-27 07:15:00+00	f	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNDJjMzJkYjEtOGUyNC00ZGYxLWEyZjgtOGU3YzVmNjMyZTEwIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	3	1
8	Indicadores de salud renal - SES	Indicadores de salud renal - SES	1.0	2024-05-27 07:16:00+00	2024-05-27 07:16:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiOTI4NjdlYmQtNDRjNS00YWY4LWFjNGMtZmQzMmNjYWY5MDY5IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	9	1
9	Sala situacional de EsSalud	Sala situacional de EsSalud	1.0	2024-05-27 07:17:00+00	2024-05-27 07:17:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNDcyMjQyOTYtOWZhNy00YWUzLThjYjEtNGU2MDZlNDU2MjFlIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	9	1
35	Disponibilidad de camas	Reporte que muestra la disponibilidad de camas a nivel de red y centro asistencial	1.0	2024-05-27 07:51:00+00	2024-05-27 07:51:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNDI5NTFjMzAtYTk4NS00NWU2LWI4MDAtM2E3YTUwOGJmYmZjIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	10	2
10	Gestión sin colas	Reporte que cuenta con información del sistema de Gestión sin Colas a nivel de oficina sobre los nuevos usuarios, cantidad de tickets generados como también los tiempos de espera, servicio y respuesta.	1.0	2024-05-27 07:19:00+00	2024-05-27 07:19:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZDQ3ZWI2M2YtNGE1Yy00NjYzLWFiMmMtNjM4ZjhlNDEyZWMzIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	1	2
11	Mi Consulta	Reporte que permite visualizar la información relacionada a la aplicación EsSalud - MiConsulta. Se puede apreciar el avance de registros en la aplicación, el estado de las IPRESS en su condición de citas habilitadas por la aplicación.	1.0	2024-05-27 07:20:00+00	2024-05-27 07:20:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiODEyYTFlMGYtMzFiNC00NTFjLWI2MDgtYWQwYTAyNjZjNGQyIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	1	2
12	Pedidos del Congreso de la República	Reporte que hace seguimiento de los pedidos realizados por el congreso de la república y otras entidades.	1.0	2024-05-27 07:21:00+00	2024-05-27 07:21:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZGU0MWRkMGItMWY1Zi00Mjk1LTgwOTItNmUzMzlhN2UzNzNjIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	f	t	1	2
13	Sistema de Gestión Documental	Reporte que facilita la visualización relacionada al Sistema de Gestión Documental SGD. El reporte cuenta de tres dimensiones: Gestión de ahorro, gestión documental y gestión de usuarios a nivel de dependencia y fecha.	1.0	2024-05-27 07:21:00+00	2024-05-27 07:21:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMDk0ZjMzNzItZGZiNC00YWE5LTk0ZDctMjZiMTFkYWIzYjUxIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	1	2
14	Trámite Cabildo	Reporte que permite conocer el estado de trámite de proveedores cuyos procesos de pago están aún pendientes.	1.0	2024-05-27 07:22:00+00	2024-05-27 07:22:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMmJiMTFiN2ItZWEyNC00NTkyLWIxZjItYTBmN2I3MjE4NjI0IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	1	2
15	Población Asegurada a Essalud	Reporte que muestra la población asegurada a EsSalud según seguro y asegurado, departamento, red y rango de edad (GCPS, GCSPE 1 y GCSPE 2).	1.0	2024-05-27 07:23:00+00	2024-05-27 07:23:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiYjM0Y2EyZTgtY2RiYy00ZWYzLTlhMWMtNTE0ZjA1M2M1NzQ4IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	2	2
16	Seguro Complementario de Trabajo de Riesgo	Reporte que contiene información sobre el seguro complementario de trabajo de riesgo (+ Protección) según SCTR, aportantes del SCTR, evolución de aporte, empresas, recaudación y brecha.	1.0	2024-05-27 07:24:00+00	2024-05-27 07:24:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNzIyOTUzNWUtOTk2MS00MTNkLTg3ODMtYWJmOWM0NWI1NTI5IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	2	2
17	Seguro contra accidentes	Reporte que contiene información sobre el seguro contra accidentes (+ Vida) según aportantes, monto de aporte, empresas, recaudación, siniestros y brecha.	1.0	2024-05-27 07:25:00+00	2024-05-27 07:25:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMjQxNDdlMzgtMmNmMC00YjY2LWFjZTItN2QzNDc2OThjZjU3IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	f	t	2	2
18	Capital Humano	Reporte que muestra información sobre la planilla de trabajadores de EsSalud. El reporte muestra datos al nivel de sexo, grupo etario, sector, red asistencial, función, cargo y régimen laboral.	1.0	2024-05-27 07:26:00+00	2024-05-27 07:26:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiYmNhMWIwZmYtMTA2MS00NGRlLWE4ODItZGU4NmFjMTYxOTFkIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	6	2
19	Monitoreo de Abastecimiento – Nacional	Reporte estratégico que permite ver información sobre el estado situacional del abastecimiento de bienes estratégicos de suministro centralizado a nivel nacional, sus coberturas nacionales y el estado de sus procesos de abastecimiento.	1.0	2024-05-27 07:26:00+00	2024-05-27 07:26:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiODVlYjIxZGMtYzZkNi00YTQ4LWE2ZjgtYjljZjRjM2FhNGNkIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	5	2
21	Eventos supuestamente atribuibles a vacunación e inmunización (ESAVI)	Eventos supuestamente atribuibles a vacunación e inmunización en vacunatorios de EsSalud	1.0	2024-05-27 07:28:00+00	2024-05-27 07:28:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZTE1ZTE1YzQtZDRlYy00NGJiLWJiMTUtM2NjMzlkNWFmMGFlIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	8	2
22	Guía de práctica clínica: Enfermedad Hipertensiva del Embarazo	Indicadores para evaluación de la adherencia de la guía de práctica clínica para el manejo de la enfermedad hipertensiva del embarazo	1.0	2024-05-27 07:29:00+00	2024-05-27 07:29:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMjc3ZDU3M2MtMTMzMS00M2FiLTkxY2QtZmMyZjMwMWU0NzJhIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	8	2
23	Guía de práctica clínica: Enfermedad Renal Crónica	Indicadores para evaluación de la adherencia de la guía de práctica clínica para el manejo de la enfermedad renal crónica en estadios 2, 3A, 3B, 4 y 5	1.0	2024-05-27 07:30:00+00	2024-05-27 07:30:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMTBiODA3NzUtZTRiYi00MDgxLWE1ODAtOWE5YmY3NDZjZWYwIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	8	2
24	Guía de práctica clínica: Hemofilia	Indicadores para evaluación de la adherencia de la guía de práctica clínica para el manejo de la hemofilia	1.0	2024-05-27 07:32:00+00	2024-05-27 07:32:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZDUwYjRiZjItNTlmMC00MDQyLWE4MjUtZmIwNjFmZmI5NzQyIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	8	2
25	Defunciones validadas por Dengue	Reporte que permite observar las defunciones por Dengue en EsSalud, ofreciendo datos sobre el número total de fallecimientos y distribución geográfica.	1.0	2024-05-27 07:32:00+00	2024-05-27 07:32:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiYzgxMGMwMmQtMzgxOS00MWQwLTkwNzYtOWUxNDVlMWRjOTQ5IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	3	2
26	Estado situacional - Dengue (Externo)	Reporte que describe la situación actual del dengue en EsSalud, incluyendo el número de casos y medidas de control implementadas para prevenir su propagación	1.0	2024-05-27 07:34:00+00	2024-05-27 07:34:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNjAyYTM3MmQtYmVkMy00YTQxLThhODgtNmZhMjQ3YTY4YmVmIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	3	2
27	Hospitalizaciones por Dengue	Reporte que permite observar las hospitalizaciones por Dengue en EsSalud, ofreciendo datos sobre el número total de casos en hospitalización y distribución geográfica.	1.0	2024-05-27 07:45:00+00	2024-05-27 07:45:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNzYwNzQ3ODYtODRkYi00MGE2LWJkMjQtMGU1ZDhhNzBiNGI3IiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	3	2
28	Pacientes crónicos en Essalud	Reporte con información sobre pacientes crónicos asegurados y registrados en EsSalud según pacientes, principal enfermedad y enfermedades crónicas.	1.0	2024-05-27 07:46:00+00	2024-05-27 07:46:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNzExNzNjODAtNGQ5Yi00Mjk2LTllYTQtNWYxY2I3OGNiMDBlIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	3	2
29	Aporte de Asegurados Titulares	Reporte que muestra los aportes de asegurados titulares a nivel de empresas y personas.	1.0	2024-05-27 07:46:00+00	2024-05-27 07:46:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMzJhNjVkNjctY2NiOS00ZDA3LTk4ODItZjNiODkyNTgyM2IzIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	4	2
30	Certificado de Incapacidad Temporal para el trabajo	Reporte que cuenta con información  sobre los certificados de incapacidad temporal para el trabajo, los cuales se subdividen en incapacidad temporal y maternidad	1.0	2024-05-27 07:47:00+00	2024-05-27 07:47:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNGY2M2Q2YTMtMzdjMS00NDlmLWFmMTUtNzM0YzZmZWU1ZjQzIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	4	2
31	Proceso presupuestal y financiero de las prestaciones económicas	Reporte con información actualizada sobre el seguimiento y análisis del proceso presupuestal y financiero de las prestaciones económicas realizado.	1.0	2024-05-27 07:48:00+00	2024-05-27 07:48:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMGVjNmE2ZTYtZTk0ZS00MWFmLTllNDctMjk4M2I4NjE4M2ZjIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	f	t	4	2
32	Solicitudes procesadas, días y subsidios otorgados	Reporte que muestra información sobre las solicitudes procesadas, subsidios otorgados, regímenes y modalidades según tipo de subsidio: incapacidad temporal, maternidad, lactancia ley N° 26790, lactancia D.L N°885 y sepelio.	1.0	2024-05-27 07:49:00+00	2024-05-27 07:49:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZTRiZTQwMzQtMDdiNS00NzViLTg3MjctZDQ5YzM4YmNiODljIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	4	2
33	Subsidios Procesados en Essalud	Reporte que permite ver los subsidios procesados en EsSalud y envuelve CIIU, días subsidiados, lactancia, enfermedad o accidente y maternidad.	1.0	2024-05-27 07:49:00+00	2024-05-27 07:49:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNDcxOThkMTYtOTgxYy00M2Y3LWI1MGMtZWU0ZDFjNGI4NTIyIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	4	2
34	Defunciones por COVID19	Reporte que muestra información de las defunciones causadas por COVID19 a nivel de IPRESS	1.0	2024-05-27 07:50:00+00	2024-05-27 07:50:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMzM4YTk1YzktYzM4Zi00NDVhLTg5ZWItYjVmMmNhYzAyZjRmIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	10	2
37	Monitoreo de abastecimiento - Canal de Distribución	Reporte que permite  ver información sobre el estado situacional de coberturas de bienes estratégicos a nivel nacional y por canal de distribución (redes)	1.0	2024-05-27 07:53:00+00	2024-05-27 07:53:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiMWZjZGVhYTctNzhiMC00ZDdlLWIxZDUtN2JjYmI4ZTZkZGFkIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	5	3
38	Monitoreo de Abastecimiento - IPRESS	Reporte que permite  ver información sobre el estado situacional de coberturas de bienes estratégicos en IPRESS a nivel nacional, los saldos por lotes y evolución del consumo	1.0	2024-05-27 07:54:00+00	2024-05-27 07:54:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiM2Q5MTJmYmEtN2JhMi00MTlmLWFlMjItOTdhM2NjNWQ4N2RiIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	5	3
52	Seguimiento de trámite - GCTIC	Seguimiento de trámite - GCTIC	1.0	2024-05-27 08:08:00+00	2024-05-27 08:08:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNTRlNTQ4YWUtNzFhYS00MGRhLWJmNjUtM2YwY2YwMDcwYTUyIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	f	t	10	3
53	Seguimiento de trámite - GCGP	Reporte que permite conocer el estado de trámite registrado en el Sistema de Gestión Documental.	1.0	2024-05-27 08:08:00+00	2024-05-27 08:08:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZWFiNWYzZTEtNDVlOC00ZWQxLWI5MjctNzNhYjUyZDI0M2RjIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	f	t	10	3
39	Monitoreo de Carga de Consumo ESSI - SAP en IPRESS	Reporte operativo que monitorea la carga diaria de consumo de ESSI - SAP a nivel de IPRESS de EsSalud.	1.0	2024-05-27 07:55:00+00	2024-05-27 07:55:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZDZlNTk3OGItMGJkMy00ZjUyLTgzYmUtNjM4MDM3ZTkzMTZiIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	t	f	5	3
40	Monitoreos	Reporte que permite observar el monitoreo central al seguimiento del niño global con base en hitos segmentando por Red Asistencial, IPRESS y lineamiento.	1.0	2024-05-27 07:56:00+00	2024-05-27 07:56:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiZWRkOTRjYjQtNWJkMi00YjI5LTgzMTAtZWE4ZWU2MTdiOGMxIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	t	f	f	7	3
41	Detalle de defunciones validadas por Dengue	Reporte que detalla las defunciones relacionadas con el dengue, destacando su distribución a nivel de red y centros asistenciales en EsSalud	1.0	2024-05-27 07:57:00+00	2024-05-27 07:57:00+00	t	clipboard-data	https://app.powerbi.com/view?r=eyJrIjoiNjNhMmZhNjItZWYzZi00ZjNlLWJmYjMtOGI1ZTJiMjZmYzJlIiwidCI6IjM0ZjMyNDE5LTFjMDUtNDc1Ni04OTZlLTQ1ZDYzMzcyNjU5YiIsImMiOjR9	f	f	t	3	3
\.


--
-- Data for Name: Roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Roles" (id, name, active, "createdAt", "updatedAt") FROM stdin;
1	user	t	2024-05-27 06:43:46.665+00	2024-05-27 06:43:46.665+00
2	admin	t	2024-05-27 06:43:46.666+00	2024-05-27 06:43:46.666+00
\.


--
-- Data for Name: States; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."States" (id, name, active, "createdAt", "updatedAt") FROM stdin;
1	PENDIENTE DE FIRMA	t	2024-05-27 06:43:46.675+00	2024-05-27 06:43:46.675+00
2	POR REVISAR	t	2024-05-27 06:43:46.675+00	2024-05-27 06:43:46.675+00
3	APROBADO	t	2024-05-27 06:43:46.675+00	2024-05-27 06:43:46.675+00
4	DENEGADO	t	2024-05-27 06:43:46.675+00	2024-05-27 06:43:46.675+00
\.


--
-- Data for Name: TagReport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."TagReport" ("createdAt", "updatedAt", "TagId", "ReportId") FROM stdin;
\.


--
-- Data for Name: Tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Tags" (id, name, "createdAt", "updatedAt", "GroupTagId") FROM stdin;
\.


--
-- Data for Name: UserModule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserModule" ("createdAt", "updatedAt", "UserId", "ModuleId") FROM stdin;
2024-05-27 16:12:10.779+00	2024-05-27 16:12:10.779+00	1	7
2024-05-27 16:12:10.81+00	2024-05-27 16:12:10.81+00	3	7
2024-05-27 16:12:10.835+00	2024-05-27 16:12:10.835+00	4	7
2024-05-27 16:12:10.862+00	2024-05-27 16:12:10.862+00	5	7
2024-05-27 16:12:10.889+00	2024-05-27 16:12:10.889+00	7	7
2024-05-27 16:12:10.934+00	2024-05-27 16:12:10.934+00	8	7
2024-05-27 16:12:10.975+00	2024-05-27 16:12:10.975+00	10	7
2024-05-27 16:12:11+00	2024-05-27 16:12:11+00	11	7
2024-05-27 16:12:11.023+00	2024-05-27 16:12:11.023+00	12	7
2024-05-27 16:12:11.051+00	2024-05-27 16:12:11.051+00	13	7
2024-05-27 16:12:11.108+00	2024-05-27 16:12:11.108+00	14	7
2024-05-27 16:12:11.152+00	2024-05-27 16:12:11.152+00	15	7
2024-05-27 16:12:11.178+00	2024-05-27 16:12:11.178+00	16	7
2024-05-27 16:12:11.202+00	2024-05-27 16:12:11.202+00	17	7
2024-05-27 16:12:11.223+00	2024-05-27 16:12:11.223+00	18	7
2024-05-27 16:12:11.242+00	2024-05-27 16:12:11.242+00	19	7
2024-05-27 16:12:11.261+00	2024-05-27 16:12:11.261+00	20	7
2024-05-27 16:12:11.279+00	2024-05-27 16:12:11.279+00	21	7
2024-05-27 16:12:11.299+00	2024-05-27 16:12:11.299+00	22	7
2024-05-27 16:12:11.32+00	2024-05-27 16:12:11.32+00	23	7
2024-05-27 16:12:11.339+00	2024-05-27 16:12:11.339+00	36	7
2024-05-27 16:12:11.359+00	2024-05-27 16:12:11.359+00	37	7
2024-05-27 16:12:11.382+00	2024-05-27 16:12:11.382+00	38	7
2024-05-27 16:12:11.404+00	2024-05-27 16:12:11.404+00	40	7
2024-05-27 16:12:11.424+00	2024-05-27 16:12:11.424+00	41	7
2024-05-27 16:12:11.445+00	2024-05-27 16:12:11.445+00	43	7
2024-05-27 16:12:11.463+00	2024-05-27 16:12:11.463+00	47	7
2024-05-27 16:12:11.481+00	2024-05-27 16:12:11.481+00	49	7
2024-05-27 16:12:11.502+00	2024-05-27 16:12:11.502+00	50	7
2024-05-27 16:12:11.522+00	2024-05-27 16:12:11.522+00	51	7
2024-05-27 16:12:11.542+00	2024-05-27 16:12:11.542+00	52	7
2024-05-27 16:12:11.562+00	2024-05-27 16:12:11.562+00	53	7
2024-05-27 16:12:11.581+00	2024-05-27 16:12:11.581+00	54	7
2024-05-27 16:12:11.604+00	2024-05-27 16:12:11.604+00	55	7
2024-05-27 16:12:11.623+00	2024-05-27 16:12:11.623+00	56	7
2024-05-27 16:12:11.644+00	2024-05-27 16:12:11.644+00	57	7
2024-05-27 16:12:11.671+00	2024-05-27 16:12:11.671+00	58	7
2024-05-27 16:12:11.694+00	2024-05-27 16:12:11.694+00	59	7
2024-05-27 16:12:11.715+00	2024-05-27 16:12:11.715+00	60	7
2024-05-27 16:12:11.733+00	2024-05-27 16:12:11.733+00	61	7
2024-05-27 16:12:11.752+00	2024-05-27 16:12:11.752+00	62	7
2024-05-27 16:12:11.772+00	2024-05-27 16:12:11.772+00	72	7
2024-05-27 16:12:11.793+00	2024-05-27 16:12:11.793+00	73	7
2024-05-27 16:12:11.813+00	2024-05-27 16:12:11.813+00	75	7
2024-05-27 16:12:11.831+00	2024-05-27 16:12:11.831+00	77	7
2024-05-27 16:12:11.849+00	2024-05-27 16:12:11.849+00	78	7
2024-05-27 16:12:11.867+00	2024-05-27 16:12:11.867+00	80	7
2024-05-27 16:12:11.885+00	2024-05-27 16:12:11.885+00	84	7
2024-05-27 16:12:11.903+00	2024-05-27 16:12:11.903+00	85	7
2024-05-27 16:12:11.945+00	2024-05-27 16:12:11.945+00	1	1
2024-05-27 16:12:11.981+00	2024-05-27 16:12:11.981+00	3	1
2024-05-27 16:12:12.015+00	2024-05-27 16:12:12.015+00	4	1
2024-05-27 16:12:12.051+00	2024-05-27 16:12:12.051+00	5	1
2024-05-27 16:12:12.083+00	2024-05-27 16:12:12.083+00	6	1
2024-05-27 16:12:12.111+00	2024-05-27 16:12:12.111+00	7	1
2024-05-27 16:12:12.131+00	2024-05-27 16:12:12.131+00	8	1
2024-05-27 16:12:12.152+00	2024-05-27 16:12:12.152+00	10	1
2024-05-27 16:12:12.172+00	2024-05-27 16:12:12.172+00	11	1
2024-05-27 16:12:12.195+00	2024-05-27 16:12:12.195+00	12	1
2024-05-27 16:12:12.219+00	2024-05-27 16:12:12.219+00	13	1
2024-05-27 16:12:12.248+00	2024-05-27 16:12:12.248+00	14	1
2024-05-27 16:12:12.276+00	2024-05-27 16:12:12.276+00	15	1
2024-05-27 16:12:12.298+00	2024-05-27 16:12:12.298+00	16	1
2024-05-27 16:12:12.32+00	2024-05-27 16:12:12.32+00	17	1
2024-05-27 16:12:12.339+00	2024-05-27 16:12:12.339+00	18	1
2024-05-27 16:12:12.359+00	2024-05-27 16:12:12.359+00	19	1
2024-05-27 16:12:12.402+00	2024-05-27 16:12:12.402+00	20	1
2024-05-27 16:12:12.424+00	2024-05-27 16:12:12.424+00	21	1
2024-05-27 16:12:12.443+00	2024-05-27 16:12:12.443+00	22	1
2024-05-27 16:12:12.461+00	2024-05-27 16:12:12.461+00	23	1
2024-05-27 16:12:12.48+00	2024-05-27 16:12:12.48+00	36	1
2024-05-27 16:12:12.532+00	2024-05-27 16:12:12.532+00	41	1
2024-05-27 16:12:12.553+00	2024-05-27 16:12:12.553+00	44	1
2024-05-27 16:12:12.572+00	2024-05-27 16:12:12.572+00	49	1
2024-05-27 16:12:12.59+00	2024-05-27 16:12:12.59+00	50	1
2024-05-27 16:12:12.609+00	2024-05-27 16:12:12.609+00	51	1
2024-05-27 16:12:12.631+00	2024-05-27 16:12:12.631+00	52	1
2024-05-27 16:12:12.668+00	2024-05-27 16:12:12.668+00	53	1
2024-05-27 16:12:12.692+00	2024-05-27 16:12:12.692+00	54	1
2024-05-27 16:12:12.71+00	2024-05-27 16:12:12.71+00	55	1
2024-05-27 16:12:12.726+00	2024-05-27 16:12:12.726+00	56	1
2024-05-27 16:12:12.745+00	2024-05-27 16:12:12.745+00	57	1
2024-05-27 16:12:12.763+00	2024-05-27 16:12:12.763+00	58	1
2024-05-27 16:12:12.78+00	2024-05-27 16:12:12.78+00	59	1
2024-05-27 16:12:12.796+00	2024-05-27 16:12:12.796+00	60	1
2024-05-27 16:12:12.811+00	2024-05-27 16:12:12.811+00	61	1
2024-05-27 16:12:12.831+00	2024-05-27 16:12:12.831+00	62	1
2024-05-27 16:12:12.849+00	2024-05-27 16:12:12.849+00	63	1
2024-05-27 16:12:12.885+00	2024-05-27 16:12:12.885+00	64	1
2024-05-27 16:12:12.918+00	2024-05-27 16:12:12.918+00	65	1
2024-05-27 16:12:12.94+00	2024-05-27 16:12:12.94+00	66	1
2024-05-27 16:12:12.962+00	2024-05-27 16:12:12.962+00	67	1
2024-05-27 16:12:12.98+00	2024-05-27 16:12:12.98+00	68	1
2024-05-27 16:12:12.999+00	2024-05-27 16:12:12.999+00	69	1
2024-05-27 16:12:13.017+00	2024-05-27 16:12:13.017+00	70	1
2024-05-27 16:12:13.035+00	2024-05-27 16:12:13.035+00	71	1
2024-05-27 16:12:13.054+00	2024-05-27 16:12:13.054+00	73	1
2024-05-27 16:12:13.072+00	2024-05-27 16:12:13.072+00	75	1
2024-05-27 16:12:13.093+00	2024-05-27 16:12:13.093+00	78	1
2024-05-27 16:12:13.119+00	2024-05-27 16:12:13.119+00	81	1
2024-05-27 16:12:13.144+00	2024-05-27 16:12:13.144+00	84	1
2024-05-27 16:12:13.165+00	2024-05-27 16:12:13.165+00	85	1
2024-05-27 16:12:13.182+00	2024-05-27 16:12:13.182+00	1	6
2024-05-27 16:12:13.197+00	2024-05-27 16:12:13.197+00	3	6
2024-05-27 16:12:13.231+00	2024-05-27 16:12:13.231+00	21	6
2024-05-27 16:12:13.249+00	2024-05-27 16:12:13.249+00	23	6
2024-05-27 16:12:13.295+00	2024-05-27 16:12:13.295+00	43	6
2024-05-27 16:12:13.312+00	2024-05-27 16:12:13.312+00	50	6
2024-05-27 16:12:13.328+00	2024-05-27 16:12:13.328+00	51	6
2024-05-27 16:12:13.342+00	2024-05-27 16:12:13.342+00	52	6
2024-05-27 16:12:13.356+00	2024-05-27 16:12:13.356+00	53	6
2024-05-27 16:12:13.373+00	2024-05-27 16:12:13.373+00	54	6
2024-05-27 16:12:13.389+00	2024-05-27 16:12:13.389+00	55	6
2024-05-27 16:12:13.405+00	2024-05-27 16:12:13.405+00	56	6
2024-05-27 16:12:13.421+00	2024-05-27 16:12:13.421+00	57	6
2024-05-27 16:12:13.439+00	2024-05-27 16:12:13.439+00	58	6
2024-05-27 16:12:13.455+00	2024-05-27 16:12:13.455+00	59	6
2024-05-27 16:12:13.472+00	2024-05-27 16:12:13.472+00	61	6
2024-05-27 16:12:13.487+00	2024-05-27 16:12:13.487+00	62	6
2024-05-27 16:12:13.503+00	2024-05-27 16:12:13.503+00	63	6
2024-05-27 16:12:13.519+00	2024-05-27 16:12:13.519+00	64	6
2024-05-27 16:12:13.535+00	2024-05-27 16:12:13.535+00	65	6
2024-05-27 16:12:13.55+00	2024-05-27 16:12:13.55+00	66	6
2024-05-27 16:12:13.568+00	2024-05-27 16:12:13.568+00	67	6
2024-05-27 16:12:13.587+00	2024-05-27 16:12:13.587+00	68	6
2024-05-27 16:12:13.603+00	2024-05-27 16:12:13.603+00	69	6
2024-05-27 16:12:13.62+00	2024-05-27 16:12:13.62+00	70	6
2024-05-27 16:12:13.636+00	2024-05-27 16:12:13.636+00	71	6
2024-05-27 16:12:13.651+00	2024-05-27 16:12:13.651+00	72	6
2024-05-27 16:12:13.668+00	2024-05-27 16:12:13.668+00	73	6
2024-05-27 16:12:13.682+00	2024-05-27 16:12:13.682+00	75	6
2024-05-27 16:12:13.697+00	2024-05-27 16:12:13.697+00	81	6
2024-05-27 16:12:13.714+00	2024-05-27 16:12:13.714+00	82	6
2024-05-27 16:12:13.729+00	2024-05-27 16:12:13.729+00	84	6
2024-05-27 16:12:13.742+00	2024-05-27 16:12:13.742+00	85	6
2024-05-27 16:12:15.973+00	2024-05-27 16:12:15.973+00	1	10
2024-05-27 16:12:15.987+00	2024-05-27 16:12:15.987+00	3	10
2024-05-27 16:12:16.002+00	2024-05-27 16:12:16.002+00	4	10
2024-05-27 16:12:16.018+00	2024-05-27 16:12:16.018+00	5	10
2024-05-27 16:12:16.033+00	2024-05-27 16:12:16.033+00	6	10
2024-05-27 16:12:16.049+00	2024-05-27 16:12:16.049+00	7	10
2024-05-27 16:12:16.064+00	2024-05-27 16:12:16.064+00	8	10
2024-05-27 16:12:16.079+00	2024-05-27 16:12:16.079+00	10	10
2024-05-27 16:12:16.093+00	2024-05-27 16:12:16.093+00	11	10
2024-05-27 16:12:16.105+00	2024-05-27 16:12:16.105+00	12	10
2024-05-27 16:12:16.118+00	2024-05-27 16:12:16.118+00	13	10
2024-05-27 16:12:16.133+00	2024-05-27 16:12:16.133+00	21	10
2024-05-27 16:12:16.147+00	2024-05-27 16:12:16.147+00	22	10
2024-05-27 16:12:16.162+00	2024-05-27 16:12:16.162+00	23	10
2024-05-27 16:12:16.176+00	2024-05-27 16:12:16.176+00	24	10
2024-05-27 16:12:16.193+00	2024-05-27 16:12:16.193+00	27	10
2024-05-27 16:12:16.21+00	2024-05-27 16:12:16.21+00	28	10
2024-05-27 16:12:16.224+00	2024-05-27 16:12:16.224+00	29	10
2024-05-27 16:12:16.239+00	2024-05-27 16:12:16.239+00	36	10
2024-05-27 16:12:16.278+00	2024-05-27 16:12:16.278+00	38	10
2024-05-27 16:12:16.295+00	2024-05-27 16:12:16.295+00	41	10
2024-05-27 16:12:16.312+00	2024-05-27 16:12:16.312+00	44	10
2024-05-27 16:12:16.327+00	2024-05-27 16:12:16.327+00	49	10
2024-05-27 16:12:16.341+00	2024-05-27 16:12:16.341+00	50	10
2024-05-27 16:12:16.357+00	2024-05-27 16:12:16.357+00	51	10
2024-05-27 16:12:16.372+00	2024-05-27 16:12:16.372+00	52	10
2024-05-27 16:12:16.389+00	2024-05-27 16:12:16.389+00	53	10
2024-05-27 16:12:16.405+00	2024-05-27 16:12:16.405+00	54	10
2024-05-27 16:12:16.42+00	2024-05-27 16:12:16.42+00	55	10
2024-05-27 16:12:16.436+00	2024-05-27 16:12:16.436+00	56	10
2024-05-27 16:12:16.454+00	2024-05-27 16:12:16.454+00	57	10
2024-05-27 16:12:16.475+00	2024-05-27 16:12:16.475+00	58	10
2024-05-27 16:12:16.493+00	2024-05-27 16:12:16.493+00	59	10
2024-05-27 16:12:16.51+00	2024-05-27 16:12:16.51+00	60	10
2024-05-27 16:12:16.527+00	2024-05-27 16:12:16.527+00	61	10
2024-05-27 16:12:16.541+00	2024-05-27 16:12:16.541+00	62	10
2024-05-27 16:12:16.557+00	2024-05-27 16:12:16.557+00	63	10
2024-05-27 16:12:16.573+00	2024-05-27 16:12:16.573+00	64	10
2024-05-27 16:12:16.589+00	2024-05-27 16:12:16.589+00	65	10
2024-05-27 16:12:16.604+00	2024-05-27 16:12:16.604+00	66	10
2024-05-27 16:12:16.622+00	2024-05-27 16:12:16.622+00	67	10
2024-05-27 16:12:16.639+00	2024-05-27 16:12:16.639+00	68	10
2024-05-27 16:12:16.654+00	2024-05-27 16:12:16.654+00	69	10
2024-05-27 16:12:16.669+00	2024-05-27 16:12:16.669+00	70	10
2024-05-27 16:12:16.684+00	2024-05-27 16:12:16.684+00	71	10
2024-05-27 16:12:16.701+00	2024-05-27 16:12:16.701+00	73	10
2024-05-27 16:12:16.716+00	2024-05-27 16:12:16.716+00	74	10
2024-05-27 16:12:16.73+00	2024-05-27 16:12:16.73+00	77	10
2024-05-27 16:12:16.744+00	2024-05-27 16:12:16.744+00	78	10
2024-05-27 16:12:16.757+00	2024-05-27 16:12:16.757+00	81	10
2024-05-27 16:12:16.772+00	2024-05-27 16:12:16.772+00	82	10
2024-05-27 16:12:16.787+00	2024-05-27 16:12:16.787+00	84	10
2024-05-27 16:12:16.801+00	2024-05-27 16:12:16.801+00	85	10
2024-05-27 16:12:17.183+00	2024-05-27 16:12:17.183+00	75	10
2024-05-27 16:12:17.238+00	2024-05-27 16:12:17.238+00	1	5
2024-05-27 16:12:17.253+00	2024-05-27 16:12:17.253+00	3	5
2024-05-27 16:12:17.269+00	2024-05-27 16:12:17.269+00	4	5
2024-05-27 16:12:17.283+00	2024-05-27 16:12:17.283+00	5	5
2024-05-27 16:12:17.298+00	2024-05-27 16:12:17.298+00	6	5
2024-05-27 16:12:17.313+00	2024-05-27 16:12:17.313+00	7	5
2024-05-27 16:12:17.328+00	2024-05-27 16:12:17.328+00	8	5
2024-05-27 16:12:17.343+00	2024-05-27 16:12:17.343+00	10	5
2024-05-27 16:12:17.358+00	2024-05-27 16:12:17.358+00	11	5
2024-05-27 16:12:17.372+00	2024-05-27 16:12:17.372+00	12	5
2024-05-27 16:12:17.401+00	2024-05-27 16:12:17.401+00	21	5
2024-05-27 16:12:17.416+00	2024-05-27 16:12:17.416+00	22	5
2024-05-27 16:12:17.431+00	2024-05-27 16:12:17.431+00	23	5
2024-05-27 16:12:17.445+00	2024-05-27 16:12:17.445+00	25	5
2024-05-27 16:12:17.494+00	2024-05-27 16:12:17.494+00	26	5
2024-05-27 16:12:17.524+00	2024-05-27 16:12:17.524+00	30	5
2024-05-27 16:12:17.57+00	2024-05-27 16:12:17.57+00	31	5
2024-05-27 16:12:17.615+00	2024-05-27 16:12:17.615+00	32	5
2024-05-27 16:12:17.632+00	2024-05-27 16:12:17.632+00	33	5
2024-05-27 16:12:17.65+00	2024-05-27 16:12:17.65+00	34	5
2024-05-27 16:12:17.668+00	2024-05-27 16:12:17.668+00	35	5
2024-05-27 16:12:17.693+00	2024-05-27 16:12:17.693+00	36	5
2024-05-27 16:12:17.774+00	2024-05-27 16:12:17.774+00	47	5
2024-05-27 16:12:17.793+00	2024-05-27 16:12:17.793+00	49	5
2024-05-27 16:12:17.807+00	2024-05-27 16:12:17.807+00	61	5
2024-05-27 16:12:17.82+00	2024-05-27 16:12:17.82+00	62	5
2024-05-27 16:12:17.832+00	2024-05-27 16:12:17.832+00	73	5
2024-05-27 16:12:17.847+00	2024-05-27 16:12:17.847+00	75	5
2024-05-27 16:12:17.862+00	2024-05-27 16:12:17.862+00	78	5
2024-05-27 16:12:21.671+00	2024-05-27 16:12:21.671+00	1	8
2024-05-27 16:12:21.686+00	2024-05-27 16:12:21.686+00	3	8
2024-05-27 16:12:21.699+00	2024-05-27 16:12:21.699+00	4	8
2024-05-27 16:12:21.713+00	2024-05-27 16:12:21.713+00	13	8
2024-05-27 16:12:21.727+00	2024-05-27 16:12:21.727+00	21	8
2024-05-27 16:12:21.742+00	2024-05-27 16:12:21.742+00	23	8
2024-05-27 16:12:21.758+00	2024-05-27 16:12:21.758+00	24	8
2024-05-27 16:12:21.772+00	2024-05-27 16:12:21.772+00	37	8
2024-05-27 16:12:21.787+00	2024-05-27 16:12:21.787+00	40	8
2024-05-27 16:12:21.801+00	2024-05-27 16:12:21.801+00	41	8
2024-05-27 16:12:21.817+00	2024-05-27 16:12:21.817+00	42	8
2024-05-27 16:12:21.839+00	2024-05-27 16:12:21.839+00	43	8
2024-05-27 16:12:21.86+00	2024-05-27 16:12:21.86+00	45	8
2024-05-27 16:12:21.878+00	2024-05-27 16:12:21.878+00	46	8
2024-05-27 16:12:21.893+00	2024-05-27 16:12:21.893+00	47	8
2024-05-27 16:12:21.907+00	2024-05-27 16:12:21.907+00	49	8
2024-05-27 16:12:21.922+00	2024-05-27 16:12:21.922+00	50	8
2024-05-27 16:12:21.935+00	2024-05-27 16:12:21.935+00	51	8
2024-05-27 16:12:21.949+00	2024-05-27 16:12:21.949+00	52	8
2024-05-27 16:12:21.963+00	2024-05-27 16:12:21.963+00	53	8
2024-05-27 16:12:21.977+00	2024-05-27 16:12:21.977+00	54	8
2024-05-27 16:12:21.989+00	2024-05-27 16:12:21.989+00	55	8
2024-05-27 16:12:22.003+00	2024-05-27 16:12:22.003+00	56	8
2024-05-27 16:12:22.019+00	2024-05-27 16:12:22.019+00	57	8
2024-05-27 16:12:22.033+00	2024-05-27 16:12:22.033+00	58	8
2024-05-27 16:12:22.048+00	2024-05-27 16:12:22.048+00	59	8
2024-05-27 16:12:22.062+00	2024-05-27 16:12:22.062+00	60	8
2024-05-27 16:12:22.078+00	2024-05-27 16:12:22.078+00	61	8
2024-05-27 16:12:22.091+00	2024-05-27 16:12:22.091+00	62	8
2024-05-27 16:12:22.105+00	2024-05-27 16:12:22.105+00	73	8
2024-05-27 16:12:22.119+00	2024-05-27 16:12:22.119+00	75	8
2024-05-27 16:12:22.133+00	2024-05-27 16:12:22.133+00	76	8
2024-05-27 16:12:22.148+00	2024-05-27 16:12:22.148+00	77	8
2024-05-27 16:12:22.162+00	2024-05-27 16:12:22.162+00	78	8
2024-05-27 16:12:22.176+00	2024-05-27 16:12:22.176+00	79	8
2024-05-27 16:12:22.192+00	2024-05-27 16:12:22.192+00	82	8
2024-05-27 16:12:22.205+00	2024-05-27 16:12:22.205+00	84	8
2024-05-27 16:12:22.219+00	2024-05-27 16:12:22.219+00	85	8
2024-05-27 16:12:22.637+00	2024-05-27 16:12:22.637+00	72	8
2024-05-27 16:12:22.665+00	2024-05-27 16:12:22.665+00	74	8
2024-05-27 16:12:22.749+00	2024-05-27 16:12:22.749+00	81	8
2024-05-27 16:12:22.916+00	2024-05-27 16:12:22.916+00	1	2
2024-05-27 16:12:22.928+00	2024-05-27 16:12:22.928+00	3	2
2024-05-27 16:12:22.941+00	2024-05-27 16:12:22.941+00	4	2
2024-05-27 16:12:22.956+00	2024-05-27 16:12:22.956+00	5	2
2024-05-27 16:12:22.971+00	2024-05-27 16:12:22.971+00	6	2
2024-05-27 16:12:22.987+00	2024-05-27 16:12:22.987+00	7	2
2024-05-27 16:12:23.005+00	2024-05-27 16:12:23.005+00	8	2
2024-05-27 16:12:23.021+00	2024-05-27 16:12:23.021+00	9	2
2024-05-27 16:12:23.037+00	2024-05-27 16:12:23.037+00	10	2
2024-05-27 16:12:23.051+00	2024-05-27 16:12:23.051+00	11	2
2024-05-27 16:12:23.066+00	2024-05-27 16:12:23.066+00	12	2
2024-05-27 16:12:23.119+00	2024-05-27 16:12:23.119+00	14	2
2024-05-27 16:12:23.138+00	2024-05-27 16:12:23.138+00	15	2
2024-05-27 16:12:23.155+00	2024-05-27 16:12:23.155+00	16	2
2024-05-27 16:12:23.174+00	2024-05-27 16:12:23.174+00	17	2
2024-05-27 16:12:23.19+00	2024-05-27 16:12:23.19+00	18	2
2024-05-27 16:12:23.204+00	2024-05-27 16:12:23.204+00	19	2
2024-05-27 16:12:23.218+00	2024-05-27 16:12:23.218+00	20	2
2024-05-27 16:12:23.234+00	2024-05-27 16:12:23.234+00	21	2
2024-05-27 16:12:23.273+00	2024-05-27 16:12:23.273+00	23	2
2024-05-27 16:12:23.298+00	2024-05-27 16:12:23.298+00	37	2
2024-05-27 16:12:23.316+00	2024-05-27 16:12:23.316+00	41	2
2024-05-27 16:12:23.335+00	2024-05-27 16:12:23.335+00	49	2
2024-05-27 16:12:23.353+00	2024-05-27 16:12:23.353+00	75	2
2024-05-27 16:12:23.372+00	2024-05-27 16:12:23.372+00	78	2
2024-05-27 16:12:23.393+00	2024-05-27 16:12:23.393+00	84	2
2024-05-27 16:12:23.427+00	2024-05-27 16:12:23.427+00	85	2
2024-05-27 16:12:23.656+00	2024-05-27 16:12:23.656+00	40	10
2024-05-27 16:12:23.699+00	2024-05-27 16:12:23.699+00	76	10
2024-05-27 16:12:23.741+00	2024-05-27 16:12:23.741+00	83	10
2024-05-27 16:12:23.787+00	2024-05-27 16:12:23.787+00	3	3
2024-05-27 16:12:23.802+00	2024-05-27 16:12:23.802+00	4	3
2024-05-27 16:12:23.817+00	2024-05-27 16:12:23.817+00	13	3
2024-05-27 16:12:23.832+00	2024-05-27 16:12:23.832+00	23	3
2024-05-27 16:12:24.346+00	2024-05-27 16:12:24.346+00	3	9
2024-05-27 16:12:24.361+00	2024-05-27 16:12:24.361+00	4	9
2024-05-27 16:12:24.376+00	2024-05-27 16:12:24.376+00	13	9
2024-05-27 16:12:24.391+00	2024-05-27 16:12:24.391+00	23	9
2024-05-27 16:12:24.407+00	2024-05-27 16:12:24.407+00	37	9
2024-05-27 16:12:24.737+00	2024-05-27 16:12:24.737+00	3	4
2024-05-27 16:12:24.765+00	2024-05-27 16:12:24.765+00	4	4
2024-05-27 16:12:24.785+00	2024-05-27 16:12:24.785+00	13	4
2024-05-27 16:12:24.801+00	2024-05-27 16:12:24.801+00	23	4
2024-05-27 16:42:12.106+00	2024-05-27 16:42:12.106+00	86	1
2024-05-27 16:45:56.629+00	2024-05-27 16:45:56.629+00	5	4
2024-05-27 16:45:56.629+00	2024-05-27 16:45:56.629+00	5	8
2024-05-27 16:45:56.629+00	2024-05-27 16:45:56.629+00	5	9
2024-05-27 16:46:04.847+00	2024-05-27 16:46:04.847+00	86	2
2024-05-27 16:46:04.847+00	2024-05-27 16:46:04.847+00	86	3
2024-05-27 16:46:04.847+00	2024-05-27 16:46:04.847+00	86	4
2024-05-27 16:46:04.847+00	2024-05-27 16:46:04.847+00	86	5
2024-05-27 16:46:04.847+00	2024-05-27 16:46:04.847+00	86	6
2024-05-27 16:46:04.847+00	2024-05-27 16:46:04.847+00	86	7
2024-05-27 16:46:04.847+00	2024-05-27 16:46:04.847+00	86	8
2024-05-27 16:46:04.847+00	2024-05-27 16:46:04.847+00	86	9
2024-05-27 16:46:04.847+00	2024-05-27 16:46:04.847+00	86	10
2024-05-27 22:12:57.025+00	2024-05-27 22:12:57.025+00	1	3
2024-05-27 22:12:57.025+00	2024-05-27 22:12:57.025+00	1	4
2024-05-27 22:12:57.025+00	2024-05-27 22:12:57.025+00	1	9
2024-05-27 22:29:28.995+00	2024-05-27 22:29:28.995+00	2	7
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	1
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	2
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	3
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	4
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	5
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	6
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	7
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	8
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	9
2024-05-27 22:37:47.725+00	2024-05-27 22:37:47.725+00	88	10
2024-05-28 14:04:27.755+00	2024-05-28 14:04:27.755+00	24	1
\.


--
-- Data for Name: UserReport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserReport" ("createdAt", "updatedAt", "UserId", "ReportId") FROM stdin;
2024-05-27 16:12:10.765+00	2024-05-27 16:12:10.765+00	1	18
2024-05-27 16:12:10.806+00	2024-05-27 16:12:10.806+00	3	18
2024-05-27 16:12:10.832+00	2024-05-27 16:12:10.832+00	4	18
2024-05-27 16:12:10.858+00	2024-05-27 16:12:10.858+00	5	18
2024-05-27 16:12:10.886+00	2024-05-27 16:12:10.886+00	7	18
2024-05-27 16:12:10.929+00	2024-05-27 16:12:10.929+00	8	18
2024-05-27 16:12:10.972+00	2024-05-27 16:12:10.972+00	10	18
2024-05-27 16:12:10.997+00	2024-05-27 16:12:10.997+00	11	18
2024-05-27 16:12:11.02+00	2024-05-27 16:12:11.02+00	12	18
2024-05-27 16:12:11.048+00	2024-05-27 16:12:11.048+00	13	18
2024-05-27 16:12:11.102+00	2024-05-27 16:12:11.102+00	14	18
2024-05-27 16:12:11.149+00	2024-05-27 16:12:11.149+00	15	18
2024-05-27 16:12:11.175+00	2024-05-27 16:12:11.175+00	16	18
2024-05-27 16:12:11.199+00	2024-05-27 16:12:11.199+00	17	18
2024-05-27 16:12:11.22+00	2024-05-27 16:12:11.22+00	18	18
2024-05-27 16:12:11.24+00	2024-05-27 16:12:11.24+00	19	18
2024-05-27 16:12:11.259+00	2024-05-27 16:12:11.259+00	20	18
2024-05-27 16:12:11.277+00	2024-05-27 16:12:11.277+00	21	18
2024-05-27 16:12:11.297+00	2024-05-27 16:12:11.297+00	22	18
2024-05-27 16:12:11.318+00	2024-05-27 16:12:11.318+00	23	18
2024-05-27 16:12:11.337+00	2024-05-27 16:12:11.337+00	36	18
2024-05-27 16:12:11.356+00	2024-05-27 16:12:11.356+00	37	18
2024-05-27 16:12:11.379+00	2024-05-27 16:12:11.379+00	38	18
2024-05-27 16:12:11.401+00	2024-05-27 16:12:11.401+00	40	18
2024-05-27 16:12:11.422+00	2024-05-27 16:12:11.422+00	41	18
2024-05-27 16:12:11.443+00	2024-05-27 16:12:11.443+00	43	18
2024-05-27 16:12:11.461+00	2024-05-27 16:12:11.461+00	47	18
2024-05-27 16:12:11.479+00	2024-05-27 16:12:11.479+00	49	18
2024-05-27 16:12:11.5+00	2024-05-27 16:12:11.5+00	50	18
2024-05-27 16:12:11.52+00	2024-05-27 16:12:11.52+00	51	18
2024-05-27 16:12:11.54+00	2024-05-27 16:12:11.54+00	52	18
2024-05-27 16:12:11.56+00	2024-05-27 16:12:11.56+00	53	18
2024-05-27 16:12:11.579+00	2024-05-27 16:12:11.579+00	54	18
2024-05-27 16:12:11.601+00	2024-05-27 16:12:11.601+00	55	18
2024-05-27 16:12:11.62+00	2024-05-27 16:12:11.62+00	56	18
2024-05-27 16:12:11.642+00	2024-05-27 16:12:11.642+00	57	18
2024-05-27 16:12:11.668+00	2024-05-27 16:12:11.668+00	58	18
2024-05-27 16:12:11.691+00	2024-05-27 16:12:11.691+00	59	18
2024-05-27 16:12:11.713+00	2024-05-27 16:12:11.713+00	60	18
2024-05-27 16:12:11.731+00	2024-05-27 16:12:11.731+00	61	18
2024-05-27 16:12:11.75+00	2024-05-27 16:12:11.75+00	62	18
2024-05-27 16:12:11.77+00	2024-05-27 16:12:11.77+00	72	18
2024-05-27 16:12:11.791+00	2024-05-27 16:12:11.791+00	73	18
2024-05-27 16:12:11.81+00	2024-05-27 16:12:11.81+00	75	18
2024-05-27 16:12:11.829+00	2024-05-27 16:12:11.829+00	77	18
2024-05-27 16:12:11.846+00	2024-05-27 16:12:11.846+00	78	18
2024-05-27 16:12:11.865+00	2024-05-27 16:12:11.865+00	80	18
2024-05-27 16:12:11.883+00	2024-05-27 16:12:11.883+00	84	18
2024-05-27 16:12:11.902+00	2024-05-27 16:12:11.902+00	85	18
2024-05-27 16:12:11.942+00	2024-05-27 16:12:11.942+00	1	7
2024-05-27 16:12:11.977+00	2024-05-27 16:12:11.977+00	3	7
2024-05-27 16:12:12.01+00	2024-05-27 16:12:12.01+00	4	7
2024-05-27 16:12:12.041+00	2024-05-27 16:12:12.041+00	5	7
2024-05-27 16:12:12.08+00	2024-05-27 16:12:12.08+00	6	7
2024-05-27 16:12:12.109+00	2024-05-27 16:12:12.109+00	7	7
2024-05-27 16:12:12.129+00	2024-05-27 16:12:12.129+00	8	7
2024-05-27 16:12:12.15+00	2024-05-27 16:12:12.15+00	10	7
2024-05-27 16:12:12.17+00	2024-05-27 16:12:12.17+00	11	7
2024-05-27 16:12:12.192+00	2024-05-27 16:12:12.192+00	12	7
2024-05-27 16:12:12.216+00	2024-05-27 16:12:12.216+00	13	7
2024-05-27 16:12:12.245+00	2024-05-27 16:12:12.245+00	14	7
2024-05-27 16:12:12.273+00	2024-05-27 16:12:12.273+00	15	7
2024-05-27 16:12:12.296+00	2024-05-27 16:12:12.296+00	16	7
2024-05-27 16:12:12.317+00	2024-05-27 16:12:12.317+00	17	7
2024-05-27 16:12:12.338+00	2024-05-27 16:12:12.338+00	18	7
2024-05-27 16:12:12.357+00	2024-05-27 16:12:12.357+00	19	7
2024-05-27 16:12:12.398+00	2024-05-27 16:12:12.398+00	20	7
2024-05-27 16:12:12.422+00	2024-05-27 16:12:12.422+00	21	7
2024-05-27 16:12:12.44+00	2024-05-27 16:12:12.44+00	22	7
2024-05-27 16:12:12.459+00	2024-05-27 16:12:12.459+00	23	7
2024-05-27 16:12:12.477+00	2024-05-27 16:12:12.477+00	36	7
2024-05-27 16:12:12.53+00	2024-05-27 16:12:12.53+00	41	7
2024-05-27 16:12:12.55+00	2024-05-27 16:12:12.55+00	44	7
2024-05-27 16:12:12.57+00	2024-05-27 16:12:12.57+00	49	7
2024-05-27 16:12:12.588+00	2024-05-27 16:12:12.588+00	50	7
2024-05-27 16:12:12.607+00	2024-05-27 16:12:12.607+00	51	7
2024-05-27 16:12:12.627+00	2024-05-27 16:12:12.627+00	52	7
2024-05-27 16:12:12.665+00	2024-05-27 16:12:12.665+00	53	7
2024-05-27 16:12:12.689+00	2024-05-27 16:12:12.689+00	54	7
2024-05-27 16:12:12.708+00	2024-05-27 16:12:12.708+00	55	7
2024-05-27 16:12:12.724+00	2024-05-27 16:12:12.724+00	56	7
2024-05-27 16:12:12.742+00	2024-05-27 16:12:12.742+00	57	7
2024-05-27 16:12:12.761+00	2024-05-27 16:12:12.761+00	58	7
2024-05-27 16:12:12.778+00	2024-05-27 16:12:12.778+00	59	7
2024-05-27 16:12:12.794+00	2024-05-27 16:12:12.794+00	60	7
2024-05-27 16:12:12.81+00	2024-05-27 16:12:12.81+00	61	7
2024-05-27 16:12:12.828+00	2024-05-27 16:12:12.828+00	62	7
2024-05-27 16:12:12.847+00	2024-05-27 16:12:12.847+00	63	7
2024-05-27 16:12:12.88+00	2024-05-27 16:12:12.88+00	64	7
2024-05-27 16:12:12.915+00	2024-05-27 16:12:12.915+00	65	7
2024-05-27 16:12:12.937+00	2024-05-27 16:12:12.937+00	66	7
2024-05-27 16:12:12.959+00	2024-05-27 16:12:12.959+00	67	7
2024-05-27 16:12:12.978+00	2024-05-27 16:12:12.978+00	68	7
2024-05-27 16:12:12.997+00	2024-05-27 16:12:12.997+00	69	7
2024-05-27 16:12:13.015+00	2024-05-27 16:12:13.015+00	70	7
2024-05-27 16:12:13.033+00	2024-05-27 16:12:13.033+00	71	7
2024-05-27 16:12:13.052+00	2024-05-27 16:12:13.052+00	73	7
2024-05-27 16:12:13.07+00	2024-05-27 16:12:13.07+00	75	7
2024-05-27 16:12:13.09+00	2024-05-27 16:12:13.09+00	78	7
2024-05-27 16:12:13.116+00	2024-05-27 16:12:13.116+00	81	7
2024-05-27 16:12:13.142+00	2024-05-27 16:12:13.142+00	84	7
2024-05-27 16:12:13.163+00	2024-05-27 16:12:13.163+00	85	7
2024-05-27 16:12:13.181+00	2024-05-27 16:12:13.181+00	1	17
2024-05-27 16:12:13.195+00	2024-05-27 16:12:13.195+00	3	17
2024-05-27 16:12:13.229+00	2024-05-27 16:12:13.229+00	21	17
2024-05-27 16:12:13.247+00	2024-05-27 16:12:13.247+00	23	17
2024-05-27 16:12:13.293+00	2024-05-27 16:12:13.293+00	43	17
2024-05-27 16:12:13.31+00	2024-05-27 16:12:13.31+00	50	17
2024-05-27 16:12:13.326+00	2024-05-27 16:12:13.326+00	51	17
2024-05-27 16:12:13.34+00	2024-05-27 16:12:13.34+00	52	17
2024-05-27 16:12:13.354+00	2024-05-27 16:12:13.354+00	53	17
2024-05-27 16:12:13.371+00	2024-05-27 16:12:13.371+00	54	17
2024-05-27 16:12:13.387+00	2024-05-27 16:12:13.387+00	55	17
2024-05-27 16:12:13.403+00	2024-05-27 16:12:13.403+00	56	17
2024-05-27 16:12:13.419+00	2024-05-27 16:12:13.419+00	57	17
2024-05-27 16:12:13.437+00	2024-05-27 16:12:13.437+00	58	17
2024-05-27 16:12:13.453+00	2024-05-27 16:12:13.453+00	59	17
2024-05-27 16:12:13.47+00	2024-05-27 16:12:13.47+00	61	17
2024-05-27 16:12:13.485+00	2024-05-27 16:12:13.485+00	62	17
2024-05-27 16:12:13.501+00	2024-05-27 16:12:13.501+00	63	17
2024-05-27 16:12:13.517+00	2024-05-27 16:12:13.517+00	64	17
2024-05-27 16:12:13.533+00	2024-05-27 16:12:13.533+00	65	17
2024-05-27 16:12:13.548+00	2024-05-27 16:12:13.548+00	66	17
2024-05-27 16:12:13.566+00	2024-05-27 16:12:13.566+00	67	17
2024-05-27 16:12:13.585+00	2024-05-27 16:12:13.585+00	68	17
2024-05-27 16:12:13.601+00	2024-05-27 16:12:13.601+00	69	17
2024-05-27 16:12:13.618+00	2024-05-27 16:12:13.618+00	70	17
2024-05-27 16:12:13.634+00	2024-05-27 16:12:13.634+00	71	17
2024-05-27 16:12:13.65+00	2024-05-27 16:12:13.65+00	72	17
2024-05-27 16:12:13.665+00	2024-05-27 16:12:13.665+00	73	17
2024-05-27 16:12:13.68+00	2024-05-27 16:12:13.68+00	75	17
2024-05-27 16:12:13.696+00	2024-05-27 16:12:13.696+00	81	17
2024-05-27 16:12:13.713+00	2024-05-27 16:12:13.713+00	82	17
2024-05-27 16:12:13.728+00	2024-05-27 16:12:13.728+00	84	17
2024-05-27 16:12:13.741+00	2024-05-27 16:12:13.741+00	85	17
2024-05-27 16:12:13.754+00	2024-05-27 16:12:13.754+00	1	42
2024-05-27 16:12:13.78+00	2024-05-27 16:12:13.78+00	3	42
2024-05-27 16:12:13.8+00	2024-05-27 16:12:13.8+00	4	42
2024-05-27 16:12:13.819+00	2024-05-27 16:12:13.819+00	5	42
2024-05-27 16:12:13.837+00	2024-05-27 16:12:13.837+00	6	42
2024-05-27 16:12:13.851+00	2024-05-27 16:12:13.851+00	7	42
2024-05-27 16:12:13.87+00	2024-05-27 16:12:13.87+00	8	42
2024-05-27 16:12:13.888+00	2024-05-27 16:12:13.888+00	10	42
2024-05-27 16:12:13.905+00	2024-05-27 16:12:13.905+00	11	42
2024-05-27 16:12:13.921+00	2024-05-27 16:12:13.921+00	12	42
2024-05-27 16:12:13.938+00	2024-05-27 16:12:13.938+00	13	42
2024-05-27 16:12:13.954+00	2024-05-27 16:12:13.954+00	14	42
2024-05-27 16:12:13.972+00	2024-05-27 16:12:13.972+00	15	42
2024-05-27 16:12:13.988+00	2024-05-27 16:12:13.988+00	16	42
2024-05-27 16:12:14.005+00	2024-05-27 16:12:14.005+00	17	42
2024-05-27 16:12:14.021+00	2024-05-27 16:12:14.021+00	18	42
2024-05-27 16:12:14.038+00	2024-05-27 16:12:14.038+00	19	42
2024-05-27 16:12:14.053+00	2024-05-27 16:12:14.053+00	20	42
2024-05-27 16:12:14.07+00	2024-05-27 16:12:14.07+00	21	42
2024-05-27 16:12:14.086+00	2024-05-27 16:12:14.086+00	22	42
2024-05-27 16:12:14.103+00	2024-05-27 16:12:14.103+00	23	42
2024-05-27 16:12:14.12+00	2024-05-27 16:12:14.12+00	36	42
2024-05-27 16:12:14.136+00	2024-05-27 16:12:14.136+00	37	42
2024-05-27 16:12:14.151+00	2024-05-27 16:12:14.151+00	38	42
2024-05-27 16:12:14.167+00	2024-05-27 16:12:14.167+00	41	42
2024-05-27 16:12:14.184+00	2024-05-27 16:12:14.184+00	43	42
2024-05-27 16:12:14.202+00	2024-05-27 16:12:14.202+00	44	42
2024-05-27 16:12:14.217+00	2024-05-27 16:12:14.217+00	47	42
2024-05-27 16:12:14.233+00	2024-05-27 16:12:14.233+00	49	42
2024-05-27 16:12:14.247+00	2024-05-27 16:12:14.247+00	50	42
2024-05-27 16:12:14.264+00	2024-05-27 16:12:14.264+00	51	42
2024-05-27 16:12:14.282+00	2024-05-27 16:12:14.282+00	52	42
2024-05-27 16:12:14.3+00	2024-05-27 16:12:14.3+00	53	42
2024-05-27 16:12:14.319+00	2024-05-27 16:12:14.319+00	54	42
2024-05-27 16:12:14.335+00	2024-05-27 16:12:14.335+00	55	42
2024-05-27 16:12:14.35+00	2024-05-27 16:12:14.35+00	56	42
2024-05-27 16:12:14.366+00	2024-05-27 16:12:14.366+00	57	42
2024-05-27 16:12:14.381+00	2024-05-27 16:12:14.381+00	58	42
2024-05-27 16:12:14.398+00	2024-05-27 16:12:14.398+00	59	42
2024-05-27 16:12:14.421+00	2024-05-27 16:12:14.421+00	60	42
2024-05-27 16:12:14.442+00	2024-05-27 16:12:14.442+00	61	42
2024-05-27 16:12:14.46+00	2024-05-27 16:12:14.46+00	62	42
2024-05-27 16:12:14.478+00	2024-05-27 16:12:14.478+00	63	42
2024-05-27 16:12:14.497+00	2024-05-27 16:12:14.497+00	64	42
2024-05-27 16:12:14.515+00	2024-05-27 16:12:14.515+00	65	42
2024-05-27 16:12:14.537+00	2024-05-27 16:12:14.537+00	66	42
2024-05-27 16:12:14.552+00	2024-05-27 16:12:14.552+00	67	42
2024-05-27 16:12:14.566+00	2024-05-27 16:12:14.566+00	68	42
2024-05-27 16:12:14.582+00	2024-05-27 16:12:14.582+00	69	42
2024-05-27 16:12:14.597+00	2024-05-27 16:12:14.597+00	70	42
2024-05-27 16:12:14.612+00	2024-05-27 16:12:14.612+00	71	42
2024-05-27 16:12:14.629+00	2024-05-27 16:12:14.629+00	73	42
2024-05-27 16:12:14.644+00	2024-05-27 16:12:14.644+00	74	42
2024-05-27 16:12:14.659+00	2024-05-27 16:12:14.659+00	75	42
2024-05-27 16:12:14.675+00	2024-05-27 16:12:14.675+00	77	42
2024-05-27 16:12:14.69+00	2024-05-27 16:12:14.69+00	78	42
2024-05-27 16:12:14.708+00	2024-05-27 16:12:14.708+00	82	42
2024-05-27 16:12:14.725+00	2024-05-27 16:12:14.725+00	84	42
2024-05-27 16:12:14.74+00	2024-05-27 16:12:14.74+00	85	42
2024-05-27 16:12:14.754+00	2024-05-27 16:12:14.754+00	1	38
2024-05-27 16:12:14.766+00	2024-05-27 16:12:14.766+00	3	38
2024-05-27 16:12:14.78+00	2024-05-27 16:12:14.78+00	4	38
2024-05-27 16:12:14.794+00	2024-05-27 16:12:14.794+00	5	38
2024-05-27 16:12:14.807+00	2024-05-27 16:12:14.807+00	6	38
2024-05-27 16:12:14.821+00	2024-05-27 16:12:14.821+00	7	38
2024-05-27 16:12:14.837+00	2024-05-27 16:12:14.837+00	8	38
2024-05-27 16:12:14.851+00	2024-05-27 16:12:14.851+00	9	38
2024-05-27 16:12:14.865+00	2024-05-27 16:12:14.865+00	10	38
2024-05-27 16:12:14.88+00	2024-05-27 16:12:14.88+00	11	38
2024-05-27 16:12:14.895+00	2024-05-27 16:12:14.895+00	12	38
2024-05-27 16:12:14.911+00	2024-05-27 16:12:14.911+00	13	38
2024-05-27 16:12:14.938+00	2024-05-27 16:12:14.938+00	14	38
2024-05-27 16:12:14.954+00	2024-05-27 16:12:14.954+00	15	38
2024-05-27 16:12:14.969+00	2024-05-27 16:12:14.969+00	16	38
2024-05-27 16:12:14.983+00	2024-05-27 16:12:14.983+00	17	38
2024-05-27 16:12:14.998+00	2024-05-27 16:12:14.998+00	18	38
2024-05-27 16:12:15.012+00	2024-05-27 16:12:15.012+00	19	38
2024-05-27 16:12:15.028+00	2024-05-27 16:12:15.028+00	20	38
2024-05-27 16:12:15.045+00	2024-05-27 16:12:15.045+00	21	38
2024-05-27 16:12:15.06+00	2024-05-27 16:12:15.06+00	22	38
2024-05-27 16:12:15.075+00	2024-05-27 16:12:15.075+00	23	38
2024-05-27 16:12:15.092+00	2024-05-27 16:12:15.092+00	24	38
2024-05-27 16:12:15.108+00	2024-05-27 16:12:15.108+00	36	38
2024-05-27 16:12:15.124+00	2024-05-27 16:12:15.124+00	37	38
2024-05-27 16:12:15.141+00	2024-05-27 16:12:15.141+00	38	38
2024-05-27 16:12:15.157+00	2024-05-27 16:12:15.157+00	40	38
2024-05-27 16:12:15.174+00	2024-05-27 16:12:15.174+00	41	38
2024-05-27 16:12:15.189+00	2024-05-27 16:12:15.189+00	42	38
2024-05-27 16:12:15.205+00	2024-05-27 16:12:15.205+00	43	38
2024-05-27 16:12:15.221+00	2024-05-27 16:12:15.221+00	45	38
2024-05-27 16:12:15.238+00	2024-05-27 16:12:15.238+00	46	38
2024-05-27 16:12:15.253+00	2024-05-27 16:12:15.253+00	47	38
2024-05-27 16:12:15.268+00	2024-05-27 16:12:15.268+00	49	38
2024-05-27 16:12:15.282+00	2024-05-27 16:12:15.282+00	50	38
2024-05-27 16:12:15.296+00	2024-05-27 16:12:15.296+00	51	38
2024-05-27 16:12:15.311+00	2024-05-27 16:12:15.311+00	52	38
2024-05-27 16:12:15.326+00	2024-05-27 16:12:15.326+00	53	38
2024-05-27 16:12:15.34+00	2024-05-27 16:12:15.34+00	54	38
2024-05-27 16:12:15.356+00	2024-05-27 16:12:15.356+00	55	38
2024-05-27 16:12:15.371+00	2024-05-27 16:12:15.371+00	56	38
2024-05-27 16:12:15.385+00	2024-05-27 16:12:15.385+00	57	38
2024-05-27 16:12:15.402+00	2024-05-27 16:12:15.402+00	58	38
2024-05-27 16:12:15.417+00	2024-05-27 16:12:15.417+00	59	38
2024-05-27 16:12:15.431+00	2024-05-27 16:12:15.431+00	60	38
2024-05-27 16:12:15.446+00	2024-05-27 16:12:15.446+00	61	38
2024-05-27 16:12:15.461+00	2024-05-27 16:12:15.461+00	62	38
2024-05-27 16:12:15.475+00	2024-05-27 16:12:15.475+00	73	38
2024-05-27 16:12:15.488+00	2024-05-27 16:12:15.488+00	74	38
2024-05-27 16:12:15.503+00	2024-05-27 16:12:15.503+00	75	38
2024-05-27 16:12:15.517+00	2024-05-27 16:12:15.517+00	76	38
2024-05-27 16:12:15.536+00	2024-05-27 16:12:15.536+00	77	38
2024-05-27 16:12:15.551+00	2024-05-27 16:12:15.551+00	78	38
2024-05-27 16:12:15.565+00	2024-05-27 16:12:15.565+00	79	38
2024-05-27 16:12:15.58+00	2024-05-27 16:12:15.58+00	81	38
2024-05-27 16:12:15.602+00	2024-05-27 16:12:15.602+00	82	38
2024-05-27 16:12:15.621+00	2024-05-27 16:12:15.621+00	84	38
2024-05-27 16:12:15.638+00	2024-05-27 16:12:15.638+00	85	38
2024-05-27 16:12:15.653+00	2024-05-27 16:12:15.653+00	1	52
2024-05-27 16:12:15.668+00	2024-05-27 16:12:15.668+00	3	52
2024-05-27 16:12:15.683+00	2024-05-27 16:12:15.683+00	4	52
2024-05-27 16:12:15.696+00	2024-05-27 16:12:15.696+00	21	52
2024-05-27 16:12:15.71+00	2024-05-27 16:12:15.71+00	23	52
2024-05-27 16:12:15.74+00	2024-05-27 16:12:15.74+00	41	52
2024-05-27 16:12:15.755+00	2024-05-27 16:12:15.755+00	61	52
2024-05-27 16:12:15.77+00	2024-05-27 16:12:15.77+00	62	52
2024-05-27 16:12:15.782+00	2024-05-27 16:12:15.782+00	73	52
2024-05-27 16:12:15.795+00	2024-05-27 16:12:15.795+00	75	52
2024-05-27 16:12:15.833+00	2024-05-27 16:12:15.833+00	1	41
2024-05-27 16:12:15.853+00	2024-05-27 16:12:15.853+00	3	41
2024-05-27 16:12:15.869+00	2024-05-27 16:12:15.869+00	23	41
2024-05-27 16:12:15.885+00	2024-05-27 16:12:15.885+00	24	41
2024-05-27 16:12:15.898+00	2024-05-27 16:12:15.898+00	27	41
2024-05-27 16:12:15.912+00	2024-05-27 16:12:15.912+00	28	41
2024-05-27 16:12:15.926+00	2024-05-27 16:12:15.926+00	29	41
2024-05-27 16:12:15.956+00	2024-05-27 16:12:15.956+00	41	41
2024-05-27 16:12:15.971+00	2024-05-27 16:12:15.971+00	1	25
2024-05-27 16:12:15.986+00	2024-05-27 16:12:15.986+00	3	25
2024-05-27 16:12:16+00	2024-05-27 16:12:16+00	4	25
2024-05-27 16:12:16.016+00	2024-05-27 16:12:16.016+00	5	25
2024-05-27 16:12:16.031+00	2024-05-27 16:12:16.031+00	6	25
2024-05-27 16:12:16.047+00	2024-05-27 16:12:16.047+00	7	25
2024-05-27 16:12:16.063+00	2024-05-27 16:12:16.063+00	8	25
2024-05-27 16:12:16.077+00	2024-05-27 16:12:16.077+00	10	25
2024-05-27 16:12:16.092+00	2024-05-27 16:12:16.092+00	11	25
2024-05-27 16:12:16.104+00	2024-05-27 16:12:16.104+00	12	25
2024-05-27 16:12:16.117+00	2024-05-27 16:12:16.117+00	13	25
2024-05-27 16:12:16.131+00	2024-05-27 16:12:16.131+00	21	25
2024-05-27 16:12:16.145+00	2024-05-27 16:12:16.145+00	22	25
2024-05-27 16:12:16.16+00	2024-05-27 16:12:16.16+00	23	25
2024-05-27 16:12:16.175+00	2024-05-27 16:12:16.175+00	24	25
2024-05-27 16:12:16.191+00	2024-05-27 16:12:16.191+00	27	25
2024-05-27 16:12:16.208+00	2024-05-27 16:12:16.208+00	28	25
2024-05-27 16:12:16.223+00	2024-05-27 16:12:16.223+00	29	25
2024-05-27 16:12:16.238+00	2024-05-27 16:12:16.238+00	36	25
2024-05-27 16:12:16.252+00	2024-05-27 16:12:16.252+00	37	25
2024-05-27 16:12:16.277+00	2024-05-27 16:12:16.277+00	38	25
2024-05-27 16:12:16.293+00	2024-05-27 16:12:16.293+00	41	25
2024-05-27 16:12:16.31+00	2024-05-27 16:12:16.31+00	44	25
2024-05-27 16:12:16.325+00	2024-05-27 16:12:16.325+00	49	25
2024-05-27 16:12:16.339+00	2024-05-27 16:12:16.339+00	50	25
2024-05-27 16:12:16.355+00	2024-05-27 16:12:16.355+00	51	25
2024-05-27 16:12:16.37+00	2024-05-27 16:12:16.37+00	52	25
2024-05-27 16:12:16.387+00	2024-05-27 16:12:16.387+00	53	25
2024-05-27 16:12:16.403+00	2024-05-27 16:12:16.403+00	54	25
2024-05-27 16:12:16.418+00	2024-05-27 16:12:16.418+00	55	25
2024-05-27 16:12:16.434+00	2024-05-27 16:12:16.434+00	56	25
2024-05-27 16:12:16.449+00	2024-05-27 16:12:16.449+00	57	25
2024-05-27 16:12:16.473+00	2024-05-27 16:12:16.473+00	58	25
2024-05-27 16:12:16.49+00	2024-05-27 16:12:16.49+00	59	25
2024-05-27 16:12:16.508+00	2024-05-27 16:12:16.508+00	60	25
2024-05-27 16:12:16.525+00	2024-05-27 16:12:16.525+00	61	25
2024-05-27 16:12:16.539+00	2024-05-27 16:12:16.539+00	62	25
2024-05-27 16:12:16.555+00	2024-05-27 16:12:16.555+00	63	25
2024-05-27 16:12:16.571+00	2024-05-27 16:12:16.571+00	64	25
2024-05-27 16:12:16.587+00	2024-05-27 16:12:16.587+00	65	25
2024-05-27 16:12:16.602+00	2024-05-27 16:12:16.602+00	66	25
2024-05-27 16:12:16.619+00	2024-05-27 16:12:16.619+00	67	25
2024-05-27 16:12:16.637+00	2024-05-27 16:12:16.637+00	68	25
2024-05-27 16:12:16.652+00	2024-05-27 16:12:16.652+00	69	25
2024-05-27 16:12:16.667+00	2024-05-27 16:12:16.667+00	70	25
2024-05-27 16:12:16.683+00	2024-05-27 16:12:16.683+00	71	25
2024-05-27 16:12:16.699+00	2024-05-27 16:12:16.699+00	73	25
2024-05-27 16:12:16.714+00	2024-05-27 16:12:16.714+00	74	25
2024-05-27 16:12:16.728+00	2024-05-27 16:12:16.728+00	77	25
2024-05-27 16:12:16.742+00	2024-05-27 16:12:16.742+00	78	25
2024-05-27 16:12:16.756+00	2024-05-27 16:12:16.756+00	81	25
2024-05-27 16:12:16.77+00	2024-05-27 16:12:16.77+00	82	25
2024-05-27 16:12:16.786+00	2024-05-27 16:12:16.786+00	84	25
2024-05-27 16:12:16.799+00	2024-05-27 16:12:16.799+00	85	25
2024-05-27 16:12:16.813+00	2024-05-27 16:12:16.813+00	1	27
2024-05-27 16:12:16.826+00	2024-05-27 16:12:16.826+00	3	27
2024-05-27 16:12:16.84+00	2024-05-27 16:12:16.84+00	4	27
2024-05-27 16:12:16.854+00	2024-05-27 16:12:16.854+00	21	27
2024-05-27 16:12:16.866+00	2024-05-27 16:12:16.866+00	22	27
2024-05-27 16:12:16.879+00	2024-05-27 16:12:16.879+00	23	27
2024-05-27 16:12:16.892+00	2024-05-27 16:12:16.892+00	24	27
2024-05-27 16:12:16.906+00	2024-05-27 16:12:16.906+00	27	27
2024-05-27 16:12:16.924+00	2024-05-27 16:12:16.924+00	28	27
2024-05-27 16:12:16.944+00	2024-05-27 16:12:16.944+00	29	27
2024-05-27 16:12:16.962+00	2024-05-27 16:12:16.962+00	37	27
2024-05-27 16:12:16.977+00	2024-05-27 16:12:16.977+00	41	27
2024-05-27 16:12:16.992+00	2024-05-27 16:12:16.992+00	49	27
2024-05-27 16:12:17.006+00	2024-05-27 16:12:17.006+00	61	27
2024-05-27 16:12:17.019+00	2024-05-27 16:12:17.019+00	62	27
2024-05-27 16:12:17.032+00	2024-05-27 16:12:17.032+00	63	27
2024-05-27 16:12:17.047+00	2024-05-27 16:12:17.047+00	64	27
2024-05-27 16:12:17.061+00	2024-05-27 16:12:17.061+00	65	27
2024-05-27 16:12:17.077+00	2024-05-27 16:12:17.077+00	66	27
2024-05-27 16:12:17.092+00	2024-05-27 16:12:17.092+00	67	27
2024-05-27 16:12:17.108+00	2024-05-27 16:12:17.108+00	68	27
2024-05-27 16:12:17.121+00	2024-05-27 16:12:17.121+00	69	27
2024-05-27 16:12:17.137+00	2024-05-27 16:12:17.137+00	70	27
2024-05-27 16:12:17.152+00	2024-05-27 16:12:17.152+00	71	27
2024-05-27 16:12:17.167+00	2024-05-27 16:12:17.167+00	73	27
2024-05-27 16:12:17.181+00	2024-05-27 16:12:17.181+00	75	27
2024-05-27 16:12:17.196+00	2024-05-27 16:12:17.196+00	77	27
2024-05-27 16:12:17.21+00	2024-05-27 16:12:17.21+00	84	27
2024-05-27 16:12:17.223+00	2024-05-27 16:12:17.223+00	85	27
2024-05-27 16:12:17.236+00	2024-05-27 16:12:17.236+00	1	12
2024-05-27 16:12:17.251+00	2024-05-27 16:12:17.251+00	3	12
2024-05-27 16:12:17.267+00	2024-05-27 16:12:17.267+00	4	12
2024-05-27 16:12:17.281+00	2024-05-27 16:12:17.281+00	5	12
2024-05-27 16:12:17.296+00	2024-05-27 16:12:17.296+00	6	12
2024-05-27 16:12:17.311+00	2024-05-27 16:12:17.311+00	7	12
2024-05-27 16:12:17.326+00	2024-05-27 16:12:17.326+00	8	12
2024-05-27 16:12:17.341+00	2024-05-27 16:12:17.341+00	10	12
2024-05-27 16:12:17.356+00	2024-05-27 16:12:17.356+00	11	12
2024-05-27 16:12:17.37+00	2024-05-27 16:12:17.37+00	12	12
2024-05-27 16:12:17.399+00	2024-05-27 16:12:17.399+00	21	12
2024-05-27 16:12:17.414+00	2024-05-27 16:12:17.414+00	22	12
2024-05-27 16:12:17.429+00	2024-05-27 16:12:17.429+00	23	12
2024-05-27 16:12:17.444+00	2024-05-27 16:12:17.444+00	25	12
2024-05-27 16:12:17.49+00	2024-05-27 16:12:17.49+00	26	12
2024-05-27 16:12:17.522+00	2024-05-27 16:12:17.522+00	30	12
2024-05-27 16:12:17.557+00	2024-05-27 16:12:17.557+00	31	12
2024-05-27 16:12:17.613+00	2024-05-27 16:12:17.613+00	32	12
2024-05-27 16:12:17.63+00	2024-05-27 16:12:17.63+00	33	12
2024-05-27 16:12:17.648+00	2024-05-27 16:12:17.648+00	34	12
2024-05-27 16:12:17.666+00	2024-05-27 16:12:17.666+00	35	12
2024-05-27 16:12:17.691+00	2024-05-27 16:12:17.691+00	36	12
2024-05-27 16:12:17.77+00	2024-05-27 16:12:17.77+00	47	12
2024-05-27 16:12:17.79+00	2024-05-27 16:12:17.79+00	49	12
2024-05-27 16:12:17.805+00	2024-05-27 16:12:17.805+00	61	12
2024-05-27 16:12:17.818+00	2024-05-27 16:12:17.818+00	62	12
2024-05-27 16:12:17.831+00	2024-05-27 16:12:17.831+00	73	12
2024-05-27 16:12:17.846+00	2024-05-27 16:12:17.846+00	75	12
2024-05-27 16:12:17.861+00	2024-05-27 16:12:17.861+00	78	12
2024-05-27 16:12:17.876+00	2024-05-27 16:12:17.876+00	1	44
2024-05-27 16:12:17.89+00	2024-05-27 16:12:17.89+00	3	44
2024-05-27 16:12:17.904+00	2024-05-27 16:12:17.904+00	4	44
2024-05-27 16:12:17.918+00	2024-05-27 16:12:17.918+00	13	44
2024-05-27 16:12:17.936+00	2024-05-27 16:12:17.936+00	21	44
2024-05-27 16:12:17.952+00	2024-05-27 16:12:17.952+00	23	44
2024-05-27 16:12:17.967+00	2024-05-27 16:12:17.967+00	24	44
2024-05-27 16:12:17.985+00	2024-05-27 16:12:17.985+00	37	44
2024-05-27 16:12:18+00	2024-05-27 16:12:18+00	40	44
2024-05-27 16:12:18.014+00	2024-05-27 16:12:18.014+00	41	44
2024-05-27 16:12:18.027+00	2024-05-27 16:12:18.027+00	45	44
2024-05-27 16:12:18.042+00	2024-05-27 16:12:18.042+00	46	44
2024-05-27 16:12:18.057+00	2024-05-27 16:12:18.057+00	49	44
2024-05-27 16:12:18.072+00	2024-05-27 16:12:18.072+00	61	44
2024-05-27 16:12:18.083+00	2024-05-27 16:12:18.083+00	62	44
2024-05-27 16:12:18.097+00	2024-05-27 16:12:18.097+00	73	44
2024-05-27 16:12:18.111+00	2024-05-27 16:12:18.111+00	75	44
2024-05-27 16:12:18.126+00	2024-05-27 16:12:18.126+00	76	44
2024-05-27 16:12:18.14+00	2024-05-27 16:12:18.14+00	77	44
2024-05-27 16:12:18.155+00	2024-05-27 16:12:18.155+00	78	44
2024-05-27 16:12:18.171+00	2024-05-27 16:12:18.171+00	79	44
2024-05-27 16:12:18.186+00	2024-05-27 16:12:18.186+00	1	47
2024-05-27 16:12:18.199+00	2024-05-27 16:12:18.199+00	3	47
2024-05-27 16:12:18.212+00	2024-05-27 16:12:18.212+00	4	47
2024-05-27 16:12:18.225+00	2024-05-27 16:12:18.225+00	13	47
2024-05-27 16:12:18.238+00	2024-05-27 16:12:18.238+00	21	47
2024-05-27 16:12:18.253+00	2024-05-27 16:12:18.253+00	23	47
2024-05-27 16:12:18.267+00	2024-05-27 16:12:18.267+00	24	47
2024-05-27 16:12:18.278+00	2024-05-27 16:12:18.278+00	37	47
2024-05-27 16:12:18.291+00	2024-05-27 16:12:18.291+00	40	47
2024-05-27 16:12:18.302+00	2024-05-27 16:12:18.302+00	41	47
2024-05-27 16:12:18.314+00	2024-05-27 16:12:18.314+00	45	47
2024-05-27 16:12:18.328+00	2024-05-27 16:12:18.328+00	46	47
2024-05-27 16:12:18.341+00	2024-05-27 16:12:18.341+00	49	47
2024-05-27 16:12:18.353+00	2024-05-27 16:12:18.353+00	61	47
2024-05-27 16:12:18.366+00	2024-05-27 16:12:18.366+00	62	47
2024-05-27 16:12:18.379+00	2024-05-27 16:12:18.379+00	73	47
2024-05-27 16:12:18.392+00	2024-05-27 16:12:18.392+00	75	47
2024-05-27 16:12:18.404+00	2024-05-27 16:12:18.404+00	76	47
2024-05-27 16:12:18.417+00	2024-05-27 16:12:18.417+00	77	47
2024-05-27 16:12:18.43+00	2024-05-27 16:12:18.43+00	78	47
2024-05-27 16:12:18.452+00	2024-05-27 16:12:18.452+00	79	47
2024-05-27 16:12:18.476+00	2024-05-27 16:12:18.476+00	1	49
2024-05-27 16:12:18.491+00	2024-05-27 16:12:18.491+00	3	49
2024-05-27 16:12:18.504+00	2024-05-27 16:12:18.504+00	4	49
2024-05-27 16:12:18.517+00	2024-05-27 16:12:18.517+00	13	49
2024-05-27 16:12:18.53+00	2024-05-27 16:12:18.53+00	21	49
2024-05-27 16:12:18.542+00	2024-05-27 16:12:18.542+00	23	49
2024-05-27 16:12:18.555+00	2024-05-27 16:12:18.555+00	24	49
2024-05-27 16:12:18.568+00	2024-05-27 16:12:18.568+00	37	49
2024-05-27 16:12:18.582+00	2024-05-27 16:12:18.582+00	40	49
2024-05-27 16:12:18.594+00	2024-05-27 16:12:18.594+00	41	49
2024-05-27 16:12:18.605+00	2024-05-27 16:12:18.605+00	45	49
2024-05-27 16:12:18.618+00	2024-05-27 16:12:18.618+00	46	49
2024-05-27 16:12:18.631+00	2024-05-27 16:12:18.631+00	49	49
2024-05-27 16:12:18.644+00	2024-05-27 16:12:18.644+00	61	49
2024-05-27 16:12:18.657+00	2024-05-27 16:12:18.657+00	62	49
2024-05-27 16:12:18.67+00	2024-05-27 16:12:18.67+00	73	49
2024-05-27 16:12:18.684+00	2024-05-27 16:12:18.684+00	75	49
2024-05-27 16:12:18.699+00	2024-05-27 16:12:18.699+00	76	49
2024-05-27 16:12:18.71+00	2024-05-27 16:12:18.71+00	77	49
2024-05-27 16:12:18.723+00	2024-05-27 16:12:18.723+00	78	49
2024-05-27 16:12:18.734+00	2024-05-27 16:12:18.734+00	79	49
2024-05-27 16:12:18.748+00	2024-05-27 16:12:18.748+00	1	48
2024-05-27 16:12:18.762+00	2024-05-27 16:12:18.762+00	3	48
2024-05-27 16:12:18.776+00	2024-05-27 16:12:18.776+00	4	48
2024-05-27 16:12:18.789+00	2024-05-27 16:12:18.789+00	13	48
2024-05-27 16:12:18.803+00	2024-05-27 16:12:18.803+00	21	48
2024-05-27 16:12:18.816+00	2024-05-27 16:12:18.816+00	23	48
2024-05-27 16:12:18.83+00	2024-05-27 16:12:18.83+00	24	48
2024-05-27 16:12:18.843+00	2024-05-27 16:12:18.843+00	37	48
2024-05-27 16:12:18.857+00	2024-05-27 16:12:18.857+00	40	48
2024-05-27 16:12:18.871+00	2024-05-27 16:12:18.871+00	41	48
2024-05-27 16:12:18.883+00	2024-05-27 16:12:18.883+00	45	48
2024-05-27 16:12:18.898+00	2024-05-27 16:12:18.898+00	46	48
2024-05-27 16:12:18.91+00	2024-05-27 16:12:18.91+00	61	48
2024-05-27 16:12:18.922+00	2024-05-27 16:12:18.922+00	62	48
2024-05-27 16:12:18.935+00	2024-05-27 16:12:18.935+00	73	48
2024-05-27 16:12:18.949+00	2024-05-27 16:12:18.949+00	75	48
2024-05-27 16:12:18.963+00	2024-05-27 16:12:18.963+00	76	48
2024-05-27 16:12:18.976+00	2024-05-27 16:12:18.976+00	77	48
2024-05-27 16:12:18.989+00	2024-05-27 16:12:18.989+00	78	48
2024-05-27 16:12:19.003+00	2024-05-27 16:12:19.003+00	79	48
2024-05-27 16:12:19.015+00	2024-05-27 16:12:19.015+00	1	46
2024-05-27 16:12:19.027+00	2024-05-27 16:12:19.027+00	3	46
2024-05-27 16:12:19.042+00	2024-05-27 16:12:19.042+00	4	46
2024-05-27 16:12:19.058+00	2024-05-27 16:12:19.058+00	13	46
2024-05-27 16:12:19.072+00	2024-05-27 16:12:19.072+00	21	46
2024-05-27 16:12:19.087+00	2024-05-27 16:12:19.087+00	23	46
2024-05-27 16:12:19.101+00	2024-05-27 16:12:19.101+00	24	46
2024-05-27 16:12:19.114+00	2024-05-27 16:12:19.114+00	37	46
2024-05-27 16:12:19.127+00	2024-05-27 16:12:19.127+00	40	46
2024-05-27 16:12:19.154+00	2024-05-27 16:12:19.154+00	45	46
2024-05-27 16:12:19.168+00	2024-05-27 16:12:19.168+00	46	46
2024-05-27 16:12:19.182+00	2024-05-27 16:12:19.182+00	61	46
2024-05-27 16:12:19.195+00	2024-05-27 16:12:19.195+00	62	46
2024-05-27 16:12:19.214+00	2024-05-27 16:12:19.214+00	73	46
2024-05-27 16:12:19.231+00	2024-05-27 16:12:19.231+00	75	46
2024-05-27 16:12:19.245+00	2024-05-27 16:12:19.245+00	76	46
2024-05-27 16:12:19.259+00	2024-05-27 16:12:19.259+00	77	46
2024-05-27 16:12:19.273+00	2024-05-27 16:12:19.273+00	78	46
2024-05-27 16:12:19.286+00	2024-05-27 16:12:19.286+00	79	46
2024-05-27 16:12:19.299+00	2024-05-27 16:12:19.299+00	1	31
2024-05-27 16:12:19.314+00	2024-05-27 16:12:19.314+00	3	31
2024-05-27 16:12:19.329+00	2024-05-27 16:12:19.329+00	4	31
2024-05-27 16:12:19.342+00	2024-05-27 16:12:19.342+00	21	31
2024-05-27 16:12:19.356+00	2024-05-27 16:12:19.356+00	22	31
2024-05-27 16:12:19.369+00	2024-05-27 16:12:19.369+00	23	31
2024-05-27 16:12:19.383+00	2024-05-27 16:12:19.383+00	37	31
2024-05-27 16:12:19.397+00	2024-05-27 16:12:19.397+00	38	31
2024-05-27 16:12:19.411+00	2024-05-27 16:12:19.411+00	41	31
2024-05-27 16:12:19.425+00	2024-05-27 16:12:19.425+00	49	31
2024-05-27 16:12:19.44+00	2024-05-27 16:12:19.44+00	50	31
2024-05-27 16:12:19.453+00	2024-05-27 16:12:19.453+00	51	31
2024-05-27 16:12:19.467+00	2024-05-27 16:12:19.467+00	52	31
2024-05-27 16:12:19.483+00	2024-05-27 16:12:19.483+00	53	31
2024-05-27 16:12:19.497+00	2024-05-27 16:12:19.497+00	54	31
2024-05-27 16:12:19.511+00	2024-05-27 16:12:19.511+00	55	31
2024-05-27 16:12:19.526+00	2024-05-27 16:12:19.526+00	56	31
2024-05-27 16:12:19.541+00	2024-05-27 16:12:19.541+00	57	31
2024-05-27 16:12:19.556+00	2024-05-27 16:12:19.556+00	58	31
2024-05-27 16:12:19.57+00	2024-05-27 16:12:19.57+00	59	31
2024-05-27 16:12:19.584+00	2024-05-27 16:12:19.584+00	61	31
2024-05-27 16:12:19.598+00	2024-05-27 16:12:19.598+00	62	31
2024-05-27 16:12:19.613+00	2024-05-27 16:12:19.613+00	63	31
2024-05-27 16:12:19.628+00	2024-05-27 16:12:19.628+00	64	31
2024-05-27 16:12:19.666+00	2024-05-27 16:12:19.666+00	65	31
2024-05-27 16:12:19.686+00	2024-05-27 16:12:19.686+00	66	31
2024-05-27 16:12:19.701+00	2024-05-27 16:12:19.701+00	67	31
2024-05-27 16:12:19.717+00	2024-05-27 16:12:19.717+00	68	31
2024-05-27 16:12:19.733+00	2024-05-27 16:12:19.733+00	69	31
2024-05-27 16:12:19.749+00	2024-05-27 16:12:19.749+00	70	31
2024-05-27 16:12:19.763+00	2024-05-27 16:12:19.763+00	71	31
2024-05-27 16:12:19.777+00	2024-05-27 16:12:19.777+00	73	31
2024-05-27 16:12:19.79+00	2024-05-27 16:12:19.79+00	74	31
2024-05-27 16:12:19.804+00	2024-05-27 16:12:19.804+00	75	31
2024-05-27 16:12:19.817+00	2024-05-27 16:12:19.817+00	82	31
2024-05-27 16:12:19.831+00	2024-05-27 16:12:19.831+00	84	31
2024-05-27 16:12:19.846+00	2024-05-27 16:12:19.846+00	85	31
2024-05-27 16:12:19.86+00	2024-05-27 16:12:19.86+00	1	37
2024-05-27 16:12:19.87+00	2024-05-27 16:12:19.87+00	3	37
2024-05-27 16:12:19.883+00	2024-05-27 16:12:19.883+00	4	37
2024-05-27 16:12:19.899+00	2024-05-27 16:12:19.899+00	5	37
2024-05-27 16:12:19.918+00	2024-05-27 16:12:19.918+00	6	37
2024-05-27 16:12:19.933+00	2024-05-27 16:12:19.933+00	7	37
2024-05-27 16:12:19.948+00	2024-05-27 16:12:19.948+00	8	37
2024-05-27 16:12:19.962+00	2024-05-27 16:12:19.962+00	9	37
2024-05-27 16:12:19.974+00	2024-05-27 16:12:19.974+00	10	37
2024-05-27 16:12:19.987+00	2024-05-27 16:12:19.987+00	11	37
2024-05-27 16:12:20+00	2024-05-27 16:12:20+00	12	37
2024-05-27 16:12:20.014+00	2024-05-27 16:12:20.014+00	13	37
2024-05-27 16:12:20.028+00	2024-05-27 16:12:20.028+00	14	37
2024-05-27 16:12:20.042+00	2024-05-27 16:12:20.042+00	15	37
2024-05-27 16:12:20.057+00	2024-05-27 16:12:20.057+00	16	37
2024-05-27 16:12:20.069+00	2024-05-27 16:12:20.069+00	17	37
2024-05-27 16:12:20.082+00	2024-05-27 16:12:20.082+00	18	37
2024-05-27 16:12:20.094+00	2024-05-27 16:12:20.094+00	19	37
2024-05-27 16:12:20.107+00	2024-05-27 16:12:20.107+00	20	37
2024-05-27 16:12:20.121+00	2024-05-27 16:12:20.121+00	21	37
2024-05-27 16:12:20.134+00	2024-05-27 16:12:20.134+00	22	37
2024-05-27 16:12:20.148+00	2024-05-27 16:12:20.148+00	23	37
2024-05-27 16:12:20.162+00	2024-05-27 16:12:20.162+00	24	37
2024-05-27 16:12:20.176+00	2024-05-27 16:12:20.176+00	36	37
2024-05-27 16:12:20.189+00	2024-05-27 16:12:20.189+00	37	37
2024-05-27 16:12:20.202+00	2024-05-27 16:12:20.202+00	38	37
2024-05-27 16:12:20.214+00	2024-05-27 16:12:20.214+00	40	37
2024-05-27 16:12:20.227+00	2024-05-27 16:12:20.227+00	41	37
2024-05-27 16:12:20.24+00	2024-05-27 16:12:20.24+00	42	37
2024-05-27 16:12:20.253+00	2024-05-27 16:12:20.253+00	43	37
2024-05-27 16:12:20.268+00	2024-05-27 16:12:20.268+00	45	37
2024-05-27 16:12:20.28+00	2024-05-27 16:12:20.28+00	46	37
2024-05-27 16:12:20.293+00	2024-05-27 16:12:20.293+00	47	37
2024-05-27 16:12:20.309+00	2024-05-27 16:12:20.309+00	49	37
2024-05-27 16:12:20.327+00	2024-05-27 16:12:20.327+00	50	37
2024-05-27 16:12:20.343+00	2024-05-27 16:12:20.343+00	51	37
2024-05-27 16:12:20.357+00	2024-05-27 16:12:20.357+00	52	37
2024-05-27 16:12:20.371+00	2024-05-27 16:12:20.371+00	53	37
2024-05-27 16:12:20.384+00	2024-05-27 16:12:20.384+00	54	37
2024-05-27 16:12:20.401+00	2024-05-27 16:12:20.401+00	55	37
2024-05-27 16:12:20.422+00	2024-05-27 16:12:20.422+00	56	37
2024-05-27 16:12:20.438+00	2024-05-27 16:12:20.438+00	57	37
2024-05-27 16:12:20.453+00	2024-05-27 16:12:20.453+00	58	37
2024-05-27 16:12:20.467+00	2024-05-27 16:12:20.467+00	59	37
2024-05-27 16:12:20.48+00	2024-05-27 16:12:20.48+00	60	37
2024-05-27 16:12:20.493+00	2024-05-27 16:12:20.493+00	61	37
2024-05-27 16:12:20.506+00	2024-05-27 16:12:20.506+00	62	37
2024-05-27 16:12:20.519+00	2024-05-27 16:12:20.519+00	72	37
2024-05-27 16:12:20.533+00	2024-05-27 16:12:20.533+00	73	37
2024-05-27 16:12:20.547+00	2024-05-27 16:12:20.547+00	74	37
2024-05-27 16:12:20.561+00	2024-05-27 16:12:20.561+00	75	37
2024-05-27 16:12:20.574+00	2024-05-27 16:12:20.574+00	76	37
2024-05-27 16:12:20.588+00	2024-05-27 16:12:20.588+00	77	37
2024-05-27 16:12:20.603+00	2024-05-27 16:12:20.603+00	78	37
2024-05-27 16:12:20.617+00	2024-05-27 16:12:20.617+00	79	37
2024-05-27 16:12:20.657+00	2024-05-27 16:12:20.657+00	81	37
2024-05-27 16:12:20.692+00	2024-05-27 16:12:20.692+00	82	37
2024-05-27 16:12:20.704+00	2024-05-27 16:12:20.704+00	84	37
2024-05-27 16:12:20.718+00	2024-05-27 16:12:20.718+00	85	37
2024-05-27 16:12:20.731+00	2024-05-27 16:12:20.731+00	1	39
2024-05-27 16:12:20.746+00	2024-05-27 16:12:20.746+00	3	39
2024-05-27 16:12:20.758+00	2024-05-27 16:12:20.758+00	4	39
2024-05-27 16:12:20.772+00	2024-05-27 16:12:20.772+00	5	39
2024-05-27 16:12:20.786+00	2024-05-27 16:12:20.786+00	6	39
2024-05-27 16:12:20.8+00	2024-05-27 16:12:20.8+00	7	39
2024-05-27 16:12:20.814+00	2024-05-27 16:12:20.814+00	8	39
2024-05-27 16:12:20.827+00	2024-05-27 16:12:20.827+00	9	39
2024-05-27 16:12:20.841+00	2024-05-27 16:12:20.841+00	10	39
2024-05-27 16:12:20.854+00	2024-05-27 16:12:20.854+00	11	39
2024-05-27 16:12:20.875+00	2024-05-27 16:12:20.875+00	12	39
2024-05-27 16:12:20.908+00	2024-05-27 16:12:20.908+00	13	39
2024-05-27 16:12:20.942+00	2024-05-27 16:12:20.942+00	14	39
2024-05-27 16:12:20.998+00	2024-05-27 16:12:20.998+00	15	39
2024-05-27 16:12:21.019+00	2024-05-27 16:12:21.019+00	16	39
2024-05-27 16:12:21.042+00	2024-05-27 16:12:21.042+00	17	39
2024-05-27 16:12:21.079+00	2024-05-27 16:12:21.079+00	18	39
2024-05-27 16:12:21.107+00	2024-05-27 16:12:21.107+00	19	39
2024-05-27 16:12:21.134+00	2024-05-27 16:12:21.134+00	20	39
2024-05-27 16:12:21.153+00	2024-05-27 16:12:21.153+00	21	39
2024-05-27 16:12:21.171+00	2024-05-27 16:12:21.171+00	22	39
2024-05-27 16:12:21.185+00	2024-05-27 16:12:21.185+00	23	39
2024-05-27 16:12:21.2+00	2024-05-27 16:12:21.2+00	24	39
2024-05-27 16:12:21.219+00	2024-05-27 16:12:21.219+00	36	39
2024-05-27 16:12:21.237+00	2024-05-27 16:12:21.237+00	37	39
2024-05-27 16:12:21.252+00	2024-05-27 16:12:21.252+00	38	39
2024-05-27 16:12:21.266+00	2024-05-27 16:12:21.266+00	40	39
2024-05-27 16:12:21.28+00	2024-05-27 16:12:21.28+00	41	39
2024-05-27 16:12:21.294+00	2024-05-27 16:12:21.294+00	42	39
2024-05-27 16:12:21.307+00	2024-05-27 16:12:21.307+00	43	39
2024-05-27 16:12:21.321+00	2024-05-27 16:12:21.321+00	45	39
2024-05-27 16:12:21.333+00	2024-05-27 16:12:21.333+00	46	39
2024-05-27 16:12:21.347+00	2024-05-27 16:12:21.347+00	47	39
2024-05-27 16:12:21.359+00	2024-05-27 16:12:21.359+00	49	39
2024-05-27 16:12:21.372+00	2024-05-27 16:12:21.372+00	50	39
2024-05-27 16:12:21.386+00	2024-05-27 16:12:21.386+00	51	39
2024-05-27 16:12:21.399+00	2024-05-27 16:12:21.399+00	52	39
2024-05-27 16:12:21.412+00	2024-05-27 16:12:21.412+00	53	39
2024-05-27 16:12:21.423+00	2024-05-27 16:12:21.423+00	54	39
2024-05-27 16:12:21.437+00	2024-05-27 16:12:21.437+00	55	39
2024-05-27 16:12:21.453+00	2024-05-27 16:12:21.453+00	56	39
2024-05-27 16:12:21.466+00	2024-05-27 16:12:21.466+00	57	39
2024-05-27 16:12:21.479+00	2024-05-27 16:12:21.479+00	58	39
2024-05-27 16:12:21.493+00	2024-05-27 16:12:21.493+00	59	39
2024-05-27 16:12:21.506+00	2024-05-27 16:12:21.506+00	60	39
2024-05-27 16:12:21.519+00	2024-05-27 16:12:21.519+00	61	39
2024-05-27 16:12:21.533+00	2024-05-27 16:12:21.533+00	62	39
2024-05-27 16:12:21.546+00	2024-05-27 16:12:21.546+00	73	39
2024-05-27 16:12:21.559+00	2024-05-27 16:12:21.559+00	74	39
2024-05-27 16:12:21.573+00	2024-05-27 16:12:21.573+00	75	39
2024-05-27 16:12:21.586+00	2024-05-27 16:12:21.586+00	76	39
2024-05-27 16:12:21.601+00	2024-05-27 16:12:21.601+00	77	39
2024-05-27 16:12:21.614+00	2024-05-27 16:12:21.614+00	79	39
2024-05-27 16:12:21.626+00	2024-05-27 16:12:21.626+00	82	39
2024-05-27 16:12:21.64+00	2024-05-27 16:12:21.64+00	84	39
2024-05-27 16:12:21.656+00	2024-05-27 16:12:21.656+00	85	39
2024-05-27 16:12:21.669+00	2024-05-27 16:12:21.669+00	1	20
2024-05-27 16:12:21.684+00	2024-05-27 16:12:21.684+00	3	20
2024-05-27 16:12:21.698+00	2024-05-27 16:12:21.698+00	4	20
2024-05-27 16:12:21.711+00	2024-05-27 16:12:21.711+00	13	20
2024-05-27 16:12:21.725+00	2024-05-27 16:12:21.725+00	21	20
2024-05-27 16:12:21.741+00	2024-05-27 16:12:21.741+00	23	20
2024-05-27 16:12:21.756+00	2024-05-27 16:12:21.756+00	24	20
2024-05-27 16:12:21.77+00	2024-05-27 16:12:21.77+00	37	20
2024-05-27 16:12:21.786+00	2024-05-27 16:12:21.786+00	40	20
2024-05-27 16:12:21.799+00	2024-05-27 16:12:21.799+00	41	20
2024-05-27 16:12:21.815+00	2024-05-27 16:12:21.815+00	42	20
2024-05-27 16:12:21.837+00	2024-05-27 16:12:21.837+00	43	20
2024-05-27 16:12:21.856+00	2024-05-27 16:12:21.856+00	45	20
2024-05-27 16:12:21.876+00	2024-05-27 16:12:21.876+00	46	20
2024-05-27 16:12:21.892+00	2024-05-27 16:12:21.892+00	47	20
2024-05-27 16:12:21.906+00	2024-05-27 16:12:21.906+00	49	20
2024-05-27 16:12:21.92+00	2024-05-27 16:12:21.92+00	50	20
2024-05-27 16:12:21.933+00	2024-05-27 16:12:21.933+00	51	20
2024-05-27 16:12:21.947+00	2024-05-27 16:12:21.947+00	52	20
2024-05-27 16:12:21.961+00	2024-05-27 16:12:21.961+00	53	20
2024-05-27 16:12:21.975+00	2024-05-27 16:12:21.975+00	54	20
2024-05-27 16:12:21.988+00	2024-05-27 16:12:21.988+00	55	20
2024-05-27 16:12:22.001+00	2024-05-27 16:12:22.001+00	56	20
2024-05-27 16:12:22.017+00	2024-05-27 16:12:22.017+00	57	20
2024-05-27 16:12:22.031+00	2024-05-27 16:12:22.031+00	58	20
2024-05-27 16:12:22.046+00	2024-05-27 16:12:22.046+00	59	20
2024-05-27 16:12:22.06+00	2024-05-27 16:12:22.06+00	60	20
2024-05-27 16:12:22.076+00	2024-05-27 16:12:22.076+00	61	20
2024-05-27 16:12:22.09+00	2024-05-27 16:12:22.09+00	62	20
2024-05-27 16:12:22.103+00	2024-05-27 16:12:22.103+00	73	20
2024-05-27 16:12:22.117+00	2024-05-27 16:12:22.117+00	75	20
2024-05-27 16:12:22.131+00	2024-05-27 16:12:22.131+00	76	20
2024-05-27 16:12:22.147+00	2024-05-27 16:12:22.147+00	77	20
2024-05-27 16:12:22.16+00	2024-05-27 16:12:22.16+00	78	20
2024-05-27 16:12:22.174+00	2024-05-27 16:12:22.174+00	79	20
2024-05-27 16:12:22.19+00	2024-05-27 16:12:22.19+00	82	20
2024-05-27 16:12:22.204+00	2024-05-27 16:12:22.204+00	84	20
2024-05-27 16:12:22.217+00	2024-05-27 16:12:22.217+00	85	20
2024-05-27 16:12:22.232+00	2024-05-27 16:12:22.232+00	1	19
2024-05-27 16:12:22.247+00	2024-05-27 16:12:22.247+00	3	19
2024-05-27 16:12:22.261+00	2024-05-27 16:12:22.261+00	4	19
2024-05-27 16:12:22.274+00	2024-05-27 16:12:22.274+00	13	19
2024-05-27 16:12:22.287+00	2024-05-27 16:12:22.287+00	21	19
2024-05-27 16:12:22.3+00	2024-05-27 16:12:22.3+00	23	19
2024-05-27 16:12:22.312+00	2024-05-27 16:12:22.312+00	24	19
2024-05-27 16:12:22.326+00	2024-05-27 16:12:22.326+00	37	19
2024-05-27 16:12:22.338+00	2024-05-27 16:12:22.338+00	40	19
2024-05-27 16:12:22.351+00	2024-05-27 16:12:22.351+00	41	19
2024-05-27 16:12:22.364+00	2024-05-27 16:12:22.364+00	42	19
2024-05-27 16:12:22.377+00	2024-05-27 16:12:22.377+00	43	19
2024-05-27 16:12:22.391+00	2024-05-27 16:12:22.391+00	45	19
2024-05-27 16:12:22.404+00	2024-05-27 16:12:22.404+00	46	19
2024-05-27 16:12:22.415+00	2024-05-27 16:12:22.415+00	47	19
2024-05-27 16:12:22.427+00	2024-05-27 16:12:22.427+00	49	19
2024-05-27 16:12:22.44+00	2024-05-27 16:12:22.44+00	50	19
2024-05-27 16:12:22.453+00	2024-05-27 16:12:22.453+00	51	19
2024-05-27 16:12:22.469+00	2024-05-27 16:12:22.469+00	52	19
2024-05-27 16:12:22.489+00	2024-05-27 16:12:22.489+00	53	19
2024-05-27 16:12:22.501+00	2024-05-27 16:12:22.501+00	54	19
2024-05-27 16:12:22.515+00	2024-05-27 16:12:22.515+00	55	19
2024-05-27 16:12:22.527+00	2024-05-27 16:12:22.527+00	56	19
2024-05-27 16:12:22.539+00	2024-05-27 16:12:22.539+00	57	19
2024-05-27 16:12:22.554+00	2024-05-27 16:12:22.554+00	58	19
2024-05-27 16:12:22.576+00	2024-05-27 16:12:22.576+00	59	19
2024-05-27 16:12:22.592+00	2024-05-27 16:12:22.592+00	60	19
2024-05-27 16:12:22.607+00	2024-05-27 16:12:22.607+00	61	19
2024-05-27 16:12:22.621+00	2024-05-27 16:12:22.621+00	62	19
2024-05-27 16:12:22.636+00	2024-05-27 16:12:22.636+00	72	19
2024-05-27 16:12:22.649+00	2024-05-27 16:12:22.649+00	73	19
2024-05-27 16:12:22.663+00	2024-05-27 16:12:22.663+00	74	19
2024-05-27 16:12:22.677+00	2024-05-27 16:12:22.677+00	75	19
2024-05-27 16:12:22.692+00	2024-05-27 16:12:22.692+00	76	19
2024-05-27 16:12:22.707+00	2024-05-27 16:12:22.707+00	77	19
2024-05-27 16:12:22.72+00	2024-05-27 16:12:22.72+00	78	19
2024-05-27 16:12:22.733+00	2024-05-27 16:12:22.733+00	79	19
2024-05-27 16:12:22.747+00	2024-05-27 16:12:22.747+00	81	19
2024-05-27 16:12:22.761+00	2024-05-27 16:12:22.761+00	82	19
2024-05-27 16:12:22.775+00	2024-05-27 16:12:22.775+00	84	19
2024-05-27 16:12:22.79+00	2024-05-27 16:12:22.79+00	85	19
2024-05-27 16:12:22.802+00	2024-05-27 16:12:22.802+00	1	50
2024-05-27 16:12:22.816+00	2024-05-27 16:12:22.816+00	3	50
2024-05-27 16:12:22.83+00	2024-05-27 16:12:22.83+00	4	50
2024-05-27 16:12:22.842+00	2024-05-27 16:12:22.842+00	21	50
2024-05-27 16:12:22.855+00	2024-05-27 16:12:22.855+00	23	50
2024-05-27 16:12:22.901+00	2024-05-27 16:12:22.901+00	75	50
2024-05-27 16:12:22.914+00	2024-05-27 16:12:22.914+00	1	4
2024-05-27 16:12:22.927+00	2024-05-27 16:12:22.927+00	3	4
2024-05-27 16:12:22.939+00	2024-05-27 16:12:22.939+00	4	4
2024-05-27 16:12:22.955+00	2024-05-27 16:12:22.955+00	5	4
2024-05-27 16:12:22.969+00	2024-05-27 16:12:22.969+00	6	4
2024-05-27 16:12:22.985+00	2024-05-27 16:12:22.985+00	7	4
2024-05-27 16:12:23.003+00	2024-05-27 16:12:23.003+00	8	4
2024-05-27 16:12:23.019+00	2024-05-27 16:12:23.019+00	9	4
2024-05-27 16:12:23.035+00	2024-05-27 16:12:23.035+00	10	4
2024-05-27 16:12:23.049+00	2024-05-27 16:12:23.049+00	11	4
2024-05-27 16:12:23.064+00	2024-05-27 16:12:23.064+00	12	4
2024-05-27 16:12:23.117+00	2024-05-27 16:12:23.117+00	14	4
2024-05-27 16:12:23.136+00	2024-05-27 16:12:23.136+00	15	4
2024-05-27 16:12:23.153+00	2024-05-27 16:12:23.153+00	16	4
2024-05-27 16:12:23.172+00	2024-05-27 16:12:23.172+00	17	4
2024-05-27 16:12:23.188+00	2024-05-27 16:12:23.188+00	18	4
2024-05-27 16:12:23.202+00	2024-05-27 16:12:23.202+00	19	4
2024-05-27 16:12:23.216+00	2024-05-27 16:12:23.216+00	20	4
2024-05-27 16:12:23.232+00	2024-05-27 16:12:23.232+00	21	4
2024-05-27 16:12:23.271+00	2024-05-27 16:12:23.271+00	23	4
2024-05-27 16:12:23.296+00	2024-05-27 16:12:23.296+00	37	4
2024-05-27 16:12:23.314+00	2024-05-27 16:12:23.314+00	41	4
2024-05-27 16:12:23.333+00	2024-05-27 16:12:23.333+00	49	4
2024-05-27 16:12:23.351+00	2024-05-27 16:12:23.351+00	75	4
2024-05-27 16:12:23.37+00	2024-05-27 16:12:23.37+00	78	4
2024-05-27 16:12:23.391+00	2024-05-27 16:12:23.391+00	84	4
2024-05-27 16:12:23.424+00	2024-05-27 16:12:23.424+00	85	4
2024-05-27 16:12:23.452+00	2024-05-27 16:12:23.452+00	1	35
2024-05-27 16:12:23.468+00	2024-05-27 16:12:23.468+00	3	35
2024-05-27 16:12:23.485+00	2024-05-27 16:12:23.485+00	4	35
2024-05-27 16:12:23.504+00	2024-05-27 16:12:23.504+00	23	35
2024-05-27 16:12:23.537+00	2024-05-27 16:12:23.537+00	41	35
2024-05-27 16:12:23.555+00	2024-05-27 16:12:23.555+00	3	26
2024-05-27 16:12:23.57+00	2024-05-27 16:12:23.57+00	4	26
2024-05-27 16:12:23.584+00	2024-05-27 16:12:23.584+00	7	26
2024-05-27 16:12:23.598+00	2024-05-27 16:12:23.598+00	13	26
2024-05-27 16:12:23.613+00	2024-05-27 16:12:23.613+00	23	26
2024-05-27 16:12:23.627+00	2024-05-27 16:12:23.627+00	24	26
2024-05-27 16:12:23.655+00	2024-05-27 16:12:23.655+00	40	26
2024-05-27 16:12:23.672+00	2024-05-27 16:12:23.672+00	41	26
2024-05-27 16:12:23.685+00	2024-05-27 16:12:23.685+00	60	26
2024-05-27 16:12:23.697+00	2024-05-27 16:12:23.697+00	76	26
2024-05-27 16:12:23.712+00	2024-05-27 16:12:23.712+00	77	26
2024-05-27 16:12:23.726+00	2024-05-27 16:12:23.726+00	78	26
2024-05-27 16:12:23.739+00	2024-05-27 16:12:23.739+00	83	26
2024-05-27 16:12:23.756+00	2024-05-27 16:12:23.756+00	84	26
2024-05-27 16:12:23.77+00	2024-05-27 16:12:23.77+00	85	26
2024-05-27 16:12:23.785+00	2024-05-27 16:12:23.785+00	3	5
2024-05-27 16:12:23.8+00	2024-05-27 16:12:23.8+00	4	5
2024-05-27 16:12:23.815+00	2024-05-27 16:12:23.815+00	13	5
2024-05-27 16:12:23.83+00	2024-05-27 16:12:23.83+00	23	5
2024-05-27 16:12:23.864+00	2024-05-27 16:12:23.864+00	3	34
2024-05-27 16:12:23.878+00	2024-05-27 16:12:23.878+00	4	34
2024-05-27 16:12:23.891+00	2024-05-27 16:12:23.891+00	23	34
2024-05-27 16:12:23.922+00	2024-05-27 16:12:23.922+00	3	53
2024-05-27 16:12:23.934+00	2024-05-27 16:12:23.934+00	4	53
2024-05-27 16:12:23.948+00	2024-05-27 16:12:23.948+00	23	53
2024-05-27 16:12:23.974+00	2024-05-27 16:12:23.974+00	80	53
2024-05-27 16:12:23.991+00	2024-05-27 16:12:23.991+00	3	51
2024-05-27 16:12:24.005+00	2024-05-27 16:12:24.005+00	4	51
2024-05-27 16:12:24.051+00	2024-05-27 16:12:24.051+00	6	51
2024-05-27 16:12:24.066+00	2024-05-27 16:12:24.066+00	7	51
2024-05-27 16:12:24.08+00	2024-05-27 16:12:24.08+00	8	51
2024-05-27 16:12:24.094+00	2024-05-27 16:12:24.094+00	9	51
2024-05-27 16:12:24.109+00	2024-05-27 16:12:24.109+00	10	51
2024-05-27 16:12:24.125+00	2024-05-27 16:12:24.125+00	11	51
2024-05-27 16:12:24.139+00	2024-05-27 16:12:24.139+00	12	51
2024-05-27 16:12:24.153+00	2024-05-27 16:12:24.153+00	13	51
2024-05-27 16:12:24.167+00	2024-05-27 16:12:24.167+00	14	51
2024-05-27 16:12:24.183+00	2024-05-27 16:12:24.183+00	15	51
2024-05-27 16:12:24.199+00	2024-05-27 16:12:24.199+00	16	51
2024-05-27 16:12:24.215+00	2024-05-27 16:12:24.215+00	17	51
2024-05-27 16:12:24.228+00	2024-05-27 16:12:24.228+00	18	51
2024-05-27 16:12:24.244+00	2024-05-27 16:12:24.244+00	19	51
2024-05-27 16:12:24.259+00	2024-05-27 16:12:24.259+00	20	51
2024-05-27 16:12:24.273+00	2024-05-27 16:12:24.273+00	21	51
2024-05-27 16:12:24.286+00	2024-05-27 16:12:24.286+00	23	51
2024-05-27 16:12:24.316+00	2024-05-27 16:12:24.316+00	49	51
2024-05-27 16:12:24.33+00	2024-05-27 16:12:24.33+00	80	51
2024-05-27 16:12:24.344+00	2024-05-27 16:12:24.344+00	3	23
2024-05-27 16:12:24.359+00	2024-05-27 16:12:24.359+00	4	23
2024-05-27 16:12:24.374+00	2024-05-27 16:12:24.374+00	13	23
2024-05-27 16:12:24.389+00	2024-05-27 16:12:24.389+00	23	23
2024-05-27 16:12:24.405+00	2024-05-27 16:12:24.405+00	37	23
2024-05-27 16:12:24.419+00	2024-05-27 16:12:24.419+00	3	24
2024-05-27 16:12:24.433+00	2024-05-27 16:12:24.433+00	4	24
2024-05-27 16:12:24.455+00	2024-05-27 16:12:24.455+00	13	24
2024-05-27 16:12:24.473+00	2024-05-27 16:12:24.473+00	23	24
2024-05-27 16:12:24.49+00	2024-05-27 16:12:24.49+00	37	24
2024-05-27 16:12:24.504+00	2024-05-27 16:12:24.504+00	3	22
2024-05-27 16:12:24.517+00	2024-05-27 16:12:24.517+00	4	22
2024-05-27 16:12:24.53+00	2024-05-27 16:12:24.53+00	13	22
2024-05-27 16:12:24.545+00	2024-05-27 16:12:24.545+00	23	22
2024-05-27 16:12:24.559+00	2024-05-27 16:12:24.559+00	37	22
2024-05-27 16:12:24.575+00	2024-05-27 16:12:24.575+00	3	21
2024-05-27 16:12:24.588+00	2024-05-27 16:12:24.588+00	4	21
2024-05-27 16:12:24.602+00	2024-05-27 16:12:24.602+00	13	21
2024-05-27 16:12:24.617+00	2024-05-27 16:12:24.617+00	23	21
2024-05-27 16:12:24.633+00	2024-05-27 16:12:24.633+00	37	21
2024-05-27 16:12:24.647+00	2024-05-27 16:12:24.647+00	3	43
2024-05-27 16:12:24.66+00	2024-05-27 16:12:24.66+00	4	43
2024-05-27 16:12:24.676+00	2024-05-27 16:12:24.676+00	23	43
2024-05-27 16:12:24.693+00	2024-05-27 16:12:24.693+00	37	43
2024-05-27 16:12:24.707+00	2024-05-27 16:12:24.707+00	58	43
2024-05-27 16:12:24.721+00	2024-05-27 16:12:24.721+00	82	43
2024-05-27 16:12:24.735+00	2024-05-27 16:12:24.735+00	3	9
2024-05-27 16:12:24.762+00	2024-05-27 16:12:24.762+00	4	9
2024-05-27 16:12:24.782+00	2024-05-27 16:12:24.782+00	13	9
2024-05-27 16:12:24.799+00	2024-05-27 16:12:24.799+00	23	9
2024-05-27 16:12:24.814+00	2024-05-27 16:12:24.814+00	3	6
2024-05-27 16:12:24.829+00	2024-05-27 16:12:24.829+00	4	6
2024-05-27 16:12:24.843+00	2024-05-27 16:12:24.843+00	13	6
2024-05-27 16:12:24.857+00	2024-05-27 16:12:24.857+00	23	6
2024-05-27 16:12:24.871+00	2024-05-27 16:12:24.871+00	3	8
2024-05-27 16:12:24.885+00	2024-05-27 16:12:24.885+00	4	8
2024-05-27 16:12:24.897+00	2024-05-27 16:12:24.897+00	13	8
2024-05-27 16:12:24.91+00	2024-05-27 16:12:24.91+00	23	8
2024-05-27 16:12:24.925+00	2024-05-27 16:12:24.925+00	3	3
2024-05-27 16:12:24.941+00	2024-05-27 16:12:24.941+00	4	3
2024-05-27 16:12:24.957+00	2024-05-27 16:12:24.957+00	13	3
2024-05-27 16:12:24.97+00	2024-05-27 16:12:24.97+00	23	3
2024-05-27 16:12:24.982+00	2024-05-27 16:12:24.982+00	78	3
2024-05-27 16:12:24.996+00	2024-05-27 16:12:24.996+00	3	45
2024-05-27 16:12:25.01+00	2024-05-27 16:12:25.01+00	4	45
2024-05-27 16:12:25.026+00	2024-05-27 16:12:25.026+00	23	45
2024-05-27 16:12:25.041+00	2024-05-27 16:12:25.041+00	58	45
2024-05-27 16:12:25.06+00	2024-05-27 16:12:25.06+00	3	1
2024-05-27 16:12:25.077+00	2024-05-27 16:12:25.077+00	23	1
2024-05-27 16:12:25.094+00	2024-05-27 16:12:25.094+00	3	2
2024-05-27 16:12:25.109+00	2024-05-27 16:12:25.109+00	13	2
2024-05-27 16:12:25.125+00	2024-05-27 16:12:25.125+00	23	2
2024-05-27 16:42:12.097+00	2024-05-27 16:42:12.097+00	86	1
2024-05-27 16:42:12.455+00	2024-05-27 16:42:12.455+00	86	2
2024-05-27 16:42:12.847+00	2024-05-27 16:42:12.847+00	86	3
2024-05-27 16:42:13.167+00	2024-05-27 16:42:13.167+00	86	7
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	10
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	11
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	13
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	14
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	15
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	16
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	28
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	29
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	30
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	32
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	33
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	36
2024-05-27 16:43:40.899+00	2024-05-27 16:43:40.899+00	3	40
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	1
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	2
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	3
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	6
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	8
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	9
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	10
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	11
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	13
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	14
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	15
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	16
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	19
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	20
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	21
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	22
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	23
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	24
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	26
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	27
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	28
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	29
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	30
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	31
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	32
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	33
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	36
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	40
2024-05-27 16:45:56.638+00	2024-05-27 16:45:56.638+00	5	43
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	4
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	5
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	6
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	8
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	9
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	10
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	11
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	12
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	13
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	14
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	15
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	16
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	17
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	18
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	19
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	20
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	21
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	22
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	23
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	24
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	25
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	26
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	27
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	28
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	29
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	30
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	31
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	32
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	33
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	34
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	35
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	36
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	37
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	38
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	39
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	40
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	41
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	42
2024-05-27 16:46:04.852+00	2024-05-27 16:46:04.852+00	86	43
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	1
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	2
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	3
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	5
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	6
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	8
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	9
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	10
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	11
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	13
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	14
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	15
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	16
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	21
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	22
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	23
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	24
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	26
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	28
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	29
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	30
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	32
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	33
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	34
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	36
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	40
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	43
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	45
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	51
2024-05-27 22:12:57.033+00	2024-05-27 22:12:57.033+00	1	53
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	10
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	11
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	13
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	14
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	15
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	16
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	28
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	29
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	30
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	32
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	33
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	36
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	40
2024-05-27 22:29:28.998+00	2024-05-27 22:29:28.998+00	2	7
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	1
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	2
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	3
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	4
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	5
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	6
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	8
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	9
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	10
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	11
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	12
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	13
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	14
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	15
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	16
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	17
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	18
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	19
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	20
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	21
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	22
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	23
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	24
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	25
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	26
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	27
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	28
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	29
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	30
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	31
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	32
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	33
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	34
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	35
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	36
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	37
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	38
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	39
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	40
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	41
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	42
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	43
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	44
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	45
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	46
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	47
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	48
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	49
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	50
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	51
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	52
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	53
2024-05-27 22:37:47.731+00	2024-05-27 22:37:47.731+00	88	7
2024-05-27 22:38:57.051+00	2024-05-27 22:38:57.051+00	86	44
2024-05-27 22:39:02.066+00	2024-05-27 22:39:02.066+00	86	45
2024-05-27 22:39:02.519+00	2024-05-27 22:39:02.519+00	86	46
2024-05-27 22:39:03.632+00	2024-05-27 22:39:03.632+00	86	47
2024-05-27 22:39:04.006+00	2024-05-27 22:39:04.006+00	86	48
2024-05-27 22:39:04.568+00	2024-05-27 22:39:04.568+00	86	49
2024-05-27 22:39:04.974+00	2024-05-27 22:39:04.974+00	86	50
2024-05-27 22:39:05.328+00	2024-05-27 22:39:05.328+00	86	51
2024-05-27 22:39:05.782+00	2024-05-27 22:39:05.782+00	86	52
2024-05-27 22:39:06.272+00	2024-05-27 22:39:06.272+00	86	53
2024-05-28 14:04:27.749+00	2024-05-28 14:04:27.749+00	24	3
2024-05-28 15:49:03.824+00	2024-05-28 15:49:03.824+00	41	46
2024-05-28 15:51:40.264+00	2024-05-28 15:51:40.264+00	38	26
2024-05-29 15:54:05.281+00	2024-05-29 15:54:05.281+00	50	45
2024-05-29 15:54:10.332+00	2024-05-29 15:54:10.332+00	50	43
2024-05-29 15:54:32.877+00	2024-05-29 15:54:32.877+00	54	45
2024-05-29 15:54:36.97+00	2024-05-29 15:54:36.97+00	54	43
2024-05-29 15:54:50.682+00	2024-05-29 15:54:50.682+00	91	45
2024-05-29 15:54:58.691+00	2024-05-29 15:54:58.691+00	91	43
2024-05-29 15:55:18.684+00	2024-05-29 15:55:18.684+00	89	45
2024-05-29 15:55:22.781+00	2024-05-29 15:55:22.781+00	89	43
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users" (id, username, firstname, lastname, dni, email, password, cargo, "createdAt", "updatedAt", active, ldap, "RoleId", "DependencyId") FROM stdin;
1	admin	admin	admin	0000000	admin@essalud.gob.pe	$2a$10$u90xxNYbmDm/BP.wKU07i.q3qu0qsjipAl52bu9WmeHqXOBVHXseW	\N	2024-05-27 06:43:46.689+00	2024-05-27 06:43:46.689+00	t	f	2	\N
4	frank.guzman	\N	\N	\N	frank.guzman@essalud.gob.pe	\N	\N	2024-05-27 08:48:44.323+00	2024-05-27 08:48:44.323+00	t	t	1	\N
5	maria.aguilard	\N	\N	\N	maria.aguilard@essalud.gob.pe	\N	\N	2024-05-27 08:48:44.529+00	2024-05-27 08:48:44.529+00	t	t	1	\N
6	yuri.vilca	\N	\N	\N	yuri.vilca@essalud.gob.pe	\N	\N	2024-05-27 08:48:44.738+00	2024-05-27 08:48:44.739+00	t	t	1	\N
7	keile.desposorio	\N	\N	\N	keile.desposorio@essalud.gob.pe	\N	\N	2024-05-27 08:48:45.017+00	2024-05-27 08:48:45.017+00	t	t	1	\N
8	roland.iparraguirre	\N	\N	\N	roland.iparraguirre@essalud.gob.pe	\N	\N	2024-05-27 08:48:45.281+00	2024-05-27 08:48:45.282+00	t	t	1	\N
9	giuliana.delcastillo	\N	\N	\N	giuliana.delcastillo@essalud.gob.pe	\N	\N	2024-05-27 08:48:45.486+00	2024-05-27 08:48:45.486+00	t	t	1	\N
10	ruben.figueroa	\N	\N	\N	ruben.figueroa@essalud.gob.pe	\N	\N	2024-05-27 08:48:45.7+00	2024-05-27 08:48:45.7+00	t	t	1	\N
11	elias.steck	\N	\N	\N	elias.steck@essalud.gob.pe	\N	\N	2024-05-27 08:48:45.907+00	2024-05-27 08:48:45.907+00	t	t	1	\N
12	erika.bayona	\N	\N	\N	erika.bayona@essalud.gob.pe	\N	\N	2024-05-27 08:48:46.126+00	2024-05-27 08:48:46.126+00	t	t	1	\N
13	grace.gomez	\N	\N	\N	grace.gomez@essalud.gob.pe	\N	\N	2024-05-27 08:48:46.359+00	2024-05-27 08:48:46.359+00	t	t	1	\N
14	carlos.linares	\N	\N	\N	carlos.linares@essalud.gob.pe	\N	\N	2024-05-27 08:48:46.583+00	2024-05-27 08:48:46.583+00	t	t	1	\N
15	julio.salas	\N	\N	\N	julio.salas@essalud.gob.pe	\N	\N	2024-05-27 08:48:46.805+00	2024-05-27 08:48:46.806+00	t	t	1	\N
16	ana.montalvo	\N	\N	\N	ana.montalvo@essalud.gob.pe	\N	\N	2024-05-27 08:48:47.038+00	2024-05-27 08:48:47.038+00	t	t	1	\N
17	tania.paredes	\N	\N	\N	tania.paredes@essalud.gob.pe	\N	\N	2024-05-27 08:48:47.303+00	2024-05-27 08:48:47.303+00	t	t	1	\N
18	hector.arbulu	\N	\N	\N	hector.arbulu@essalud.gob.pe	\N	\N	2024-05-27 08:48:47.626+00	2024-05-27 08:48:47.626+00	t	t	1	\N
19	silvia.camarena	\N	\N	\N	silvia.camarena@essalud.gob.pe	\N	\N	2024-05-27 08:48:47.865+00	2024-05-27 08:48:47.865+00	t	t	1	\N
20	carlos.floresr	\N	\N	\N	carlos.floresr@essalud.gob.pe	\N	\N	2024-05-27 08:48:48.089+00	2024-05-27 08:48:48.089+00	t	t	1	\N
21	lilian.lopez	\N	\N	\N	lilian.lopez@essalud.gob.pe	\N	\N	2024-05-27 08:48:48.339+00	2024-05-27 08:48:48.339+00	t	t	1	\N
22	gctic.qa	\N	\N	\N	gctic.qa@essalud.gob.pe	\N	\N	2024-05-27 08:48:48.821+00	2024-05-27 08:48:48.822+00	t	t	1	\N
23	yuri.romero	\N	\N	\N	gctic.gsit05@essalud.gob.pe	\N	\N	2024-05-27 08:48:49.06+00	2024-05-27 08:48:49.06+00	t	t	1	\N
24	edwin.neciosup	\N	\N	\N	edwin.neciosup@essalud.gob.pe	\N	\N	2024-05-27 08:48:49.282+00	2024-05-27 08:48:49.282+00	t	t	1	\N
25	rdelgado	\N	\N	\N	rdelgado@essalud.gob.pe	\N	\N	2024-05-27 08:48:49.49+00	2024-05-27 08:48:49.49+00	t	t	1	\N
26	jose.mendozad	\N	\N	\N	jose.mendozad@essalud.gob.pe	\N	\N	2024-05-27 08:48:49.707+00	2024-05-27 08:48:49.707+00	t	t	1	\N
27	yovanna.seclen	\N	\N	\N	yovanna.seclen@essalud.gob.pe	\N	\N	2024-05-27 08:48:49.954+00	2024-05-27 08:48:49.954+00	t	t	1	\N
28	cayo.roca	\N	\N	\N	cayo.roca@essalud.gob.pe	\N	\N	2024-05-27 08:48:50.22+00	2024-05-27 08:48:50.221+00	t	t	1	\N
29	nataly.sifuentes	\N	\N	\N	nataly.sifuentes@essalud.gob.pe	\N	\N	2024-05-27 08:48:50.466+00	2024-05-27 08:48:50.467+00	t	t	1	\N
30	enrique.caballero	\N	\N	\N	enrique.caballero@essalud.gob.pe	\N	\N	2024-05-27 08:48:50.755+00	2024-05-27 08:48:50.755+00	t	t	1	\N
31	ana.huaman	\N	\N	\N	abustamante@essalud.gob.pe	\N	\N	2024-05-27 08:48:50.978+00	2024-05-27 08:48:50.979+00	t	t	1	\N
32	jorge.balarezo	\N	\N	\N	jorge.balarezo@essalud.gob.pe	\N	\N	2024-05-27 08:48:51.288+00	2024-05-27 08:48:51.288+00	t	t	1	\N
33	maria-paz.salinas	\N	\N	\N	maria-paz.salinas@essalud.gob.pe	\N	\N	2024-05-27 08:48:51.569+00	2024-05-27 08:48:51.569+00	t	t	1	\N
34	jessenia.martino	\N	\N	\N	jessenia.martino@essalud.gob.pe	\N	\N	2024-05-27 08:48:51.779+00	2024-05-27 08:48:51.779+00	t	t	1	\N
35	ivette.alarco	\N	\N	\N	Ivette.Alarco@essalud.gob.pe	\N	\N	2024-05-27 08:48:51.99+00	2024-05-27 08:48:51.991+00	t	t	1	\N
36	fiorella.villalobos	\N	\N	\N	fiorella.villalobos@essalud.gob.pe	\N	\N	2024-05-27 08:48:52.216+00	2024-05-27 08:48:52.216+00	t	t	1	\N
37	ulises.contreras	\N	\N	\N	ulises.contreras@essalud.gob.pe	\N	\N	2024-05-27 08:48:52.433+00	2024-05-27 08:48:52.434+00	t	t	1	\N
38	christian.gomeza	\N	\N	\N	christian.gomeza@essalud.gob.pe	\N	\N	2024-05-27 08:48:52.643+00	2024-05-27 08:48:52.643+00	t	t	1	\N
39	jose.espinozas	\N	\N	\N	jose.espinozas@essalud.gob.pe	\N	\N	2024-05-27 08:48:52.854+00	2024-05-27 08:48:52.855+00	t	t	1	\N
40	jose.salazar	\N	\N	\N	jose.salazar@essalud.gob.pe	\N	\N	2024-05-27 08:48:53.275+00	2024-05-27 08:48:53.275+00	t	t	1	\N
41	gctic.gsit10	\N	\N	\N	gctic.gsit10@essalud.gob.pe	\N	\N	2024-05-27 08:48:53.479+00	2024-05-27 08:48:53.479+00	t	t	1	\N
42	hernando.perez	\N	\N	\N	hernando.perez@essalud.gob.pe	\N	\N	2024-05-27 08:48:53.687+00	2024-05-27 08:48:53.688+00	t	t	1	\N
43	scarpio	\N	\N	\N	scarpio@essalud.gob.pe	\N	\N	2024-05-27 08:48:53.955+00	2024-05-27 08:48:53.955+00	t	t	1	\N
44	john.colonio	\N	\N	\N	john.colonio@essalud.gob.pe	\N	\N	2024-05-27 08:48:54.161+00	2024-05-27 08:48:54.161+00	t	t	1	\N
45	lisbeth.bonilla	\N	\N	\N	lisbeth.bonilla@essalud.gob.pe	\N	\N	2024-05-27 08:48:54.369+00	2024-05-27 08:48:54.369+00	t	t	1	\N
46	ceabe.sgayd2	\N	\N	\N	ceabe.sgayd2@essalud.gob.pe	\N	\N	2024-05-27 08:48:54.571+00	2024-05-27 08:48:54.571+00	t	t	1	\N
47	mochoa	\N	\N	\N	mochoa@essalud.gob.pe	\N	\N	2024-05-27 08:48:54.774+00	2024-05-27 08:48:54.774+00	t	t	1	\N
48	maria.maravi	\N	\N	\N	maria.maravi@essalud.gob.pe	\N	\N	2024-05-27 08:48:54.983+00	2024-05-27 08:48:54.983+00	t	t	1	\N
49	pedro.ripalda	\N	\N	\N	pedro.ripalda@essalud.gob.pe	\N	\N	2024-05-27 08:48:55.271+00	2024-05-27 08:48:55.271+00	t	t	1	\N
50	nicke.flores	\N	\N	\N	nicke.flores@essalud.gob.pe	\N	\N	2024-05-27 08:48:55.495+00	2024-05-27 08:48:55.495+00	t	t	1	\N
51	alicia.saavedra	\N	\N	\N	alicia.saavedra@essalud.gob.pe	\N	\N	2024-05-27 08:48:55.7+00	2024-05-27 08:48:55.7+00	t	t	1	\N
52	rosario.alfaro	\N	\N	\N	rosario.alfaro@essalud.gob.pe	\N	\N	2024-05-27 08:48:55.904+00	2024-05-27 08:48:55.904+00	t	t	1	\N
53	jlucano	\N	\N	\N	jlucano@essalud.gob.pe	\N	\N	2024-05-27 08:48:56.125+00	2024-05-27 08:48:56.125+00	t	t	1	\N
54	bibiana.chota	\N	\N	\N	bibiana.chota@essalud.gob.pe	\N	\N	2024-05-27 08:48:56.346+00	2024-05-27 08:48:56.346+00	t	t	1	\N
55	reinaldo.penas	\N	\N	\N	reinaldo.penas@essalud.gob.pe	\N	\N	2024-05-27 08:48:56.559+00	2024-05-27 08:48:56.559+00	t	t	1	\N
56	luis.garciaz	\N	\N	\N	luis.garciaz@essalud.gob.pe	\N	\N	2024-05-27 08:48:56.768+00	2024-05-27 08:48:56.768+00	t	t	1	\N
57	susan.alvarado	\N	\N	\N	susan.alvarado@essalud.gob.pe	\N	\N	2024-05-27 08:48:56.977+00	2024-05-27 08:48:56.977+00	t	t	1	\N
58	dennis.vera	\N	\N	\N	dennis.vera@essalud.gob.pe	\N	\N	2024-05-27 08:48:57.21+00	2024-05-27 08:48:57.21+00	t	t	1	\N
59	juan.rodriguezv	\N	\N	\N	juan.rodriguezv@essalud.gob.pe	\N	\N	2024-05-27 08:48:57.44+00	2024-05-27 08:48:57.44+00	t	t	1	\N
60	luis.hurtado	\N	\N	\N	luis.hurtado@essalud.gob.pe	\N	\N	2024-05-27 08:48:57.642+00	2024-05-27 08:48:57.642+00	t	t	1	\N
61	carlos.perez	\N	\N	\N	carlos.perez@essalud.gob.pe	\N	\N	2024-05-27 08:48:57.845+00	2024-05-27 08:48:57.846+00	t	t	1	\N
62	piero.delcarmen	\N	\N	\N	piero.delcarmen@essalud.gob.pe	\N	\N	2024-05-27 08:48:58.054+00	2024-05-27 08:48:58.054+00	t	t	1	\N
63	david.romero	\N	\N	\N	david.romero@essalud.gob.pe	\N	\N	2024-05-27 08:48:58.289+00	2024-05-27 08:48:58.289+00	t	t	1	\N
64	eva.rodriguezv	\N	\N	\N	eva.rodriguezv@essalud.gob.pe	\N	\N	2024-05-27 08:48:58.496+00	2024-05-27 08:48:58.496+00	t	t	1	\N
65	jeannette.motta	\N	\N	\N	jeannette.motta@essalud.gob.pe	\N	\N	2024-05-27 08:48:58.699+00	2024-05-27 08:48:58.7+00	t	t	1	\N
66	julio.suarez	\N	\N	\N	julio.suarez@essalud.gob.pe	\N	\N	2024-05-27 08:48:58.91+00	2024-05-27 08:48:58.91+00	t	t	1	\N
67	kathia.vega	\N	\N	\N	kathia.vega@essalud.gob.pe	\N	\N	2024-05-27 08:48:59.118+00	2024-05-27 08:48:59.119+00	t	t	1	\N
68	maria.delgadom	\N	\N	\N	maria.delgadom@essalud.gob.pe	\N	\N	2024-05-27 08:48:59.333+00	2024-05-27 08:48:59.333+00	t	t	1	\N
69	ruben.pena	\N	\N	\N	ruben.pena@essalud.gob.pe	\N	\N	2024-05-27 08:48:59.559+00	2024-05-27 08:48:59.559+00	t	t	1	\N
70	william.arana	\N	\N	\N	william.arana@essalud.gob.pe	\N	\N	2024-05-27 08:48:59.769+00	2024-05-27 08:48:59.769+00	t	t	1	\N
71	yohny.torres	\N	\N	\N	yohny.torres@essalud.gob.pe	\N	\N	2024-05-27 08:48:59.972+00	2024-05-27 08:48:59.972+00	t	t	1	\N
72	isaac.villafuerte	\N	\N	\N	isaac.villafuerte@essalud.gob.pe	\N	\N	2024-05-27 08:49:00.277+00	2024-05-27 08:49:00.278+00	t	t	1	\N
73	ana.figueroa	\N	\N	\N	ana.figueroa@essalud.gob.pe	\N	\N	2024-05-27 08:49:00.484+00	2024-05-27 08:49:00.484+00	t	t	1	\N
74	emerson.lino	\N	\N	\N	emerson.lino@essalud.gob.pe	\N	\N	2024-05-27 08:49:00.692+00	2024-05-27 08:49:00.692+00	t	t	1	\N
75	susan.quivio	\N	\N	\N	susan.quivio@essalud.gob.pe	\N	\N	2024-05-27 08:49:00.919+00	2024-05-27 08:49:00.919+00	t	t	1	\N
76	monica.seminario	\N	\N	\N	monica.seminario@essalud.gob.pe	\N	\N	2024-05-27 08:49:01.128+00	2024-05-27 08:49:01.128+00	t	t	1	\N
77	amer.martinez	\N	\N	\N	amer.martinez@essalud.gob.pe	\N	\N	2024-05-27 08:49:01.331+00	2024-05-27 08:49:01.331+00	t	t	1	\N
78	zoilo.silva	\N	\N	\N	zoilo.silva@essalud.gob.pe	\N	\N	2024-05-27 08:49:01.568+00	2024-05-27 08:49:01.568+00	t	t	1	\N
79	luis.taboada	\N	\N	\N	luis.taboada@essalud.gob.pe	\N	\N	2024-05-27 08:49:01.808+00	2024-05-27 08:49:01.808+00	t	t	1	\N
80	nathalie.minaya	\N	\N	\N	nathalie.minaya@essalud.gob.pe	\N	\N	2024-05-27 08:49:02.025+00	2024-05-27 08:49:02.025+00	t	t	1	\N
81	augusto.vasquez	\N	\N	\N	augusto.vasquez@essalud.gob.pe	\N	\N	2024-05-27 08:49:02.264+00	2024-05-27 08:49:02.264+00	t	t	1	\N
82	alberto.barrenechea	\N	\N	\N	alberto.barrenechea@essalud.gob.pe	\N	\N	2024-05-27 08:49:02.471+00	2024-05-27 08:49:02.471+00	t	t	1	\N
83	gctic.gsit16	\N	\N	\N	gctic.gsit16@essalud.gob.pe	\N	\N	2024-05-27 08:49:02.762+00	2024-05-27 08:49:02.762+00	t	t	1	\N
84	alexander.larosa	\N	\N	\N	alexander.larosa@essalud.gob.pe	\N	\N	2024-05-27 08:49:02.968+00	2024-05-27 08:49:02.968+00	t	t	1	\N
85	german.carbonel	\N	\N	\N	german.carbonel@essalud.gob.pe	\N	\N	2024-05-27 08:49:03.211+00	2024-05-27 08:49:03.211+00	t	t	1	\N
3	geovanni.chiarella	\N	\N	\N	geovanni.chiarella@essalud.gob.pe	\N	\N	2024-05-27 08:48:44.105+00	2024-05-27 08:48:44.105+00	t	t	2	\N
86	gctic.gsit05	\N	\N	\N	gctic.gsit05@essalud.gob.pe	\N	\N	2024-05-27 13:53:23.062+00	2024-05-27 13:53:23.062+00	t	t	1	\N
87	gctic.gsit01	\N	\N	\N	gctic.gsit01@essalud.gob.pe	\N	\N	2024-05-27 22:29:30.393+00	2024-05-27 22:29:30.394+00	t	t	1	\N
88	gctic.gsit08	\N	\N	\N	gctic.gsit08@essalud.gob.pe	\N	\N	2024-05-27 22:29:38.125+00	2024-05-27 22:29:38.125+00	t	t	2	\N
89	juan.palominoc	\N	\N	\N	juan.palominoc@essalud.gob.pe	\N	\N	2024-05-28 13:10:22.762+00	2024-05-28 13:10:22.763+00	t	t	1	\N
90	orestes.ramirez	\N	\N	\N	orestes.ramirez@essalud.gob.pe	\N	\N	2024-05-28 13:50:52.744+00	2024-05-28 13:50:52.744+00	t	t	1	\N
91	patricia.reategui	\N	\N	\N	patricia.reategui@essalud.gob.pe	\N	\N	2024-05-28 15:19:30.761+00	2024-05-28 15:19:30.761+00	t	t	1	\N
92	damrina.depaz	\N	\N	\N	damrina.depaz@essalud.gob.pe	\N	\N	2024-05-28 18:46:44.239+00	2024-05-28 18:46:44.239+00	t	t	1	\N
93	yuri.llacza	\N	\N	\N	yuri.llacza@essalud.gob.pe	\N	\N	2024-05-29 16:25:02.608+00	2024-05-29 16:25:02.609+00	t	t	1	\N
94	santiago.caldas	\N	\N	\N	santiago.caldas@essalud.gob.pe	\N	\N	2024-05-29 16:31:46.205+00	2024-05-29 16:31:46.205+00	t	t	1	\N
95	martin.tantalean	\N	\N	\N	martin.tantalean@essalud.gob.pe	\N	\N	2024-05-29 17:49:13.012+00	2024-05-29 17:49:13.013+00	t	t	1	\N
96	gcpp.sgc03	\N	\N	\N	gcpp.sgc03@essalud.gob.pe	\N	\N	2024-05-30 14:46:59.414+00	2024-05-30 14:46:59.414+00	t	t	1	\N
97	carlos.ruizl	\N	\N	\N	carlos.ruizl@essalud.gob.pe	\N	\N	2024-05-30 22:37:09.603+00	2024-05-30 22:37:09.603+00	t	t	1	\N
98	gctic.gsit13	\N	\N	\N	gctic.gsit13@essalud.gob.pe	\N	\N	2024-05-31 16:37:33.396+00	2024-05-31 16:37:33.396+00	t	t	1	\N
99	lider.cotrina	\N	\N	\N	lider.cotrina@essalud.gob.pe	\N	\N	2024-05-31 16:51:19.013+00	2024-05-31 16:51:19.013+00	t	t	1	\N
100	julio.linares	\N	\N	\N	julio.linares@essalud.gob.pe	\N	\N	2024-06-04 14:47:13.795+00	2024-06-04 14:47:13.795+00	t	t	1	\N
101	lusdina.laura	\N	\N	\N	lusdina.laura@essalud.gob.pe	\N	\N	2024-06-04 15:51:29.177+00	2024-06-04 15:51:29.178+00	t	t	1	\N
102	melissa.benito	\N	\N	\N	melissa.benito@essalud.gob.pe	\N	\N	2024-06-04 16:28:52.361+00	2024-06-04 16:28:52.361+00	t	t	1	\N
2	gctic.gsit06	\N	\N	\N	gctic.gsit06@essalud.gob.pe	\N	\N	2024-05-27 06:44:39.233+00	2024-05-27 06:44:39.234+00	t	t	1	\N
103	ada.estrada	\N	\N	\N	ada.estrada@essalud.gob.pe	\N	\N	2024-06-05 18:19:14.477+00	2024-06-05 18:19:14.477+00	t	t	1	\N
104	gustavo.stumpfle	\N	\N	\N	gustavo.stumpfle@essalud.gob.pe	\N	\N	2024-06-05 18:45:20.646+00	2024-06-05 18:45:20.646+00	t	t	1	\N
105	melvin.urbina	\N	\N	\N	melvin.urbina@essalud.gob.pe	\N	\N	2024-06-05 19:26:07.302+00	2024-06-05 19:26:07.303+00	t	t	1	\N
106	percy.ramos	\N	\N	\N	percy.ramos@essalud.gob.pe	\N	\N	2024-06-05 19:28:26.459+00	2024-06-05 19:28:26.459+00	t	t	1	\N
107	consuelo.moran	\N	\N	\N	consuelo.moran@essalud.gob.pe	\N	\N	2024-06-05 19:31:35.806+00	2024-06-05 19:31:35.807+00	t	t	1	\N
\.


--
-- Name: AccessAudits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."AccessAudits_id_seq"', 511, true);


--
-- Name: AccessRequests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."AccessRequests_id_seq"', 1, false);


--
-- Name: Dependencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Dependencies_id_seq"', 1, false);


--
-- Name: GroupTags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."GroupTags_id_seq"', 1, false);


--
-- Name: Groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Groups_id_seq"', 3, true);


--
-- Name: ImplementationRequests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ImplementationRequests_id_seq"', 1, false);


--
-- Name: LoginAudits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."LoginAudits_id_seq"', 575, true);


--
-- Name: MainDependencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."MainDependencies_id_seq"', 1, false);


--
-- Name: Modules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Modules_id_seq"', 18, true);


--
-- Name: Notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Notifications_id_seq"', 258, true);


--
-- Name: Reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Reports_id_seq"', 53, true);


--
-- Name: Roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Roles_id_seq"', 2, true);


--
-- Name: States_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."States_id_seq"', 4, true);


--
-- Name: Tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Tags_id_seq"', 1, false);


--
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_id_seq"', 107, true);


--
-- Name: AccessAudits AccessAudits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessAudits"
    ADD CONSTRAINT "AccessAudits_pkey" PRIMARY KEY (id);


--
-- Name: AccessRequestReport AccessRequestReport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessRequestReport"
    ADD CONSTRAINT "AccessRequestReport_pkey" PRIMARY KEY ("AccessRequestId", "ReportId");


--
-- Name: AccessRequests AccessRequests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessRequests"
    ADD CONSTRAINT "AccessRequests_pkey" PRIMARY KEY (id);


--
-- Name: Dependencies Dependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dependencies"
    ADD CONSTRAINT "Dependencies_pkey" PRIMARY KEY (id);


--
-- Name: GroupTags GroupTags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."GroupTags"
    ADD CONSTRAINT "GroupTags_pkey" PRIMARY KEY (id);


--
-- Name: Groups Groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Groups"
    ADD CONSTRAINT "Groups_pkey" PRIMARY KEY (id);


--
-- Name: ImplementationRequests ImplementationRequests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ImplementationRequests"
    ADD CONSTRAINT "ImplementationRequests_pkey" PRIMARY KEY (id);


--
-- Name: LoginAudits LoginAudits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LoginAudits"
    ADD CONSTRAINT "LoginAudits_pkey" PRIMARY KEY (id);


--
-- Name: MainDependencies MainDependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MainDependencies"
    ADD CONSTRAINT "MainDependencies_pkey" PRIMARY KEY (id);


--
-- Name: Modules Modules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Modules"
    ADD CONSTRAINT "Modules_pkey" PRIMARY KEY (id);


--
-- Name: Notifications Notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notifications"
    ADD CONSTRAINT "Notifications_pkey" PRIMARY KEY (id);


--
-- Name: Reports Reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reports"
    ADD CONSTRAINT "Reports_pkey" PRIMARY KEY (id);


--
-- Name: Roles Roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Roles"
    ADD CONSTRAINT "Roles_pkey" PRIMARY KEY (id);


--
-- Name: States States_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."States"
    ADD CONSTRAINT "States_pkey" PRIMARY KEY (id);


--
-- Name: TagReport TagReport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TagReport"
    ADD CONSTRAINT "TagReport_pkey" PRIMARY KEY ("TagId", "ReportId");


--
-- Name: Tags Tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tags"
    ADD CONSTRAINT "Tags_pkey" PRIMARY KEY (id);


--
-- Name: UserModule UserModule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserModule"
    ADD CONSTRAINT "UserModule_pkey" PRIMARY KEY ("UserId", "ModuleId");


--
-- Name: UserReport UserReport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserReport"
    ADD CONSTRAINT "UserReport_pkey" PRIMARY KEY ("UserId", "ReportId");


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: AccessAudits AccessAudits_ReportId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessAudits"
    ADD CONSTRAINT "AccessAudits_ReportId_fkey" FOREIGN KEY ("ReportId") REFERENCES public."Reports"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: AccessAudits AccessAudits_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessAudits"
    ADD CONSTRAINT "AccessAudits_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: AccessRequestReport AccessRequestReport_AccessRequestId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessRequestReport"
    ADD CONSTRAINT "AccessRequestReport_AccessRequestId_fkey" FOREIGN KEY ("AccessRequestId") REFERENCES public."AccessRequests"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: AccessRequestReport AccessRequestReport_ReportId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessRequestReport"
    ADD CONSTRAINT "AccessRequestReport_ReportId_fkey" FOREIGN KEY ("ReportId") REFERENCES public."Reports"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: AccessRequests AccessRequests_StateId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessRequests"
    ADD CONSTRAINT "AccessRequests_StateId_fkey" FOREIGN KEY ("StateId") REFERENCES public."States"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: AccessRequests AccessRequests_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AccessRequests"
    ADD CONSTRAINT "AccessRequests_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Dependencies Dependencies_MainDependencyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dependencies"
    ADD CONSTRAINT "Dependencies_MainDependencyId_fkey" FOREIGN KEY ("MainDependencyId") REFERENCES public."MainDependencies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ImplementationRequests ImplementationRequests_StateId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ImplementationRequests"
    ADD CONSTRAINT "ImplementationRequests_StateId_fkey" FOREIGN KEY ("StateId") REFERENCES public."States"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ImplementationRequests ImplementationRequests_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ImplementationRequests"
    ADD CONSTRAINT "ImplementationRequests_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: LoginAudits LoginAudits_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LoginAudits"
    ADD CONSTRAINT "LoginAudits_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Notifications Notifications_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notifications"
    ADD CONSTRAINT "Notifications_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Reports Reports_GroupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reports"
    ADD CONSTRAINT "Reports_GroupId_fkey" FOREIGN KEY ("GroupId") REFERENCES public."Groups"(id) ON UPDATE CASCADE;


--
-- Name: Reports Reports_ModuleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reports"
    ADD CONSTRAINT "Reports_ModuleId_fkey" FOREIGN KEY ("ModuleId") REFERENCES public."Modules"(id) ON UPDATE CASCADE;


--
-- Name: TagReport TagReport_ReportId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TagReport"
    ADD CONSTRAINT "TagReport_ReportId_fkey" FOREIGN KEY ("ReportId") REFERENCES public."Reports"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TagReport TagReport_TagId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TagReport"
    ADD CONSTRAINT "TagReport_TagId_fkey" FOREIGN KEY ("TagId") REFERENCES public."Tags"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Tags Tags_GroupTagId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tags"
    ADD CONSTRAINT "Tags_GroupTagId_fkey" FOREIGN KEY ("GroupTagId") REFERENCES public."GroupTags"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: UserModule UserModule_ModuleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserModule"
    ADD CONSTRAINT "UserModule_ModuleId_fkey" FOREIGN KEY ("ModuleId") REFERENCES public."Modules"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserModule UserModule_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserModule"
    ADD CONSTRAINT "UserModule_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserReport UserReport_ReportId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserReport"
    ADD CONSTRAINT "UserReport_ReportId_fkey" FOREIGN KEY ("ReportId") REFERENCES public."Reports"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserReport UserReport_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserReport"
    ADD CONSTRAINT "UserReport_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Users Users_DependencyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_DependencyId_fkey" FOREIGN KEY ("DependencyId") REFERENCES public."Dependencies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Users Users_RoleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_RoleId_fkey" FOREIGN KEY ("RoleId") REFERENCES public."Roles"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

