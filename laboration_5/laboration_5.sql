-- Laboration 5 i Databassystem (GIK2AL) av Philip Sinnott --

-- Uppgift 1 --

-- Skapa tabeller och lägg till constraints --
CREATE TABLE bankkund(
pnr VARCHAR2(11) NOT NULL,
fnamn VARCHAR2(25) NOT NULL,
enamn VARCHAR2(25) NOT NULL,
passwd VARCHAR2(16) NOT NULL);

ALTER TABLE bankkund 
ADD CONSTRAINT bankkund_pnr_PK PRIMARY KEY(pnr);

CREATE TABLE kontotyp(
ktnr NUMBER(6) NOT NULL,
ktnamn VARCHAR2(20) NOT NULL,
ränta NUMBER(5,2) NOT NULL);

ALTER TABLE kontotyp
ADD CONSTRAINT kontotyp_ktnr_PK PRIMARY KEY(ktnr);

CREATE TABLE ränteändring(
rnr NUMBER(6) NOT NULL,
ktnr NUMBER(6) NOT NULL,
ränta NUMBER(5,2) NOT NULL,
rnr_datum DATE NOT NULL);

ALTER TABLE ränteändring
ADD CONSTRAINT ränteändring_rnr_PK PRIMARY KEY(rnr);

ALTER TABLE ränteändring
ADD CONSTRAINT ränteändring_ktnr_FK FOREIGN KEY(ktnr) REFERENCES kontotyp(ktnr);

CREATE TABLE konto(
knr NUMBER(8) NOT NULL,
ktnr NUMBER(6) NOT NULL,
regdatum DATE NOT NULL,
saldo NUMBER(10,2) NOT NULL);

ALTER TABLE konto
ADD CONSTRAINT konto_knr_PK PRIMARY KEY(knr);

CREATE TABLE kontoägare(
radnr NUMBER(9) NOT NULL,
pnr VARCHAR2(11) NOT NULL,
knr NUMBER(8) NOT NULL);

ALTER TABLE kontoägare
ADD CONSTRAINT kontoägare_radnr_PK PRIMARY KEY(radnr);

ALTER TABLE kontoägare
ADD CONSTRAINT kontoägare_pnr_FK FOREIGN KEY(pnr) REFERENCES bankkund(pnr);

ALTER TABLE kontoägare
ADD CONSTRAINT kontoägare_knr_FK FOREIGN KEY(knr) REFERENCES konto(knr);

CREATE TABLE uttag(
radnr NUMBER(9) NOT NULL,
pnr VARCHAR2(11) NOT NULL,
knr NUMBER(8) NOT NULL,
belopp NUMBER(10,2),
datum DATE NOT NULL);

ALTER TABLE uttag
ADD CONSTRAINT uttag_radnr_PK PRIMARY KEY(radnr);

ALTER TABLE uttag
ADD CONSTRAINT uttag_pnr_FK FOREIGN KEY(pnr) REFERENCES bankkund(pnr);

ALTER TABLE uttag
ADD CONSTRAINT uttag_knr_FK FOREIGN KEY(knr) REFERENCES konto(knr);

CREATE TABLE insättning(
radnr NUMBER(9) NOT NULL,
pnr VARCHAR2(11) NOT NULL,
knr NUMBER(8) NOT NULL,
belopp NUMBER(10,2),
datum DATE NOT NULL);

ALTER TABLE insättning
ADD CONSTRAINT insättning_radnr_PK PRIMARY KEY(radnr);

ALTER TABLE insättning
ADD CONSTRAINT insättning_pnr_FK FOREIGN KEY(pnr) REFERENCES bankkund(pnr);

ALTER TABLE insättning
ADD CONSTRAINT insättning_knr_FK FOREIGN KEY(knr) REFERENCES konto(knr);

CREATE TABLE överföring(
radnr NUMBER(9) NOT NULL,
pnr VARCHAR2(11) NOT NULL,
från_knr NUMBER(8) NOT NULL,
till_knr NUMBER(8) NOT NULL,
belopp NUMBER(10,2),
datum DATE NOT NULL);

ALTER TABLE överföring
ADD CONSTRAINT överföring_radnr_PK PRIMARY KEY(radnr);

ALTER TABLE överföring
ADD CONSTRAINT överföring_pnr_FK FOREIGN KEY(pnr) REFERENCES bankkund(pnr);

ALTER TABLE överföring
ADD CONSTRAINT överföring_från_knr_FK FOREIGN KEY(från_knr) REFERENCES konto(knr);

ALTER TABLE överföring
ADD CONSTRAINT överföring_till_knr_FK FOREIGN KEY(till_knr) REFERENCES konto(knr);

-- Uppgift 2 --
-- Datamodell --

-- Uppgift 3 --

