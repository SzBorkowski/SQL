--CREATE
CREATE TABLE Fabryki (
    ID_Fabryki integer  NOT NULL,
    Adres_fabryki varchar2(50)  NOT NULL,
    CONSTRAINT Fabryki_pk PRIMARY KEY (ID_Fabryki)
) ;

CREATE TABLE Klienci (
    ID_Klienta integer  NOT NULL,
    Imie_Nazwisko varchar2(50)  NOT NULL,
    Numer_NIP integer  NULL,
    CONSTRAINT Klienci_pk PRIMARY KEY (ID_Klienta)
) ;

CREATE TABLE Pracownicy_fabryki (
    ID_Pracownika integer  NOT NULL,
    Fabryki_ID_Fabryki integer  NOT NULL,
    Imie_Nazwisko varchar2(50)  NOT NULL,
    Wynagrodzenie number(7,2)  NOT NULL,
    Poczatek_zatrudnienia date  NOT NULL,
    CONSTRAINT Pracownicy_fabryki_pk PRIMARY KEY (ID_Pracownika)
) ;

CREATE TABLE Pracownicy_salonu (
    ID_Pracownika integer  NOT NULL,
    Salony_sprzedazy_ID_Salonu integer  NOT NULL,
    Imie_Nazwisko varchar2(50)  NOT NULL,
    Wynagrodzenie number(7,2)  NOT NULL,
    Poczatek_zatrudnienia date  NOT NULL,
    Czy_handlowiec char(3)  NOT NULL,
    Czy_mechanik char(3)  NOT NULL,
    CONSTRAINT Pracownicy_salonu_pk PRIMARY KEY (ID_Pracownika)
) ;

CREATE TABLE Salony_sprzedazy (
    ID_Salonu integer  NOT NULL,
    Adres_salonu varchar2(50)  NOT NULL,
    Ilosc_stanowisk_serwisowych float(2)  NOT NULL,
    CONSTRAINT Salony_sprzedazy_pk PRIMARY KEY (ID_Salonu)
) ;

CREATE TABLE Wizyta_w_salonie (
    Klienci_ID_Klienta integer  NOT NULL,
    Salony_sprzedazy_ID_Salonu integer  NOT NULL,
    Data_wizyty date  NOT NULL,
    VIN_pojazdu char(17)  NOT NULL,
    Przebieg_pojazdu integer  NOT NULL,
    Czy_kupno char(3)  NOT NULL,
    Czy_serwis char(3)  NOT NULL
) ;

CREATE TABLE Wyprodukowane_samochody (
    Fabryki_ID_Fabryki integer  NOT NULL,
    Salony_sprzedazy_ID_Salonu integer  NOT NULL,
    Nazwa_modelu varchar2(20)  NOT NULL,
    Numer_VIN char(17)  NOT NULL,
    Data_produkcji date  NOT NULL
) ;

--ALTER
ALTER TABLE Pracownicy_salonu ADD CONSTRAINT Handlowcy_Salony_sprzedazy
    FOREIGN KEY (Salony_sprzedazy_ID_Salonu)
    REFERENCES Salony_sprzedazy (ID_Salonu);

ALTER TABLE Pracownicy_fabryki ADD CONSTRAINT Pracownicy_fabryki_Fabryki
    FOREIGN KEY (Fabryki_ID_Fabryki)
    REFERENCES Fabryki (ID_Fabryki);

ALTER TABLE Wizyta_w_salonie ADD CONSTRAINT Wizyta_w_salonie_Klienci
    FOREIGN KEY (Klienci_ID_Klienta)
    REFERENCES Klienci (ID_Klienta);

ALTER TABLE Wizyta_w_salonie ADD CONSTRAINT Wizyta_w_salonie_Salony_sprzedazy
    FOREIGN KEY (Salony_sprzedazy_ID_Salonu)
    REFERENCES Salony_sprzedazy (ID_Salonu);

ALTER TABLE Wyprodukowane_samochody ADD CONSTRAINT Wyprodukowane_samochody_Fabryki
    FOREIGN KEY (Fabryki_ID_Fabryki)
    REFERENCES Fabryki (ID_Fabryki);

ALTER TABLE Wyprodukowane_samochody ADD CONSTRAINT Wyprodukowane_samochody_Salony_sprzedazy
    FOREIGN KEY (Salony_sprzedazy_ID_Salonu)
    REFERENCES Salony_sprzedazy (ID_Salonu);

