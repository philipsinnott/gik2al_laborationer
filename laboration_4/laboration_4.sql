------------------------------------Start copy and paste--------------------------------
CREATE TABLE bilägare(
pnr VARCHAR2(13) PRIMARY KEY,
fnamn VARCHAR2(20),
enamn VARCHAR2(20),
bor_i VARCHAR2(20),
jobbar_i VARCHAR2(20));

CREATE TABLE fordon(
regnr VARCHAR2(6) PRIMARY KEY,
pnr REFERENCES bilägare(pnr),
tillverkare VARCHAR2(20),
modell VARCHAR2(20),
årsmodell NUMBER(4),
hk NUMBER(4),
datum DATE);

INSERT INTO bilägare VALUES('19490321-7899','hans','rosenboll','borlänge','falun');
INSERT INTO bilägare VALUES('19540201-4428','tomas','kvist','gagnef','borlänge');
INSERT INTO bilägare VALUES('19650823-7999','roger','nyberg','borlänge','falun');
INSERT INTO bilägare VALUES('19710601-7799','lena','malm','borlänge','falun');
INSERT INTO bilägare VALUES('19690321-7898','ollas','bullas','falun','borlänge');
INSERT INTO bilägare VALUES('19590421-7199','tåmmy','dåmert','borlänge','falun');
INSERT INTO bilägare VALUES('19610321-4299','rollf','ekengren','borlänge','falun');
INSERT INTO bilägare VALUES('19810321-7199','maria','stjärnkvist','borlänge','falun');
INSERT INTO bilägare VALUES('19720721-7899','leyla','errstraid','borlänge','falun');
INSERT INTO bilägare VALUES('19380321-7799','arne','möller','borlänge','falun');
INSERT INTO fordon VALUES('ase456','19490321-7899','volvo','945',1998,160,to_date('2003-08-11','YYYY-MM-DD'));
INSERT INTO fordon VALUES('ptg889','19490321-7899','fiat','excel',1991,287,to_date('1998-05-19','YYYY-MM-DD'));
INSERT INTO fordon VALUES('bon666','19540201-4428','john deere','gris',1967,48,to_date('1989-06-28','YYYY-MM-DD'));
INSERT INTO fordon VALUES('rog589','19650823-7999','saab','900 talladega',1997,205,to_date('2003-05-11','YYYY-MM-DD'));
INSERT INTO fordon VALUES('ert456','19710601-7799','volvo','850',1997,150,to_date('2001-07-11','YYYY-MM-DD'));
INSERT INTO fordon VALUES('ola774','19690321-7898','mb','e420',1998,285,to_date('2000-08-11','YYYY-MM-DD'));
INSERT INTO fordon VALUES('thf345','19590421-7199','opel','kapitän',1968,105,to_date('1991-06-11','YYYY-MM-DD'));
INSERT INTO fordon VALUES('dde411','19610321-4299','saab','9000 aero',1998,225,to_date('2000-07-28','YYYY-MM-DD'));
INSERT INTO fordon VALUES('ser478','19810321-7199','audi','tt',2003,247,to_date('2004-07-05','YYYY-MM-DD'));
INSERT INTO fordon VALUES('fgt147','19720721-7899','volvo','66',1981,62,to_date('2003-05-11','YYYY-MM-DD'));
INSERT INTO fordon VALUES('tau444','19380321-7799','ford','taunus',1973,95,to_date('1975-08-23','YYYY-MM-DD'));
INSERT INTO fordon VALUES('pot333','19540201-4428','volvo','745',1989,93,to_date('1996-01-11','YYYY-MM-DD'));
COMMIT;
------------------------------------End copy and paste----------------------------------

-- Uppgift 1 --
DECLARE
    v_regnr fordon.regnr%type;
    v_tillverkare fordon.tillverkare%type;
    v_modell fordon.modell%type;

BEGIN
    SELECT initcap(regnr), initcap(tillverkare), initcap(modell)
    INTO v_regnr, v_tillverkare, v_modell
    FROM fordon
    WHERE pnr = '19650823-7999';

