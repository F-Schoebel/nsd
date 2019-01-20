--------------------------------------------------------------------------------------------------------------------------------
--Tabellen- und Typerstellung
--------------------------------------------------------------------------------------------------------------------------------

begin
    execute immediate 'drop table system.kunde';
exception
    when others then null;
end;
/

begin
    execute immediate 'drop table system.entwickler';
exception
    when others then null;
end;
/

begin
  execute immediate 'drop table system.anwendungssoftware';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop table system.computerspiel';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop table system.warenkorbeintrag';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop table system.publisher';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop table system.bestellung';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type bestellungseintraege_nt_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type standort_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type standort_liste_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type entwickler_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type kunde_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type softwareartikel_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type computerspiel_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type anwendungssoftware_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type bestelleintraege_nt_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type bestelleintrag_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type person_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type warenkorbeintrag_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type publisher_typ force';
exception
  when others then null;
end;
/

begin
  execute immediate 'drop type bestellung_typ force';
exception
  when others then null;
end;
/

create type person_typ as object (
    vorname varchar(30),
    name varchar(30),
    geburtsdatum date,
    email varchar(30),
    telefonnummer varchar(30),
    iban varchar(20)
);

/

create type standort_typ as object (
    land varchar(50),
    stadt varchar(50),
    plz varchar(10),
    strasse varchar(50),
    hausnr varchar(10)
);

/

create type standort_liste_typ as varray(5)of standort_typ;

/

create type kunde_typ as object (
    kunden_id int,
    person person_typ,
    standorte standort_liste_typ
);

/

create type entwickler_typ as object (
    entwickler_id int,
    firmenname varchar(30),
    person person_typ,
    standorte standort_liste_typ
);

/

create type softwareartikel_typ as object (
    artikel_id int,
    entwickler ref entwickler_typ,
    softwarename varchar(50),
    einzelpreis double precision,
    erscheinungsdatum date
)not final;

/

create type publisher_typ as object (
    publisher_id int,
    firmenname varchar(30),
    standorte standort_liste_typ
);

/

create type computerspiel_typ under softwareartikel_typ (
    altersbegrenzung integer,
    genre varchar(30),
    prequel_id integer,
    publisher ref publisher_typ
);

/

create type anwendungssoftware_typ under softwareartikel_typ (
    lizenz varchar(30)
);

/

create type bestelleintrag_typ as object (
    artikel ref softwareartikel_typ,
    anzahl int,
    einzelpreis double precision
);

/

create type bestelleintraege_nt_typ as table of bestelleintrag_typ;

/

create type bestellung_typ as object (
    bestell_id int,
    kunde ref kunde_typ,
    bestelldatum date,
    status varchar(30),
    bestellungen bestelleintraege_nt_typ
);

/

create type warenkorbeintrag_typ as object (
    warenkorbeintrag_id int,
    anzahl int,
    artikel ref softwareartikel_typ,
    kunde ref kunde_typ
);

/

create table system.kunde of kunde_typ (
    kunden_id primary key
);

/

create table system.entwickler of entwickler_typ (
    entwickler_id primary key
);

/

create table system.publisher of publisher_typ (
    publisher_id primary key
);

/

create table system.computerspiel of computerspiel_typ (
    artikel_id primary key
);

/

create table system.anwendungssoftware of anwendungssoftware_typ (
    artikel_id primary key
);

/

create table system.warenkorbeintrag of warenkorbeintrag_typ (
    warenkorbeintrag_id primary key
);

/

create table system.bestellung of bestellung_typ (
    bestell_id primary key
) nested table
    bestellungen store as bestelleintraege_tab;

/