--INSERT
INSERT INTO Fabryki VALUES (1, 'Kielce');
INSERT INTO Fabryki VALUES (2, 'Szczecin');
INSERT INTO Fabryki VALUES (3, 'Konin');
INSERT INTO Fabryki VALUES (4, 'Gdynia');

INSERT INTO Salony_sprzedazy VALUES (1, 'Warszawa', 3);
INSERT INTO Salony_sprzedazy VALUES (2, 'Poznan', 1);
INSERT INTO Salony_sprzedazy VALUES (3, 'Warszawa', 2);
INSERT INTO Salony_sprzedazy VALUES (4, 'Wroclaw', 4);

INSERT INTO Klienci VALUES (1, 'Piotr Mnich', NULL);
INSERT INTO Klienci VALUES (2, 'Karol Piotrkowski', 1234567895);
INSERT INTO Klienci VALUES (3, 'Paulina Kent', 1643579241);
INSERT INTO Klienci VALUES (4, 'Kamila Lont', 1346728415);
INSERT INTO pracownicy_fabryki VALUES (1, 1, 'Grzegorz Bono', 5500, '2012-08-10');
INSERT INTO pracownicy_fabryki VALUES (2, 1, 'Konrad Pompka', 6500, '2008-10-18');
INSERT INTO pracownicy_fabryki VALUES (3, 2, 'Klaudia Grzywacz', 6000, '2010-06-08');
INSERT INTO pracownicy_fabryki VALUES (4, 2, 'Tadeusz Mina', 5200, '2016-02-20');
INSERT INTO pracownicy_fabryki VALUES (5, 3, 'Krystian Komin', 4800, '2020-11-25');
INSERT INTO pracownicy_fabryki VALUES (6, 3, 'Marcin Kempa', 7000, '2018-04-16');
INSERT INTO pracownicy_fabryki VALUES (7, 4, 'Aleksandra Tymianek', 5000, '2017-07-19');
INSERT INTO pracownicy_fabryki VALUES (8, 4, 'Mateusz Bymian', 5800, '2019-10-21');

INSERT INTO pracownicy_salonu VALUES (1, 1, 'Aureliusz Witkowski', 6500, '2020-07-15', 'nie', 'tak');
INSERT INTO pracownicy_salonu VALUES (2, 1, 'Amelia Nowak', 7400, '2013-10-09', 'tak', 'nie');
INSERT INTO pracownicy_salonu VALUES (3, 2, 'Kaja Szewczyk', 8000, '2015-06-10', 'tak', 'nie');
INSERT INTO pracownicy_salonu VALUES (4, 2, 'Fryderyk Kwiatkowski', 8200, '2018-03-04', 'nie', 'tak');
INSERT INTO pracownicy_salonu VALUES (5, 3, 'Borys Kubiak', 7500, '2019-04-26', 'tak', 'nie');
INSERT INTO pracownicy_salonu VALUES (6, 3, 'Blanka Andrzejewska', 6000, '2021-11-08', 'tak', 'nie');
INSERT INTO pracownicy_salonu VALUES (7, 4, 'Jan Maciejewski', 7800, '2018-09-20', 'tak', 'nie');
INSERT INTO pracownicy_salonu VALUES (8, 4, 'Jadwiga Krawczyk', 6800, '2020-05-27', 'tak', 'nie');

INSERT INTO wyprodukowane_samochody VALUES (1, 1, 'Kompot', '1HGBH41JXMN109186', '2020-06-15');
INSERT INTO wyprodukowane_samochody VALUES (1, 1, 'Kompot', '2KMTY86APYM961749', '2021-10-02');
INSERT INTO wyprodukowane_samochody VALUES (2, 2, 'Bryza', '5EBJW41GDXJ109745', '2020-07-24');
INSERT INTO wyprodukowane_samochody VALUES (2, 2, 'Kompot', '7NTED95QBRN347516', '2018-12-07');
INSERT INTO wyprodukowane_samochody VALUES (3, 3, 'Balon', '1TEWB85YENM734685', '2019-01-29');
INSERT INTO wyprodukowane_samochody VALUES (3, 3, 'Bryza', '2PRHV46BEZG572498', '2020-02-16');
INSERT INTO wyprodukowane_samochody VALUES (4, 4, 'Balon', '9ORBJ17TRYE734285', '2021-10-04');
INSERT INTO wyprodukowane_samochody VALUES (4, 4, 'Bryza', '5YRBH64TSNM558699', '2022-09-03');

