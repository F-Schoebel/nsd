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
    kundenid int,
    person person_typ,
    standorte standort_liste_typ
);

/

create type entwickler_typ as object (
    entwicklerid int,
    firmenname varchar(30),
    person person_typ,
    standorte standort_liste_typ
);

/

create type softwareartikel_typ as object (
    artikelid int,
    entwickler ref entwickler_typ,
    softwarename varchar(50),
    einzelpreis double precision,
    erscheinungsdatum date
)not final;

/

create type publisher_typ as object (
    publisherid int,
    firmenname varchar(30),
    standorte standort_liste_typ
);

/

create type computerspiel_typ under softwareartikel_typ (
    altersbegrenzung integer,
    genre varchar(30),
    prequelid integer,
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
    bestellid int,
    kunde ref kunde_typ,
    bestelldatum date,
    status varchar(30),
    bestellungen bestelleintraege_nt_typ
);

/

create type warenkorbeintrag_typ as object (
    warenkorbeintragid int,
    anzahl int,
    artikel ref softwareartikel_typ,
    kunde ref kunde_typ
);

/

create table system.kunde of kunde_typ (
    kundenid primary key
);

/

create table system.entwickler of entwickler_typ (
    entwicklerid primary key
);

/

create table system.publisher of publisher_typ (
    publisherid primary key
);

/

create table system.computerspiel of computerspiel_typ (
    artikelid primary key
);

/

create table system.anwendungssoftware of anwendungssoftware_typ (
    artikelid primary key
);

/

create table system.warenkorbeintrag of warenkorbeintrag_typ (
    warenkorbeintragid primary key
);

/

create table system.bestellung of bestellung_typ (
    bestellid primary key
) nested table
    bestellungen store as bestelleintraege_tab;

/

--------------------------------------------------------------------------------------------------------------------------------
--Inhalt / Kontent
--------------------------------------------------------------------------------------------------------------------------------

insert into system.kunde values
(       
    kunde_typ
    ( 
        1,
        person_typ
        (
            'Leo', 
            'Tobisch', 
            to_date('10.01.1993', 'dd.mm.yyyy'),    
            'leo@w-hs.de', 
            '0905 666666', 
            '123456'
        ), 
        standort_liste_typ
        (
            standort_typ
            (
                'Deutschland',
                'Gelsenkirchen',
                '12345',
                'supernstrasse',
                '434'
            )
        )
    )
);

/

insert into system.publisher values
(       
    publisher_typ
    ( 
        1,
        'Bubisoft',
        standort_liste_typ
        (
            standort_typ
            (
                'Deutschland',
                'Berlin',
                '75648',
                'Bubisoftstraße',
                '21'
            ),
            standort_typ
            (
                'Belgien',
                'Brüssel',
                '92046',
                'Gropplerstraße',
                '87'
            )
        )    
    )
);

/

insert into system.entwickler values
(       
    entwickler_typ
    ( 
        1,
        'Super-inc',
        person_typ
        (
            'Flo', 
            'Smith', 
            to_date('22.02.1993', 'dd.mm.yyyy'),    
            'flo@w-hs.de', 
            '0905 666666', 
            '123456'
        ), 
        standort_liste_typ
        (
            standort_typ
            (
                'Deutschland',
                'Gelsenkirchen',
                '12345',
                'superstrasse',
                '431'
            )
        )
    )
);

/

insert into system.computerspiel values
(       
    computerspiel_typ
    ( 
        1,
        (
            select
                ref(p) 
            from
                system.entwickler p
            where
                p.entwicklerid = 1
        ),
        'Red Dead Leo',
        59.99,
        to_date('10.02.2018','DD.MM.YYYY'),
        18,
        'Shooter',
        null,
        (
            select 
                ref(p)
            from
                system.publisher p
            where
                p.publisherid = 1
        )
    )
);

/

insert into system.computerspiel values
(       
    computerspiel_typ
    ( 
        2,
        (
            select
                ref(p) 
            from
                system.entwickler p
            where
                p.entwicklerid = 1
        ),
        'Red Dead Leo 2',
        59.99,
        to_date('05.01.2019','DD.MM.YYYY'),
        18,
        'Shooter',
        1,
        (
            select 
                ref(p)
            from
                system.publisher p
            where
                p.publisherid = 1
        )
    )
);

/

insert into system.warenkorbeintrag values
(       
    warenkorbeintrag_typ
    ( 
        1,
        2,
        (
            select
                ref(p) 
            from
                system.computerspiel p
            where
                p.artikelid = 1
        ),
        (
            select 
                ref(p)
            from
                system.kunde p
            where
                p.kundenid = 1
        )
    )
);

/

insert into system.bestellung values
(       
    bestellung_typ
    ( 
        1,
        (
            select
                ref(p) 
            from
                system.kunde p
            where
                p.kundenid = 1
        ),
        to_date('16.01.2019', 'DD.MM.YYYY'),
        'erhalten',
        bestelleintraege_nt_typ
        (
            bestelleintrag_typ
            (
                (
                    select
                        ref(p)
                    from
                        system.computerspiel p
                    where
                        p.artikelid = 1
                ),
                1,
                59.99
            ),
            bestelleintrag_typ
            (
                (
                    select
                        ref(p)
                    from
                        system.computerspiel p
                    where
                        p.artikelid = 2
                ),
                1,
                59.50
            )            
        )
    )
);

/

insert into system.anwendungssoftware values
(       
    anwendungssoftware_typ
    ( 
        3,
        (
            select
                ref(p) 
            from
                system.entwickler p
            where
                p.entwicklerid = 1
        ),
        'Cheattool xy',
        10.00,
        to_date('12.03.2018','DD.MM.YYYY'),
        'unbegrenzt'
    )
);


--select treat(person as person_typ).name from kunde

--select k.kundennummer, n.* from kunde k, table(standorte) n;

--select n.*, s.* from kunde k, entwickler e, table(e.standorte) n, table(k.standorte) s;
