CREATE TABLE kund(
username VARCHAR2(8) PRIMARY KEY,
passwd VARCHAR2(8) NOT NULL,
fnamn VARCHAR2(20) NOT NULL,
enamn VARCHAR2(20) NOT NULL,
yrke VARCHAR2(20),
regdatum DATE NOT NULL,
årslön NUMBER(7));

INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('MrBig','MBisKING','Roger','nyberg','Officer',TO_DATE('1998-NOV-29','YYYY-MON-DD'),317000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('MEZcal','P33kssa','maria','Nyberg','psykolog',TO_DATE('1999-08-29','YYYY-MM-DD'),435000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('KLÖven','bintje','Tomas','kvist','Potatisbonde',TO_DATE('2000-02-28','YYYY-MM-DD'),198000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('OlleBull','Bullas','hans','Lindqvist',NULL,TO_DATE('2002-05-05','YYYY-MM-DD'),116000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('MrMDI','MDIisit','Hans','Rosenboll','adjunkt',TO_DATE('1997-01-15','YYYY-MM-DD'),307000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('King25','asdf1234','charlotte','Ortiz','tandläkare',TO_DATE('2003-12-10','YYYY-MM-DD'),586000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('h01hanro','T56xxL','Sven','Larsson',NULL,TO_DATE('2003-08-09','YYYY-MM-DD'),NULL);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('XXXL','IRule','Margareta','ek','VD',TO_DATE('2001-06-29','YYYY-MM-DD'),942000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('Rolven','revolver','roger','nyberg',NULL,TO_DATE('1998-10-29','YYYY-MM-DD'),240000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('IceMan','Quantos','Maria','Nyberg','Ingenjör',TO_DATE('1998-02-14','YYYY-MM-DD'),412000);
COMMIT;

-- Uppgift 1 --
SELECT * FROM kund
ORDER BY initcap(enamn) ASC;

-- Uppgift 2 --
SELECT * FROM kund
ORDER BY initcap(enamn) DESC;

-- Uppgift 3 --
SELECT count(username)
FROM kund;

-- Uppgift 4 --
SELECT count(årslön)
FROM kund
WHERE årslön > 300000;

-- Uppgift 5 --
SELECT count(årslön)
FROM kund
WHERE årslön < 300000;

-- Uppgift 6 --
SELECT avg(nvl(årslön, 0)) as "Medellön"
FROM kund;

-- Uppgift 7 --
SELECT username, fnamn, enamn, nvl(årslön, 0) as årslön
FROM kund
WHERE nvl(årslön, 0) < (SELECT avg(nvl(årslön, 0))
                        FROM kund);

-- Uppgift 8 --
SELECT upper(fnamn) as fnamn, upper(enamn) as enamn
FROM kund
WHERE lower(enamn) like '%s%';

-- Uppgift 9 --
SELECT lower(fnamn) as fnamn, lower(enamn) as enamn, lower(nvl(yrke, 'arbetsfri')) as yrke
FROM kund
WHERE lower(fnamn) like '%s';

-- Uppgift 10 --
SELECT nvl(initcap(yrke), 'Arbetsfri') as yrke, count(username) as antal
FROM kund
GROUP BY yrke
ORDER BY yrke ASC;

-- Uppgift 11 --
SELECT initcap(fnamn) ||' '|| initcap(enamn) as kundnamn
FROM kund;
-- ORDER BY kundnamn ASC;

-- Uppgift 12 --
SELECT count(username) as inloggad
FROM kund
WHERE username like 'King25' and passwd like 'asdf1234';

-- Uppgift 13 --
SELECT count(username) as inloggad
FROM kund
WHERE username like 'KING25' and passwd like 'ASDF1234';

-- Uppgift 14 --
SELECT username, passwd, to_char(regdatum, 'YYYY-MM-DD') as regdatum
FROM kund
WHERE to_char(regdatum, 'YYYY') < '2000';

-- Uppgift 15 --
SELECT username, passwd, to_char(regdatum, 'YYYY-MM-DD') as regdatum
FROM kund
WHERE to_char(regdatum, 'YYYY-MM-DD') between '2001-01-01' and '2003-10-01';

-- Uppgift 16 --
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('MrBig2','MBisKING','Roger','kvist','Forskare',TO_DATE('2016-NOV-29','YYYY-MON-DD'),NULL);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('MEZcal33','P33kssa','roger','eriksson','takläggare',TO_DATE('2013-08-29','YYYY-MM-DD'),NULL);
Commit;

SELECT username, passwd, fnamn, enamn
FROM kund
WHERE (lower(enamn) = 'nyberg' or lower(enamn) = 'kvist') and (lower(fnamn) <> 'roger');

-- Uppgift 17 --
SELECT fnamn, enamn, årslön
FROM kund
WHERE årslön = (SELECT MAX(årslön)
                FROM kund);

-- Uppgift 18 --
SELECT fnamn, enamn, årslön
FROM kund
WHERE årslön = (SELECT MIN(årslön)
                FROM kund);

-- Uppgift 19 --
SELECT fnamn, enamn
FROM kund
WHERE yrke IS NULL;
