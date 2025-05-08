--
-- PostgreSQL database dump
--

-- Dumped from database version 12.16
-- Dumped by pg_dump version 12.16

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accessorio; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.accessorio (
    nome character varying(20) NOT NULL
);


ALTER TABLE public.accessorio OWNER TO lucatribolati;

--
-- Name: dipendente; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.dipendente (
    matricola integer NOT NULL,
    nome character varying(20) NOT NULL,
    cognome character varying(20) NOT NULL,
    ruolo character varying(30) NOT NULL,
    status character varying(7) NOT NULL,
    dataassunzione date NOT NULL,
    stipendiocorrente numeric(6,2) DEFAULT NULL::numeric,
    datalicenziamento date,
    sede integer NOT NULL,
    CONSTRAINT dipendente_status_check CHECK (((status)::text = ANY ((ARRAY['Ex'::character varying, 'Attuale'::character varying])::text[])))
);


ALTER TABLE public.dipendente OWNER TO lucatribolati;

--
-- Name: disponibile; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.disponibile (
    idveicolo integer NOT NULL
);


ALTER TABLE public.disponibile OWNER TO lucatribolati;

--
-- Name: dotazione; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.dotazione (
    idveicolo integer NOT NULL,
    accessorio character varying(20) NOT NULL
);


ALTER TABLE public.dotazione OWNER TO lucatribolati;

--
-- Name: extra; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.extra (
    servizioaggiuntivo character varying(30) NOT NULL,
    idveicolo integer NOT NULL,
    datariconsegnanoleggio date NOT NULL,
    importo numeric(5,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.extra OWNER TO lucatribolati;

--
-- Name: manutenzione; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.manutenzione (
    idveicolo integer NOT NULL,
    tipologiaintervento character varying(60) NOT NULL,
    dataintervento date NOT NULL,
    chilometraggio integer NOT NULL,
    costointervento numeric(6,2) NOT NULL,
    codicespesa integer NOT NULL
);


ALTER TABLE public.manutenzione OWNER TO lucatribolati;

--
-- Name: motorizzazioneelettrica; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.motorizzazioneelettrica (
    idveicolo integer NOT NULL,
    autonomia integer NOT NULL,
    temporicarica integer NOT NULL
);


ALTER TABLE public.motorizzazioneelettrica OWNER TO lucatribolati;

--
-- Name: noleggiato; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.noleggiato (
    idveicolo integer NOT NULL,
    privato integer,
    partitaiva integer
);


ALTER TABLE public.noleggiato OWNER TO lucatribolati;

--
-- Name: noleggio; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.noleggio (
    idveicolo integer NOT NULL,
    datariconsegna date NOT NULL,
    datainizio date NOT NULL,
    formula character(5) NOT NULL,
    kminizio integer NOT NULL,
    kmfine integer NOT NULL,
    importototalepagato numeric(6,2) NOT NULL,
    codicespesa integer NOT NULL,
    sede integer NOT NULL,
    privato integer,
    partitaiva integer,
    CONSTRAINT noleggio_formula_check CHECK ((formula = ANY (ARRAY['Breve'::bpchar, 'Lungo'::bpchar])))
);


ALTER TABLE public.noleggio OWNER TO lucatribolati;

--
-- Name: partitaiva; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.partitaiva (
    codice integer NOT NULL,
    telefono character varying(15) NOT NULL,
    numerodinoleggi integer DEFAULT 0 NOT NULL,
    ragionesociale character varying(50) NOT NULL,
    numeropartita character(11) NOT NULL
);


ALTER TABLE public.partitaiva OWNER TO lucatribolati;

--
-- Name: privato; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.privato (
    codice integer NOT NULL,
    telefono character varying(15) NOT NULL,
    numerodinoleggi integer DEFAULT 0 NOT NULL,
    nome character varying(20) NOT NULL,
    cognome character varying(20) NOT NULL,
    numeropatente character(10) NOT NULL,
    datapatente date NOT NULL,
    eta smallint NOT NULL
);


ALTER TABLE public.privato OWNER TO lucatribolati;

--
-- Name: sede; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.sede (
    id integer NOT NULL,
    comune character varying(20) NOT NULL,
    via character varying(20) NOT NULL,
    numerocivico integer NOT NULL
);


ALTER TABLE public.sede OWNER TO lucatribolati;

--
-- Name: servizioaggiuntivo; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.servizioaggiuntivo (
    tipologia character varying(30) NOT NULL
);


ALTER TABLE public.servizioaggiuntivo OWNER TO lucatribolati;

--
-- Name: spesa; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.spesa (
    codice integer NOT NULL,
    importo numeric(7,2) NOT NULL,
    data date NOT NULL,
    dipendente integer,
    sede integer,
    idveicolo integer
);


ALTER TABLE public.spesa OWNER TO lucatribolati;

--
-- Name: tariffa; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.tariffa (
    idveicolo integer NOT NULL,
    tipologiacliente character varying(10) NOT NULL,
    formulanoleggio character(5) NOT NULL,
    quota numeric(4,2) NOT NULL,
    CONSTRAINT tariffa_formulanoleggio_check CHECK ((formulanoleggio = ANY (ARRAY['Breve'::bpchar, 'Lungo'::bpchar]))),
    CONSTRAINT tariffa_tipologiacliente_check CHECK (((tipologiacliente)::text = ANY (ARRAY[('Privato'::character varying)::text, ('PartitaIva'::character varying)::text])))
);


ALTER TABLE public.tariffa OWNER TO lucatribolati;

--
-- Name: telefono; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.telefono (
    numero character varying(15) NOT NULL,
    sede integer
);


ALTER TABLE public.telefono OWNER TO lucatribolati;

--
-- Name: veicolo; Type: TABLE; Schema: public; Owner: lucatribolati
--

CREATE TABLE public.veicolo (
    id integer NOT NULL,
    segmento character(1) NOT NULL,
    marca character varying(15) NOT NULL,
    modello character varying(15) NOT NULL,
    motorizzazione character varying(9) NOT NULL,
    targa character(7) DEFAULT NULL::bpchar,
    CONSTRAINT veicolo_motorizzazione_check CHECK (((motorizzazione)::text = ANY ((ARRAY['Benzina'::character varying, 'Diesel'::character varying, 'Elettrica'::character varying])::text[]))),
    CONSTRAINT veicolo_segmento_check CHECK ((segmento = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'M'::bpchar])))
);


