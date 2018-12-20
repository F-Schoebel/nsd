drop Table SYSTEM.KUNDE;
drop Table SYSTEM.ENTWICKLER;
drop Table SYSTEM.SOFTWAREARTIKEL;
drop Table SYSTEM.WARENKORBEINTRAG;
drop Type STANDORT_TYP force;
drop Type STANDORT_LISTE_TYP force;
drop Type ENTWICKLER_TYP force;
drop Type KUNDE_TYP force;
drop Type SOFTWAREARTIKEL_TYP force;
drop Type Computerspiel_typ force;
drop Type Anwendungssoftware_typ force;
drop Type PERSON_TYP force;
drop Type WARENKORBEINTRAG_TYP force;


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

Create Type Kunde_typ as Object (
    KundenNr int,
    Person Person_typ,
    Standorte Standort_liste_typ
);

/

Create Type Entwickler_typ as Object (
    EntwicklerID int,
    Firmenname varchar(30),
    Person Person_typ,
    Standorte Standort_liste_typ
);

/

Create Type Softwareartikel_typ as Object (
    ArtikelID integer,
    Entwickler REF Entwickler_typ,
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

Create Type Warenkorbeintrag_typ as Object (
    EintragID int,
    Anzahl int,
    Artikel REF Softwareartikel_typ,
    Kunde REF Kunde_typ
);

/

Create Table SYSTEM.KUNDE OF Kunde_typ (
    KundenNr PRIMARY Key
); 

/

Create Table SYSTEM.ENTWICKLER OF Entwickler_typ (
    EntwicklerID PRIMARY KEY
); 

/

Create Table SYSTEM.SOFTWAREARTIKEL (
    ArtikelID Integer PRIMARY KEY,
    Softwareartikel Softwareartikel_typ
); 

/

Create Table SYSTEM.WARENKORBEINTRAG OF Warenkorbeintrag_typ (
    EintragID PRIMARY KEY 
); 

/


--SELECT TREAT(PERSON as PERSON_TYP).NAME FROM KUNDE

--SELECT k.Kundennummer, n.* FROM Kunde k, TABLE(Standorte) n;

--SELECT n.*, s.* FROM Kunde k, Entwickler e, TABLE(e.Standorte) n, TABLE(k.Standorte) s;

