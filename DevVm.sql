BEGIN
    EXECUTE IMMEDIATE 'drop Table SYSTEM.KUNDE';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'drop Table SYSTEM.ENTWICKLER';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Table SYSTEM.SOFTWAREARTIKEL';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Table SYSTEM.WARENKORBEINTRAG';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Table SYSTEM.PUBLISHER';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Table SYSTEM.BESTELLUNG';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type BESTELLUNGSEINTRAEGE_NT_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type STANDORT_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type STANDORT_LISTE_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type ENTWICKLER_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type KUNDE_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type SOFTWAREARTIKEL_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type Computerspiel_typ force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type Anwendungssoftware_typ force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type BESTELLEINTRAEGE_NT_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type BESTELLEINTRAG_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type PERSON_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type WARENKORBEINTRAG_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type PUBLISHER_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type BESTELLUNG_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop Type BESTELLEINTRAG_TYP force';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
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

Create Type Publisher_typ as Object (
    PublisherID int,
    Firmenname varchar(30),
    Standorte Standort_liste_typ
);

/

Create Type Computerspiel_typ under Softwareartikel_typ (
    Altersbegrenzung integer,
    Genre varchar(30),
    SequelID integer,
    Publisher REF Publisher_typ
);

/

Create Type Anwendungssoftware_typ under Softwareartikel_typ (
    Lizenz varchar(30)    
);

/

Create Type Bestelleintrag_typ as Object (
    Artikel REF Softwareartikel_typ,
    Anzahl int,
    Einzelpreis double precision
);

/

CREATE TYPE BESTELLUNGSEINTRAEGE_NT_TYP AS TABLE OF Bestelleintrag_typ;

/

Create Type Bestellung_typ as Object (
    BestellID int,
    Kunde REF Kunde_typ,
    Bestelldatum Date,
    Status varchar(30),
    Bestellungen BESTELLUNGSEINTRAEGE_NT_TYP
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

Create Table SYSTEM.PUBLISHER OF Publisher_typ (
    PublisherID PRIMARY KEY
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

Create Table SYSTEM.BESTELLUNG OF Bestellung_typ (
    BestellID PRIMARY KEY
) NESTED TABLE
    Bestellungen STORE AS BESTELLEINTRAEGE_TAB; 

/


--SELECT TREAT(PERSON as PERSON_TYP).NAME FROM KUNDE

--SELECT k.Kundennummer, n.* FROM Kunde k, TABLE(Standorte) n;

--SELECT n.*, s.* FROM Kunde k, Entwickler e, TABLE(e.Standorte) n, TABLE(k.Standorte) s;

