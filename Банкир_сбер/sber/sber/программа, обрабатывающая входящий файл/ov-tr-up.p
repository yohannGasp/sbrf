/* OV-TR-UP.P
  Программа подъема документов из Novell-файлов телексных сообщений в UNIX c 
  растестовкой. 

Бородин М.П. добавил строки с 931 по 933 для установления 
  номера документа по СКБ.

18.10.04 Oval добавил процедуру подъема п/п от АБГ "Никойл" в формате ISO 7746.
 
15.12.2004 Oval вставил замену счетов от РНКО. 
22.12.2004 Бородин Изменил для платины тип документа

17.05.2005 OvAl включил подмену счетов 47422 и 47423 на 30232 и 30233
  при приеме документов от РНКО по Золотой Короне. 
16.08.2008 Изменил тип документа для Платины - Киберплата на 09

09.09.2008 - Slava - изменен формат для УБРИР

08.10.2010 - Бородин добавил бик Рапиды, так чтобы для нее работал алгоритм Платины

13.09.2012 - Ивонин добавил обработку валюты по РНКО

15.10.2012 - Ивонин замена корсчетов по РНКО

29 01 2014 - Бородин
 сделал уборку спец символов и возвратов каретки из текстовых полей СПЕД

01.08.2014 - Бородин
 смена транзитных счетов с 474 на 302 для РНКО
07.08.2014 - Бородин
 для РНКО смена порядка определения счетов для выплат 

*/

{b-vars.i} /* 09.09.2008 - Slava */

def temp-table aaa 
  field num as int
  field mars as char.
def buffer maa for aaa.
def workfile plat field dat as char /* формат ГГММДД */
                  /* field rach1 as char */
                  field test as char
                  field refer as char
                  field nr as char
                  field dat1 as char /* формат ГГММДД */
                  field kw as char
                  field ocher as char
                  field nazwa-plat as char
                  field inn-plat as char
                  field nazwa-bnk-plat as char
                  field gor-plat as char
                  field rach-plat as char 
                  field bik-plat as char
                  field kor-plat as char 
                  field nazwa-bnk-pol as char
                  field gor-pol as char
                  field inn-pol as char
                  field nazwa-pol as char
                  field rach-pol as char 
                  field bik-pol as char
                  field kor-pol as char 
                  field tresc as  char
                  field num as int
                  field typ as int
                  field loro as logi
                  field dat-spis as char
                  field kpp-plat as char
                  field kpp-pol as char
                  field platina as logi init no
                  field rnko as int
                  field wal-plat as char
                  field kordt49 as char 
                  field korkt55 as char
                  field typdoc as char
                  /* Slava 12/09/2013 */
                  field spad as log

                 field BUD_DATE33 as char   /* Дата налогового документа          */ 
                 field BUD_OKATO as char    /* Код ОКАТО                          */ 
                 field BUD_DATE34 as char   /* Налоговый период                   */ 
                 field BUD_TAXP26 as char   /* Код составителя документа          */ 
                 field BUD_NUM_32 as char   /* Номер налогового документа         */ 
                 field BUD_KOD_28 as char   /* Код основания налогового платежа   */ 
                 field BUD_PAY_29 as char   /* Код типа налогового платежа        */ 
                 field BUD_KBK    as char   /* Код бюджетной классификации        */ 

                  /* ------------ */
                  .

def temp-table t-bank
  field bik as integer form 'zzzzzzz9'
  field nazwa like bank-ew.nazwa
  field kol as int form 'zzzzzzz'
  field list as char.

/* Slava 11/09/2013 Для импорта сберовского СПЭД */
def workfile t-spad
  field nr as char
  field bik-pol as char
  field rach-pol as char 
  /* field RC_CODE as char */
  field kor-pol as char
  field rach-plat as char 
  field tresc as  char
  field nazwa-bnk-pol as char
  field inn-pol as char
  field gor-pol as char
  /* field CR_CODE as char */
  field kor-plat as char
  field nazwa-pol as char
  field nazwa-plat as char
  field TYPE_MESS as char
  field gor-plat as char
  field nazwa-bnk-plat as char
  field bik-plat as char
  field SEND_TYPE as char
  field ocher as char
  field dat as char
  field kw as char
  field inn-plat as char
  field BUD_DATE33 as char
  field BUD_OKATO as char
  field BUD_DATE34 as char
  field BUD_TAXP26 as char
  field kpp-pol as char
  field BUD_NUM_32 as char
  field BUD_KOD_28 as char
  field BUD_PAY_29 as char
  field BUD_KBK    as char
  field kpp-plat as char
  field wal-plat as char  /* Slava 2014/01/202*/
  field typdoc as char
.

def stream str-in.
def stream str-out.
def stream str-out-loro.
def stream str-err.
def stream str-ans.

def var dir-out as char init '/opt/exchange/banks/in'.
def var dir-ans as char init '/opt/exchange/banks/rastest'.
def var out-filename as char extent 2.
def var tmp as char.
def var i as int.
def var item as char form 'x(78)'.
def var menu as char extent 4 form 'x(10)'
  init ['1-й','Конец','Принять','Выход'].
def var confirm as char form 'xxx' extent 2 init ['Да','Нет'].
def var stroka as char.
def var nn as int.
def var ok as logical.
def var report as char.
def var stat as char.
def var labels as char form 'x(9)' extent 3 
  init ['Принято -',' Ошибки -','  Всего -'].
def var counter as int form '>>9' extent 3 init 0.
def var err-file-name as char.
def var ans-file-name as char.
def var from-rkc as logical.
def var from-sb as logical.
def var from-chelin as logical.
def var from-ubrir as logical.
def var from-skb as logical.
def var from-alpha as logical.
def var from-ors as logical.
def var from-rnko as logical.
def var from-nikoil as logical.
def var from-platina as logical.
def var from-spad as log. /* Slava  11/09/2013 */

def var use-spad as log init True /* False */. /* Slava 20/01/2014 - использовать загрузчик спэд для файлов из сбера */

def var pos as int.
def var out-string as char.
def var login as char.
def var loro-list as char.
def var flag-loro as logi.
def var psvk as char form 'xx'.

form 
  menu[1] help 'Переместиться в начало.'
  menu[2] help 'Переместиться в конец.'
  menu[3] help 'Поднять сообщения.'
  menu[4] help 'Выход из программы.'
    with overlay centered row screen-lines 
      no-box no-labels frame f-menu.
form
  t-bank.bik column-label 'БИК'
  t-bank.nazwa
  t-bank.kol column-label 'Неподн.!файлов'
    with row 2 15 down overlay centered title ' ПОДЪЕМ ПЛАТЕЖНЫХ СООБЩЕНИЙ '
      frame f1.
form skip
  '  ' stat form 'x(26)' '  ' skip
  '──────────────────────────────' skip
/*  '------------------------------' skip */
  '     ' labels[1] counter [1] skip
  '     ' labels[2] counter [2] skip
  '     ' labels[3] counter [3] skip
  with color message row 9 centered overlay no-labels frame sts.

pause 0 before-hide.
psvk = chr(13) + chr(10).
if search('/bankier/adfil/trans_dir.dat') <> ? then do:
  input from '/bankier/adfil/trans_dir.dat'.
  do on error undo, leave:
    import dir-ans dir-ans.
    import dir-out dir-out.
    import login.
    import loro-list.
  end.  
  input close.
end.
else do:
  message 'Нет файла настройки каталогов.' skip
          ' По умолчанию установлен путь ' skip
          'в UNIX:' skip dir-out skip(1)
          '    Продолжить выполнение ?   '  
          view-as alert-box question buttons yes-no title ''
            update choice as logical.
  if not choice then return.          
end.


for each const no-lock:
  create t-bank.
  find first bank-ew where bank-ew.nr-banku = const.bik no-lock.
  assign t-bank.bik = const.bik t-bank.nazwa = bank-ew.nazwa.
  input through value(const.search-cmd) no-echo.
  repeat:
    set item with no-box no-label frame indata1.
    assign t-bank.list = t-bank.list + item + ','
           t-bank.kol = t-bank.kol + 1.
  end.
  input close.
  t-bank.list = trim(t-bank.list,',').
end.

display menu with frame f-menu.
view frame f1.
find first t-bank no-error.
{ browse5.i
   &File=t-bank
   &Frame="frame f1" 
   &Strip_name=menu
   &Strip_frame=f-menu
   &Strips_4=*
   &Strip1_Key=HOME
   &Strip2_Key=END
   &Strip3_DO="do:
                 if t-bank.kol > 0 then do:
                   display 'Поднять содержимое ящика ? ' confirm
                     with color message no-labels overlay row 10 centered
                       frame conf.
                   choose field confirm color normal go-on(END-ERROR)
                     with frame conf.
                   hide frame conf.    
                   if keyfunction(lastkey) <> 'END-ERROR' and
                       frame-index = 1 then do:
                     run uper.
                     next redraw.
                   end.   
                 end.
                 else message 'Так ведь поднимать нечего...'. 
                 next read-key. 
               end"
   &Strip4_Key=END-ERROR 
   &Fields_2=*      
   &Field1=bik   &Type1=i
   &Field2=nazwa &Type2=c 
   &View="t-bank.kol"
   &Color_View=* } 

hide frame f1.
hide frame f-menu.
 
procedure uper.
def var i as int.
def var kol as int.
def var t-date as date.
def var t-deci as deci.

