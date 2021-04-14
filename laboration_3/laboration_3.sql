CREATE TABLE kund(
knr NUMBER(6) PRIMARY KEY,
fnamn VARCHAR2(20),
enamn VARCHAR2(25),
adress VARCHAR2(30),
postnr NUMBER(8),
ort VARCHAR2(20),
riktnr VARCHAR2(6),
telnr VARCHAR2(10));
CREATE TABLE kundorder(
ordnr NUMBER(9) PRIMARY KEY,
knr REFERENCES kund(knr),
datum DATE);
CREATE TABLE varugrupp(
vgnr NUMBER(4) PRIMARY KEY,
vgnamn VARCHAR2(30));
CREATE TABLE artikel(
artnr NUMBER(8) PRIMARY KEY,
vgnr REFERENCES varugrupp(vgnr),
artnamn VARCHAR2(25),
pris NUMBER(9,2));
CREATE TABLE orderrad(
radnr NUMBER(9) PRIMARY KEY,
ordnr REFERENCES kundorder(ordnr),
artnr REFERENCES artikel(artnr),
antal NUMBER(6));
CREATE TABLE artikelbild(
bildnr NUMBER(9) PRIMARY KEY,
artnr REFERENCES artikel(artnr),
filtyp VARCHAR2(5),
path VARCHAR2(80),
width NUMBER(4),
height NUMBER(4));

