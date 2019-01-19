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