ALTER TABLE public.veicolo OWNER TO lucatribolati;

--
-- Data for Name: accessorio; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.accessorio (nome) FROM stdin;
Autoradio
Clima
Vetri elettrici
Box tetto
Catenabile
Gancio traino
Ruotino
Airbag
Airbag laterali
ESP
ABS
Servosterzo
\.


--
-- Data for Name: dipendente; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.dipendente (matricola, nome, cognome, ruolo, status, dataassunzione, stipendiocorrente, datalicenziamento, sede) FROM stdin;
2702	Matteo	Marconi	Impiegato	Attuale	2012-03-05	1300.00	\N	3
1806	Lucio	Drappo	Impiegato	Attuale	2013-03-13	1350.00	\N	3
1907	Maurizio	Gorietti	Impiegato	Attuale	2013-03-17	1300.00	\N	2
1407	Elia	Marconi	Contabile	Attuale	2008-04-18	2100.00	\N	4
705	Elena 	Fortini	Segretaria	Attuale	2008-11-11	1200.00	\N	3
902	Samira	Kamal	Segretaria	Attuale	2006-08-07	1200.00	\N	2
1314	Luca	Tribolati	Direttore	Attuale	2020-12-04	4250.95	\N	1
2325	Giovanni	Fortunati	Supervisore	Ex	2020-11-12	4251.00	2020-11-14	1
3546	Yassmine	Lahlali	Mega Direttore Galattico	Attuale	2006-09-07	9999.99	\N	1
4657	Riccardo	Ricciola	Perito informatico	Attuale	2018-03-25	2450.40	\N	4
5768	Mario	Rossi	Impiegato	Attuale	2020-05-03	950.00	\N	3
6879	Beatrice	Broccolo	Segretaria	Attuale	2020-12-04	1100.00	\N	1
7980	Ivo	Totoro	Impiegato	Attuale	2005-12-28	1250.00	\N	4
1510	Marco	Numerini	Impiegato	Attuale	2010-04-06	1250.00	\N	4
1408	Leonardo 	Cecconi	Impiegato	Attuale	2009-05-19	1300.00	\N	4
1612	Giacomo	Cagliesi	Impiegato	Attuale	2006-02-12	1300.00	\N	4
1304	Sara	Tofi	Manager aziendale	Attuale	2008-12-16	3500.00	\N	1
503	Federico	Listini	Impiegato	Ex	2009-10-15	1300.00	2010-10-15	3
1610	Elio	Bianchi	Impiegato	Attuale	2007-03-31	1300.00	\N	2
608	Gianluca	Coraggi	Impiegato	Attuale	2006-07-09	1300.00	\N	2
511	Alessandro	Gorietti	Impiegato	Attuale	2006-03-07	1300.00	\N	1
1212	Omar	Haddad	Perito informatico	Attuale	2007-01-01	2500.00	\N	1
1205	Enrico	Gaio	Contabile	Attuale	2006-09-04	2000.00	\N	1
1704	Ahui	Ezecheil	Contabile	Attuale	2009-10-08	2000.00	2010-10-08	2
\.


--
-- Data for Name: disponibile; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.disponibile (idveicolo) FROM stdin;
1
5
12
36
44
64
86
99
111
123
134
154
219
222
234
245
257
335
343
345
356
375
431
432
456
467
474
534
543
546
555
562
563
652
653
654
674
742
746
754
755
756
763
765
835
854
856
865
888
895
903
930
936
944
964
974
976
985
986
999
\.


--
-- Data for Name: dotazione; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.dotazione (idveicolo, accessorio) FROM stdin;
654	Airbag
888	ABS
930	Ruotino
234	Vetri elettrici
356	Servosterzo
865	Autoradio
944	Box tetto
999	Catenabile
456	Clima
903	Gancio traino
755	Airbag
835	ABS
356	Ruotino
222	Vetri elettrici
546	Servosterzo
134	Autoradio
763	Box tetto
936	Catenabile
930	Clima
534	Gancio traino
742	Airbag
755	ABS
257	Ruotino
467	Servosterzo
546	Autoradio
999	Box tetto
930	Catenabile
467	Clima
375	Gancio traino
356	Airbag
111	ABS
86	Vetri elettrici
44	Servosterzo
375	Autoradio
343	Box tetto
563	Catenabile
674	Clima
754	Gancio traino
5	Airbag
64	ABS
99	Ruotino
123	Vetri elettrici
154	Servosterzo
219	Autoradio
234	Box tetto
343	Catenabile
375	Clima
742	Gancio traino
\.


--
-- Data for Name: extra; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.extra (servizioaggiuntivo, idveicolo, datariconsegnanoleggio, importo) FROM stdin;
Chilometri extra	219	2020-05-05	8.00
Seggiolino per auto	219	2020-05-05	99.00
Chilometri extra	345	2021-05-10	8.00
Porta bici	375	2019-04-02	100.00
Chilometri extra	562	2019-04-22	36.00
Servizio stradale	562	2019-04-22	50.00
Box da tetto	562	2019-04-22	30.00
Chilometri extra	653	2023-01-01	217.00
Chilometri extra	534	2022-03-05	32.00
Danni accidentali	653	2023-01-01	70.00
Furto e incendio	653	2023-01-01	40.00
\.