INSERT INTO wizyta_w_salonie VALUES (1, 1, '2020-07-05', '1HGBH41JXMN109186', 0, 'tak', 'nie');
INSERT INTO wizyta_w_salonie VALUES (1, 1, '2021-09-03', '1HGBH41JXMN109186', 15364, 'nie', 'tak');
INSERT INTO wizyta_w_salonie VALUES (2, 2, '2020-02-12', '5MLTG84QWBT957295', 102345, 'nie', 'tak');
INSERT INTO wizyta_w_salonie VALUES (2, 2, '2022-11-17', '5MLTG84QWBT957295', 154678, 'nie', 'tak');
INSERT INTO wizyta_w_salonie VALUES (3, 3, '2021-06-26', '1TEWB85YENM734685', 0, 'tak', 'nie');
INSERT INTO wizyta_w_salonie VALUES (3, 3, '2022-07-03', '2PRHV46BEZG572498', 0, 'tak', 'nie');
INSERT INTO wizyta_w_salonie VALUES (4, 4, '2020-10-25', '4MGJR94MGPR012859', 248315, 'nie', 'tak');
INSERT INTO wizyta_w_salonie VALUES (4, 4, '2021-04-12', '5AMTJ9475PORF0174', 186479, 'nie', 'tak');

--INSTRUKCJE SELECT

--a)	Wybierz wszystkich pracowników salonu, którzy zarabiaj¹ wiêcej ni¿ 7000:
SELECT *
FROM pracownicy_salonu
WHERE wynagrodzenie > 7000;


--b)	Wybierz nazwy i wynagrodzenia pracowników fabryk oraz salonów, którzy zarabiaj¹ mniej ni¿ 6500:
SELECT imie_nazwisko, wynagrodzenie
FROM pracownicy_fabryki
WHERE wynagrodzenie < 6500
UNION
SELECT imie_nazwisko, wynagrodzenie
FROM pracownicy_salonu
WHERE wynagrodzenie < 6500;


--b)   Wybierz numery VIN samochodów, które zosta³y wyprodukowane w Kielcach:
SELECT numer_vin, fab.adres_fabryki
FROM wyprodukowane_samochody sam, fabryki fab
WHERE sam.fabryki_id_fabryki = fab.id_fabryki AND adres_fabryki = 'Kielce';


--c)	Wybierz fabryki, z których wyprodukowane samochody sprzeda³y siê w salonach. Obok fabryki podaj liczbê sprzedanych z niej aut:
SELECT wyp.fabryki_id_fabryki fabryka, COUNT(*) ilosc_sprzedanych_aut
FROM wyprodukowane_samochody wyp, wizyta_w_salonie wiz
WHERE wyp.numer_vin = wiz.vin_pojazdu AND czy_kupno = 'tak'
GROUP BY wyp.fabryki_id_fabryki;


--d)	Wybierz nazwy klientów oraz iloœæ ich wizyt w salonie, pod warunkiem, ¿e odwiedzili salon wiêcej ni¿ 1 raz:
SELECT kli.imie_nazwisko, COUNT(*) ilosc_wizyt_w_serwisie
FROM wizyta_w_salonie wiz, klienci kli
WHERE wiz.klienci_id_klienta = kli.id_klienta
GROUP BY kli.imie_nazwisko
HAVING COUNT(*) > 1;


--d)	SprawdŸ, czy numery vin wyprodukowanych samochodów zosta³y nadane prawid³owo (nie wystêpuj¹ duplikaty):
SELECT numer_vin, COUNT(*) duplikat
FROM wyprodukowane_samochody
GROUP BY numer_vin
HAVING COUNT(*) > 1;


--e)	Wska¿ salony, w którym wiêcej ni¿ jeden pracownik zarabia wiêcej ni¿ 7000:
SELECT salony_sprzedazy_id_salonu, COUNT(*) liczba_osob_zarabiajacych_ponad_7000
FROM pracownicy_salonu
WHERE wynagrodzenie > 7000
GROUP BY salony_sprzedazy_id_salonu
HAVING COUNT(*) > 1;


--e)	Wybierz nazwy klientów oraz iloœæ ich wizyt w salonie w celu serwisu pojazdu, pod warunkiem, ¿e skorzystali z serwisu wiêcej ni¿ 1 raz:
SELECT kli.imie_nazwisko, COUNT(*) ilosc_wizyt_w_serwisie
FROM wizyta_w_salonie wiz, klienci kli
WHERE wiz.klienci_id_klienta = kli.id_klienta AND czy_serwis = 'tak'
GROUP BY kli.imie_nazwisko
HAVING COUNT(*) > 1; 