counter = 0.
do i = 1 to 999:
  assign out-filename[1] = dir-out + '/'
         out-filename[2] = out-filename[1] + 'L' + 
           string(t-bank.bik) + '.' + string(i,'999')
         out-filename[1] = out-filename[1] + 
           string(t-bank.bik) + '.' + string(i,'999').
  if (search(out-filename[1]) <> out-filename[1]) and
     (search(out-filename[2]) <> out-filename[2]) then leave.
end.
output stream str-out to value(out-filename[1]) append.
output stream str-out-loro to value(out-filename[2]) append.
stat = 'ЧТЕНИЕ СООБЩЕНИЙ...'.
display stat with frame sts.
do pos = length(entry(1,t-bank.list)) to 1 by -1:
  if substr(entry(1,t-bank.list),pos,1) = '/' then leave.
end.
assign from-rkc =  (t-bank.bik = 46568000)
       /* from-sb = (t-bank.bik = 46577674)  */ /* перенесен ниже */
       from-chelin = (t-bank.bik = 47501779)
       from-ubrir = (t-bank.bik = 46577795)
       from-skb = (t-bank.bik = 46577756)
       from-alpha = (t-bank.bik = 44525593)
       from-ors = (t-bank.bik = 46577303)
       from-rnko = (t-bank.bik = 45004832)
       from-nikoil = (t-bank.bik = 44525566)
       from-platina = ((t-bank.bik = 44585931) or (t-bank.bik = 44583290)) .
                                             /* 08.10.2010 Бородин or выше - рапида тоже Платина*/
       /* Slava 2014/01/20 - выбор спэд или старого загрузчика */
       if use-spad then 
         from-spad = (t-bank.bik = 46577674) .
       else
         from-spad = (t-bank.bik = 46577674) .

if from-rkc then do:
  kol = t-bank.kol.
/*  do i = 1 to kol:
    input stream str-in from value(entry(i,t-bank.list)).
    repeat transaction on error undo, leave:
      import stream str-in unformatted stroka.
      stroka = replace(stroka,'^"','^ "').
      put stream str-out unformatted stroka skip. 
    end.
    input stream str-in close.
    unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null').
    t-bank.kol = t-bank.kol - 1.
  end.
  output stream str-out close.
  output stream str-out-loro close.
  unix silent value('rm ' + out-filename[2] + ' > /dev/null').
  return.  */
/* Изменил OvAl 07.06.06 для нового формата обмена с РКЦ. */  
  do i = 1 to kol:
    unix silent value(
      'cp ' + entry(i,t-bank.list) + ' ' + dir-out + ';' +
      'mv ' + entry(i,t-bank.list) + ' ' +
        substr(entry(i,t-bank.list),1,r-index(entry(i,t-bank.list),'/')) + 
        'BAK;' + 
      'rm ' + dir-out + '/46568000.* ' + dir-out + '/l46568000.* 2>/dev/null').
    t-bank.kol = t-bank.kol - 1. 
  end.
  output stream str-out close.
  output stream str-out-loro close.
  unix silent value('rm ' + out-filename[2] + ' > /dev/null').
  return.  
end.
find first parm where parm.rodz-par = 'data-sys' no-lock.
if from-sb then run former-sb.
else if from-chelin then run former-chelin.
     else if t-bank.bik = 46577780 then run former-vt.
          else if from-ubrir then run former-ubrir.
               else if from-skb then run former-skb.
                    else if from-alpha then run former-alpha.
                         else if from-ors then run former-ors.
                              else if from-rnko then run former-rnko.
                                   else if from-nikoil then run former-nikoil.
                                        else if from-platina then run former-platina.
                                          else if from-spad then run former-spad. /* Slava 11/09/2013 */
                                             else run former.
if not (from-sb or 
        from-chelin or 
        from-ubrir or 
        from-ors or 
        from-rnko or
        from-platina
        or from-spad /* Slava 11/09/2013 */
        ) then do:
  assign stat = 'РАСТЕСТОВАНИЕ СООБЩЕНИЙ...'
         err-file-name = substr(entry(1,t-bank.list),1,pos) + 
                         trim(replace(string(time,'hh:mm'),':','')) +
                         string(day(parm.wart-dat),'99') + '.' + 
                         entry(month(parm.wart-dat),'1,2,3,4,5,6,7,8,9,a,b,c') +
                         string(year(parm.wart-dat) mod 100,'99')
         ans-file-name = dir-ans + '/' + string(t-bank.bik) + '/' +
                         string(day(parm.wart-dat),'99') + 
                         string(month(parm.wart-dat),'99') +
                         trim(replace(string(time,'hh:mm'),':','')) + '.txt'.
  output stream str-err to value(err-file-name).  
  output stream str-ans to value(ans-file-name).
end.  



for each plat:
  display stat labels counter with frame sts. 
  if not (from-sb or 
          from-chelin or 
          from-ubrir or 
          from-ors or 
          from-rnko or
          from-platina
          or from-spad /* Slava 11/09/2013 */
          ) then do:
    ok = no.
/*message plat.dat plat.kw plat.test view-as alert-box.*/
    t-date = date(trim(plat.dat)) no-error.
    if not error-status:error then do:
      t-deci = decimal(plat.kw) no-error.
      if not error-status:error then do:
        run ov-detest.p(t-bank.bik,t-date,810,t-deci,trim(plat.test), 
          output ok, output report).
        if return-value begins 'Input' then do:
          message 'Не определены кодовые таблицы для входящих платежей !' skip
                  'Откорректируйте таблицы, скопируйте вновь файл во' skip
                  'входной каталог и повторите транспортировку.'
            view-as alert-box.
          leave.  
        end.
      end.
      else report = 'Неверен формат суммы'.    
    end.
    else report = 'Неверен формат даты'.
  end.
  else ok = yes.
  if not ok then do:
    put stream str-err 'MARS' skip.
    for each aaa where aaa.num = plat.num:
      put stream str-err unformatted aaa.mars skip.
    end.
    put stream str-err unformatted report skip(2).
    find parm where parm.rodz-par = 'BANK-WL' no-lock.
    find first bank-ew where bank-ew.nr-banku = integer(parm.wart-par) no-lock.
    put stream str-ans unformatted 
      'MARS' skip
      'FROM: ' bank-ew.nazwa skip
      '      ' bank-ew.miasto skip.
    find first bank-ew where bank-ew.nr-banku = t-bank.bik no-lock.
    put stream str-ans unformatted
      'TO  : ' bank-ew.nazwa skip
      '      ' bank-ew.miasto skip
      'DATE: ' plat.dat skip
      'NK  : '.
    find first aaa where 
      aaa.num = plat.num and aaa.mars begins 'NK  : ' no-error.
    if avail aaa then put stream str-ans unformatted substr(aaa.mars,7).
    put stream str-ans unformatted skip 'ND  : '.
    find first aaa where 
      aaa.num = plat.num and aaa.mars begins 'ND  : ' no-error.
    if avail aaa then put stream str-ans unformatted substr(aaa.mars,7).
    put stream str-ans unformatted skip(1)
      '::940 СООБЩЕНИЕ О НЕВОЗМОЖНОСТИ ВЫПОЛНЕНИЯ РАСПОРЯЖЕНИЯ' skip
      'PLEASE PAY' skip (1)
      ':20 Н/Р: ' plat.refer skip
      ':23 Н/ПЛ: ' plat.nr skip
      ':59 ПОЛУЧАТЕЛЬ: ' plat.nazwa-pol skip
      ':61 ОТЧЕТ: НЕ ПРОВЕДЕНО ' plat.kw skip
      ':63 ПРИЧИНА: ' caps(report) skip
      'ENDMARS' skip(2).
    counter[2] = counter[2] + 1.
  end.      
  else do:
    assign plat.dat = replace(trim(plat.dat),'Ч','4')
           plat.nr = trim(plat.nr)
           plat.kw = replace(trim(plat.kw),'Ч','4')
           plat.rach-plat = replace(trim(plat.rach-plat),'Ч','4')
           plat.bik-plat = replace(trim(plat.bik-plat),'Ч','4')
           plat.kor-plat = replace(trim(plat.kor-plat),'Ч','4')
           plat.rach-pol = replace(trim(plat.rach-pol),'Ч','4')
           plat.bik-pol = replace(trim(plat.bik-pol),'Ч','4')
           plat.kor-pol = replace(trim(plat.kor-pol),'Ч','4')
           plat.tresc = trim(replace(plat.tresc,'^',psvk))
           plat.nazwa-plat = trim(plat.nazwa-plat)
           plat.nazwa-pol = trim(plat.nazwa-pol)
           plat.nazwa-bnk-plat = trim(plat.nazwa-bnk-plat)
           plat.nazwa-bnk-pol = trim(plat.nazwa-bnk-pol)
           plat.dat1 = replace(trim(plat.dat1),'Ч','4')
           plat.inn-plat = replace(trim(plat.inn-plat),'Ч','4')
           plat.inn-pol = replace(trim(plat.inn-pol),'Ч','4')
           plat.bik-plat = replace(trim(plat.bik-plat),'Ч','4')
           plat.dat-spis = string(parm.wart-dat,'999999')
           plat.wal-plat = if trim(plat.wal-plat) = '' then '810' else trim(plat.wal-plat)
           plat.kordt49  = trim(plat.kordt49)
           plat.korkt55  = trim(plat.korkt55)
           plat.typdoc   = if trim(plat.typdoc) = '' then '01' else trim(plat.typdoc).


    

    out-string = 
       '20' + plat.dat + '^' + /* Дата обработки/Дата документа */ /*Бородин сменил тип документа с 1 на 01 */
