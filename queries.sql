--------------------------------------------------------------------------------------------------------------------------------
--Abfragen
--------------------------------------------------------------------------------------------------------------------------------

--mit einer N:M Beziehung:
--gib mir alle Artikelnamen von allen Bestellungen

select
    TREAT(deref(nt.artikel) as softwareartikel_typ).softwarename as bestellter_artikel
from
    system.bestellung b, table(b.bestellungen) nt;




--rekursive Beziehung
--gib mir den Vorgänger von Spiel X

select
    vorgaenger.softwarename
from
    system.computerspiel nachfolger
join
    system.computerspiel vorgaenger
on
    vorgaenger.artikel_id = nachfolger.prequel_id
where
    nachfolger.softwarename = 'Better Game';
    --nachfolger.artikelid = 2




--Vererbung:
--Gib mir alle gekauften Artikel von Kunde X, die von Typ Computerspiel sind.

select
    TREAT(deref(nt.artikel) as computerspiel_typ).softwarename as bestellter_artikel
from
    system.bestellung b, table(b.bestellungen) nt
where
    TREAT(deref(b.kunde) as kunde_typ).kunden_id = 1;




--Aggregation:
--Gib mir alle Videospiele, die einen Publisher haben.

select
    c.softwarename
from
    system.computerspiel c
where
    c.publisher is not null;




--Komposition:
--Gib mir alle Bestelldetails der Bestellungs-ID X.

select
    b.bestell_id,
    b.bestelldatum,
    b.status,
    TREAT(deref(b.kunde) as kunde_typ).kunden_id as kunden_id,
    TREAT(TREAT(deref(b.kunde) as kunde_typ).person as person_typ).vorname || ' ' ||
    TREAT(TREAT(deref(b.kunde) as kunde_typ).person as person_typ).name as name,
    TREAT(deref(nt.artikel) as softwareartikel_typ).softwarename as bestellter_artikel
from
    system.bestellung b, table(b.bestellungen) nt
where
    b.bestell_id = 1;