--
-- Data for Name: manutenzione; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.manutenzione (idveicolo, tipologiaintervento, dataintervento, chilometraggio, costointervento, codicespesa) FROM stdin;
888	Foratura gomma	2020-04-19	8125	134.00	87646
865	Sostituzione tergicristalli	2020-12-20	8900	30.00	75555
854	Scatola dello sterzo	2020-03-05	13500	340.00	75455
835	Scatola dello sterzo	2020-12-05	12466	322.00	44311
756	Sostituzione cambio	2021-05-08	5644	1500.00	43243
222	Manutenzione straordinaria	2021-05-17	3444	660.00	34223
1	Cambio olio e filtro	2020-12-18	345	150.00	30110
36	Frizione	2018-12-05	2345	650.00	11111
64	Tagliando ordinario	2020-04-19	3532	145.00	12345
86	Tagliando ordinario	2020-04-13	4632	145.00	14322
218	Sostituzione candele e tagliando	2021-04-22	3242	250.00	33452
154	Frizione	2021-09-10	4322	690.00	32221
134	Tagliando ordinario	2022-05-03	4325	230.00	23432
123	Scatola sterzo	2020-04-03	5322	431.00	22421
111	Scatola sterzo	2019-04-03	5233	320.00	22345
99	Tagliando ordinario	2021-05-03	643	120.00	22342
13	Scatola sterzo	2019-12-12	522	350.00	33345
889	Scatola dello sterzo	2019-03-04	6540	331.00	23445
12	Pasticche e cambio olio	2020-05-12	523	150.00	33344
5	Pasticche e cambio olio	2018-03-05	5432	120.00	33499
930	Scatola dello sterzo	2018-11-28	3200	345.00	44323
3	Pasticche e cambio olio	2021-05-11	456	125.00	30999
4	Tagliando ordinario	2019-04-22	5432	150.00	30098
5	Sostituzione candele	2020-04-04	6433	215.00	12234
5	Manutenzione straordinaria	2020-04-04	12500	250.00	34242
\.


--
-- Data for Name: motorizzazioneelettrica; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.motorizzazioneelettrica (idveicolo, autonomia, temporicarica) FROM stdin;
763	395	3
546	395	3
765	395	3
856	395	3
865	395	3
888	395	3
123	314	5
674	314	5
\.


--
-- Data for Name: noleggiato; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.noleggiato (idveicolo, privato, partitaiva) FROM stdin;
1	411	\N
5	415	\N
12	423	\N
36	432	\N
44	435	\N
64	436	\N
86	438	\N
99	31	\N
111	32	\N
754	93	\N
755	95	\N
756	100	\N
763	101	\N
765	104	\N
835	108	\N
854	111	\N
856	167	\N
865	321	\N
888	333	\N
895	351	\N
903	352	\N
930	356	\N
936	371	\N
944	388	\N
964	392	\N
974	400	\N
976	401	\N
985	405	\N
986	407	\N
999	410	\N
653	\N	24
474	\N	21
431	\N	18
654	\N	15
\.


--
-- Data for Name: noleggio; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.noleggio (idveicolo, datariconsegna, datainizio, formula, kminizio, kmfine, importototalepagato, codicespesa, sede, privato, partitaiva) FROM stdin;
219	2020-05-05	2020-05-01	Breve	2300	3000	313.00	100	1	12	\N
234	2021-05-25	2021-01-10	Lungo	5000	9000	5040.00	101	3	\N	11
335	2022-05-12	2022-05-09	Breve	2300	2600	116.00	102	5	31	\N
345	2021-05-10	2021-05-03	Breve	10200	11700	273.00	104	2	\N	13
375	2019-04-02	2018-10-05	Lungo	12000	20000	6580.00	106	1	\N	32
431	2023-06-10	2023-06-07	Breve	450	850	123.00	107	4	89	\N
456	2021-10-10	2021-10-05	Breve	2300	2750	205.00	108	3	131	\N
534	2022-03-05	2022-03-01	Breve	8000	8800	196.00	109	2	352	\N
543	2021-09-12	2021-09-11	Breve	3200	3300	44.00	110	3	\N	14
546	2022-04-11	2022-04-01	Breve	14500	15850	380.00	111	2	402	\N
562	2019-04-22	2019-04-10	Breve	13500	15500	608.00	112	1	421	\N
652	2023-06-07	2023-06-01	Breve	11500	12500	246.00	113	1	400	\N
653	2023-01-01	2022-04-01	Lungo	20500	31000	8967.00	114	4	\N	12
345	2021-10-01	2021-05-01	Lungo	5500	10500	6600.00	103	4	35	\N
345	2022-10-03	2022-10-01	Breve	350	600	94.00	105	1	60	\N
\.


--
-- Data for Name: partitaiva; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.partitaiva (codice, telefono, numerodinoleggi, ragionesociale, numeropartita) FROM stdin;
11	0756674566	8	Panetteria SAS di Luca Pini	38476557890
12	0755374566	2	Macelleria halal SNC di Fantauzzi Paolo	22399847566
13	0756632566	3	Falegnameria Flamini SRL di Flamini Tonino	00918776381
14	0756654366	5	Pizzeria Bella Napoli SNC di Genny Savastano	01009283755
15	0756674562	4	Bar planet SRL di Luca Biggioggero	00916354665
18	0756674543	2	Autocarrozzeria artigiana SRL di Giovanni Marini	00986354998
21	0756674500	3	Studio legale SNC di Plini Luca	00918273655
24	0754534566	1	Nuova auto SRL di Mario Rossi	00937645540
32	0742534264	1	Polli e galline SNC di Luca Galli	00918263537
58	0757662739	1	La gintoneria SRL di Davide Lacerenza	9487756400 
\.


