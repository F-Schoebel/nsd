drop Table SYSTEM.KUNDE;
drop Table SYSTEM.ENTWICKLER;
drop Table SYSTEM.SOFTWAREARTIKEL;
drop Type STANDORT_TYP force;
drop Type STANDORT_LISTE_TYP force;
drop Type SOFTWAREARTIKEL_TYP force;
drop Type Computerspiel_typ force;
drop Type Anwendungssoftware_typ force;
drop Type PERSON_TYP force;


Create Type Standort_typ as Object (
    LAND varchar(50),
    STADT varchar(50),
    PLZ varchar(10),
    STRASSE varchar(50),
    HAUSNR varchar(10)
);

/

Create Type Standort_liste_typ as VARRAY(5)of Standort_typ; 

/

Create Type Person_typ as Object (
    VORNAME varchar(30),
    NAME varchar(30),
    GEBURTSDATUM date,
    EMAIL varchar(30),
    TELEFONNUMMER varchar(30),
    IBAN varchar(20)
);

/

Create Table SYSTEM.KUNDE (
    KundenID Integer PRIMARY KEY,
    Person Person_typ,
    Standorte Standort_liste_typ
); 

/

Create Table SYSTEM.ENTWICKLER (
    EntwicklerID Integer PRIMARY KEY,
    Name varchar(30),
    Standorte Standort_liste_typ
); 

/

Create Type Softwareartikel_typ as Object (
    EntwicklerID integer,
    SOFTWARENAME varchar(50),
    EINZELPREIS double precision,
    ERSCHEINUNGSDATUM date
)NOT FINAL;

/

Create Type Computerspiel_typ under Softwareartikel_typ (
    Altersbegrenzung integer,
    Genre varchar(30),
    SequelID integer    
);

/

Create Type Anwendungssoftware_typ under Softwareartikel_typ (
    Lizenz varchar(30)    
);

/

Create Table SYSTEM.SOFTWAREARTIKEL (
    ArtikelID Integer PRIMARY KEY,
    Softwareartikel Softwareartikel_typ
); 

/


--SELECT TREAT(PERSON as PERSON_TYP).NAME FROM KUNDE

--SELECT k.Kundennummer, n.* FROM Kunde k, TABLE(Standorte) n;

--SELECT n.*, s.* FROM Kunde k, Entwickler e, TABLE(e.Standorte) n, TABLE(k.Standorte) s;

