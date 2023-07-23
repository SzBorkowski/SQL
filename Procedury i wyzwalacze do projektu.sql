/*Procedura bez kursora ma za zadanie wyœwietlenie informacji o wizycie klienta w salonie.
Pobiera ona informacje o kliencie (osobie fizycznej, stad brak NIPu)
oraz o wizycie w salonie, podczas której zakupiono samochód.
Dodatkowo wyœwietla informacje o samochodzie, którego dotyczy wizyta w salonie.*/
CREATE OR REPLACE PROCEDURE wyswietl_wizyte_w_salonie AS
    v_ID_Klienta Klienci.ID_Klienta%TYPE;
    v_Imie_Nazwisko Klienci.Imie_Nazwisko%TYPE;
    v_Adres_salonu Salony_sprzedazy.Adres_salonu%TYPE;
    v_Nazwa_modelu Wyprodukowane_samochody.Nazwa_modelu%TYPE;
    v_Data_wizyty Wizyta_w_salonie.Data_wizyty%TYPE;
    v_Data_produkcji Wyprodukowane_samochody.Data_produkcji%TYPE;
    v_Przebieg_pojazdu Wizyta_w_salonie.Przebieg_pojazdu%TYPE;
BEGIN
    SELECT ID_Klienta, Imie_Nazwisko
    INTO v_ID_Klienta, v_Imie_Nazwisko
    FROM Klienci
    WHERE Numer_NIP IS NULL
    AND ROWNUM = 1;

    DBMS_OUTPUT.PUT_LINE('ID Klienta: ' || v_ID_Klienta);
    DBMS_OUTPUT.PUT_LINE('Imiê i Nazwisko: ' || v_Imie_Nazwisko);

    SELECT Adres_salonu, Nazwa_modelu, Data_wizyty, Data_produkcji, Przebieg_pojazdu
    INTO v_Adres_salonu, v_Nazwa_modelu, v_Data_wizyty, v_Data_produkcji, v_Przebieg_pojazdu
    FROM Wizyta_w_salonie w
    INNER JOIN Salony_sprzedazy s ON w.Salony_sprzedazy_ID_Salonu = s.ID_Salonu
    INNER JOIN Wyprodukowane_samochody ws ON w.VIN_pojazdu = ws.Numer_VIN
    WHERE w.Klienci_ID_Klienta = v_ID_Klienta
    AND w.Czy_kupno = 'tak'
    AND ROWNUM = 1;

    DBMS_OUTPUT.PUT_LINE('Adres salonu: ' || v_Adres_salonu);
    DBMS_OUTPUT.PUT_LINE('Nazwa modelu: ' || v_Nazwa_modelu);
    DBMS_OUTPUT.PUT_LINE('Data produkcji: ' || v_Data_produkcji);
    DBMS_OUTPUT.PUT_LINE('Przebieg pojazdu: ' || v_Przebieg_pojazdu || ' km');
    DBMS_OUTPUT.PUT_LINE('Data wizyty: ' || TO_CHAR(v_Data_wizyty, 'YYYY-MM-DD'));

    DBMS_OUTPUT.PUT_LINE('Procedura zakoñczona.');
END;

EXECUTE wyswietl_wizyte_w_salonie;



/*Procedura z kursorem - wyœwietlenie statystyk pracowników salonu sprzeda¿y.
Kursor cur_dane przechowuje dane pracowników i adresy ich salonów.
Pêtla pobieraa wartoœci z kursora i nastêpnie wartoœci te sa wyswietlane.
Pêtla konczy sie po sprawdzeniu wszystkich pracownikow.
Obliczane jest srednie wynagrodzenie i wyswietlenie statystyk nt. liczby pracownikow,
sumy wynagrodzen, sredniego wynagrodzenia.*/
CREATE OR REPLACE PROCEDURE pokaz_statystyki IS
   
   CURSOR cur_dane IS
      SELECT P.Imie_Nazwisko, P.Wynagrodzenie, S.Adres_salonu
      FROM Pracownicy_salonu P
      INNER JOIN Salony_sprzedazy S ON P.Salony_sprzedazy_ID_Salonu = S.ID_Salonu;
      
   v_Imie_Nazwisko Pracownicy_salonu.Imie_Nazwisko%TYPE;
   v_Wynagrodzenie Pracownicy_salonu.Wynagrodzenie%TYPE;
   v_Adres_salonu Salony_sprzedazy.Adres_salonu%TYPE;
   
   v_liczba_pracownikow INTEGER := 0;
   v_suma_wynagrodzen NUMBER := 0;
   v_srednie_wynagrodzenie NUMBER := 0;