dbms_output.put_line('Regnr: '||v_regnr);
dbms_output.put_line('Tillverkare: '||v_tillverkare);
dbms_output.put_line('Modell: '||v_modell);
END;

-- Uppgift 2 --
DECLARE
    v_regnr fordon.regnr%type;
    v_tillverkare fordon.tillverkare%type;
    v_modell fordon.modell%type;

BEGIN
    SELECT initcap(regnr), initcap(tillverkare), initcap(modell)
    INTO v_regnr, v_tillverkare, v_modell
    FROM fordon
    WHERE pnr = '19540201-4428';
EXCEPTION
    WHEN OTHERS THEN dbms_output.put_line('Något blev fel!');
END;

-- Uppgift 3 --
DECLARE
    v_regnr fordon.regnr%type;
    v_tillverkare fordon.tillverkare%type;
    v_modell fordon.modell%type;

BEGIN
    SELECT initcap(regnr), initcap(tillverkare), initcap(modell)
    INTO v_regnr, v_tillverkare, v_modell
    FROM fordon
    WHERE pnr = '19540201-4428';
EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line('Följande blev fel:');
    dbms_output.put_line('Felkod: '||SQLCODE);
    dbms_output.put_line('Felmeddelande: '||SQLERRM);
END;

-- Uppgift 4 --
DECLARE
    CURSOR bilägare IS SELECT initcap(fnamn) as förnamn, initcap(enamn) as efternamn, round((sysdate - (to_date(substr(pnr, 1, 8), 'YYYYMMDD'))) / 365, 1) as ålder
                    FROM bilägare;

BEGIN
    FOR ägare IN bilägare LOOP
        dbms_output.put_line(ägare.förnamn||', '||ägare.efternamn||', '||ägare.ålder);
    END LOOP;
END;

-- Uppgift 5 --
DECLARE
    CURSOR antal_bilar IS SELECT b.pnr as pnr, b.fnamn as fnamn, b.enamn as enamn, count(f.regnr) as bil
                            FROM bilägare b, fordon f
                            WHERE b.pnr = f.pnr
                            GROUP BY b.pnr, b.fnamn, b.enamn
                            ORDER BY pnr ASC;
BEGIN
    FOR bil IN antal_bilar LOOP
        IF bil.bil > 1 THEN
            dbms_output.put_line(bil.pnr||', '||bil.fnamn||', '||bil.enamn||', äger: '||bil.bil||' bilar');
        ELSE
            dbms_output.put_line(bil.pnr||', '||bil.fnamn||', '||bil.enamn||', äger: '||bil.bil||' bil');
        END IF;
    END LOOP;
END;

-- Uppgift 6 --
-------------------------------------Start copy and paste-------------------------------
CREATE TABLE fartdåre(
pnr VARCHAR2(13),
fnamn VARCHAR2(20),
enamn VARCHAR2(20),
regnr VARCHAR2(6),
tillverkare VARCHAR2(20),
modell VARCHAR2(20));
-------------------------------------End copy and paste---------------------------------
DECLARE
    CURSOR c_200_hk IS SELECT b.pnr, b.fnamn, b.enamn, f.regnr, f.tillverkare, f.modell
                        FROM bilägare b, fordon f
                        WHERE b.pnr = f.pnr
                        AND f.hk > 200;
                        
    v_rec c_200_hk%rowtype;
    
BEGIN
    IF NOT c_200_hk%isopen THEN
        OPEN c_200_hk;
    END IF;
    
    LOOP
        FETCH c_200_hk
        INTO v_rec;
        
        EXIT WHEN c_200_hk%notfound;
            INSERT INTO fartdåre(pnr, fnamn, enamn, regnr, tillverkare, modell)
            VALUES(v_rec.pnr, v_rec.fnamn, v_rec.enamn, v_rec.regnr, v_rec.tillverkare, v_rec.modell);
            
    END LOOP;
    COMMIT;
    dbms_output.put_line('Kopieringen är klar!');
    CLOSE c_200_hk;

END;