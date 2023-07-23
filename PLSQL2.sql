--zad1

Set serveroutput on;
Declare
Pensja EMP.SAL%TYPE;
NR EMP.EMPNO%TYPE;
Info VARCHAR2(100);
CURSOR PRACOWNIK IS SELECT EMPNO, ENAME, NVL(SAL, 0) PLACA FROM EMP; 
PRAC PRACOWNIK%Rowtype;
BEGIN
OPEN PRACOWNIK;
LOOP
FETCH PRACOWNIK INTO PRAC;
EXIT WHEN PRACOWNIK%NOTFOUND;
NR := PRAC.EMPNO;
Pensja := PRAC.PLACA;
IF Pensja <= 1800 THEN
Pensja := Pensja * 1.1;
Info := 'Pracownik ' ||  PRAC.ENAME || ' ma podwyzszona place do ' || Pensja;
END IF;
IF Pensja > 2000 THEN
Pensja := Pensja * 0.9;
Info := 'Pracowik ' || PRAC.ENAME ||  ' ma obnizona place do ' ||  Pensja;
END IF;
IF PRAC.PLACA <> pensja THEN
UPDATE EMP SET SAL = Pensja WHERE EMPNO=PRAC.EMPNO;
dbms_output.put_line (Info);
END IF;
END LOOP;
CLOSE PRACOWNIK;
END;

-- zad2

create or replace PROCEDURE Zad2_2(pensjaMin NUMBER, pensjaMax NUMBER)
AS
    nrPracownika int;
    nazwisko varchar2(50);
    pensja int;
    info varchar2(100);
    CURSOR kursorZad2 IS SELECT empno, ename, NVL(sal,0) PLACA FROM EMP;
    PRAC kursorZad2%rowtype;
begin
    Open kursorZad2;
        LOOP
            FETCH kursorZad2 INTO PRAC;
            EXIT WHEN kursorZad2%NOTFOUND;
            nrPracownika := Prac.EMPNO;
            pensja := Prac.Placa;
            IF pensja < pensjaMin then
                pensja := pensja * 1.1;
                info := 'Pracownik' || Prac.Ename || ' ma podwyzszona place do ' || Pensja; 
            end if;
            if pensja > pensjaMax then
                pensja := pensja * 0.9;
                info := 'Pracownik' || Prac.Ename || ' ma obnizona place do ' || Pensja;
            end if;
            if Prac.Placa <> pensja then
                UPDATE emp set sal = pensja where empno = Prac.Empno;
                DBMS_OUTPUT.PUT(Info);
            end if;
        END LOOP;
    CLOSE kursorzad2;
end;

------------------------------------
Set serveroutput on;
Exec zad2_2(1000,1500);
--ROLLBACK;

-- zad3

CREATE or replace PROCEDURE  Zad2_3(dzial int)
AS
    nazwisko emp.ename%Type;
    pensja emp.sal%Type;
    srednieZarobki emp.sal%Type;
    prowizja emp.comm%Type;
    nrPracownika emp.empno%Type;
    info varchar2(100);
    CURSOR kursorZad3 IS SELECT empno, ename, nvl(comm,0) PROWIZJA, sal PLACA FROM EMP WHERE deptno = dzial;
    PRACOWNIK kursorZad3%rowtype;
begin
    select AVG(sal) into srednieZarobki from emp where deptno = dzial;
    Open kursorZad3;
        LOOP
            FETCH kursorZad3 INTO PRACOWNIK;
            EXIT WHEN kursorZad3%NOTFOUND;
            
            nazwisko := PRACOWNIK.ename;
            pensja := PRACOWNIK.PLACA;
            prowizja := PRACOWNIK.PROWIZJA;
            nrPracownika := PRACOWNIK.empno;
            if(pensja <= srednieZarobki)then
                prowizja := PROWIZJA+pensja * 0.05;
                UPDATE emp set comm = prowizja where empno = nrPracownika;
                dbms_output.put_line ('Pracownik ' || nazwisko || ' ma zminiana prowizje na ' || prowizja); 
            end if;    
        END LOOP;
    CLOSE kursorZad3;
end;
 
SET SERVEROUTPUT ON;
 exec Zad2_3(10);

--ROLLBACK;