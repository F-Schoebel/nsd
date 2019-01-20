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
    temp_value number; --speichern einer computerspielvariable um zu prüfen, ob es sich um ein computerspiel oder anwendungssoftware handelt.
    next_id number;
begin
    --ermittelt die nächste warenkrobid.
    begin
        select max(warenkorbeintragid)+1 into next_id from system.warenkorbeintrag;
    end;
    if next_id is null then
        next_id := 1;
    end if;    
    --erkennt, ob der gewollte artikel bereits im Warenkorb des Kunden enthalten ist, wenn ja, dann wird die Warenid und anzahl gespeichert
    begin
        select 
            w.anzahl, w.warenkorbeintragid 
        into 
            article_count, waren_id
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
    --erkennt ob es sich um ein computerspiel oder anwendungssoftware handelt und speichert dies in temp_value ab.
    begin
        select 
            c.altersbegrenzung 
        into 
            temp_value
        from
            system.computerspiel c
        where
            c.artikelid = article_id;            
        exception
          when no_data_found then
            temp_value := -1;
    end;
    
    if article_count >= 1 then
        update
            warenkorbeintrag w
        set
            w.anzahl = w.anzahl+1
        where
            w.warenkorbeintragid = waren_id;
    elsif temp_value = -1 then  
        insert into system.warenkorbeintrag values
        (       
            warenkorbeintrag_typ
            ( 
                next_id,
                1,
                (
                    select
                        ref(p) 
                    from
                        system.anwendungssoftware p 
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
    --wird geprüft, ob der käufer alt genug für das Videospiel ist.
    elsif temp_value < calculate_age(kunden_id) then
        insert into system.warenkorbeintrag values
        (       
            warenkorbeintrag_typ
            ( 
                next_id,
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

/

--berechnet das Alter eines Kunden um prüfen zu können, ob die Person das gewollte Spiel kaufen kann.

create or replace function calculate_age
    (kunden_id in integer)
    return number
is
    age number;
begin
    select 
        trunc(months_between(sysdate, TREAT(k.person as person_typ).geburtsdatum))/12 
    into
        age
    from
        system.kunde k
    where
        k.kundenid = kunden_id;
    return age;
end;
