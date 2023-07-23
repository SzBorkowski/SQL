--Podzapytanie zwyk쿮 w warunku where #1
--Znalezc pracownikow salonow z pensja rowna najwiekszemu zarobkowi wsrod pracownikow salonow.
SELECT imie_nazwisko, wynagrodzenie
FROM pracownicy_salonu
WHERE wynagrodzenie =
    (SELECT MAX(wynagrodzenie)
    FROM pracownicy_salonu);
    
--Podzapytanie zwyk쿮 w warunku where #2
--Znalezc pracownikow, ktorzy pracuja w tej samej fabryce co Krystian Komin.
SELECT imie_nazwisko
FROM pracownicy_fabryki
WHERE imie_nazwisko != 'Krystian Komin' AND fabryki_id_fabryki =
    (SELECT fabryki_id_fabryki
    FROM pracownicy_fabryki
    WHERE imie_nazwisko = 'Krystian Komin');
    
--Podzapytanie zwykle z podzapytaniem w klauzuli from #1
--Wybierz pracownikow fabryk, ktorzy zarabiaja wiecej niz srednia w ich fabryce.
SELECT pracownicy_fabryki.fabryki_id_fabryki, imie_nazwisko, wynagrodzenie, srednia_wyplata
FROM pracownicy_fabryki,
    (SELECT fabryki_id_fabryki, ROUND(AVG(wynagrodzenie),2) srednia_wyplata
    FROM pracownicy_fabryki
    GROUP BY fabryki_id_fabryki) temp
WHERE pracownicy_fabryki.fabryki_id_fabryki = temp.fabryki_id_fabryki AND wynagrodzenie > srednia_wyplata;

--Podzapytanie zwykle z podzapytaniem w klauzuli from #2
--Wybierz trzy modele samochodow, ktore zostaly wyprodukowane najwiecej razy, wraz z iloscia wyprodukowanych egzemplarzy dla kazdego modelu.
SELECT *
FROM (
    SELECT Nazwa_modelu, COUNT(*) ilosc_samochodow
    FROM Wyprodukowane_samochody
    GROUP BY Nazwa_modelu
    ORDER BY ilosc_samochodow DESC) tabela_ilosci_samochodow
WHERE ROWNUM <= 3;


--Podzapytanie zwyk쿮 w warunku having #1
--Znalezc salon, w ktorym sa najwyzsze srednie zarobki.
SELECT salony_sprzedazy_id_salonu, AVG(wynagrodzenie)
FROM pracownicy_salonu
GROUP BY salony_sprzedazy_id_salonu
HAVING AVG(wynagrodzenie) =
    (SELECT MAX(AVG(wynagrodzenie))
    FROM pracownicy_salonu
    GROUP BY salony_sprzedazy_id_salonu);

--Podzapytanie zwyk쿮 w warunku having #2
--Wybierz klientow, ktorzy odwiedzili salon w celu kupna samochodu wiecej niz tylko jednego dnia.
SELECT imie_nazwisko, COUNT(*) liczba_odwiedzin
FROM wizyta_w_salonie, klienci
WHERE klienci.id_klienta = wizyta_w_salonie.klienci_id_klienta AND czy_kupno = 'tak'
GROUP BY imie_nazwisko
HAVING COUNT(DISTINCT data_wizyty) > 1;

--Podzapytanie skorelowane z podzapytaniem w klauzuli where #1
--Znalezc pracownikow fabryk, ktorzy zarabiaja najwiecej w danej fabryce.
SELECT imie_nazwisko, fabryki_id_fabryki, wynagrodzenie
FROM pracownicy_fabryki pf
WHERE wynagrodzenie =
    (SELECT MAX(wynagrodzenie)
    FROM pracownicy_fabryki
    WHERE fabryki_id_fabryki = pf.fabryki_id_fabryki);
    
--Podzapytanie skorelowane z podzapytaniem w klauzuli where #2
--Znalezc 3 najlepiej zarabiajacych pracownikow salonow.
SELECT imie_nazwisko, wynagrodzenie
FROM pracownicy_salonu ps
WHERE 3 >
    (SELECT COUNT(*)
    FROM pracownicy_salonu
    WHERE ps.wynagrodzenie < wynagrodzenie)
    ORDER BY wynagrodzenie DESC;
    
--Podzapytanie skorelowane z podzapytaniem w warunku having #1
--Podaj salony sprzedazy, w ktorych liczba wizyt przekracza srednia liczbe wizyt we wszystkich salonach
SELECT Salony_sprzedazy_ID_Salonu, COUNT(*) as liczba_wizyt
FROM Wizyta_w_salonie
GROUP BY Salony_sprzedazy_ID_Salonu
HAVING COUNT(*) >
    (SELECT AVG(liczba_wizyt)
    FROM
        (SELECT Salony_sprzedazy_ID_Salonu, COUNT(*) liczba_wizyt
        FROM Wizyta_w_salonie
        GROUP BY Salony_sprzedazy_ID_Salonu)
        temp);