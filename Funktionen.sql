--------------------------------------------------------------------------------------------------------------------------------
--Funktionen und Prozeduren
--------------------------------------------------------------------------------------------------------------------------------

--Fügt einen Artikel dem Warenkorb eines Kunden hinzu. 
--Wenn bereits einer vorhanden ist, wird dieser um 1 erhöeht.
--Wenn noch dieser Artikel noch nicht im Warenkorb enthalten ist, wird er mit der Anzahl 1 eingefügt.

create or replace procedure add_article 
    (article_id in integer, kunden_id in integer) 
as
    article_count number;
    waren_id number;
begin
    begin
    select 
        w.anzahl, w.warenkorbeintragid into article_count, waren_id
    from
        system.warenkorbeintrag w
    where
        treat(deref(w.kunde) as kunde_typ).kundenid = kunden_id
    and
        treat(deref(w.artikel) as softwareartikel_typ).artikelid = article_id;
        
    exception
      when no_data_found then
        article_count := 0;
        waren_id := 0;
    end;
    
    if article_count >= 1 then
        update
            warenkorbeintrag w
        set
            w.anzahl = w.anzahl+1
        where
            w.warenkorbeintragid = waren_id;
    else 
        insert into system.warenkorbeintrag values
        (       
            warenkorbeintrag_typ
            ( 
                (select max(warenkorbeintragid)+1 from warenkorbeintrag),
                1,
                (
                    select
                        ref(p) 
                    from
                        system.computerspiel p
                    where
                        p.artikelid = article_id
                ),
                (
                    select 
                        ref(p)
                    from
                        system.kunde p
                    where
                        p.kundenid = kunden_id
                )
            )
        );
    end if;
end;

/

--Entfernt einen Artikel aus dem Warenkorb eines Kunden 
--Wenn mehrere von einem Typ enthalten sind, wird dieser um 1 verringert.
--Wenn nurnoch 1 Artikel von diesem typ enthalten ist, wird dieser komplett entfernt

create or replace procedure remove_article 
    (article_id in integer, kunden_id in integer) 
as
    article_count number;
    waren_id number;
begin
    begin
    select 
        w.anzahl, w.warenkorbeintragid into article_count, waren_id
    from
        system.warenkorbeintrag w
    where
        treat(deref(w.kunde) as kunde_typ).kundenid = kunden_id
    and
        treat(deref(w.artikel) as softwareartikel_typ).artikelid = article_id;
        
    exception
      when no_data_found then
        article_count := 0;
        waren_id := 0;
    end;
    
    if article_count >= 2 then
        update
            warenkorbeintrag w
        set
            w.anzahl = w.anzahl-1
        where
            w.warenkorbeintragid = waren_id;
    elsif article_count = 1 then
        delete
        from
            warenkorbeintrag
        where
            warenkorbeintragid = waren_id;
    end if;
end;