BEGIN
   OPEN cur_dane;
   
   LOOP
      FETCH cur_dane INTO v_Imie_Nazwisko, v_Wynagrodzenie, v_Adres_salonu;
      EXIT WHEN cur_dane%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('Pracownik: ' || v_Imie_Nazwisko || ', Wynagrodzenie: ' || v_Wynagrodzenie || ', Salon sprzeda¿y: ' || v_Adres_salonu);
      
      v_liczba_pracownikow := v_liczba_pracownikow + 1;
      v_suma_wynagrodzen := v_suma_wynagrodzen + v_Wynagrodzenie;
   END LOOP;
   
   CLOSE cur_dane;
   
   IF v_liczba_pracownikow > 0 THEN
      v_srednie_wynagrodzenie := v_suma_wynagrodzen / v_liczba_pracownikow;
   END IF;
   
   DBMS_OUTPUT.PUT_LINE('Liczba pracowników: ' || v_liczba_pracownikow);
   DBMS_OUTPUT.PUT_LINE('Suma wynagrodzeñ: ' || v_suma_wynagrodzen);
   DBMS_OUTPUT.PUT_LINE('Œrednie wynagrodzenie: ' || v_srednie_wynagrodzenie);
   
END;

EXECUTE pokaz_statystyki;



/*Wyzwalacz sprawdzajacy czy dodawany pracownik ma prawidlowo przypisana funkcje.*/
SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER handlowiec_lub_mechanik
BEFORE INSERT ON s26076.pracownicy_salonu
FOR EACH ROW
DECLARE
    zla_posada EXCEPTION;
    can_insert BOOLEAN := TRUE;
BEGIN
    IF :NEW.czy_handlowiec = 'tak' AND :NEW.czy_mechanik = 'tak' THEN
        RAISE_APPLICATION_ERROR(-20000, 'Pracownik nie mo¿e byæ jednoczeœnie handlowcem i mechanikiem.');
    END IF;
    IF :NEW.czy_handlowiec = 'nie' AND :NEW.czy_mechanik = 'nie' THEN
        RAISE_APPLICATION_ERROR(-20000, 'Pracownik musi byæ handlowcem lub mechanikiem');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Pracownik zostal wpisany do bazy.');
END;

INSERT INTO pracownicy_salonu(imie_nazwisko, czy_handlowiec, czy_mechanik)
VALUES ('Kamil Mango', 'tak', 'tak');
INSERT INTO pracownicy_salonu(imie_nazwisko, czy_handlowiec, czy_mechanik)
VALUES ('Michal Mango', 'nie', 'nie');
INSERT INTO pracownicy_salonu(imie_nazwisko, czy_handlowiec, czy_mechanik)
VALUES ('Karol Mango', 'tak', 'nie');
INSERT INTO pracownicy_salonu(imie_nazwisko, czy_handlowiec, czy_mechanik)
VALUES ('Fraanek Mango', 'nie', 'tak');

/*Ten wyzwalacz zostanie uruchomiony przed kazdym wstawieniem lub aktualizacja wiersza w tabeli.
Sprawdza on ilosc stanowisk serwisowych w salonie i ilosc wizyt w poprzednich 3 dniach.
Dziennie na stanowisku mozna obsluzyc maks. 2 samochody, wiec jesli ilosc stanowisk*3*2
bedzie mniejsze od liczby wizyt, pojawi sie blad mowiacy o przeciazeniu salonu i potrzebie rozbudowania go.*/
CREATE OR REPLACE TRIGGER sprawdz_wizyte
BEFORE INSERT OR UPDATE ON Wizyta_w_salonie
FOR EACH ROW
DECLARE
  v_salon_stanowiska Salony_sprzedazy.Ilosc_stanowisk_serwisowych%TYPE;
  v_count NUMBER;