--
-- Data for Name: privato; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.privato (codice, telefono, numerodinoleggi, nome, cognome, numeropatente, datapatente, eta) FROM stdin;
12	3928833748	2	Gianluca	Armani	3458765469	1995-08-23	48
31	3489976456	1	Plinio	Minni	3647394756	1997-04-12	50
35	3516666543	1	Asdrubale	Menicacci	5544332290	2016-03-18	30
39	3333345980	1	Primo	Secondi	5432456789	2009-07-25	35
50	3345645909	1	Dario	Lampa	4443985476	1990-12-07	60
55	3211231212	3	Mario	Mari	4443569857	1991-05-05	49
60	3577768593	1	Marco	Assad	9483726485	1975-08-26	86
78	3355567456	2	Ibrahim	Zoli	6473897564	1999-04-22	36
80	3929950555\n	5	Giovanni	Storti	6574839576	1998-12-13	61
81	3332145675	2	Giacomino	Poretti	3334566784	1975-04-03	65
89	3211212822	2	Leonardo	Di Cipria	4759374639	1990-06-21	50
91	3563852757	1	Luca	Trafilati	4785673672	1929-07-15	108
93	3284551555	3	Riccardo	Brambilla	4678956738	1982-02-17	64
82	3456543678	1	Aldo	Baglio	8564738236	1995-07-30	60
95	3224131321	1	Brambilla	Fumagalli	4758539755	1987-02-25	54
100	3662525294	2	Plinio	Il Vecchio	3895783725	1982-08-13	58
104	3214452671	1	Tony	Hawk	4678472654	2000-05-15	45
108	3785783465	3	Giancarlo	Bonomelli	4764873645	2010-08-13	35
111	3356784564	1	Paolo	Bonaparte	3765847568	2005-05-24	40
124	3334567543	3	Mario	Porcelli	3456549000	2004-12-04	41
131	3334756776	2	Arnaldo	Baldoni	7462574892	2006-12-31	45
167	3564657564	3	Canzio	Marconi	7463748593	2004-03-05	50
321	3334567889	6	Luigi	Rossi	8475647829	2020-03-04	26
333	3321239082	2	Pino	Daniele	8374657483	2012-06-01	31
351	3456789653	1	Gianpaolo	Archi Mori	7463526749	2008-09-09	31
352	3466114356	2	Milena	Casciarri	7465748903	2019-06-04	45
371	3445609009	2	Francesca	Fortini	8756473859	2016-12-29	42
356	3334455667	1	Michela	Homel	7465849202	2008-04-17	36
388	3215679356	2	Luana	Lauri	7465739840	2020-08-06	26
391	3662524675	1	Maura	Nulli	7463546008	2009-11-09	30
392	3345600009	3	Jack	Sully	7564739283	2019-12-13	29
400	3675564783	1	Jack	Sparrow	7465748394	2010-09-09	30
401	3214459990	1	Amalio	Braulio	7758499985	1992-02-28	45
402	3566675432	1	Lucia	Trimoloni	8874637281	2001-12-12	50
85	3785983673	1	Giovanni	Importunati	4759364857	1987-09-24	55
32	3654485906	2	Ugo	Fantocci	5433555543	2006-12-22	38
49	3669765843	1	Dina	Lampa	8594837584	1990-12-12	60
405	3665252452	1	Marco	Cogoi	7564900086	1998-12-30	31
407	3313345689	2	Yassin	Mohamed	7564337409	1998-12-09	44
101	3334141729	1	Plinio	Il Giovane	5893672642	1991-02-12	55
410	3456667869	1	Felice	Natale	9985564386	1991-05-12	50
411	3692525299	3	Mussin	Corleone	3334596775	2001-11-21	45
415	3314545345	1	Elisa	Massimi	4443567009	2010-11-09	35
421	3466116755	1	Eva	Kant	4436578944	2005-03-19	48
423	3194456789	1	Paolo	Elisi	3332498575	2019-09-12	23
431	3929980846	1	Eraldo	Luciani	3339485764	2010-09-13	34
432	3617765420	1	Marta	Antipatici	8874659930	2011-12-12	35
435	3456845738	2	Mariarosaria	Natali	4658473746	2020-04-15	22
436	3677756489	1	Rosamaria	Pasqua	8576664702	2021-12-12	24
438	3655549087	1	Luca	Luce	8889746376	2020-04-11	24
\.


--
-- Data for Name: sede; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.sede (id, comune, via, numerocivico) FROM stdin;
1	Perugia	Calzoni	13
3	Bastia	Sacco e Vanzetti	11
5	Foligno	Cupa	7
4	Gubbio	della Piaggiola	186
2	Spoleto	Sandro Pertini	10
\.


--
-- Data for Name: servizioaggiuntivo; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.servizioaggiuntivo (tipologia) FROM stdin;
Kasko
Servizio stradale
Aumento massimale
Seggiolino per auto
Danni accidentali
Furto e incendio
Chilometri extra
Box da tetto
Porta bici
Porta sci
\.