CREATE OR REPLACE TRIGGER biufer_bankkund
    BEFORE INSERT OR UPDATE
    ON bankkund
    FOR EACH ROW
WHEN (LENGTH(NEW.passwd) != 6)
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'Lösenordet är inte 6 tecken långt!');
END;

-- Uppgift 4 --
-- fö 13 21:00 min --

CREATE OR REPLACE PROCEDURE do_bankkund(
    p_pnr IN bankkund.pnr%TYPE,
    p_fnamn IN bankkund.fnamn%TYPE,
    p_enamn IN bankkund.enamn%TYPE,
    p_passwd IN bankkund.passwd%TYPE)
    AS
BEGIN
    INSERT INTO bankkund(pnr, fnamn, enamn, passwd)
    VALUES(p_pnr, p_fnamn, p_enamn, p_passwd);
END;

-- Uppgift 5 --

-- Lösenord är endast 3 tecken långt så felmeddelandet kommer triggas och en ny kund kommer EJ skapas. --
BEGIN
    do_bankkund('010812-0000', 'Philip', 'Sinnott', 'abc');
COMMIT;
END;

-- Dessa kommer alla fungera då alla lösenord är 6 tecken långa. --
-------------------------Start copy and paste---------------------------------
BEGIN
do_bankkund('540126-1111','Hans','Rosendahl','olle45');
do_bankkund('560126-1111','Hans','Rosengårdh','olle85');
do_bankkund('540126-1457','Lina','Karlsson','asdfgh');
do_bankkund('691124-4478','Leena','Kvist','qwerty');
COMMIT;
END;
/
-------------------------End copy and paste---------------------------------

-- Uppgift 6 --
CREATE SEQUENCE radnr_seq
    START WITH 1
    INCREMENT BY 1;

-------------------------Start copy and paste---------------------------------
INSERT INTO kontotyp(ktnr,ktnamn,ränta)
VALUES(1,'bondkonto',3.4);
INSERT INTO kontotyp(ktnr,ktnamn,ränta)
VALUES(2,'potatiskonto',4.4);
INSERT INTO kontotyp(ktnr,ktnamn,ränta)
VALUES(3,'griskonto',2.4);
COMMIT;
INSERT INTO konto(knr,ktnr,regdatum,saldo)
VALUES(123,1,SYSDATE - 321,0);
INSERT INTO konto(knr,ktnr,regdatum,saldo)
VALUES(5899,2,SYSDATE - 2546,0);
INSERT INTO konto(knr,ktnr,regdatum,saldo)
VALUES(5587,3,SYSDATE - 10,0);
INSERT INTO konto(knr,ktnr,regdatum,saldo)
VALUES(8896,1,SYSDATE - 45,0);
COMMIT;
INSERT INTO kontoägare(radnr,pnr,knr)
VALUES(radnr_seq.NEXTVAL,'540126-1111',123);
INSERT INTO kontoägare(radnr,pnr,knr)
VALUES(radnr_seq.NEXTVAL,'691124-4478',123);
INSERT INTO kontoägare(radnr,pnr,knr)
VALUES(radnr_seq.NEXTVAL,'540126-1111',5899);
INSERT INTO kontoägare(radnr,pnr,knr)
VALUES(radnr_seq.NEXTVAL,'691124-4478',8896);
COMMIT;
-------------------------End copy and paste---------------------------------

-- Uppgift 7 --
CREATE OR REPLACE FUNCTION logga_in(
    f_pnr IN bankkund.pnr%TYPE,
    f_passwd IN bankkund.passwd%TYPE)
RETURN NUMBER
AS
v_authenticated bankkund.passwd%TYPE;
BEGIN
    SELECT passwd INTO v_authenticated FROM bankkund WHERE pnr = f_pnr;
    IF v_authenticated = f_passwd THEN
    RETURN 1;
    ELSE
    RETURN 0;
    END IF;
END;


-- Visa konton --
SELECT *
FROM bankkund;

-- Returnerar 0 då lösenordet är felaktigt --
SELECT logga_in('540126-1111', 'olle100') as test_1
FROM dual;

-- Returnerar 1 då lösenordet är korrekt --
SELECT logga_in('540126-1111', 'olle45') as test_2
FROM dual;


-- Uppgift 8 --
CREATE OR REPLACE FUNCTION get_saldo(
    f_knr IN konto.knr%TYPE)
RETURN NUMBER
AS
v_saldo konto.saldo%TYPE;
BEGIN
    SELECT saldo INTO v_saldo FROM konto WHERE knr = f_knr;
    RETURN v_saldo;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20001,'Vi kunde inte hitta detta konto (knr: '||f_knr||') i databasen.');
        RAISE;
END;

-- Fungerar då kunden existerar --
SELECT get_saldo(123) as test_1
FROM dual;

