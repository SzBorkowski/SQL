--1.
SET SERVEROUTPUT ON
DECLARE ile int;
BEGIN
    SELECT COUNT(*) INTO ile FROM emp;
    dbms_output.put_line('W tabeli jest ' ||ile|| ' osob.');
END;

--2.
SET SERVEROUTPUT ON
DECLARE ile int;
BEGIN
    SELECT COUNT(*) INTO ile FROM emp;
    IF (ile < 16) THEN
    BEGIN
        INSERT INTO emp (empno,ename,deptno) VALUES ('4444','Kowalski','10');
        dbms_output.put_line('Wstawiono Kowalskiego');
    END;
    ELSE
        dbms_output.put_line('Nie wstawiono danych');
    END IF;
END;

--3.
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE wstawDzial (nazwaDzialu varchar, lokalizacja varchar)
IS
    nrDzialu int;
    ile int;
BEGIN
    SELECT COUNT(*) INTO ile FROM dept WHERE dname = nazwaDzialu;
    IF (ile > 0) THEN
        SELECT deptno INTO nrDzialu FROM dept WHERE dname = nazwaDzialu;
        UPDATE dept SET loc = lokalizacja WHERE deptno = nrDzialu ;
        dbms_output.put_line('Zmieniono lokalizacje');
    ELSE
        SELECT MAX(deptno)+10 INTO nrDzialu FROM dept;
        INSERT INTO dept (deptno,dname,loc) VALUES (nrDzialu,nazwaDzialu,lokalizacja);
        dbms_output.put_line('Dodano nowy dzial');
    END IF;
END wstawDzial;

--4.
CREATE OR REPLACE PROCEDURE DODAJ_Prac(
nazwisko varchar2, stanowisko varchar2, datazatr date, 
pensja number, prowizja number, dzial varchar2) 
AS
numer integer;
nr_dz integer;
x integer;
brak_dzialu EXCEPTION;
prac_juz_jest EXCEPTION;
BEGIN
SELECT COUNT(*) INTO nr_dz FROM dept
WHERE RTRIM(dname) LIKE dzial; 
IF nr_dz =0 THEN RAISE brak_dzialu;
END IF;
SELECT deptno INTO nr_dz FROM dept WHERE RTRIM(dname) like dzial;
SELECT COUNT(*) INTO numer FROM emp
WHERE RTRIM(ename) LIKE nazwisko; 
IF numer>0 THEN RAISE prac_juz_jest;
ELSE
SELECT NVL(MAX(empno)+1,1) INTO numer
FROM emp;
DBMS_OUTPUT.PUT_LINE ('Numer nowego pracownika to '||numer);
INSERT INTO emp
VALUES (numer, nazwisko, stanowisko, NULL, datazatr, pensja, prowizja, nr_dz);
DBMS_OUTPUT.PUT_LINE ('Dodano pracownika: '|| numer ||' nazwisko =' ||nazwisko);
COMMIT;
END IF;
EXCEPTION
WHEN brak_dzialu THEN 
DBMS_OUTPUT.PUT_LINE ('Brak dzialu o nazwie= '||DZIAL);
WHEN prac_juz_jest THEN 
SELECT empno INTO numer
FROM emp WHERE ename LIKE nazwisko||'%';
DBMS_OUTPUT.PUT_LINE ('Pracownik juz byl, empno= '||numer);
UPDATE emp SET JOB= stanowisko , hiredate = datazatr , sal= pensja, comm= prowizja  WHERE empno=numer;
END;

--5.
CREATE OR REPLACE PROCEDURE dodaj_projekt(
    nazwa_projektu IN VARCHAR2,
    budzet IN NUMBER,
    data_startu IN DATE,
    data_konca IN DATE)
AS
    liczba_pracownikow NUMBER;
BEGIN
    -- Sprawdzamy, czy istnieje ju¿ projekt o podanej nazwie
    SELECT COUNT(*) INTO liczba_pracownikow FROM proj WHERE pname = nazwa_projektu;
    IF liczba_pracownikow = 0 THEN
        -- Projekt nie istnieje, dodajemy go do tabeli
        INSERT INTO PROJ (PROJNO, PNAME, BUDGET, START_DATE, END_DATE)
        VALUES ((SELECT MAX(PROJNO) + 1 FROM PROJ), nazwa_projektu, budzet, data_startu, data_konca);
    ELSE
        -- Projekt istnieje, aktualizujemy jego dane
        UPDATE PROJ SET BUDGET = BUDGET + budzet, 
                        START_DATE = LEAST(data_startu, START_DATE), 
                        END_DATE = GREATEST(data_konca, END_DATE)
        WHERE PNAME = nazwa_projektu;
    END IF;
    -- Wypisujemy liczbê pracowników zatrudnionych w projekcie
    SELECT COUNT(*) INTO liczba_pracownikow FROM proj WHERE pname = nazwa_projektu;
    DBMS_OUTPUT.PUT_LINE('Liczba pracownikow w projekcie ' || nazwa_projektu || ': ' || liczba_pracownikow);
END;
-- Dodanie nowego projektu
EXECUTE INSERT_OR_UPDATE_PROJECT('NEW_PROJECT', 50000, TO_DATE('01-01-2024', 'DD-MM-YYYY'), TO_DATE('31-12-2024', 'DD-MM-YYYY'));