--
-- Data for Name: spesa; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.spesa (codice, importo, data, dipendente, sede, idveicolo) FROM stdin;
1000	25000.00	2020-12-11	\N	\N	944
1001	8500.00	2019-04-02	\N	\N	964
1002	15000.00	2021-06-03	\N	\N	974
1003	17500.00	2022-04-19	\N	\N	976
1004	13500.00	2022-09-09	\N	\N	985
1005	15500.00	2021-09-03	\N	\N	986
1006	13500.00	2019-05-02	\N	\N	999
1007	8500.00	2019-03-18	\N	\N	257
1008	10250.00	2018-12-05	\N	\N	432
1009	21500.00	2019-04-19	\N	\N	467
1010	1500.00	2020-04-01	902	\N	\N
1011	1650.00	2020-05-01	1304	\N	\N
1012	1200.00	2020-05-01	1612	\N	\N
1013	1250.00	2020-05-01	1704	\N	\N
1014	2250.00	2020-05-01	4657	\N	\N
1015	3250.00	2021-05-03	6879	\N	\N
1016	1450.00	2021-05-02	7980	\N	\N
1017	1350.00	2021-05-06	1314	\N	\N
1101	254.00	2020-05-04	\N	2	\N
1102	2345.00	2021-05-03	\N	1	\N
1103	2110.00	2020-04-19	\N	3	\N
1104	3100.00	2021-04-14	\N	4	\N
1105	430.00	2022-04-19	\N	4	\N
1106	530.00	2023-04-19	\N	2	\N
1107	3400.00	2020-04-05	\N	5	\N
1108	250.00	2021-03-10	\N	5	\N
1109	340.00	2019-12-15	\N	2	\N
1116	1200.00	2019-04-22	\N	2	\N
1018	1350.00	2022-05-05	1212	\N	\N
1019	1350.00	2022-04-05	1212	\N	\N
1020	1350.00	2022-03-05	1212	\N	\N
1021	1650.00	2020-06-01	1304	\N	\N
1022	1650.00	2020-07-01	1304	\N	\N
12345	145.00	2020-04-19	\N	\N	\N
23432	230.00	2022-05-03	\N	\N	\N
14322	145.00	2020-04-13	\N	\N	\N
22342	120.00	2021-05-03	\N	\N	\N
32221	690.00	2021-09-10	\N	\N	\N
22421	431.00	2020-04-03	\N	\N	\N
44311	322.00	2020-12-05	\N	\N	\N
33452	250.00	2021-04-22	\N	\N	\N
87646	134.00	2020-04-19	\N	\N	\N
12234	215.00	2020-04-04	\N	\N	\N
22345	320.00	2019-04-03	\N	\N	\N
11111	650.00	2018-12-05	\N	\N	\N
1027	2250.00	2020-06-01	4657	\N	\N
1028	2250.00	2020-07-01	4657	\N	\N
34223	660.00	2021-05-17	\N	\N	\N
34242	250.00	2020-04-04	\N	\N	\N
43243	1500.00	2021-05-08	\N	\N	\N
75455	340.00	2020-03-05	\N	\N	\N
75555	30.00	2020-12-20	\N	\N	\N
1029	2250.00	2020-08-01	4657	\N	\N
1030	2250.00	2020-09-01	4657	\N	\N
1023	1500.00	2022-05-01	902	\N	\N
30098	150.00	2019-04-22	\N	\N	\N
30999	125.00	2021-05-11	\N	\N	\N
30110	150.00	2020-12-18	\N	\N	\N
1024	1500.00	2022-06-01	902	\N	\N
1025	1500.00	2022-07-01	902	\N	\N
1026	1500.00	2022-08-01	902	\N	\N
33345	350.00	2019-12-12	\N	\N	\N
23445	331.00	2019-03-04	\N	\N	\N
33344	150.00	2020-05-12	\N	\N	\N
33499	120.00	2018-03-05	\N	\N	\N
44323	345.00	2018-11-28	\N	\N	\N
100	313.00	2020-05-05	\N	\N	\N
101	5040.00	2021-05-25	\N	\N	\N
102	116.00	2022-05-12	\N	\N	\N
103	6600.00	2021-10-01	\N	\N	\N
104	273.00	2021-05-10	\N	\N	\N
105	94.00	2022-10-03	\N	\N	\N
106	6580.00	2019-04-02	\N	\N	\N
107	123.00	2023-06-10	\N	\N	\N
108	205.00	2021-10-10	\N	\N	\N
109	196.00	2022-03-05	\N	\N	\N
110	44.00	2021-09-12	\N	\N	\N
111	380.00	2022-04-11	\N	\N	\N
112	608.00	2019-04-22	\N	\N	\N
113	246.00	2023-06-07	\N	\N	\N
114	8967.00	2023-01-01	\N	\N	\N
\.