-- Fungerar EJ då kunden EJ existerar --
SELECT get_saldo(666) as test_2
FROM dual;


-- Uppgift 9 --
CREATE OR REPLACE FUNCTION get_behörighet(
    f_pnr IN kontoägare.pnr%TYPE,
    f_knr IN kontoägare.knr%TYPE)
RETURN NUMBER
AS
v_behörighet kontoägare.knr%TYPE;
BEGIN
    SELECT knr INTO v_behörighet FROM kontoägare WHERE knr = f_knr AND pnr = f_pnr;
    IF v_behörighet = f_knr THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
        WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20001, 'Den angivna personen är inte ägare till det angivna belastningskontot.');
        RAISE;
END;

-- Visa konton --
SELECT *
FROM kontoägare;

-- Returnerar ett felmeddelande då den med det angivna pnr EJ har ett konto med det angivna knr --
SELECT get_behörighet('540126-1111', 8896) as test_1
FROM dual;

-- Returnerar 1 då den med det angivna pnr har ett konto med det angivna knr --
SELECT get_behörighet('540126-1111', 5899) as test_2
FROM dual;

-- Uppgift 10 --
CREATE OR REPLACE TRIGGER aifer_insättning
AFTER INSERT
ON insättning
FOR EACH ROW

BEGIN
    UPDATE konto SET konto.saldo = konto.saldo + :NEW.belopp WHERE konto.knr = :NEW.knr;
END;

-- Visa alla konton och dess olika saldon --
SELECT *
FROM konto;

-- Test! SE TILL ATT värdet för pnr och knr existerar i parenttabellerna, annars blir det brott mot referensintegriteten --
INSERT INTO insättning(radnr, pnr, knr, belopp, datum)
VALUES(radnr_seq.NEXTVAL, '540126-1111', 123, 1000, SYSDATE);
COMMIT;

    
-- Uppgift 11 --
CREATE OR REPLACE TRIGGER bifer_uttag
BEFORE INSERT
ON uttag
FOR EACH ROW

BEGIN
    IF get_saldo(:NEW.knr) - :NEW.belopp < 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Det finns inte tillräckligt med pengar på kontot för att genomföra detta.');
    END IF;
END;

-- Test --
INSERT INTO uttag(radnr, pnr, knr, belopp, datum)
VALUES(radnr_seq.NEXTVAL, '540126-1111', 123, 1000, SYSDATE);
COMMIT;

-- Visa saldo --
SELECT *
FROM konto;

-- Uppgift 12 --

CREATE OR REPLACE TRIGGER aifer_uttag
AFTER INSERT
ON uttag
FOR EACH ROW

BEGIN
    UPDATE konto SET saldo = saldo - :NEW.belopp WHERE knr = :NEW.knr;
END;

-- test --

-- Uppgift 13 --
CREATE OR REPLACE TRIGGER bifer_överföring
BEFORE INSERT
ON överföring
FOR EACH ROW

BEGIN
    IF get_saldo(:NEW.från_knr) < :NEW.belopp THEN
        RAISE_APPLICATION_ERROR(-20012, 'Det finns inte tillräckligt med pengar på kontot för att genomföra denna överföring.');
    END IF;
END;

-- test --
INSERT INTO överföring(radnr, pnr, från_knr, till_knr, belopp, datum)
VALUES(radnr_seq.NEXTVAL, '540126-1111', 123, 5899, 1000, SYSDATE);

-- skicka in --
INSERT INTO insättning(radnr, pnr, knr, belopp, datum)
VALUES(radnr_seq.NEXTVAL, '540126-1111', 123, 1000, SYSDATE);


-- Uppgift 14 --
CREATE OR REPLACE TRIGGER aifer_överföring
AFTER INSERT
ON överföring
FOR EACH ROW

BEGIN
    UPDATE konto SET saldo = saldo - :NEW.belopp WHERE knr = :NEW.från_knr;
    UPDATE konto SET saldo = saldo + :NEW.belopp WHERE knr = :NEW.till_knr;
END;

-- test --
INSERT INTO överföring(radnr, pnr, från_knr, till_knr, belopp, datum)
VALUES(radnr_seq.NEXTVAL, '540126-1111', 123, 5899, 50, SYSDATE);


-- Uppgift 15 --
CREATE OR REPLACE PROCEDURE do_insättning(
    p_pnr IN insättning.pnr%TYPE,
    p_knr IN insättning.knr%TYPE,
    p_belopp IN insättning.belopp%TYPE)