/*2 */  plat.nr + '^' + plat.typdoc + '^B^^^^^^4^' + plat.wal-plat + '^' + 
/*12*/  plat.kw + '^' + 
/*13*/  plat.kw + '^^5^^^^' +
 /*if plat.ocher = '' then '6' else trim(plat.ocher) + '^^^^' + /* оч.плат.*/*/
/*19*/  plat.rach-plat + '^' + /* счет инициатора */
/*20*/  plat.bik-plat + '^' +  /* бик инициатора  */
/*21*/  plat.kor-plat + '^^' + /* корсчет инициатора, условный номер */
/*23*/  plat.bik-plat + '^^' + /* бик банка-плательщика, бик РКЦ */ 
/*25*/  plat.rach-pol + '^' +  /* счет бенифициара */
/*26*/  plat.bik-pol + '^' +   /* банк бенифициара */
/*27*/  plat.kor-pol + '^^' +  /* корсчет бенифициара, условный номер бенеф. */
/*29*/  plat.bik-pol + '^^' +  /* бик банка-получ, бик ркц */
/*31*/  plat.tresc + '^^^' +   /* назначение платежа   */
/*34*/  plat.nazwa-plat + '^' + /* название инициатора  */ 
/*35*/  plat.nazwa-pol + '^' + /* название бенефициара */
/*36*/  plat.nazwa-bnk-plat + '^' + /* название банка-инициатора  */
/*37*/  plat.nazwa-bnk-pol + '^^^^^^^^^^^' + /* название банка-бенефициара */
/*48*/  'e^' + /* Тип корсчета/счета Дт */  plat.kordt49 + /* Корсчет/счет Дт */ 
/*49*/ '^^^^^' + 
/*54*/  'e^' + /* Тип корсчета/счета Кт */  plat.korkt55 +  /* Корсчет/счет Кт */
/*55*/  '^^' + 
/*57*/  '20' + plat.dat1 + '^' + /* Дата валютирования */
/*58*/  plat.inn-pol + '^^^^^^' +
/*64*/  plat.bik-plat + '^^' +
/*66*/  plat.bik-pol + '^^^^^^^^^' + 
/*75*/  plat.inn-plat + '^' +
/*76*/  plat.inn-pol + '^^^^^' +
/*81*/  '20' + plat.dat1 + '^^^^^^^^^^' + /* Дата основного документа */
/*91*/  plat.dat-spis + '^' + 
/*92*/  plat.kpp-plat + '^' + 
/*93*/  plat.kpp-pol /* + '^^^^^^^^^' */

. 
/* Slava 12.09/2013 - СПЭД налоговые платежи */
if not plat.spad then do:
  out-string = out-string + '^^^^^^^^^'.
end.
else do:
  out-string = out-string + '^' +
    plat.BUD_TAXP26 + '^' +  /* 94 Код составителя документа */  
    plat.BUD_KBK + '^' +   /* 95 Код бюджетной классификации        */ 
    plat.BUD_OKATO + '^' +    /* 96 Код ОКАТО                          */ 
    plat.BUD_KOD_28 + '^' +   /* 97 Код основания налогового платежа   */ 
    plat.BUD_DATE34 + '^' +   /* 98 Налоговый период                   */ 
    plat.BUD_NUM_32 + '^' +   /* 99 Номер налогового документа         */ 
    plat.BUD_DATE33 + '^' +   /* 100 Дата налогового документа          */ 
    plat.BUD_PAY_29 + '^'    /* 101 Код типа налогового платежа        */ 
    .
end.



 /* Бородин добавил entry(3... */
    if plat.platina then assign
       entry(3 ,out-string,'^') = '09'
       entry(49,out-string,'^') = plat.rach-plat
       entry(55,out-string,'^') = plat.rach-pol.
    out-string = replace(out-string,'^"','^ "').
    if plat.loro then do:
      put stream str-out-loro unformatted out-string skip.   
      flag-loro = yes.
    end.
    else put stream str-out unformatted out-string skip.
    counter[1] = counter[1] + 1.
  end.  
  counter[3] = counter[3] + 1. 
end.
hide frame sts.
output stream str-out close.
output stream str-out-loro close.
if flag-loro then flag-loro = no.
             else unix silent value('rm ' + out-filename[2] + ' > /dev/null').
if not (from-sb or 
        from-chelin or 
        from-ubrir or 
        from-ors or 
        from-rnko or
        from-platina
        or from-spad /* Slava 11/09/2013 */
        ) then do:
  output stream str-err close.
  output stream str-ans close.
  if counter[2] = 0 then unix silent 
    value('rm ' + err-file-name + ' ' + ans-file-name + ' > /dev/null').
  else message 'ВНИМАНИЕ !' skip
               'Платежи в количестве 'counter[2] 'из-за ошибок' skip
               'не транспортированы !' skip
               'Просмотрите содержимое файлов:' skip 
               err-file-name skip ans-file-name
                 view-as alert-box.      
end.
if counter[1] = 0 then 
  unix silent value('rm ' + out-filename[1] + ' > /dev/null').
for each aaa:  delete aaa.  end.
for each plat: delete plat. end.
end procedure.


procedure former.
def var i as int.
def var inside as logical no-undo.
def var kol as int.
def var mes-in-file as int.
def var inn as int.

kol = t-bank.kol.

do i = 1 to kol:
  assign tmp = entry(i,t-bank.list)
         tmp = substr(tmp,1,r-index(tmp,'/')) + string(time)
         mes-in-file = 0.
  unix silent value('rex-killer.pl ' + entry(i,t-bank.list) + ' ' + tmp + 
    ' > /dev/null'). 
  input stream str-in from value(tmp).
  inside = no.
  repeat transaction on error undo, leave:
    import stream str-in unformatted stroka. 
/* message stroka. pause. 
    if index(stroka,'MARS') > 0 and index(stroka,'ENDMARS') = 0 then do:
      stroka = 'MARS'.
      inside = yes.
    end. */
    if (stroka begins 'FROM') then inside = yes.  
    if inside and stroka <> '' then do:
/*      if stroka = 'MARS' then do: 
 ТАМ НИЖЕ ЕЩЕ ЕСТЬ ЗАКОММЕНТИРОВАННЫЙ MARS ! */
      if (stroka begins 'FROM') then do:
        find last aaa no-error.
        nn = if avail aaa then aaa.num + 1 else 1.
      end.               
      create aaa.
      assign aaa.num = nn
             aaa.mars = stroka.
    end.
    if stroka begins 'ENDMARS' then do:
      if inside = yes then mes-in-file = mes-in-file + 1.
      inside = no.
    end.
  end.
  if inside then do:
    for each aaa while not (aaa.mars begins 'ENDMARS') by recid(aaa) descending:
      delete aaa.
    end. 
  end.
  input stream str-in close.
  if mes-in-file > 0 then do:
    unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null'). 
    t-bank.kol = t-bank.kol - 1.
  end.
  else  message 'В файле ' entry(i,t-bank.list) skip
                'не обнаружено ни одного сообщения !' skip
                'Проверьте его !' view-as alert-box.
  unix silent value('rm ' + tmp + ' > /dev/null').
end.
find first aaa no-error.
if not avail aaa then return.
repeat on error undo, leave:
/*  if substring(aaa.mars,1,4) = 'MARS' then do: */
  if substring(aaa.mars,1,4) = 'FROM' then do:
    create plat.
    plat.num = aaa.num.
  end.
  if substr(aaa.mars,1,4) = 'DATE' or
     substr(aaa.mars,1,4) = 'DАТЕ' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.dat = trim(substring(aaa.mars,6)).
  end.
  if substr(aaa.mars,1,5) = 'NK  :' or
     substr(aaa.mars,1,5) = 'N/K :' or
     substr(aaa.mars,1,3) = 'NK:' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.loro = 
      can-do(loro-list,trim(substr(aaa.mars,index(aaa.mars,':') + 1))).
  end.   
  if substr(aaa.mars,1,3) = ':15' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.test = replace(trim(substr(aaa.mars,10)),'Ч','4').
  end.
  if substr(aaa.mars,1,3) = ':20' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.refer = trim(substr(aaa.mars,9)).
  end.
  if substr(aaa.mars,1,3) = ':23' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.nr = trim(substr(aaa.mars,10)).
  end.
  if substr(aaa.mars,1,3) = ':30' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.dat1 = trim(substr(aaa.mars,10)).
  end.
  if substr(aaa.mars,1,3) = ':32' then do:
    find first plat where plat.num = aaa.num no-error.
    assign plat.kw = trim(substr(aaa.mars,11)).
    if length(plat.kw) < 4 then plat.kw = '0 ' + plat.kw.
    assign substr(plat.kw,length(plat.kw) - 2,1) = '.'
           plat.kw = replace(plat.kw,' ','').
  end.
  if substring(aaa.mars,1,3) = ':50' then do:
    find first plat where plat.num = aaa.num no-error.
    inn = index(aaa.mars,'ИНН ').
    
    plat.nazwa-plat = substring(aaa.mars,17).
    r4: repeat:
      find next aaa. 
      if substring(aaa.mars,1,3) = ':52' then do:
        find prev aaa.
        leave r4.
      end.  
      else plat.nazwa-plat = plat.nazwa-plat + ' ' + substring(aaa.mars,4).
    end.  
  end.
  if substring(aaa.mars,1,3) = ':52' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.nazwa-bnk-plat = substring(aaa.mars,23).
  end.
  if substring(aaa.mars,1,3) = ':53' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.rach-plat = substring(aaa.mars,18).
    find next aaa.
    plat.bik-plat = substring(aaa.mars,9).
    find next aaa.
    plat.kor-plat = trim(substring(aaa.mars,8)).
  end.
  if substring(aaa.mars,1,3) = ':57' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.nazwa-bnk-pol = substring(aaa.mars,22).
  end.
  if substring(aaa.mars,1,3) = ':59' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.nazwa-pol =  substring(aaa.mars,17).
    r2: repeat:
      find next aaa.
      if substring(aaa.mars,1,7) = '    Р/С' then do:
        find prev aaa.
        leave r2.
      end.  
      else plat.nazwa-pol = plat.nazwa-pol + substring(aaa.mars,4).
    end.  
  end.
  if substring(aaa.mars,1,7) = '    Р/С' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.rach-pol = substring(aaa.mars,9).
    find next aaa.
    plat.bik-pol = substring(aaa.mars,9).
    find next aaa.
    plat.kor-pol = substring(aaa.mars,9).
  end.
  if substring(aaa.mars,1,3) = ':70' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.tresc = substring(aaa.mars,25).
    r1: repeat on error undo, leave:
      find next aaa.
      if substring(aaa.mars,1,7) = 'ENDMARS' then leave r1.
      else plat.tresc = plat.tresc + ' ' + trim(aaa.mars).
    end.
  end.
  find next aaa.
