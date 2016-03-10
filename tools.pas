unit tools;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,inifiles, StdCtrls, ComCtrls, ExtCtrls, DB, ADODB, Grids, DBGrids;


var

  NumEd: array[1..19] of string = ('один ', 'два ', 'три ', 'четыре ', 'п€ть ', 'шесть ', 'семь ', 'восемь ', 'дев€ть ', 'дес€ть ', 'одиннадцать ', 'двенадцать ', 'тринадцать ', 'четырнадцать ', 'п€тнадцать ', 'шестнадцать ', 'семнадцать ', 'восемнадцать ', 'дев€тнадцать ');

  NumEd1: array[1..2] of string = ('одна ', 'две ');

  NumDec: array[2..9] of string = ('двадцать ', 'тридцать ', 'сорок ', 'п€тьдес€т ', 'шестьдес€т ', 'семьдес€т ', 'восемьдес€т ', 'дев€носто ');

  NumSot: array[1..9] of string = ('сто ', 'двести ', 'триста ', 'четыреста ', 'п€тьсот ', 'шестьсот ', 'семьсот ', 'восемьсот ', 'дев€тьсот ');

  Xlion0: array[1..3] of string = ('тыс€ч ', 'миллионов ', 'миллиардов ');

  Xlion1: array[1..3] of string = ('тыс€ча ', 'миллион ', 'миллиард ');

  Xlion2: array[1..3] of string = ('тыс€чи ', 'миллиона ', 'миллиарда ');

  function MoneyToString(Money: Double): string;
  function left_null_to_space(str:string):string;    

implementation


function left_null_to_space(str:string):string;
var
  i:integer;
begin
  for i:=1 to Length(str)-1 do begin
    if char(str[i])='0' then str[i]:=' '
    else Break;
  end;
  Result:=str;
end;


function MoneyToString(Money: Double): string;

var Money3, MoneyI, MoneyK, Digit, LastDigit, T: Integer;

  Sto, Kop: string;

begin

  Result := '';

  MoneyI := Trunc(Money);

  MoneyK := Round((Money - MoneyI) * 100);

  T := 0;

  while MoneyI > 0 do begin

    Money3 := MoneyI mod 1000;

    MoneyI := MoneyI div 1000;

    Sto := '';

    if (Money3 mod 100) < 20 then begin

      LastDigit := Money3 mod 20;

      if LastDigit > 0 then

        if (T = 1) and (LastDigit in [1..2]) then Sto := NumEd1[LastDigit]

        else Sto := NumEd[LastDigit];

      Money3 := Money3 div 100;

    end else begin

      LastDigit := Money3 mod 10;

      if LastDigit > 0 then

        if (T = 1) and (LastDigit in [1..2]) then Sto := NumEd1[LastDigit]

        else Sto := NumEd[LastDigit];

      Money3 := Money3 div 10;

      Digit := Money3 mod 10;

      if Digit > 0 then Sto := NumDec[Digit] + Sto;

      Money3 := Money3 div 10;

    end;

    if Money3 > 0 then Sto := NumSot[Money3] + Sto;

    if T > 0 then begin

      if LastDigit = 1 then Sto := Sto + Xlion1[T]

      else if LastDigit in [2..4] then Sto := Sto + Xlion2[T]

      else Sto := Sto + Xlion0[T];

    end;

    T := T + 1;

    Result := Sto + Result;

  end;

  Kop := IntToStr(MoneyK mod 10);

  MoneyK := MoneyK div 10;

  Kop := IntToStr(MoneyK) + Kop;

  Result := Result + 'руб. ' + Kop + ' коп.';

end;


end.