AS
v_saldo konto.saldo%TYPE;
v_radnr number(5);
BEGIN
    SELECT radnr_seq.NEXTVAL INTO v_radnr FROM DUAL;
    INSERT INTO insättning(radnr, pnr, knr, belopp, datum)
    VALUES(v_radnr, p_pnr, p_knr, p_belopp, SYSDATE);
    COMMIT;
    v_saldo := get_saldo(p_knr);
    dbms_output.put_line('Insättningen lyckades! Aktuellt saldo på konto '||p_knr||': '||v_saldo||' kr.');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR (-20017, 'Insättningen misslyckades. Försök igen.');
END;

-- KÖR --
EXEC do_insättning('540126-1457', 5587, 50000);


-- Uppgift 16 --
-- Insättning till kontonr som ägs av detta personnr --
EXEC do_insättning('540126-1111', 123, 500);

-- Insättning till kontonr som EJ existerar --
EXEC do_insättning('540126-1111', 1337, 100);

-- Insättning till kontonr som existerar men EJ ägs av detta personnr --
EXEC do_insättning('540126-1150', 5587, 100);


-- Uppgift 17 --
CREATE OR REPLACE PROCEDURE do_uttag(
    p_pnr IN uttag.pnr%TYPE,
    p_knr IN uttag.knr%TYPE,
    p_belopp IN uttag.belopp%TYPE)
AS
    obehörig EXCEPTION;
    v_behörighet NUMBER(5);
    v_saldo konto.saldo%TYPE;
    v_radnr NUMBER(5);
BEGIN
    v_behörighet := get_behörighet(p_pnr, p_knr);
    IF v_behörighet = 0 THEN
        RAISE obehörig;
    ELSE
        SELECT radnr_seq.NEXTVAL INTO v_radnr FROM DUAL;
        INSERT INTO uttag(radnr, pnr, knr, belopp, datum)
        VALUES(v_radnr, p_pnr, p_knr, p_belopp, SYSDATE);
        COMMIT;
        v_saldo := get_saldo(p_knr);
        dbms_output.put_line('Insättningen lyckades! Aktuellt saldo på konto '||p_knr||': '||v_saldo||' kr.');
    END IF;
EXCEPTION
    WHEN obehörig THEN
        RAISE_APPLICATION_ERROR(-20072, 'Insättningen misslyckades! Försök igen.');
END;

-- TEST --

-- Fungerar, behörig --
EXEC do_uttag('540126-1111', 123, 250);

-- Fungerar EJ, Obehörig --
EXEC do_uttag('540126-1150', 123, 250);

-- get_behörighet triggas --
EXEC do_uttag('540126-1111', 5587, 250);


-- Uppgift 18 --

-- Försöker ta ut mer pengar än vad som finns på det angivna kontot, går EJ pga tidigare skappad trigger --
EXEC do_uttag('540126-1111', 123, 50000);


-- Uppgift 19 --
CREATE OR REPLACE PROCEDURE do_överföring(
    p_pnr IN överföring.pnr%TYPE,
    p_från_knr IN överföring.från_knr%TYPE,
    p_till_knr IN överföring.till_knr%TYPE,
    p_belopp IN överföring.belopp%TYPE)
AS
    obehörig EXCEPTION;
    v_behörighet NUMBER(5);
    v_saldo_från konto.saldo%TYPE;
    v_saldo_till konto.saldo%TYPE;
    v_radnr NUMBER(5);
BEGIN
    v_behörighet := get_behörighet(p_pnr, p_till_knr);
    IF v_behörighet = 0 THEN
        RAISE obehörig;
    ELSE
        SELECT radnr_seq.NEXTVAL INTO v_radnr FROM DUAL;
        INSERT INTO överföring(radnr, pnr, från_knr, till_knr, belopp, datum)
        VALUES(v_radnr, p_pnr, p_från_knr, p_till_knr, p_belopp, SYSDATE);
        COMMIT;
        v_saldo_från := get_saldo(p_från_knr);
        v_saldo_till := get_saldo(p_till_knr);
        dbms_output.put_line('Överföringen på '||p_belopp||' kr mellan kontonr '||p_från_knr||' till kontonr '||p_till_knr||' lyckades! Aktuellt saldo på konto '||p_från_knr||': '||v_saldo_från||' kr. || Saldo på konto '||p_till_knr||': '||v_saldo_till||' kr.');
    END IF;
EXCEPTION
    WHEN obehörig THEN
        RAISE_APPLICATION_ERROR(-20072, 'Insättningen misslyckades! Försök igen.');
END;


-- Test --
SELECT *
FROM konto;

-- Fungerar så länge det finns pengar på kontonr 123 --
EXEC do_överföring('540126-1111', 123, 5587, 25);

-- Överföring med ett belopp som är större än kontots belopp  --
EXEC do_överföring('540126-1111', 123, 5587, 50000000);

-- Uppgift 20 --

-- Fler test --
EXEC do_överföring('691124-4478', 123, 5587, 100);