INSERT INTO kund VALUES(1,'olof','andersson','box144',79100,'falun',023,225478);
INSERT INTO kund VALUES(2,'maria','andersson','storgatan 23',79123,'falun',023,445599);
INSERT INTO kund VALUES(3,'tomas','kvist','box1',54784,'gagnef',0246,11122);
INSERT INTO kund VALUES(4,'hans','rosenboll','sommarvägen 36',78458,'borlänge',0243,228869);
INSERT INTO kund VALUES(5,'yvette','porpoix','sadelgatan 10',79100,'falun',023,147858);
INSERT INTO kund VALUES(6,'gustav','möller','box33',78547,'gustafs',0243,122099);
INSERT INTO kund VALUES(7,'zoltan','habbervic','paradisvägen 12',78523,'borlänge',0243,45877);
INSERT INTO kund VALUES(8,'lena','larsson','sandgatan 13',73100,'säter',0225,43251);
INSERT INTO kund VALUES(9,'ollas','bullas','korkhuvudvägen 1',79100,'falun',023,11477);
INSERT INTO kund VALUES(10,'roger','nyberg','soldatvägen 25',79100,'falun',023,225499);
INSERT INTO kundorder VALUES(100,1,TO_DATE('2001-02-14','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(101,4,TO_DATE('2001-02-14','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(289,4,TO_DATE('2003-03-04','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(125,2,TO_DATE('2001-05-24','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(147,3,TO_DATE('2001-12-11','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(152,5,TO_DATE('2001-12-15','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(458,6,TO_DATE('2004-05-08','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(489,6,TO_DATE('2004-06-10','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(324,10,TO_DATE('2003-08-22','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(198,9,TO_DATE('2002-01-12','YYYY-MM-DD'));
INSERT INTO kundorder VALUES(348,1,TO_DATE('2004-07-17','YYYY-MM-DD'));
INSERT INTO varugrupp VALUES(1,'skäggvård');
INSERT INTO varugrupp VALUES(2,'jakt');
INSERT INTO varugrupp VALUES(3,'bondgård');
INSERT INTO varugrupp VALUES(4,'fritid');
INSERT INTO artikel VALUES(1434,1,'trimsax deluxe',189.50);
INSERT INTO artikel VALUES(1724,1,'svampmedel',198.5);
INSERT INTO artikel VALUES(113,2,'yxa',795);
INSERT INTO artikel VALUES(1447,2,'kniv',349.5);
INSERT INTO artikel VALUES(5896,3,'grisfoder',240);
INSERT INTO artikel VALUES(5542,3,'potatisgödsel',128);
INSERT INTO artikel VALUES(1333,4,'piltavla',49.50);
INSERT INTO artikel VALUES(1888,4,'släktingsfälla',788.50);
INSERT INTO artikel VALUES(1141,4,'hängmatta',181.50);
INSERT INTO artikelbild VALUES(1,1434,'jpg','/bilder/1/',480,640);
INSERT INTO artikelbild VALUES(2,113,'jpg','/bilder/2/',480,640);
INSERT INTO artikelbild VALUES(3,5896,'jpg','/bilder/3/',480,640);
INSERT INTO artikelbild VALUES(4,1888,'gif','/bilder/4/',480,640);
INSERT INTO orderrad VALUES(1,100,1141,1);
INSERT INTO orderrad VALUES(2,101,1434,3);
INSERT INTO orderrad VALUES(3,101,1724,4);
INSERT INTO orderrad VALUES(4,289,1434,1);
INSERT INTO orderrad VALUES(5,289,1724,5);
INSERT INTO orderrad VALUES(6,125,1333,1);
INSERT INTO orderrad VALUES(7,125,1141,1);
INSERT INTO orderrad VALUES(8,147,5896,4);
INSERT INTO orderrad VALUES(9,147,5542,4);
INSERT INTO orderrad VALUES(10,152,113,2);
INSERT INTO orderrad VALUES(11,458,5896,3);
INSERT INTO orderrad VALUES(12,458,1447,1);
INSERT INTO orderrad VALUES(13,489,5542,3);
INSERT INTO orderrad VALUES(14,324,113,3);
INSERT INTO orderrad VALUES(15,324,1447,3);
INSERT INTO orderrad VALUES(16,324,1888,1);
INSERT INTO orderrad VALUES(17,198,1141,7);
INSERT INTO orderrad VALUES(18,348,113,3);
COMMIT;

-- Uppgift 1 --
select k.knr, k.fnamn, k.enamn, count(ko.ordnr) as antal_ordrar
from kund k, kundorder ko
where k.knr = ko.knr
group by k.knr, k.fnamn, k.enamn;

-- Uppgift 2 --
select knr, fnamn, enamn
from kund
where knr in(select knr
            from kundorder
            where ordnr in(select ordnr
                        from orderrad
                        where artnr in(select artnr
                                    from artikel
                                    where vgnr in(select vgnr
                                                from varugrupp
                                                where lower(vgnamn) in('bondgård', 'skäggvård')))));

-- Uppgift 3 --
select distinct k.knr, k.fnamn, k.enamn
from kund k, kundorder ko, orderrad orad, artikel a, varugrupp vg
where k.knr = ko.knr
and ko.ordnr = orad.ordnr
and orad.artnr = a.artnr
and a.vgnr = vg.vgnr
and lower(vg.vgnamn) in('bondgård', 'skäggvård');

-- Uppgift 4 --
select k.knr, k.fnamn, k.enamn, sum(a.pris * orad.antal) as summa
from kund k, artikel a, orderrad orad, kundorder ko
where k.knr = ko.knr
and ko.ordnr = orad.ordnr
and orad.artnr = a.artnr
group by k.knr, k.fnamn, k.enamn;

-- Uppgift 5 --
select k.knr, k.fnamn, k.enamn, round(sum(antal * pris), 0) as summa
from kund k, kundorder ko, orderrad orad, artikel a
where k.knr = ko.knr
and ko.ordnr = orad.ordnr
and orad.artnr = a.artnr
group by k.knr, k.fnamn, k.enamn
order by summa DESC;

-- Uppgift 6 --
select k.knr, k.fnamn, k.enamn, round(sum(antal * pris), 0) as summa
from kund k, kundorder ko, orderrad orad, artikel a
where k.knr = ko.knr
and ko.ordnr = orad.ordnr
and orad.artnr = a.artnr
having round(sum(antal * pris), 0) > 1500
group by k.knr, k.fnamn, k.enamn
order by summa DESC;

-- Uppgift 7 --
select initcap(k.fnamn) as förnamn, initcap(k.enamn) as efternamn
from kund k
where knr not in(select knr
                from kundorder);

-- Uppgift 8 --
select vg.vgnamn, max(a.pris) as dyrast
from varugrupp vg, artikel a
where a.vgnr = vg.vgnr
group by vg.vgnamn;

-- Uppgift 9
select artnr, path || bildnr || '.' || filtyp as sökväg
from artikelbild;

-- Uppgift 10 --
select distinct k.fnamn, k.enamn
from kund k, kundorder ko
where k.knr = ko.knr
and to_char(datum, 'YYYY--MM--DD') like '2004-%%-%%'
order by k.enamn ASC;

-- Extrauppgift --
select *
from
(
select orad.ordnr, sum(orad.pris * a.pris) as summa
from orderrad orad, artikel a
where orad.artnr = a.artnr
group by orad.ordnr
order by summa DESC
)
where rownum = 1;