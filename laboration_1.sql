-- Uppgift 1: Skapa en sekvens --

create sequence myseq
start with 1
increment by 1;

-- Uppgift 2: Skapa tabeller --

-- Tabell KUND --
create table KUND (
    persnr varchar2(13), -- PK -- 
    username varchar2(16) NOT NULL, 
    passwd varchar2(16) NOT NULL, 
    fnamn varchar2(50) NOT NULL, 
    enamn varchar2(50) NOT NULL, 
    kredittyp varchar2(10) NOT NULL, 
    telnr varchar2(20) 
);

alter table KUND 
add constraint kund_persnr_PK primary key(persnr) 
add constraint kund_kredittyp_CK check(kredittyp in('hög', 'medel', 'låg')) 
add constraint kund_username_UQ unique(username);

-- Tabell KUNDORDER --
create table KUNDORDER ( 
    ordnr number(10), -- PK -- 
    persnr varchar2(13) NOT NULL, -- FK -- 
    datum date default sysdate NOT NULL 
);

alter table KUNDORDER
add constraint kundorder_ordnr_PK primary key(ordnr) 
add constraint kundorder_persnr_FK foreign key(persnr) references KUND(persnr);

-- Tabell VARUGRUPP --
create table VARUGRUPP ( 
    vgnr number(10), -- PK -- 
    vgnamn varchar(60) NOT NULL 
);

alter table VARUGRUPP
add constraint varugrupp_vgnr_PK primary key(vgnr);

-- Tabell ARTIKEL --
create table ARTIKEL (
    artnr number(10), -- PK -- 
    vgnr number(10) NOT NULL, -- FK -- 
    artnamn varchar2(50) NOT NULL, 
    pris number(6,2) NOT NULL 
);

alter table ARTIKEL
add constraint artikel_artnr_PK primary key(artnr) 
add constraint artikel_vgnr_FK foreign key(vgnr) references VARUGRUPP(vgnr);

-- Tabell KUNDVAGN --
create table KUNDVAGN (
    radnr number(5), -- PK -- 
    ordnr number(10) NOT NULL, -- FK -- 
    artnr number(10) NOT NULL, -- FK -- 
    antal number(3) NOT NULL 
);

alter table KUNDVAGN
add constraint kundvagn_radnr_PK primary key(radnr) 
add constraint kundvagn_ordnr_FK foreign key(ordnr) references KUNDORDER(ordnr) 
add constraint kundvagn_artnr_FK foreign key(artnr) references ARTIKEL(artnr);

-- Tabell ARTIKELBILD --
create table ARTIKELBILD (
    bildnr number(10), -- PK -- 
    artnr number(10) NOT NULL, -- FK -- 
    filtyp varchar2(3) NOT NULL, 
    width number(5) NOT NULL, 
    height number(5) NOT NULL, 
    path varchar2(255) NOT NULL 
);

alter table ARTIKELBILD 
add constraint artikelbild_bildnr_PK primary key(bildnr) 
add constraint artikelbild_filtyp_CK check(filtyp in('gif', 'jpg')) 
add constraint artikelbild_artnr_FK foreign key(artnr) references ARTIKEL(artnr);

-- Uppgift 3: Lägg till tre rader i tabellen kund --

insert into KUND(persnr, username, passwd, fnamn, enamn, kredittyp, telnr)
values('010812-2854', 'h20phisi', 'monkey123', 'Philip', 'Sinnott', 'hög', 0737582339);

insert into KUND(persnr, username, passwd, fnamn, enamn, kredittyp, telnr)
values('920403-5933', 'h20matka', 'din_mamma', 'Mattias', 'Karlsson', 'medel', 0731893843);

insert into KUND(persnr, username, passwd, fnamn, enamn, kredittyp, telnr)
values('990209-3718', 'h20karja', 'swag_i_skogen', 'Karl', 'Jablonski', 'låg', 0762835991);

commit;

-- Uppgift 4: Lägg till två rader i tabellen varugrupp --

insert into VARUGRUPP
values(10005032, 'Stationära datorer');

insert into VARUGRUPP
values(10005033, 'Laptops');


-- Uppgift 5: Lägg till tre rader i tabellen artikel --

insert into ARTIKEL
values(5000, 10005032, 'ABC123-123', 3790);

insert into ARTIKEL
values(21300, 10005032, 'ABC123-124', 179);

insert into ARTIKEL
values(21305, 10005033, 'ABC143-731', 49);

-- Uppgift 6: Genomför en försäljning genom att skapa en rad i tabellen kundorder och två rader i tabellen kundvagn --

insert into KUNDORDER(ordnr, persnr)
values(myseq.nextval, '010812-2854');

insert into KUNDVAGN(radnr, ordnr, artnr, antal)
values(myseq.nextval, 1, 5000, 3);

insert into KUNDVAGN(radnr, ordnr, artnr, antal)
values(myseq.nextval, 1, 21305, 1);

-- Uppgift 7: Höj priset på alla artiklar med 23 % --

update ARTIKEL
set pris = pris * 1.23; -- Kom ihåg commit; när man håller på med Transaktioner

-- Uppgift 8: Uppdatera telefonnummer för en valfri kund --

select * from KUND

update KUND
set telnr = '0732718374'
where persnr = '990209-3718';
commit;

-- Uppgift 9: Ta bort alla rader ur tabellen kundorder! --

delete * from KUNDORDER -- Går ej, felmeddelande brott mot referensintegritet.

-- Uppgift 10: Ta bort alla databasobjekt som du skapat under labben (tabeller och en sekvens) --

drop table KUNDVAGN;
drop table KUNDORDER;
drop table KUND;
drop table ARTIKELBILD;
drop table ARTIKEL;
drop table VARUGRUPP;
drop sequence myseq;