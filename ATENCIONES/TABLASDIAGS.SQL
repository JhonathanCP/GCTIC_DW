CREATE TABLE sgss_ctdaa10_anio_hipertension(
    ATENAMBORICENASICOD VARCHAR(1),          -- PF: Clave primaria
    ATENAMBCENASICOD VARCHAR(3),            -- PF: Clave primaria
    ATENAMBNUM NUMERIC(10),                  -- PF: Clave primaria
    CONDDIAGCOD VARCHAR(1),                  -- PF: Clave primaria
    DIAGCOD VARCHAR(7),                      -- PF: Clave primaria
    ATENAMBDIAGORD NUMERIC(2),                        -- Campo adicional
    ATENAMBTIPODIAGCOD VARCHAR(1),                    -- F: Clave foránea
    ATENAMBCASODIAGCOD VARCHAR(1),                    -- F: Clave foránea
    DIAGATENAMBALTAFLAG VARCHAR(1),                   -- Campo adicional
    DIAGATENAMBPEAS NUMERIC(1),
	periodo	CHAR(6),
	anio	CHAR(4));


CREATE TABLE sgss_mtdae10_anio_hipertension (
    ateemeoricenasicod VARCHAR(1),         -- PK: Clave primaria
    ateemecenasicod VARCHAR(3),            -- PK: Clave primaria
    ateemeactmednum NUMERIC(10),           -- PK: Clave primaria
    ateemesecnum NUMERIC(4),               -- PK: Clave primaria
    conddiagcod VARCHAR(1),                -- PK: Clave primaria
    diagcod VARCHAR(7),                    -- PK: Clave primaria
    ateemediagord NUMERIC(2),              -- Campo adicional (clave no primaria)
    ateemetipodiagcod VARCHAR(1),          -- FK: Clave foránea
	periodo	CHAR(6),
	anio	CHAR(4));         

CREATE TABLE sgss_htdah10_anio_hipertension (
    atenhosoricenasicod VARCHAR(1),    -- PK: Clave primaria
    atenhoscenasicod VARCHAR(3),       -- PK: Clave primaria
    atenhosactmednum NUMERIC(10),      -- PK: Clave primaria
    atenhosnumsec NUMERIC(4),          -- PK: Clave primaria
    conddiagcod VARCHAR(1),            -- PK: Clave primaria
    diagcod VARCHAR(7),                -- PK: Clave primaria
    atenhosdiagord NUMERIC(2),         -- Campo adicional (clave no primaria)
    atenhostipodiagcod VARCHAR(1),     -- FK: Clave foránea   
	periodo	CHAR(6),
	anio	CHAR(4));


CREATE TABLE sgss_qtiod10_anio_hipertension (
	INFOPEORICENASICOD VARCHAR(1),
	INFOPECENASICOD VARCHAR(3),
	INFOPESOLOPENUM NUMERIC(10),
	INFOPESECNUM NUMERIC(3),
	CONDDIAGCOD VARCHAR(1),
	INFOPEDIAGCOD VARCHAR(7),
	TIPODIAGCOD VARCHAR(1),
	INFOPEDIAGORD NUMERIC(3),
	periodo	CHAR(6),
	anio	CHAR(4));