end.
end procedure.

procedure former-vt.
def var i as int.
def var inside as logical no-undo.
def var kol as int.
def var mes-in-file as int.

kol = t-bank.kol.
file-cycle: do i = 1 to kol:
  assign tmp = entry(i,t-bank.list)
         tmp = substr(tmp,1,r-index(tmp,'/')) + string(time)
         mes-in-file = 0.
  unix silent value('rex-killer.pl ' + entry(i,t-bank.list) + ' ' + tmp + 
    ' > /dev/null'). 
  input stream str-in from value(tmp).
  inside = no.
  repeat transaction on error undo, leave:
    import stream str-in unformatted stroka. 
    if stroka begins 'FROM' then inside = yes.
    if inside and stroka <> '' then do:
      if stroka begins 'FROM' then do:
        find last aaa no-error.
        nn = if avail aaa then aaa.num + 1 else 1.
      end. 
      create aaa.
      assign aaa.num = nn
             aaa.mars = stroka.
    end.
    if stroka begins '----' then do:
      if inside = yes then mes-in-file = mes-in-file + 1.
      inside = no.
    end.  
  end.
  if inside then do:
    for each aaa while not (aaa.mars begins '----') by recid(aaa) descending:
      delete aaa.
    end. 
  end.  
  input stream str-in close.
  if mes-in-file > 0 then do:
    unix silent value('mv'  + ' ' + entry(i,t-bank.list) + ' ' + 
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null'). 
    t-bank.kol = t-bank.kol - 1.
  end.
  else  message ' В файле ' entry(i,t-bank.list) skip
                '   не обнаружено ни одного сообщения ! ' skip
                '             Проверьте его !           ' view-as alert-box.
  unix silent value('rm ' + tmp + ' > /dev/null').
end. 
find first aaa no-error.
if not avail aaa then return.
repeat on error undo, leave:
  if substring(aaa.mars,1,4) = 'FROM' then do:
    create plat.
    plat.num = aaa.num.
  end.
  if substring(aaa.mars,1,5) = 'DATE:' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.dat = substring(aaa.mars,15,2) + substr(aaa.mars,10,2) + 
      substr(aaa.mars,7,2).
  end.  
  if substring(aaa.mars,1,5) = 'TEST:' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.test = replace(trim(substring(aaa.mars,6)),'Ч','4').
  end.
  if substring(aaa.mars,1,4) = ':20:' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.nr = trim(substring(aaa.mars,12)).
  end.
  if substring(aaa.mars,1,4) = ':30:' then do:
    find first plat where plat.num = aaa.num no-error.
    aaa.mars = trim(substr(aaa.mars,11)).
    plat.dat1 = substr(aaa.mars,9,2) + substr(aaa.mars,4,2) +
                substr(aaa.mars,1,2).
  end.
  if substring(aaa.mars,1,4) = ':32:' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.kw = replace(trim(substring(aaa.mars,24)),' ','').
  end.
  if substring(aaa.mars,1,4) = ':50:' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.rach-plat = trim(substr(aaa.mars,35)).
    find next aaa.
    plat.nazwa-plat = 'ИНН ' + trim(substr(aaa.mars,8)) + ' '.
    find next aaa.
    if aaa.mars begins 'КПП' then do:
      plat.kpp-plat = trim(substr(aaa.mars,5)).
      find next aaa.
    end.
    plat.nazwa-plat = plat.nazwa-plat + trim(aaa.mars).
    r3: repeat on error undo, leave:
      find next aaa.
      if aaa.mars begins ':57:' then leave r3.
      else plat.nazwa-plat = plat.nazwa-plat + ' ' + trim(aaa.mars).
    end.
  end.
  if substring(aaa.mars,1,4) = ':57:' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.kor-pol = trim(substr(aaa.mars,27)).
    find next aaa.
    plat.bik-pol = trim(substr(aaa.mars,8)).
    find next aaa.
    plat.nazwa-bnk-pol = trim(aaa.mars).
  end.
  if substring(aaa.mars,1,4) = ':59:' then do:
    find first plat where plat.num = aaa.num no-error.
    plat.rach-pol = trim(substr(aaa.mars,34)).
    find next aaa.
    plat.nazwa-pol = 'ИНН ' + trim(substr(aaa.mars,8)) + ' '.
    find next aaa.
    if aaa.mars begins 'КПП' then do:
      plat.kpp-pol = trim(substr(aaa.mars,5)).
      find next aaa.
    end.
    plat.nazwa-pol = plat.nazwa-pol + trim(aaa.mars).
  end.
  if substring(aaa.mars,1,4) = ':70:' then do:
    find first plat where plat.num = aaa.num no-error.
    find next aaa.
    plat.tresc = trim(aaa.mars).
    repeat: 
      find next aaa.
      if aaa.mars begins '----' or aaa.mars begins ':' then leave.
      plat.tresc = plat.tresc + ' ' + trim(aaa.mars).
    end.  
  end.
  plat.bik-plat = string(t-bank.bik).
  find first bank-ew where bank-ew.nr-banku = t-bank.bik no-lock.
  plat.kor-plat = trim(bank-ew.rach-nbp).
  plat.nazwa-bnk-plat = bank-ew.nazwa.
  find next aaa.
end.
end procedure.

procedure former-sb.
def var i as int.
def var kol as int.
def var t-char as char.
def var t-deci as deci.
def var t-date as date.
def var curve-date as char.

assign kol = t-bank.kol
       nn = 1
       curve-date = string(parm.wart-dat)
       session:date-format = 'mdy'.
do i = 1 to kol:
  unix silent value('/opt/dlc/bin/dbf 1 1 ' + entry(i,t-bank.list) + 
    ' /bankier/tmp/dbf-error > /bankier/tmp/dbf-sber').
  input stream str-in from '/bankier/tmp/dbf-sber'.
  repeat transaction on error undo, leave:
    create plat.
    assign plat.num = nn
           plat.dat = curve-date. 
    import stream str-in t-char plat.nr plat.dat t-char t-char t-char 
      plat.kw t-date t-char t-char plat.nazwa-plat plat.rach-plat t-char
      plat.nazwa-bnk-plat plat.bik-plat plat.kor-plat t-char plat.inn-plat
      t-char t-char t-char plat.nazwa-bnk-pol plat.nazwa-pol plat.rach-pol 
      t-char t-char plat.bik-pol plat.kor-pol t-char plat.inn-pol plat.tresc
      t-char t-char t-char t-char t-char t-char t-char plat.dat1.
    if from-sb then assign
      plat.dat = substr(plat.dat,9,2) + substr(plat.dat,1,2) + 
        substr(plat.dat,4,2)
      plat.dat1 = substr(plat.dat1,9,2) + substr(plat.dat1,1,2) + 
        substr(plat.dat1,4,2).
    assign plat.kw = string(decimal(replace(plat.kw,' ','')) / 100)
           nn = nn + 1. 
  end.
  input stream str-in close.
  unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
    substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null').
  t-bank.kol = t-bank.kol - 1.
end.  
session:date-format = 'ymd'.
end procedure. 

/* Slava 11/09/2013 - на основе former-sb */
procedure former-spad.
def var i as int.
def var kol as int.
def var t-char as char.
def var t-deci as deci.
def var t-date as date.
def var curve-date as char.

assign kol = t-bank.kol
       nn = 1
       curve-date = string(parm.wart-dat)
       session:date-format = 'mdy'.
do i = 1 to kol:
  unix silent value('/opt/dlc/bin/dbf 1 1 ' + entry(i,t-bank.list) + 
    ' /bankier/tmp/dbf-error > /bankier/tmp/dbf-spad').
  input stream str-in from '/bankier/tmp/dbf-spad'.
  repeat transaction on error undo, leave:

    for each t-spad: 
      delete t-spad.
    end.
    create t-spad.
    import stream str-in t-spad.

    /* 
       2014 01 30
       Это неправильный документ - нам прислали нашу собственную платежку
       надо его пропустить
     */
    if t-spad.bik-plat = "046568782" then do:

        next.

    end.

    create plat.
    assign plat.num = nn
           plat.dat = curve-date
           plat.spad = True
           . 
    /* 
    import stream str-in t-char plat.nr plat.dat t-char t-char t-char 
      plat.kw t-date t-char t-char plat.nazwa-plat plat.rach-plat t-char
      plat.nazwa-bnk-plat plat.bik-plat plat.kor-plat t-char plat.inn-plat
      t-char t-char t-char plat.nazwa-bnk-pol plat.nazwa-pol plat.rach-pol 
      t-char t-char plat.bik-pol plat.kor-pol t-char plat.inn-pol plat.tresc
      t-char t-char t-char t-char t-char t-char t-char plat.dat1.
    */


    buffer-copy t-spad to plat.

    /* бородин -мусор в dbf полях */

    assign 
      plat.tresc         = replace(replace(replace(plat.tresc,'^',' '),chr(10),' '),chr(13),' ')
      plat.nazwa-plat    = replace(replace(replace(plat.nazwa-plat,'^',' '),chr(10),' '),chr(13),' ')
      plat.nazwa-pol     = replace(replace(replace(plat.nazwa-pol,'^',' '),chr(10),' '),chr(13),' ')
      plat.nazwa-bnk-plat= replace(replace(replace(plat.nazwa-bnk-plat,'^',' '),chr(10),' '),chr(13),' ')
      plat.nazwa-bnk-pol = replace(replace(replace(plat.nazwa-bnk-pol,'^',' '),chr(10),' '),chr(13),' ')
    .


    plat.dat1 = plat.dat.
    /* if from-sb then */assign
      plat.dat = substr(plat.dat,9,2) + substr(plat.dat,1,2) + 
        substr(plat.dat,4,2)
      plat.dat1 = substr(plat.dat1,9,2) + substr(plat.dat1,1,2) + 
        substr(plat.dat1,4,2).
    assign plat.kw = trim( string(decimal(replace(plat.kw,' ','')),">>>>>>>>>>>9.99") ). /* / 100*/ 
    /* Slava 20/01/2013 */
    plat.nr = string(integer(plat.nr)) no-error.
    case plat.typdoc:
      when "ДА" then plat.typdoc = '09'.
    end case.
           nn = nn + 1. 
  end.
  input stream str-in close.
  unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
    substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null').
  t-bank.kol = t-bank.kol - 1.
end.  
session:date-format = 'ymd'.
end procedure. 



procedure former-chelin.
def var i as int.
def var kol as int.
def var t-char as char.
def var curve-date as char.
def var p as int extent 2.
def var c-info as char extent 10.

assign kol = t-bank.kol
       nn = 1
       session:date-format = 'mdy'
       curve-date = string(parm.wart-dat,'99/99/9999'). 
do i = 1 to kol:
  unix silent value('/opt/dlc/bin/dbf 1 1 ' + entry(i,t-bank.list) + 
    ' /bankier/tmp/dbf-error > /bankier/tmp/dbf-chel').
  input stream str-in from '/bankier/tmp/dbf-chel'.
  repeat transaction on error undo, leave:
    create plat.
    plat.num = nn.
    import stream str-in t-char plat.nr plat.dat 
      plat.rach-plat plat.kor-plat plat.bik-plat plat.nazwa-plat       
      plat.nazwa-bnk-plat t-char 
      plat.rach-pol plat.kor-pol plat.bik-pol plat.nazwa-pol 
      plat.nazwa-bnk-pol t-char t-char 
      plat.kw plat.tresc t-char t-char
      c-info[1] c-info[2] c-info[3] c-info[4] c-info[5]  t-char 
      c-info[6] c-info[7] c-info[8] c-info[9] c-info[10] t-char 
      t-char t-char plat.dat1.
    if c-info[1] <> '' then assign plat.rach-plat = c-info[1]
                                   plat.kor-plat = c-info[2]
                                   plat.bik-plat = c-info[3]
                                   plat.nazwa-plat = c-info[4]
                                   plat.nazwa-bnk-plat = c-info[5].
    if c-info[6] <> '' then assign plat.rach-pol = c-info[6]
                                   plat.kor-pol = c-info[7]
                                   plat.bik-pol = c-info[8]
                                   plat.nazwa-pol = c-info[9]
                                   plat.nazwa-bnk-pol = c-info[10].
    if plat.dat1 = ? then plat.dat1 = curve-date.
    assign plat.dat = substr(plat.dat,9,2) + substr(plat.dat,1,2) +
             substr(plat.dat,4,2)
           plat.dat1 = substr(plat.dat1,9,2) + substr(plat.dat1,1,2) + 
             substr(plat.dat1,4,2).
/*           p[1] = index(plat.nazwa-plat,'ИНН') + 3.
    if p[1] > 3 then do:
      repeat while substr(plat.nazwa-plat,p[1],1) = ' ': p[1] = p[1] + 1. end.
      assign p[2] = index(plat.nazwa-plat,' ',p[1])
             plat.inn-plat = substr(plat.nazwa-plat,p[1],p[2] - p[1])
             plat.nazwa-plat = trim(substr(plat.nazwa-plat,p[2])).
    end.
    p[1] = index(plat.nazwa-pol,'ИНН') + 3.
    if p[1] > 3 then do:
      repeat while substr(plat.nazwa-pol,p[1],1) = ' ': p[1] = p[1] + 1. end.
      assign p[2] = index(plat.nazwa-pol,' ',p[1])
             plat.inn-pol = substr(plat.nazwa-pol,p[1],p[2] - p[1])
             plat.nazwa-pol = trim(substr(plat.nazwa-pol,p[2])).
    end. */
    nn = nn + 1. 
  end.
  input stream str-in close.
/*  display plat except rach1 test refer. pause. */
  unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
    substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null').
  t-bank.kol = t-bank.kol - 1.
end.  
session:date-format = 'ymd'.
end procedure. 

procedure former-ubrir.
def var i as int.
def var j as int.
def var mes-in-file as int.
def var kol as int.
def var inn-kpp as int.

kol = t-bank.kol.
/*message t-bank.list view-as alert-box.*/
do i = 1 to kol:
  mes-in-file = 0.
  input stream str-in from value(entry(i,t-bank.list)).
  repeat transaction on error undo, leave:
    import stream str-in unformatted stroka. 
    /* Slava - хотя теперь платежки в файле выделяются маркерами `PAYMENT` и
    `PAGE_END`, шдем  их на йух и ищем как раньше почти  */
    if index(stroka,'ПЛАТЕЖHОE  ПОРУЧЕHИЕ  N') > 0 then do:
      create plat.
      assign mes-in-file = mes-in-file + 1
             plat.nr = substr(stroka,27,5) 
             plat.dat = substr(stroka,53,2) + 
                        substr(stroka,48,2) +
                        substr(stroka,45,2).
             /* Slava - срока платежа нет - берем dzis */
             plat.dat1 = string(year(dzis) - 2000,"99") + 
                         string(month(dzis),"99") + 
                         string(day(dzis),"99").
      do j = 2 to /* 37*/ 42:
        import stream str-in unformatted stroka.
/*message stroka view-as alert-box.        */
        case j:
          /* Slava 09/09/2008 - ИНН и КПП теперь прямо считываем */
          when 9 then do:
            plat.inn-plat = trim(substr(stroka,8,12)).
            /* plat.kpp-plat = substr(stroka,31,9). */
            plat.kw = trim(substr(stroka,58)). /* и сумму здесь же */
          end.
          when 11 or when 12 or when 13 or when 14 then do:
            plat.nazwa-plat = plat.nazwa-plat + trim(substr(stroka,4,45)) + ' '.
            /* if j = 7 then plat.kw = trim(replace(substr(stroka,56),'-','.')). */
            if j = 14 then plat.rach-plat = trim(substr(stroka,58)).
          end.  
          when 17 then plat.bik-plat = trim(substr(stroka,58)).
          when 19 then plat.kor-plat = trim(substr(stroka,58)).
          when 21 then plat.bik-pol = trim(substr(stroka,58)).
          when 23 then plat.kor-pol = trim(substr(stroka,58)).
          /* Slava 09/09/2008 - ИНН и КПП теперь прямо считываем */
          when 25 then do:
          /* было
            plat.inn-plat = trim(substr(stroka,8,12)).
            стало */
            plat.inn-pol = trim(substr(stroka,8,12)).
           
            /* plat.kpp-plat = substr(stroka,31,9). */
            plat.rach-pol = trim(substr(stroka,58)). /* и счет здесь же */
          end.

          when 27 or when 28 or when 29 or when 30
            then do:
            plat.nazwa-pol = plat.nazwa-pol + trim(substr(stroka,4,45)) + ' '.
            /*if j = 23 then plat.rach-pol = trim(substr(stroka,56)).
            if j = 28 then plat.dat1 = substr(stroka,83,2) + 
                                       substr(stroka,78,2) +
                                       substr(stroka,75,2).
                                       */
          end.                             
          when 35 or when 36 or when 37 or when 38 or when 39 then 
            plat.tresc = plat.tresc + trim(substr(stroka,4)) + ' '.
        end case.
      end.
      /*
      inn-kpp = lookup('ИНН',plat.nazwa-plat,' ').
      if inn-kpp > 0 then 
        assign plat.inn-plat = trim(entry(inn-kpp + 1,plat.nazwa-plat,' '))
               entry(inn-kpp,plat.nazwa-plat,' ') = ''
               entry(inn-kpp + 1,plat.nazwa-plat,' ') = ''.
      inn-kpp = lookup('КПП',plat.nazwa-plat,' ').
      if inn-kpp > 0 then assign entry(inn-kpp,plat.nazwa-plat,' ') = ''
                                 entry(inn-kpp + 1,plat.nazwa-plat,' ') = ''.
      inn-kpp = lookup('ИНН',plat.nazwa-pol,' ').
      if inn-kpp > 0 then 
        assign plat.inn-pol = trim(entry(inn-kpp + 1,plat.nazwa-pol,' '))
               entry(inn-kpp,plat.nazwa-pol,' ') = ''
               entry(inn-kpp + 1,plat.nazwa-pol,' ') = ''.
      inn-kpp = lookup('КПП',plat.nazwa-pol,' ').
      if inn-kpp > 0 then assign entry(inn-kpp,plat.nazwa-pol,' ') = ''
                                 entry(inn-kpp + 1,plat.nazwa-pol,' ') = ''.
      */
      assign plat.nazwa-plat = trim(plat.nazwa-plat)
             plat.nazwa-pol = trim(plat.nazwa-pol).
      find bank-ew no-lock where bank-ew.nr-banku = int(plat.bik-plat) no-error.
      if avail bank-ew then plat.nazwa-bnk-plat = bank-ew.nazwa.
      find bank-ew no-lock where bank-ew.nr-banku = int(plat.bik-pol) no-error.
      if avail bank-ew then plat.nazwa-bnk-pol = bank-ew.nazwa.
    end.
  end.  
  input stream str-in close.
  if mes-in-file > 0 then do:
    unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null'). 
    t-bank.kol = t-bank.kol - 1.
  end.
  else  message 'В файле ' entry(i,t-bank.list) skip
                'не обнаружено ни одного сообщения !' skip
                'Проверьте его !' view-as alert-box.
end.
end procedure.

procedure former-skb.
def var i as int.
def var inside as logical no-undo.
def var kol as int.
def var mes-in-file as int.
def var sta as char init "~{1:F01SKBERU4EA".
def var sto as char init "-~}".

assign sta = chr(1) + sta
       sto = sto + chr(3) 
       kol = t-bank.kol.
do i = 1 to kol:
  assign tmp = entry(i,t-bank.list)
         tmp = substr(tmp,1,r-index(tmp,'/')) + string(time)
         mes-in-file = 0.
  unix silent value('rex-killer.pl ' + entry(i,t-bank.list) + ' ' + tmp + 
    ' > /dev/null'). 
  input stream str-in from value(tmp).
  inside = no.
  c0: repeat transaction on error undo, leave c0:
    import stream str-in unformatted stroka. 
    if index(stroka,sta) > 0 then do:

      create plat.
      assign inside = yes
             plat.test = substr(stroka,r-index(stroka,'TEST:') + 5)
             plat.test = trim(substr(plat.test,1,index(plat.test,'}') - 1))
             plat.bik-plat = '046577756'
             plat.bik-pol = '046568782'
             plat.kor-plat = '30101810800000000756'
             plat.kor-pol = '30101810500000000782'.  
    end.
    if stroka begins sto and inside then assign inside = no 
                                                mes-in-file = mes-in-file + 1.
    if inside then do:
      if stroka begins ':20:' then plat.refer = trim(substr(stroka,5)).
      if stroka begins ':32A:' then 
        assign plat.dat1 = substr(stroka,6,6)
               plat.dat = plat.dat1        
               plat.kw = replace(substr(stroka,15),',','.').
      if stroka begins ':50:' then do:
        plat.rach-plat = substr(stroka,6).
        import stream str-in unformatted stroka.
        plat.inn-plat = substr(stroka,4,12).
        repeat on error undo, leave c0:
          import stream str-in unformatted stroka.
          if stroka begins ':5' then leave.
          /*if stroka begins 'INN' then plat.inn-plat = substr(stroka,4,12).
                                 else plat.nazwa-plat = 
                                      plat.nazwa-plat + stroka.*/
          plat.nazwa-plat = plat.nazwa-plat + ' ' + stroka.
        end.
      end.  
      if stroka begins ':52D:'then assign plat.bik-plat = substr(stroka,10,9)
                                          plat.kor-plat = substr(stroka,20).
      find bank-ew no-lock where bank-ew.nr-banku = int(plat.bik-plat) no-error.
      if avail bank-ew then plat.nazwa-bnk-plat = bank-ew.nazwa.
      if stroka begins ':53B:' then
        plat.loro = can-do(loro-list,trim(substring(stroka,7))).
      if stroka begins ':57D:' then assign plat.bik-pol = substr(stroka,10,9)
                                           plat.kor-pol = substr(stroka,20).
      find bank-ew no-lock where bank-ew.nr-banku = int(plat.bik-pol) no-error.
      if avail bank-ew then plat.nazwa-bnk-pol = bank-ew.nazwa.
      if stroka begins ':59:' then do:
        plat.rach-pol = substr(stroka,6).
        import stream str-in unformatted stroka.
        plat.inn-pol = substr(stroka,4,12).
        repeat on error undo, leave c0:
          import stream str-in unformatted stroka.
          if stroka begins ':70:' then leave.
          plat.nazwa-pol = plat.nazwa-pol + stroka.
        end.
      end.
      if stroka begins ':70:' then do:  
        plat.tresc = substr(stroka,5).
        repeat on error undo, leave c0:
          import stream str-in unformatted stroka.
          if (stroka begins ':71A:') or (stroka begins ':72:') then leave. 
          else plat.tresc = plat.tresc + stroka.
        end. 
      end.  
      if stroka begins ':72:/RPP/' then assign
        stroka = substr(stroka,index(stroka,'/RPP/') + 5)
        plat.nr = entry(1,stroka,'.')
        plat.dat1 = entry(2,stroka,'.')
        plat.ocher = entry(3,stroka,'.').
/*        
        plat.nr = substr(stroka, index(stroka,'/RPP/') + 5, 
                  index(stroka,'.') - index(stroka,'/RPP/') - 5)
        plat.ocher = substr(stroka,index(stroka,'ELEK') - 3,2)
        plat.dat1 = substr(stroka,index(stroka,'ELEK') + 5). 
*/
    end.    
  end.      
  input stream str-in close.
  if mes-in-file > 0 then do:
    unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null'). 
    t-bank.kol = t-bank.kol - 1.
  end.
  else  message 'В файле ' entry(i,t-bank.list) skip
                'не обнаружено ни одного сообщения !' skip
                'Проверьте его !' view-as alert-box.
  unix silent value('rm ' + tmp + ' > /dev/null').
end.
for each plat:
  run ov-liter.p(no,plat.nazwa-plat,output plat.nazwa-plat).
  run ov-liter.p(no,plat.nazwa-pol,output plat.nazwa-pol).
  run ov-liter.p(no,plat.tresc,output plat.tresc).
end.  
end procedure.

procedure former-alpha.
def var i as int.
def var inside as logical no-undo.
def var kol as int.
def var mes-in-file as int.
def var sta as char init "~{1:F01SKBERU4EA".
def var sto as char init "-~}".

assign sta = chr(1) + sta
       sto = sto + chr(3) 
       kol = t-bank.kol.
do i = 1 to kol:
  assign tmp = entry(i,t-bank.list)
         tmp = substr(tmp,1,r-index(tmp,'/')) + string(time)
         mes-in-file = 0.
  unix silent value('rex-killer.pl ' + entry(i,t-bank.list) + ' ' + tmp + 
    ' > /dev/null'). 
  input stream str-in from value(tmp).
  inside = no.
  c0: repeat transaction on error undo, leave c0:
    import stream str-in unformatted stroka. 
    if index(stroka,sta) > 0 then do:
      create plat.
      assign inside = yes
             plat.test = substr(stroka,r-index(stroka,'TEST:') + 5)
             plat.test = trim(substr(plat.test,1,index(plat.test,'}') - 1))
             plat.bik-plat = '046577756'
             plat.bik-pol = '046568782'
             plat.kor-plat = '30101810800000000756'
             plat.kor-pol = '30101810500000000782'.  
    end.
    if stroka begins sto and inside then assign inside = no 
                                                mes-in-file = mes-in-file + 1.
    if inside then do:
      if stroka begins ':20:' then plat.refer = trim(substr(stroka,5)).
      if stroka begins ':32A:' then 
        assign plat.dat1 = substr(stroka,6,6)
               plat.dat = plat.dat1        
               plat.kw = replace(substr(stroka,15),',','.').
      if stroka begins ':50:' then do:
        plat.rach-plat = substr(stroka,6).
        import stream str-in unformatted stroka.
        plat.inn-plat = substr(stroka,4,12).
        repeat on error undo, leave c0:
          import stream str-in unformatted stroka.
          if stroka begins ':5' then leave.
          /*if stroka begins 'INN' then plat.inn-plat = substr(stroka,4,12).
                                 else plat.nazwa-plat = 
                                      plat.nazwa-plat + stroka.*/
          plat.nazwa-plat = plat.nazwa-plat + ' ' + stroka.
        end.
      end.  
      if stroka begins ':52D:'then assign plat.bik-plat = substr(stroka,10,9)
                                          plat.kor-plat = substr(stroka,20).
      find bank-ew no-lock where bank-ew.nr-banku = int(plat.bik-plat) no-error.
      if avail bank-ew then plat.nazwa-bnk-plat = bank-ew.nazwa.
      if stroka begins ':53B:' then
        plat.loro = can-do(loro-list,trim(substring(stroka,7))).
      if stroka begins ':57D:' then assign plat.bik-pol = substr(stroka,10,9)
                                           plat.kor-pol = substr(stroka,20).
      find bank-ew no-lock where bank-ew.nr-banku = int(plat.bik-pol) no-error.
      if avail bank-ew then plat.nazwa-bnk-pol = bank-ew.nazwa.
      if stroka begins ':59:' then do:
        plat.rach-pol = substr(stroka,6).
        import stream str-in unformatted stroka.
        plat.inn-pol = substr(stroka,4,12).
        repeat on error undo, leave c0:
          import stream str-in unformatted stroka.
          if stroka begins ':70:' then leave.
          plat.nazwa-pol = plat.nazwa-pol + stroka.
        end.
      end.
      if stroka begins ':70:' then do:  
        plat.tresc = substr(stroka,5).
        repeat on error undo, leave c0:
          import stream str-in unformatted stroka.
          if (stroka begins ':71A:') or (stroka begins ':72:') then leave. 
          else plat.tresc = plat.tresc + stroka.
        end. 
      end.  
      if stroka begins ':72:/RPP/' then assign
        stroka = substr(stroka,index(stroka,'/RPP/') + 5)
        plat.nr = entry(1,stroka,'.')
        plat.dat1 = entry(2,stroka,'.')
        plat.ocher = entry(3,stroka,'.').
/*        
        plat.nr = substr(stroka, index(stroka,'/RPP/') + 5, 
                  index(stroka,'.') - index(stroka,'/RPP/') - 5)
        plat.ocher = substr(stroka,index(stroka,'ELEK') - 3,2)
        plat.dat1 = substr(stroka,index(stroka,'ELEK') + 5). 
*/
    end.    
  end.      
  input stream str-in close.
  if mes-in-file > 0 then do:
    unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null'). 
    t-bank.kol = t-bank.kol - 1.
  end.
  else  message 'В файле ' entry(i,t-bank.list) skip
                'не обнаружено ни одного сообщения !' skip
                'Проверьте его !' view-as alert-box.
  unix silent value('rm ' + tmp + ' > /dev/null').
end.
for each plat:
  run ov-liter.p(no,plat.nazwa-plat,output plat.nazwa-plat).
  run ov-liter.p(no,plat.nazwa-pol,output plat.nazwa-pol).
  run ov-liter.p(no,plat.tresc,output plat.tresc).
end.  
end procedure.



procedure former-ors.
def var i as int.
def var mes-in-file as int.
def var kol as int.

def buffer parm-1 for parm.
def buffer bank-ew-1 for bank-ew.

find parm-1 no-lock where parm-1.rodz-par = 'BANK-WL'.
find bank-ew-1 no-lock where bank-ew-1.nr-banku = int(parm-1.wart-par). 
kol = t-bank.kol.
c1: do i = 1 to kol:
  mes-in-file = 0.
  input stream str-in from value(entry(i,t-bank.list)).
  repeat on error undo, leave:
    import stream str-in unformatted stroka.
    if index(stroka,'^') = 0 then next.
    create plat.
    assign plat.dat = substr(entry(1,stroka,'^'),7,2) +
                      substr(entry(1,stroka,'^'),4,2) +
                      substr(entry(1,stroka,'^'),1,2)
           plat.dat1 = plat.dat
           plat.rach-pol = entry(2,stroka,'^')
           plat.nazwa-pol = entry(3,stroka,'^')
           plat.bik-pol = string(int(parm-1.wart-par))
           plat.kor-pol = bank-ew-1.rach-nbp
           plat.nazwa-bnk-pol = bank-ew-1.nazwa
           plat.gor-pol = bank-ew-1.miasto
           plat.nr = entry(4,stroka,'^')
           plat.inn-plat = entry(7,stroka,'^')
           plat.nazwa-plat = entry(8,stroka,'^')
           plat.rach-plat = entry(9,stroka,'^')
           plat.bik-plat = entry(10,stroka,'^')
           plat.kor-plat = entry(11,stroka,'^')                       
           plat.nazwa-bnk-plat = entry(12,stroka,'^')
           plat.gor-plat = entry(13,stroka,'^')
           plat.kw = entry(14,stroka,'^') 
           plat.tresc = entry(15,stroka,'^')
           mes-in-file = mes-in-file + 1.
  end.         
  input stream str-in close.
  if mes-in-file > 0 then do:
    unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null'). 
    t-bank.kol = t-bank.kol - 1.
  end.
  else message 'В файле ' entry(i,t-bank.list) skip
               'не обнаружено ни одного сообщения !' skip
               'Проверьте его !' view-as alert-box.
end.
end procedure.

procedure former-rnko.
def var i as int.
def var j as int.
def var mes-in-file as int.
def var kol as int.

/*03.12.2004
  Добавил OvAl для замены реквизитов плательщика и получателя на наши в случае,
  если плательщиком являемся мы (по признаку ИНН плательщика).
*/  
def buffer glowny-plat  for glowny.
def buffer glowny-pol   for glowny.


  /*ivonin*/
  /*какая то поебень!  удалить что ли?*/

find adres no-lock where adres.rachunek = 13.
find last parm no-lock where parm.rodz-par = 'BANK-WL'.
find bank-ew no-lock where bank-ew.nr-banku = int(parm.wart-par).

/**/

kol = t-bank.kol.
c1: do i = 1 to kol:
  mes-in-file = 0.

  /*input stream str-in from value(entry(i,t-bank.list)).*/

  input stream str-in through value("unzip -p " + entry(i,t-bank.list)).
  c2: do on error undo, leave c2:
    import stream str-in unformatted stroka.
    
    /* Переделал OvAl 30.08.2005 в связи с изменением формата.
    mes-in-file = int(substr(stroka,25,6)).
    do j = 1 to mes-in-file:*/

    repeat on error undo, leave:
      import stream str-in unformatted stroka.
      mes-in-file = mes-in-file + 1.
      create plat.
      assign plat.bik-plat = substr(stroka,2,9)
             plat.kor-plat = substr(stroka,11,25)
             plat.rach-plat = substr(stroka,36,25)
             plat.inn-plat = substr(stroka,61,12)
             plat.bik-pol = substr(stroka,73,9)
             plat.kor-pol = substr(stroka,82,25)
             plat.rach-pol = substr(stroka,107,25)
             plat.inn-pol = substr(stroka,132,12)
             plat.kw = substr(stroka,145,12) + '.' + substr(stroka,157,2)
             plat.nr = substr(stroka,161,10)
             plat.dat = substr(stroka,183,6)
             plat.dat1 = if index(substr(stroka,189,8),' ') = 0 then                                       
                                                substr(stroka,191,6)
                         else plat.dat
             plat.ocher = substr(stroka,206,2)
             plat.nazwa-plat = substr(stroka,208,160)
             plat.nazwa-pol = substr(stroka,368,160)
             plat.tresc = substr(stroka,528,640)
             plat.typdoc = '09'.

/*13.09.2012*/ 
    if substr(stroka,46,3) <> '810' and 
       substr(stroka,117,3) <> '810' then do:      
            plat.wal-plat = substr(stroka,46,3).
    end.
/* 07.08.2014
   РНКО начал посылать кроссвалютные проводки
   считаем, что ориентироваться надо на коррсчет
   меняем только выдачу
*/
    /*выдача перевода*/
    if substr(stroka,144,1) = '0' then do:                              

       if substr(stroka,46,3) = '810' and 
         (substr(stroka,117,3) = '810' or substr(stroka,117,3) = '000') then do:      

/*ivonin 15.10.2012*/

            /*plat.kordt49 = '30213810500000021384'.*/

            plat.kordt49 = '30110810600000011384'.

           /*plat.korkt55 = '47423810950330001384'.*/

            plat.korkt55 = '30233810800700001384'.
       end.


       if substr(stroka,46,3) = '840' and 
         (substr(stroka,117,3) = '840' or substr(stroka,117,3) = '000') then do:      


            /*plat.kordt49 = '30213840800000021384'.*/

            plat.kordt49 = '30110840900000011384'.

           /*plat.korkt55 = '47423840250330001384'.*/

            plat.korkt55 = '30233840100700001384'.
       end.

       if substr(stroka,46,3) = '978' and 
         (substr(stroka,117,3) = '978' or substr(stroka,117,3) = '000') then do:      

            /*plat.kordt49 = '30213978400000021384'.*/

            plat.kordt49 = '30110978500000011384'.

            /*plat.korkt55 = '47423978850330001384'.*/

            plat.korkt55 = '30233978700700001384'.
       end.

            plat.kor-pol = '30101810500000000782'.
            plat.rach-pol = plat.korkt55.
            plat.bik-pol = '046568782'. /* Slava 2013/12/16*/

    end.


    /*отправка перевода*/
    /* коррсчет стоит по дебету в приедшем файле с 41 позиции
     с 07.08.2008 меняем определение транзитного счета - ориентируемся только на дебет

     валюта платежей во всех случаях была рубль
     не стал ее переопределять
    */
    else do:


       if substr(stroka,46,3) = '810' /* and  substr(stroka,117,3) = '810' */ then do:      

            /*plat.kordt49 = '47422810650330001384'.*/
            plat.kordt49 = '30232810500700001384'.

            /*plat.korkt55 = '30213810500000021384'.*/

            plat.korkt55 = '30110810600000011384'.


       end.


       if substr(stroka,46,3) = '840' /* and  substr(stroka,117,3) = '840' */ then do:      
            /*plat.kordt49 = '47422840950330001384'.*/
            plat.kordt49 = '30232840800700001384'.

            /*plat.korkt55 = '30213840800000021384'.*/

            plat.korkt55 = '30110840900000011384'.

       end.

       if substr(stroka,46,3) = '978' /* and  substr(stroka,117,3) = '978' */ then do:      

            /*plat.kordt49 = '47422978550330001384'.*/
            plat.kordt49 = '30232978400700001384'.

            /*plat.korkt55 = '30213978400000021384'.*/

            plat.korkt55 = '30110978500000011384'.
       end.

         plat.rach-pol = plat.korkt55. 
         plat.bik-pol = '046568782'.


         plat.kor-pol = plat.kor-plat.


         plat.rach-plat = plat.kordt49.
         plat.kor-plat = '30101810500000000782'.
         plat.bik-plat = '046568782'.

    end.


/**/

/*ivonin ничего менять не нада*/

/*

/* 17.05.2005 замена счетов 47422 и 47423 на 30232 и 30233*/
      if int(plat.bik-plat) = bank-ew.nr-banku then do:
        if trim(plat.rach-plat) begins '47422' then do:
          find first glowny-plat no-lock where
            glowny-plat.konto = 30232 and
            glowny-plat.subkonto = '5004' and
            glowny-plat.usuniety = no.
          plat.rach-plat = glowny-plat.rach-ext.  
        end.
        if trim(plat.rach-plat) begins '47423' then do:
          find first glowny-plat no-lock where
            glowny-plat.konto = 30233 and
            glowny-plat.subkonto = '5004' and
            glowny-plat.usuniety = no.
          plat.rach-plat = glowny-plat.rach-ext.  
        end.
      end.
      if int(plat.bik-pol) = bank-ew.nr-banku then do:
        if trim(plat.rach-pol) begins '47422' then do:
          find first glowny-pol no-lock where
            glowny-pol.konto = 30232 and
            glowny-pol.subkonto = '5004' and
            glowny-pol.usuniety = no.
          plat.rach-pol = glowny-pol.rach-ext.  
        end.
        if trim(plat.rach-pol) begins '47423' then do:
          find first glowny-pol no-lock where
            glowny-pol.konto = 30233 and
            glowny-pol.subkonto = '5004' and
            glowny-pol.usuniety = no.
          plat.rach-pol = glowny-pol.rach-ext.  
        end.
      end.

/*15.12.2004*/  

      if plat.inn-plat = adres.regon then do:
        if plat.rach-pol begins '70107' then do:
          find first synt no-lock where
            synt.konto = 70209 and
            synt.subkonto = '4001' and
            synt.usuniety = no no-error.
          if avail synt then do:
            find first glowny no-lock of synt no-error.
            if avail glowny then plat.rach-plat = glowny.rach-ext.
          end.
        end. 
        else plat.rach-plat = glowny-plat.rach-ext.
        assign
          plat.bik-plat = string(bank-ew.nr-banku)
          plat.kor-plat = bank-ew.rach-nbp
          plat.bik-pol = plat.bik-plat
          plat.kor-pol = plat.kor-plat
          plat.rach-pol = glowny-pol.rach-ext
          plat.platina = yes.       
      end.  
/**/   

*/
   
    
    end.    
  end.
  input stream str-in close.
  if mes-in-file > 0 then do:
    unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null'). 
    t-bank.kol = t-bank.kol - 1.
  end.
  else message 'В файле ' entry(i,t-bank.list) skip
               'не обнаружено ни одного сообщения !' skip
               'Проверьте его !' view-as alert-box.
end.
end procedure.

procedure former-nikoil.
def var i as int.
def var j as int.
def var k as int.
def var c as char form 'x'.
def var inside as logical no-undo.
def var kol as int.
def var mes-in-file as int.
def var sta as char init "YZYZ".
def var sto as char init "NNNN".

kol = t-bank.kol.
do i = 1 to kol:
  assign tmp = entry(i,t-bank.list)
         tmp = substr(tmp,1,r-index(tmp,'/')) + string(time)
         mes-in-file = 0.
  unix silent value('rex-killer.pl ' + entry(i,t-bank.list) + ' ' + tmp + 
    ' > /dev/null'). 
  input stream str-in from value(tmp).
  inside = no.
  c0: repeat transaction on error undo, leave c0:
    import stream str-in unformatted stroka. 
/*message stroka inside view-as alert-box.*/
    if index(stroka,sta) > 0 then do:
      create plat.
      assign inside = yes
             plat.bik-plat = '044525566'
             plat.bik-pol = '046568782'
             plat.kor-plat = '30101810800000000566'
             plat.kor-pol = '30101810500000000782'.  
    end.
    if stroka begins sto and inside then assign inside = no 
                                                mes-in-file = mes-in-file + 1.
    if inside then do:
      if stroka begins ':15:' then plat.test = trim(substr(stroka,5)).
      if stroka begins ':20:' then plat.refer = trim(substr(stroka,5)).
      if stroka begins ':32:' then 
        assign plat.dat1 = substr(stroka,5,6)
               plat.dat = plat.dat1        
               plat.kw = replace(substr(stroka,14),',','.').
      if stroka begins ':50:' then do:
        plat.rach-plat = substr(stroka,6).
        repeat on error undo, leave c0:
          import stream str-in unformatted stroka.
          if stroka begins ':5' then leave.
          if stroka begins 'ИНН' then 
            do j = 4 to length(stroka):
              c = substr(stroka,j,1).
              if c = '.' then leave.
              if c <> ' ' then plat.inn-plat = plat.inn-plat + c. 
            end.  
          else plat.nazwa-plat = plat.nazwa-plat + stroka.
        end.
      end.  
      if stroka begins ':59:' then do:
        plat.rach-pol = substr(stroka,6).
        repeat on error undo, leave c0:
          import stream str-in unformatted stroka.
          if stroka begins ':70:' then leave.
          if stroka begins 'ИНН' then 
            do j = 4 to length(stroka):
              c = substr(stroka,j,1).
              if c = '.' then leave.
              if c <> ' ' then plat.inn-pol = plat.inn-pol + c. 
            end.  
          else plat.nazwa-pol = plat.nazwa-pol + stroka.
        end.
      end.
      if stroka begins ':70:' then do:  
        plat.tresc = trim(substr(stroka,5)).
        repeat on error undo, leave c0:
          import stream str-in unformatted stroka.
          if (stroka begins ':71:' or
              stroka begins ':72:/RPP/' or
              stroka begins '/NZP/' or
              stroka begins '//' or
              stroka begins '/DAS/' or
              stroka begins sto) then leave.
          else plat.tresc = plat.tresc + stroka.
        end.
      end.
      if stroka begins ':71:' then next c0.
      if stroka begins ':72:/RPP/' then assign 
        stroka = substr(stroka,index(stroka,'/RPP/') + 5)
        plat.nr = entry(1,stroka,'.')
        plat.dat1 = entry(2,stroka,'.')
        plat.ocher = entry(3,stroka,'.').
      if stroka begins '/NZP/' then 
        plat.tresc = plat.tresc + trim(substr(stroka,6)).
      if stroka begins '//' then 
        plat.tresc = plat.tresc + trim(substr(stroka,3)).
      if stroka begins '/DAS/' then next c0.  
      if stroka begins sto then do:
        inside = no.
        next c0.
      end.  
    end.    
  end.      
  input stream str-in close.
  if mes-in-file > 0 then do:
    unix silent value('mv -f ' + entry(i,t-bank.list) + ' ' +
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null'). 
    t-bank.kol = t-bank.kol - 1.
  end.
  else  message 'В файле ' entry(i,t-bank.list) skip
                'не обнаружено ни одного сообщения !' skip
                'Проверьте его !' view-as alert-box.
  unix silent value('rm ' + tmp + ' > /dev/null').
end.
end procedure.

procedure former-platina.
def var i as int.
def var j as int.
def var mes-in-file as int.
def var kol as int.
def var t-date as date.

find adres no-lock where adres.rachunek = 13.
find last parm no-lock where parm.rodz-par = 'BANK-WL'.
find bank-ew no-lock where bank-ew.nr-banku = int(parm.wart-par).

kol = t-bank.kol.
do i = 1 to kol:
  mes-in-file = 0.
  input stream str-in from value(entry(i,t-bank.list))
    convert source '1251' target 'IBM866'.
  repeat on error undo, leave:
    import stream str-in unformatted stroka.
    create plat.
    assign t-date = date(trim(substr(entry(1,stroka,'^'),3)))
           plat.nr = entry(2,stroka,'^')
           plat.bik-plat = string(bank-ew.nr-banku)
           plat.kor-plat = bank-ew.rach-nbp
           plat.rach-plat = entry(3,stroka,'^')
           plat.inn-plat = adres.regon
           plat.bik-pol = plat.bik-plat
           plat.kor-pol = plat.kor-plat
           plat.rach-pol = entry(4,stroka,'^')
           plat.inn-pol = plat.inn-plat
           plat.kw = entry(5,stroka,'^')
           plat.tresc = entry(6,stroka,'^')
           plat.platina = yes.
/* 15.07.05
   Вставил OvAl, чтобы дата не попала на выходной. 
*/ 
    repeat while can-find(first day_off where 
                            day_off.type_calend = 2 and
                            day_off.date = t-date):
      t-date = t-date + 1.                      
    end.
    assign plat.dat = string(t-date,'999999')
           plat.dat1 = plat.dat.
/* Конец вставки.
*/
    mes-in-file = mes-in-file + 1.
  end.
  input stream str-in close.
  if mes-in-file > 0 then do:
    unix silent value('mv ' + entry(i,t-bank.list) + ' ' +
      substr(entry(1,t-bank.list),1,pos) + 'BAK > /dev/null'). 
    t-bank.kol = t-bank.kol - 1.
  end.
  else message 'В файле ' entry(i,t-bank.list) skip
               'не обнаружено ни одного сообщения !' skip
               'Проверьте его !' view-as alert-box.
end.
end procedure.