--
-- Data for Name: tariffa; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.tariffa (idveicolo, tipologiacliente, formulanoleggio, quota) FROM stdin;
1	PartitaIva	Lungo	30.00
1	PartitaIva	Breve	32.00
1	Privato	Lungo	32.00
1	Privato	Breve	35.00
936	Privato	Breve	35.00
936	Privato	Lungo	32.00
936	PartitaIva	Breve	32.00
936	PartitaIva	Lungo	30.00
944	Privato	Breve	35.00
944	Privato	Lungo	32.00
944	PartitaIva	Breve	32.00
944	PartitaIva	Lungo	30.00
123	Privato	Breve	38.00
123	Privato	Lungo	35.00
123	PartitaIva	Breve	35.00
123	PartitaIva	Lungo	33.00
674	Privato	Breve	38.00
674	Privato	Lungo	35.00
674	PartitaIva	Breve	35.00
674	PartitaIva	Lungo	33.00
335	Privato	Breve	35.00
335	Privato	Lungo	32.00
335	PartitaIva	Breve	32.00
335	PartitaIva	Lungo	30.00
154	Privato	Breve	35.00
154	Privato	Lungo	32.00
154	PartitaIva	Breve	32.00
154	PartitaIva	Lungo	30.00
44	Privato	Breve	35.00
36	Privato	Breve	35.00
36	Privato	Lungo	32.00
36	PartitaIva	Breve	32.00
36	PartitaIva	Lungo	30.00
856	Privato	Breve	38.00
856	Privato	Lungo	35.00
856	PartitaIva	Breve	35.00
856	PartitaIva	Lungo	33.00
865	Privato	Breve	38.00
865	Privato	Lungo	35.00
865	PartitaIva	Breve	35.00
865	PartitaIva	Lungo	33.00
546	Privato	Breve	38.00
546	Privato	Lungo	35.00
546	PartitaIva	Breve	35.00
546	PartitaIva	Lungo	33.00
763	Privato	Breve	38.00
763	Privato	Lungo	35.00
763	PartitaIva	Breve	35.00
763	PartitaIva	Lungo	33.00
888	Privato	Breve	38.00
888	Privato	Lungo	35.00
888	PartitaIva	Breve	35.00
888	PartitaIva	Lungo	33.00
765	Privato	Breve	38.00
765	Privato	Lungo	35.00
765	PartitaIva	Breve	35.00
765	PartitaIva	Lungo	33.00
742	Privato	Breve	41.00
742	Privato	Lungo	38.00
742	PartitaIva	Breve	38.00
742	PartitaIva	Lungo	36.00
652	Privato	Breve	41.00
652	Privato	Lungo	38.00
652	PartitaIva	Breve	38.00
652	PartitaIva	Lungo	36.00
976	Privato	Breve	41.00
976	Privato	Lungo	38.00
976	PartitaIva	Breve	38.00
976	PartitaIva	Lungo	36.00
653	Privato	Breve	41.00
653	Privato	Lungo	38.00
653	PartitaIva	Breve	38.00
653	PartitaIva	Lungo	36.00
219	Privato	Breve	41.00
219	Privato	Lungo	38.00
219	PartitaIva	Breve	38.00
219	PartitaIva	Lungo	36.00
895	Privato	Breve	41.00
895	Privato	Lungo	38.00
895	PartitaIva	Breve	38.00
895	PartitaIva	Lungo	36.00
111	Privato	Breve	41.00
111	Privato	Lungo	38.00
111	PartitaIva	Breve	38.00
111	PartitaIva	Lungo	36.00
562	Privato	Breve	41.00
562	Privato	Lungo	38.00
562	PartitaIva	Breve	38.00
562	PartitaIva	Lungo	36.00
222	Privato	Breve	41.00
222	Privato	Lungo	38.00
222	PartitaIva	Breve	38.00
222	PartitaIva	Lungo	36.00
754	Privato	Breve	41.00
754	Privato	Lungo	38.00
754	PartitaIva	Breve	38.00
754	PartitaIva	Lungo	36.00
654	Privato	Breve	41.00
654	Privato	Lungo	38.00
654	PartitaIva	Breve	38.00
654	PartitaIva	Lungo	36.00
755	Privato	Breve	41.00
755	Privato	Lungo	38.00
755	PartitaIva	Breve	38.00
755	PartitaIva	Lungo	36.00
986	Privato	Breve	41.00
986	Privato	Lungo	38.00
986	PartitaIva	Breve	38.00
986	PartitaIva	Lungo	36.00
746	Privato	Breve	41.00
746	Privato	Lungo	38.00
746	PartitaIva	Breve	38.00
746	PartitaIva	Lungo	36.00
456	Privato	Breve	41.00
456	Privato	Lungo	38.00
456	PartitaIva	Breve	38.00
456	PartitaIva	Lungo	36.00
534	Privato	Breve	41.00
534	Privato	Lungo	38.00
534	PartitaIva	Breve	38.00
534	PartitaIva	Lungo	36.00
345	Privato	Breve	41.00
345	Privato	Lungo	38.00
345	PartitaIva	Breve	38.00
345	PartitaIva	Lungo	36.00
375	Privato	Breve	41.00
375	Privato	Lungo	38.00
375	PartitaIva	Breve	38.00
375	PartitaIva	Lungo	36.00
134	Privato	Breve	41.00
134	Privato	Lungo	38.00
134	PartitaIva	Breve	38.00
134	PartitaIva	Lungo	36.00
431	Privato	Breve	41.00
431	Privato	Lungo	38.00
431	PartitaIva	Breve	38.00
431	PartitaIva	Lungo	36.00
234	Privato	Breve	47.00
234	Privato	Lungo	44.00
234	PartitaIva	Breve	44.00
234	PartitaIva	Lungo	42.00
356	Privato	Breve	47.00
356	Privato	Lungo	44.00
356	PartitaIva	Breve	44.00
356	PartitaIva	Lungo	42.00
343	Privato	Breve	47.00
343	Privato	Lungo	44.00
343	PartitaIva	Breve	44.00
343	PartitaIva	Lungo	42.00
86	Privato	Breve	47.00
86	Privato	Lungo	44.00
86	PartitaIva	Breve	44.00
86	PartitaIva	Lungo	42.00
543	Privato	Breve	47.00
543	Privato	Lungo	44.00
543	PartitaIva	Breve	44.00
543	PartitaIva	Lungo	42.00
\.


--
-- Data for Name: telefono; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.telefono (numero, sede) FROM stdin;
0742980465	5
0742654739	5
0756534435	4
0759080980	4
0757757467	4
0755565345	3
0759980645	3
0754409089	3
0742735461	5
\.


--
-- Data for Name: veicolo; Type: TABLE DATA; Schema: public; Owner: lucatribolati
--

