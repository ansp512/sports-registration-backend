--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--





--
-- Drop roles
--

DROP ROLE postgres;


--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:94Hso6CAtZpUIsxyA0rHOg==$ljSZkvS0aacZTvmrXnrEeU2HzL1TnZg+lX/rtcIZeVE=:UDYKputoLnJ/OKYjD7aCL4Y4WUfV1LoTv2lejln3D4w=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Debian 17.0-1.pgdg120+1)
-- Dumped by pg_dump version 17.0 (Debian 17.0-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Debian 17.0-1.pgdg120+1)
-- Dumped by pg_dump version 17.0 (Debian 17.0-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: events; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA events;


ALTER SCHEMA events OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: events; Type: TABLE; Schema: events; Owner: postgres
--

CREATE TABLE events.events (
    event_id integer NOT NULL,
    name character varying(100) NOT NULL,
    event_date date NOT NULL,
    category character varying(50),
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE events.events OWNER TO postgres;

--
-- Name: events_event_id_seq; Type: SEQUENCE; Schema: events; Owner: postgres
--

CREATE SEQUENCE events.events_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE events.events_event_id_seq OWNER TO postgres;

--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: postgres
--

ALTER SEQUENCE events.events_event_id_seq OWNED BY events.events.event_id;


--
-- Name: user_events; Type: TABLE; Schema: events; Owner: postgres
--

CREATE TABLE events.user_events (
    user_id integer NOT NULL,
    event_id integer NOT NULL,
    registration_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE events.user_events OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: events; Owner: postgres
--

CREATE TABLE events.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL
);


ALTER TABLE events.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: events; Owner: postgres
--

CREATE SEQUENCE events.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE events.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: postgres
--

ALTER SEQUENCE events.users_user_id_seq OWNED BY events.users.user_id;


--
-- Name: events event_id; Type: DEFAULT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.events ALTER COLUMN event_id SET DEFAULT nextval('events.events_event_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.users ALTER COLUMN user_id SET DEFAULT nextval('events.users_user_id_seq'::regclass);


--
-- Data for Name: events; Type: TABLE DATA; Schema: events; Owner: postgres
--

COPY events.events (event_id, name, event_date, category, start_time, end_time) FROM stdin;
11	City Marathon	2024-04-15	Sports	07:00:00	14:00:00
12	Summer Basketball Tournament	2024-07-20	Sports	09:00:00	18:00:00
13	Charity Soccer Match	2024-05-30	Sports	15:00:00	17:00:00
14	Triathlon Challenge	2024-08-05	Sports	06:00:00	12:00:00
15	Tennis Open Championship	2024-06-10	Sports	10:00:00	20:00:00
16	CrossFit Competition	2024-09-22	Sports	08:00:00	17:00:00
17	Swimming Gala	2024-03-18	Sports	13:00:00	18:00:00
18	Cycling Race	2024-10-07	Sports	07:30:00	15:00:00
19	Volleyball Beach Tournament	2024-07-01	Sports	09:00:00	19:00:00
20	Winter Ice Skating Show	2024-12-15	Sports	18:00:00	21:00:00
\.


--
-- Data for Name: user_events; Type: TABLE DATA; Schema: events; Owner: postgres
--

COPY events.user_events (user_id, event_id, registration_date) FROM stdin;
1	11	2024-10-13 12:53:04.834847
1	13	2024-10-13 12:53:04.834847
2	12	2024-10-13 12:53:04.834847
3	14	2024-10-13 12:53:04.834847
4	15	2024-10-13 12:53:04.834847
5	11	2024-10-13 12:53:04.834847
6	16	2024-10-13 12:53:04.834847
7	17	2024-10-13 12:53:04.834847
8	18	2024-10-13 12:53:04.834847
9	19	2024-10-13 12:53:04.834847
10	20	2024-10-13 12:53:04.834847
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: events; Owner: postgres
--

COPY events.users (user_id, username) FROM stdin;
1	johndoe
2	janesmith
3	mikebrown
4	emilywong
5	alexjohnson
6	sarahmiller
7	davidlee
8	lisagarcia
9	chriswhite
10	amandataylor
\.


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: events; Owner: postgres
--

SELECT pg_catalog.setval('events.events_event_id_seq', 20, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: events; Owner: postgres
--

SELECT pg_catalog.setval('events.users_user_id_seq', 10, true);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: user_events user_events_pkey; Type: CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.user_events
    ADD CONSTRAINT user_events_pkey PRIMARY KEY (user_id, event_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: user_events user_events_event_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.user_events
    ADD CONSTRAINT user_events_event_id_fkey FOREIGN KEY (event_id) REFERENCES events.events(event_id);


--
-- Name: user_events user_events_user_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: postgres
--

ALTER TABLE ONLY events.user_events
    ADD CONSTRAINT user_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES events.users(user_id);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