BEGIN
  SELECT Ilosc_stanowisk_serwisowych INTO v_salon_stanowiska
  FROM Salony_sprzedazy
  WHERE ID_Salonu = :NEW.Salony_sprzedazy_ID_Salonu;

  IF INSERTING THEN
    SELECT COUNT(*) INTO v_count
    FROM Wizyta_w_salonie
    WHERE Salony_sprzedazy_ID_Salonu = :NEW.Salony_sprzedazy_ID_Salonu
    AND Czy_serwis = 'tak'
    AND Data_wizyty >= SYSDATE - 3;

 DBMS_OUTPUT.PUT_LINE(v_count);
    IF v_count+1 > v_salon_stanowiska*6 THEN
      RAISE_APPLICATION_ERROR(-20000, 'Przekroczono iloœæ wizyt serwisowych w salonie w ci¹gu ostatnich 3 dni.');
    END IF;
  END IF;

  IF UPDATING THEN
    SELECT COUNT(*) INTO v_count
    FROM Wizyta_w_salonie
    WHERE Salony_sprzedazy_ID_Salonu = :NEW.Salony_sprzedazy_ID_Salonu
    AND Czy_serwis = 'tak'
    AND Data_wizyty >= SYSDATE - 3;

    IF v_count+1 > v_salon_stanowiska*6 THEN
      RAISE_APPLICATION_ERROR(-20000, 'Po aktualizacji przekroczono iloœæ wizyt serwisowych w salonie w ci¹gu ostatnich 3 dni.');
    END IF;
  END IF;

END;

/*Salon 2 ma jedno stanowisko, wiêc aby sprawdziæ wyzwalacz, nale¿y przypisaæ mu
wiêcej ni¿ 6 wizyt serwisowych w ciagu ostatnich 3 dni.*/
INSERT INTO wizyta_w_salonie(klienci_id_klienta, salony_sprzedazy_id_salonu, data_wizyty, czy_kupno, czy_serwis)
VALUES(1, 2, '2023/06/17', 'nie', 'tak');
INSERT INTO wizyta_w_salonie(klienci_id_klienta, salony_sprzedazy_id_salonu, data_wizyty, czy_kupno, czy_serwis)
VALUES(2, 2, '2023/06/18', 'nie', 'tak');
INSERT INTO wizyta_w_salonie(klienci_id_klienta, salony_sprzedazy_id_salonu, data_wizyty, czy_kupno, czy_serwis)
VALUES(3, 2, '2023/06/16', 'nie', 'tak');
INSERT INTO wizyta_w_salonie(klienci_id_klienta, salony_sprzedazy_id_salonu, data_wizyty, czy_kupno, czy_serwis)
VALUES(4, 2, '2023/06/17', 'nie', 'tak');
INSERT INTO wizyta_w_salonie(klienci_id_klienta, salony_sprzedazy_id_salonu, data_wizyty, czy_kupno, czy_serwis)
VALUES(3, 2, '2023/06/16', 'nie', 'tak');
INSERT INTO wizyta_w_salonie(klienci_id_klienta, salony_sprzedazy_id_salonu, data_wizyty, czy_kupno, czy_serwis)
VALUES(1, 2, '2023/06/18', 'nie', 'tak');
INSERT INTO wizyta_w_salonie(klienci_id_klienta, salony_sprzedazy_id_salonu, data_wizyty, czy_kupno, czy_serwis)
VALUES(2, 2, '2023/06/17', 'nie', 'tak');
SELECT * FROM wizyta_w_salonie;
SELECT * FROM salony_sprzedazy;
ROLLBACK;