COPY public.veicolo (id, segmento, marca, modello, motorizzazione, targa) FROM stdin;
1	A	Fiat	500	Benzina	FA235GH
3	M	Mercedes	Vito	Diesel	GH331FA
4	B	Hyundai	i20	Benzina	FB59HY 
5	A	Hyundai	i10	Benzina	GA333FA
12	A	Fiat	Panda	Diesel	GA323FA
13	M	Renault	Trafic	Diesel	DF390GA
36	A	Lancia	Ypsilon	Diesel	GA444GA
44	A	Fiat	Panda	Benzina	CO000LO
64	A	Lancia	Ypsilon	Diesel	CE900RP
86	M	Renault	Trafic	Diesel	GP378FA
99	A	Fiat	Panda	Benzina	DR333FT
111	B	Ford	Fiesta	Benzina	DE220PR
123	A	Fiat	500	Elettrica	GP444TR
134	B	Volkswagen	Polo	Diesel	TR001FB
154	A	Fiat	Panda	Benzina	GS333TR
218	A	Reanult	Twingo	Benzina	GH456FG
219	B	Ford	Fiesta	Benzina	FC310BA
222	B	Ford	Puma	Benzina	BA366PG
234	M	Mercedes	Vito	Diesel	BG450PF
245	A	Fiat	Panda	Benzina	DF500FA
257	A	Hyundai	i10	Benzina	CG320RF
335	A	Fiat	Panda	Benzina	EC308CN
343	M	Mercedes	Vito	Diesel	EX645JK
344	A	Smart	Fortwo	Diesel	DC212XM
345	B	Renault	Clio	Diesel	FT766WY
356	M	Mercedes	Vito	Diesel	DR236VJ
375	B	Volkswagen	Polo	Diesel	CY892ZN
431	B	Volkswagen	Polo	Diesel	BS333ER
432	A	Fiat	Panda	Diesel	FE129DG
456	B	Renault	Clio	Benzina	FC854KK
467	A	Fiat	Panda	Diesel	ZA338PA
468	A	Ford	Ka	Benzina	EE324LD
474	A	Lancia	Ypsilon	Diesel	FR276XP
533	B	Renault	Megane	Diesel	EL297JK
534	B	Renault	Clio	Diesel	CD237XS
543	M	Renault	Trafic	Diesel	FA222GL
546	A	Renault	Zoe	Elettrica	FD456LD
555	A	Lancia	Ypsilon	Benzina	DR567DO
562	B	Ford	Puma	Benzina	DO234DA
563	A	Lancia	Ypsilon	Benzina	DE300RE
652	B	Fiat	Punto	Diesel	DA333RE
653	B	Ford	Fiesta	Benzina	DI333RE
654	B	Opel	Corsa	Benzina	DO478RE
674	A	Fiat	500	Elettrica	FR526MS
742	B	Fiat	Punto	Diesel	FP210GS
746	B	Renault	Clio	Benzina	GA310PF
754	B	Ford	Puma	Benzina	GS320ME
755	B	Opel	Corsa	Diesel	MP211SQ
756	A	Lancia	Ypsilon	Benzina	KL937MF
763	A	Renault	Zoe	Elettrica	JF726NS
765	A	Renault	Zoe	Elettrica	JE284KD
835	A	Fiat	Panda	Benzina	JD475MD
854	A	Lancia	Ypsilon	Benzina	PS294EM
856	A	Renault	Zoe	Elettrica	LE395RP
865	A	Renault	Zoe	Elettrica	DK349DD
888	A	Renault	Zoe	Elettrica	DL585NL
889	B	Volkswagen	Polo	Diesel	LE234MM
895	B	Ford	Fiesta	Benzina	WK110KK
903	A	Hyundai	i10	Benzina	LE390OE
930	A	Hyundai	i10	Benzina	WO200EE
936	A	Fiat	500	Benzina	FB465UP
944	A	Fiat	500	Diesel	FB458OE
964	A	Lancia	Ypsilon	Diesel	FA390PS
974	A	Fiat	Panda	Diesel	ER300QP
976	B	Ford	Fiesta	Benzina	ET405PR
985	A	Lancia	Ypsilon	Benzina	EY304OP
986	B	Opel	Corsa	Diesel	OR495PP
999	A	Lancia	Ypsilon	Benzina	OR940PP
\.


--
-- Name: accessorio accessorio_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.accessorio
    ADD CONSTRAINT accessorio_pkey PRIMARY KEY (nome);


--
-- Name: dipendente dipendente_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.dipendente
    ADD CONSTRAINT dipendente_pkey PRIMARY KEY (matricola);


--
-- Name: disponibile disponibile_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.disponibile
    ADD CONSTRAINT disponibile_pkey PRIMARY KEY (idveicolo);


--
-- Name: dotazione dotazione_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.dotazione
    ADD CONSTRAINT dotazione_pkey PRIMARY KEY (idveicolo, accessorio);


--
-- Name: extra extra_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.extra
    ADD CONSTRAINT extra_pkey PRIMARY KEY (servizioaggiuntivo, idveicolo, datariconsegnanoleggio);


--
-- Name: manutenzione manutenzione_codicespesa_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.manutenzione
    ADD CONSTRAINT manutenzione_codicespesa_key UNIQUE (codicespesa);


--
-- Name: manutenzione manutenzione_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.manutenzione
    ADD CONSTRAINT manutenzione_pkey PRIMARY KEY (idveicolo, tipologiaintervento, dataintervento);


--
-- Name: motorizzazioneelettrica motorizzazioneelettrica_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.motorizzazioneelettrica
    ADD CONSTRAINT motorizzazioneelettrica_pkey PRIMARY KEY (idveicolo);


--
-- Name: noleggiato noleggiato_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggiato
    ADD CONSTRAINT noleggiato_pkey PRIMARY KEY (idveicolo);


--
-- Name: noleggio noleggio_codicespesa_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggio
    ADD CONSTRAINT noleggio_codicespesa_key UNIQUE (codicespesa);


--
-- Name: noleggio noleggio_idveicolo_kminizio_kmfine_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggio
    ADD CONSTRAINT noleggio_idveicolo_kminizio_kmfine_key UNIQUE (idveicolo, kminizio, kmfine);


--
-- Name: noleggio noleggio_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggio
    ADD CONSTRAINT noleggio_pkey PRIMARY KEY (idveicolo, datariconsegna);


--
-- Name: partitaiva partitaiva_numeropartita_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.partitaiva
    ADD CONSTRAINT partitaiva_numeropartita_key UNIQUE (numeropartita);


--
-- Name: partitaiva partitaiva_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.partitaiva
    ADD CONSTRAINT partitaiva_pkey PRIMARY KEY (codice);


--
-- Name: partitaiva partitaiva_ragionesociale_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.partitaiva
    ADD CONSTRAINT partitaiva_ragionesociale_key UNIQUE (ragionesociale);


--
-- Name: partitaiva partitaiva_telefono_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.partitaiva
    ADD CONSTRAINT partitaiva_telefono_key UNIQUE (telefono);


--
-- Name: privato privato_numeropatente_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.privato
    ADD CONSTRAINT privato_numeropatente_key UNIQUE (numeropatente);


--
-- Name: privato privato_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.privato
    ADD CONSTRAINT privato_pkey PRIMARY KEY (codice);


--
-- Name: privato privato_telefono_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.privato
    ADD CONSTRAINT privato_telefono_key UNIQUE (telefono);


--
-- Name: sede sede_comune_via_numerocivico_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.sede
    ADD CONSTRAINT sede_comune_via_numerocivico_key UNIQUE (comune, via, numerocivico);


--
-- Name: sede sede_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.sede
    ADD CONSTRAINT sede_pkey PRIMARY KEY (id);


--
-- Name: servizioaggiuntivo servizioaggiuntivo_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.servizioaggiuntivo
    ADD CONSTRAINT servizioaggiuntivo_pkey PRIMARY KEY (tipologia);


--
-- Name: spesa spesa_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.spesa
    ADD CONSTRAINT spesa_pkey PRIMARY KEY (codice);


--
-- Name: tariffa tariffa_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.tariffa
    ADD CONSTRAINT tariffa_pkey PRIMARY KEY (idveicolo, tipologiacliente, formulanoleggio);


--
-- Name: telefono telefono_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_pkey PRIMARY KEY (numero);


--
-- Name: veicolo veicolo_pkey; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.veicolo
    ADD CONSTRAINT veicolo_pkey PRIMARY KEY (id);


--
-- Name: veicolo veicolo_targa_key; Type: CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.veicolo
    ADD CONSTRAINT veicolo_targa_key UNIQUE (targa);


--
-- Name: dipendente dipendente_sede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.dipendente
    ADD CONSTRAINT dipendente_sede_fkey FOREIGN KEY (sede) REFERENCES public.sede(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: disponibile disponibile_idveicolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.disponibile
    ADD CONSTRAINT disponibile_idveicolo_fkey FOREIGN KEY (idveicolo) REFERENCES public.veicolo(id) ON UPDATE CASCADE;


--
-- Name: dotazione dotazione_accessorio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.dotazione
    ADD CONSTRAINT dotazione_accessorio_fkey FOREIGN KEY (accessorio) REFERENCES public.accessorio(nome) ON UPDATE CASCADE;


--
-- Name: dotazione dotazione_idveicolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.dotazione
    ADD CONSTRAINT dotazione_idveicolo_fkey FOREIGN KEY (idveicolo) REFERENCES public.disponibile(idveicolo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: extra extra_idveicolo_datariconsegnanoleggio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.extra
    ADD CONSTRAINT extra_idveicolo_datariconsegnanoleggio_fkey FOREIGN KEY (idveicolo, datariconsegnanoleggio) REFERENCES public.noleggio(idveicolo, datariconsegna) ON UPDATE CASCADE;


--
-- Name: extra extra_servizioaggiuntivo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.extra
    ADD CONSTRAINT extra_servizioaggiuntivo_fkey FOREIGN KEY (servizioaggiuntivo) REFERENCES public.servizioaggiuntivo(tipologia) ON UPDATE CASCADE;


--
-- Name: manutenzione manutenzione_codicespesa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.manutenzione
    ADD CONSTRAINT manutenzione_codicespesa_fkey FOREIGN KEY (codicespesa) REFERENCES public.spesa(codice) ON UPDATE CASCADE;


--
-- Name: manutenzione manutenzione_idveicolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.manutenzione
    ADD CONSTRAINT manutenzione_idveicolo_fkey FOREIGN KEY (idveicolo) REFERENCES public.veicolo(id) ON UPDATE CASCADE;


--
-- Name: motorizzazioneelettrica motorizzazioneelettrica_idveicolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.motorizzazioneelettrica
    ADD CONSTRAINT motorizzazioneelettrica_idveicolo_fkey FOREIGN KEY (idveicolo) REFERENCES public.disponibile(idveicolo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: noleggiato noleggiato_idveicolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggiato
    ADD CONSTRAINT noleggiato_idveicolo_fkey FOREIGN KEY (idveicolo) REFERENCES public.disponibile(idveicolo) ON UPDATE CASCADE;


--
-- Name: noleggiato noleggiato_partitaiva_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggiato
    ADD CONSTRAINT noleggiato_partitaiva_fkey FOREIGN KEY (partitaiva) REFERENCES public.partitaiva(codice) ON UPDATE CASCADE;


--
-- Name: noleggiato noleggiato_privato_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggiato
    ADD CONSTRAINT noleggiato_privato_fkey FOREIGN KEY (privato) REFERENCES public.privato(codice) ON UPDATE CASCADE;


--
-- Name: noleggio noleggio_codicespesa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggio
    ADD CONSTRAINT noleggio_codicespesa_fkey FOREIGN KEY (codicespesa) REFERENCES public.spesa(codice) ON UPDATE CASCADE;


--
-- Name: noleggio noleggio_idveicolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggio
    ADD CONSTRAINT noleggio_idveicolo_fkey FOREIGN KEY (idveicolo) REFERENCES public.veicolo(id) ON UPDATE CASCADE;


--
-- Name: noleggio noleggio_partitaiva_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggio
    ADD CONSTRAINT noleggio_partitaiva_fkey FOREIGN KEY (partitaiva) REFERENCES public.partitaiva(codice) ON UPDATE CASCADE;


--
-- Name: noleggio noleggio_privato_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggio
    ADD CONSTRAINT noleggio_privato_fkey FOREIGN KEY (privato) REFERENCES public.privato(codice) ON UPDATE CASCADE;


--
-- Name: noleggio noleggio_sede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.noleggio
    ADD CONSTRAINT noleggio_sede_fkey FOREIGN KEY (sede) REFERENCES public.sede(id) ON UPDATE CASCADE;


--
-- Name: spesa spesa_dipendente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.spesa
    ADD CONSTRAINT spesa_dipendente_fkey FOREIGN KEY (dipendente) REFERENCES public.dipendente(matricola) ON UPDATE CASCADE;


--
-- Name: spesa spesa_idveicolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.spesa
    ADD CONSTRAINT spesa_idveicolo_fkey FOREIGN KEY (idveicolo) REFERENCES public.veicolo(id) ON UPDATE CASCADE;


--
-- Name: spesa spesa_sede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.spesa
    ADD CONSTRAINT spesa_sede_fkey FOREIGN KEY (sede) REFERENCES public.sede(id) ON UPDATE CASCADE;


--
-- Name: tariffa tariffa_idveicolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.tariffa
    ADD CONSTRAINT tariffa_idveicolo_fkey FOREIGN KEY (idveicolo) REFERENCES public.disponibile(idveicolo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: telefono telefono_sede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucatribolati
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_sede_fkey FOREIGN KEY (sede) REFERENCES public.sede(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

