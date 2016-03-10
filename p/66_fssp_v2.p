{globals.i}
{setdest.i}
{intrface.get xclass}
{intrface.get tmcod}

DEF VAR id AS CHAR NO-UNDO.
DEF VAR barcode AS CHAR NO-UNDO.
DEF VAR actype AS CHAR NO-UNDO.
DEF VAR actNumber AS CHAR NO-UNDO.
DEF VAR actDate AS CHAR NO-UNDO.
DEF VAR execProcNumber AS CHAR NO-UNDO.
DEF VAR execProcDate AS CHAR NO-UNDO.
DEF VAR priority AS CHAR NO-UNDO.
DEF VAR execActNum AS CHAR NO-UNDO.
DEF VAR execActDate AS CHAR NO-UNDO.
DEF VAR execActInitial AS CHAR NO-UNDO.
DEF VAR execActInitialAddr AS CHAR NO-UNDO.
DEF VAR bailiff AS CHAR NO-UNDO.
DEF VAR summ AS CHAR NO-UNDO.
DEF VAR creditorName AS CHAR NO-UNDO.
DEF VAR creditorAddress AS CHAR NO-UNDO.
DEF VAR accountNumber AS CHAR NO-UNDO.
DEF VAR debtorFirstName AS CHAR NO-UNDO.
DEF VAR debtorLastName AS CHAR NO-UNDO.
DEF VAR debtorSecondName AS CHAR NO-UNDO.
DEF VAR debtorBornAddres AS CHAR NO-UNDO.
DEF VAR debtorAddres AS CHAR NO-UNDO.
DEF VAR debtorBirthYear AS CHAR NO-UNDO.
DEF VAR debtorBirth AS CHAR NO-UNDO.
DEF VAR territory AS CHAR NO-UNDO.
DEF VAR department AS CHAR NO-UNDO.
DEF VAR name1 AS CHAR NO-UNDO.
DEF VAR bankname AS CHAR NO-UNDO.
DEF VAR kpp AS CHAR NO-UNDO.
DEF VAR inn AS CHAR NO-UNDO.
DEF VAR okato AS CHAR NO-UNDO.
DEF VAR bik AS CHAR NO-UNDO.
DEF VAR ls AS CHAR NO-UNDO.
DEF VAR account AS CHAR NO-UNDO.
DEF VAR receivTitle AS CHAR NO-UNDO.
DEF VAR address AS CHAR NO-UNDO.
DEF VAR kbk AS CHAR NO-UNDO.
DEF VAR bankBranch AS CHAR NO-UNDO.
DEF VAR bankAgency AS CHAR NO-UNDO.
DEF VAR osbnumber AS CHAR NO-UNDO.
DEF VAR oldnumber AS CHAR NO-UNDO.
DEF VAR accountCurreny AS CHAR NO-UNDO.
DEF VAR ProcNumberState AS CHAR NO-UNDO.
DEF VAR vStatus AS CHAR NO-UNDO.
DEF VAR DolgnikOrg AS CHAR NO-UNDO.
DEF VAR DolgnikInn AS CHAR NO-UNDO.
DEF VAR DolgnikKpp AS CHAR NO-UNDO.
DEF VAR fioispolnitelya AS CHAR NO-UNDO.
DEF VAR spisDate AS CHAR NO-UNDO.
DEF VAR spisSumm AS CHAR NO-UNDO.
DEF VAR spisAccountCurreny AS CHAR NO-UNDO.
DEF VAR spisResult AS CHAR NO-UNDO.
DEF VAR spisPrim AS CHAR NO-UNDO.
DEF VAR typeText AS CHAR NO-UNDO.

DEFINE VARIABLE Item AS CHARACTER NO-UNDO.

DEF VAR mDirName AS CHAR NO-UNDO INIT "/home2/bis/quit41d/imp-exp/pristav/".
DEF VAR mDirNameIn AS CHAR NO-UNDO INIT "/home2/bis/quit41d/imp-exp/pristav/in/".
DEF VAR mDirNameOut AS CHAR NO-UNDO INIT "/home2/bis/quit41d/imp-exp/pristav/out/".
DEF VAR mDirNameArchIn AS CHAR NO-UNDO INIT "/home2/bis/quit41d/imp-exp/pristav/archive/in/".
DEF VAR mDirNameArchOut AS CHAR NO-UNDO INIT "/home2/bis/quit41d/imp-exp/pristav/archive/out/".
DEF VAR mFileNameIn AS CHAR NO-UNDO.
DEF VAR mFileNameOut AS CHAR NO-UNDO.
DEF VAR mFileNameOut1 AS CHAR NO-UNDO.
DEF VAR mPathIn AS CHAR NO-UNDO.
DEF VAR mTypeIn AS CHAR NO-UNDO.

DEF VAR mTypeKlient AS CHAR NO-UNDO.

DEFINE STREAM mIn.
DEFINE STREAM out-file_u.
DEFINE STREAM out-file_o.

UNIX SILENT rm -fr VALUE(mDirNameOut + "*") >/dev/null.

end-date = TODAY.

/* Обработка входных файлов */
INPUT STREAM mIn FROM OS-DIR(mDirNameIn).
REPEAT:
    IMPORT STREAM mIn mFileNameIn mPathIn mTypeIn.
    IF mTypeIn EQ "F" THEN DO:
        mFileNameOut = REPLACE(mFileNameIn, "p", "u").
        mFileNameOut1 = REPLACE(mFileNameIn, "p", "o").
        OUTPUT STREAM out-file_u TO VALUE(mDirNameOut + mFileNameOut) CONVERT TARGET "UTF-8".
        OUTPUT STREAM out-file_o TO VALUE(mDirNameOut + mFileNameOut1) CONVERT TARGET "UTF-8".
        RUN MakeOutFile.
        OUTPUT STREAM out-file_u CLOSE.
        OUTPUT STREAM out-file_o CLOSE.
    END.
END.
INPUT STREAM mIn CLOSE.

/* UNIX SILENT mv -f VALUE(mDirNameIn + "*.*") VALUE(mDirNameArchIn) >/dev/null. */

message "Обработка закончена"
view-as alert-box.

PUT UNFORMATTED "" SKIP(2).
PUT UNFORMATTED  string(today,"99/99/9999") " " string(time,"hh:mm:ss") SKIP(1).
{preview.i}

/*------- Формирование одного выходного файла ---------------------*/
PROCEDURE MakeOutFile:
/* загрузка запроса */
INPUT FROM VALUE(mPathIn) CONVERT SOURCE "UTF-8".
REPEAT:
	IMPORT UNFORMATTED Item.
    /* Save to struct */

0B52011151800000000850434|
DT3:005|
PA10:1800009999|
RC10:1800400000|
AM17:00000000010000000|
DE1:2|
CU3:RUR|
SH2:01|
MT3:132|
PN22:ОАО "БАЙКАЛИНВЕСТБАНК"|
SI10:3801002781|
SA20:30221810300000000849|
SB32:ОАО "БАЙКАЛИНВЕСТБАНК" г.ИРКУТСК|
SN9:042520706|
SK20:30101810500000000706|
SS3:МФО|
RN22:ОАО "БАЙКАЛИНВЕСТБАНК"|
RI10:3801002781|
RA20:30109810918000000849|
BN39:БАЙКАЛЬСКИЙ БАНК ПАО СБЕРБАНК г.ИРКУТСК|
BC9:042520607|
BK20:30101810900000000607|
RS3:МФО|
PP65:Подкрепление корсчета. Распоряжение N 337 от 20.11.2015. НДС нет.|
LD6:201115|
IN16:0010000662011155|
SC2:13|
SD6:201115|
PT4:1201|
DH6:201115|
ED6:201115|
KS8:EDEHKNMD|
EE:

    id1                 = ENTRY(2,TRIM(ENTRY(2, Item, "|")),":").
    id2                 = ENTRY(2,TRIM(ENTRY(3, Item, "|")),":").
    id3                 = ENTRY(2,TRIM(ENTRY(4, Item, "|")),":").
    id4                 = ENTRY(2,TRIM(ENTRY(5, Item, "|")),":").
    id5                 = ENTRY(2,TRIM(ENTRY(6, Item, "|")),":").
    id6                 = ENTRY(2,TRIM(ENTRY(7, Item, "|")),":").
    id7                 = ENTRY(2,TRIM(ENTRY(8, Item, "|")),":").
    id8                 = ENTRY(2,TRIM(ENTRY(9, Item, "|")),":").
    id9                 = ENTRY(2,TRIM(ENTRY(10, Item, "|")),":").
    id10                = ENTRY(2,TRIM(ENTRY(11, Item, "|")),":").
    id11                = ENTRY(2,TRIM(ENTRY(12, Item, "|")),":").
    id12                = ENTRY(2,TRIM(ENTRY(13, Item, "|")),":").
    id13                = ENTRY(2,TRIM(ENTRY(14, Item, "|")),":").
    id14                = ENTRY(2,TRIM(ENTRY(15, Item, "|")),":").
    id15                = ENTRY(2,TRIM(ENTRY(16, Item, "|")),":").
    id16                = ENTRY(2,TRIM(ENTRY(17, Item, "|")),":").
    id17                = ENTRY(2,TRIM(ENTRY(18, Item, "|")),":").
    id18                = ENTRY(2,TRIM(ENTRY(19, Item, "|")),":").
    id19                = ENTRY(2,TRIM(ENTRY(20, Item, "|")),":").
    id20                = ENTRY(2,TRIM(ENTRY(21, Item, "|")),":").
    id21                = ENTRY(2,TRIM(ENTRY(22, Item, "|")),":").
    id22                = ENTRY(2,TRIM(ENTRY(23, Item, "|")),":").
    id23                = ENTRY(2,TRIM(ENTRY(24, Item, "|")),":").
    id24                = ENTRY(2,TRIM(ENTRY(25, Item, "|")),":").
    id25                = ENTRY(2,TRIM(ENTRY(26, Item, "|")),":").
    id26                = ENTRY(2,TRIM(ENTRY(27, Item, "|")),":").
    id27                = ENTRY(2,TRIM(ENTRY(28, Item, "|")),":").
    id28                = ENTRY(2,TRIM(ENTRY(29, Item, "|")),":").
    id29                = ENTRY(2,TRIM(ENTRY(30, Item, "|")),":").
    id30                = ENTRY(2,TRIM(ENTRY(31, Item, "|")),":").


    barcode            = TRIM(ENTRY(3, Item, "|")).
    actype             = ENTRY(2,TRIM(ENTRY(4, Item, "|")),"=").
    actNumber          = TRIM(ENTRY(5, Item, "|")).
    actDate            = TRIM(ENTRY(6, Item, "|")).
    execProcNumber     = TRIM(ENTRY(7, Item, "|")).
    execProcDate       = TRIM(ENTRY(8, Item, "|")).
    priority           = TRIM(ENTRY(9, Item, "|")).
    execActNum         = TRIM(ENTRY(10, Item, "|")).
    execActDate        = TRIM(ENTRY(11, Item, "|")).
    execActInitial     = TRIM(ENTRY(12, Item, "|")).
    execActInitialAddr = TRIM(ENTRY(13, Item, "|")).
    bailiff            = TRIM(ENTRY(14, Item, "|")).
    summ               = ENTRY(2,TRIM(ENTRY(15, Item, "|")),"=").
    creditorName       = TRIM(ENTRY(16, Item, "|")).
    creditorAddress    = TRIM(ENTRY(17, Item, "|")).
    accountNumber      = ENTRY(2,TRIM(ENTRY(18, Item, "|")),"=").

    IF ENTRY(1,TRIM(ENTRY(19, Item, "|")),"=") EQ "debtorFirstName" THEN DO:
        mTypeKlient        = "f".
        debtorFirstName    = TRIM(ENTRY(19, Item, "|")).
        debtorLastName     = TRIM(ENTRY(20, Item, "|")).
        debtorSecondName   = TRIM(ENTRY(21, Item, "|")).
        debtorBornAddres   = TRIM(ENTRY(22, Item, "|")).
        debtorAddres       = TRIM(ENTRY(23, Item, "|")).
        debtorBirthYear    = TRIM(ENTRY(24, Item, "|")).
        debtorBirth        = TRIM(ENTRY(25, Item, "|")).
	territory          = TRIM(ENTRY(26, Item, "|")).
	department         = TRIM(ENTRY(27, Item, "|")).
	name1              = TRIM(ENTRY(28, Item, "|")).
        bankname           = TRIM(ENTRY(29, Item, "|")).
        kpp                = TRIM(ENTRY(30, Item, "|")).
        inn                = TRIM(ENTRY(31, Item, "|")).
        okato              = TRIM(ENTRY(32, Item, "|")).
        bik                = ENTRY(2,TRIM(ENTRY(33, Item, "|")),"=").
        ls                 = TRIM(ENTRY(34, Item, "|")).
        account            = ENTRY(2,TRIM(ENTRY(35, Item, "|")),"=").
        receivTitle        = TRIM(ENTRY(36, Item, "|")).
        address            = TRIM(ENTRY(37, Item, "|")).
        kbk                = TRIM(ENTRY(38, Item, "|")).
        bankBranch         = TRIM(ENTRY(39, Item, "|")).
        bankAgency         = TRIM(ENTRY(40, Item, "|")).
        osbnumber          = TRIM(ENTRY(41, Item, "|")).
        accountCurreny     = ENTRY(2,TRIM(ENTRY(42, Item, "|")),"=").
	oldnumber          = ENTRY(2,TRIM(ENTRY(43, Item, "|")),"=").
    END.
    ELSE DO:
    END.


/*
    Исполняем
    1	Арест
    2	Взыскание (накопительный арест автоматически в случае недостачи ДС для погашения долга)
    3	Снятие ареста
    5	Прекращение исполнения ИД (отмена взыскания и снятия ареста)
*/

	case actype:
	when "1" then do:
            FIND FIRST acct WHERE acct.acct EQ accountNumber
                            AND acct.acct-cat EQ "b" NO-LOCK NO-ERROR.
            IF AVAILABLE acct THEN DO:
                IF acct.close-date EQ ? THEN DO:
                    RUN Arest.
                    ProcNumberState = "Принят к исполнению - постановление передано на обработку".
                    vStatus = "0".
                END.
                ELSE DO:
                    ProcNumberState = "Возврат - счет закрыт - постановление не принято к исполнению".
                    vStatus = "4".
                    spisResult = "Возврат без исполнения".
                    spisPrim = "счет закрыт".
                END.
            END.
            ELSE DO:
                ProcNumberState = "Возврат - счет не найден - постановление не принято к исполнению".
                vStatus = "5".
                spisResult = "Не найден(ы) счет(а)".
                spisPrim = "Документ не был исполнен по причине отсутствия счетов должника в банке.".
                /*   7	Возврат - несоответствие соц. данных - постановление не принято к исполнению
                        несоответствие ФИО или даты рождения; адрес может быть любой
                 */
           END.
       	   end.
	WHEN "2" then
	when "3" then
	when "5" then do:  /*  закрытые тоже берем */
    OTHERWISE DO: END.
	end.
    /* уведомления Банка о принятии/ непринятии к исполнению */
    IF  mTypeKlient EQ "f" THEN DO:
        PUT STREAM out-file_u UNFORMATTED
        "|" + id +
        "|" + execProcNumber +
        "|" + debtorFirstName +
        "|" + debtorLastName +
        "|" + debtorSecondName +
        "| accountNumber=" + accountNumber +
        "| summ=" + summ +
        "| ProcNumberState=" + ProcNumberState +
        "| Status=" + vStatus SKIP.
    END.
    ELSE DO:
        PUT STREAM out-file_u UNFORMATTED
        "|" + id +
        "|" + execProcNumber +
        "|" + DolgnikOrg +
        "| accountNumber=" + accountNumber +
        "| summ=" + summ +
        "| ProcNumberState=" + ProcNumberState +
        "| Status=" + vStatus SKIP.
    END.

    fioispolnitelya = "Таскаева Н.Г.".

    /* уведомления Банка об исполнении */
    IF  mTypeKlient EQ "f" THEN DO:
        PUT STREAM out-file_o UNFORMATTED
            "|" + id +
            "|" + actNumber +
            "|" + actDate +
            "|" + execProcNumber +
            "|" + debtorFirstName +
            "|" + debtorLastName +
            "|" + debtorSecondName +
            "| accountNumber=" + accountNumber +
            "| fioispolnitelya=" + fioispolnitelya +
            "| summ=" + summ +
            "| accountCurreny=" + accountCurreny +
            "| spisDate=" + STRING(TODAY,'99.99.9999') +
            "| spisSumm=" + summ +
            "| spisAccountCurreny=" + accountCurreny +
            "| spisResult=" + spisResult +
            "| spisPrim=" + spisPrim SKIP.
    END.
    ELSE DO:
        PUT STREAM out-file_o UNFORMATTED
            "|" + id +
            "|" + actNumber +
            "|" + actDate +
            "|" + execProcNumber +
            "|" + DolgnikOrg +
            "| accountNumber=" + accountNumber +
            "| fioispolnitelya=" + fioispolnitelya +
            "| summ=" + summ +
            "| accountCurreny=" + accountCurreny +
            "| spisDate=" + STRING(TODAY,'99.99.9999') +
            "| spisSumm=" + summ +
            "| spisAccountCurreny=" + accountCurreny +
            "| spisResult=" + spisResult +
            "| spisPrim=" + spisPrim SKIP.
    END.
/* протокол */

PUT UNFORMATTED "============================================================" SKIP(2).

    case actype:
	when "1" then typeText = "Арест".
	when "2" then typeText = "Взыскание".
	when "3" then typeText = "Снятие ареста".
	when "5" then typeText = "Прекращение исполнения ИД (отмена взыскания и снятия ареста)".
	OTHERWISE typeText = "Не корректный тип".
    end.

    IF  mTypeKlient EQ "f" THEN DO:
	PUT UNFORMATTED "|тип " + typeText SKIP.
	PUT UNFORMATTED "|" + id SKIP.
	PUT UNFORMATTED "|" + actNumber SKIP.
	PUT UNFORMATTED "|" + actDate SKIP.
	PUT UNFORMATTED "|" + execProcNumber SKIP.
	PUT UNFORMATTED "|" + debtorFirstName SKIP.
	PUT UNFORMATTED "|" + debtorLastName SKIP.
	PUT UNFORMATTED "|" + debtorSecondName SKIP.
	PUT UNFORMATTED "|accountNumber=" + accountNumber SKIP.
	PUT UNFORMATTED "|fioispolnitelya=" + fioispolnitelya SKIP.
	PUT UNFORMATTED "|summ=" + summ SKIP.
	PUT UNFORMATTED "|accountCurreny=" + accountCurreny SKIP.
	PUT UNFORMATTED "|spisDate=" + STRING(TODAY,'99.99.9999') SKIP.
	PUT UNFORMATTED "|spisSumm=" + summ SKIP.
	PUT UNFORMATTED "|spisAccountCurreny=" + accountCurreny SKIP.
	PUT UNFORMATTED "|spisResult=" + spisResult SKIP.
	PUT UNFORMATTED "|spisPrim=" + spisPrim SKIP.
    END.
    ELSE DO:
	PUT UNFORMATTED "|тип " + typeText SKIP.
	PUT UNFORMATTED "|" + id SKIP.
        PUT UNFORMATTED "|" + actNumber SKIP.
        PUT UNFORMATTED "|" + actDate SKIP.
	PUT UNFORMATTED "|" + execProcNumber SKIP.
	PUT UNFORMATTED "|" + DolgnikOrg SKIP.
	PUT UNFORMATTED "|accountNumber=" + accountNumber SKIP.
	PUT UNFORMATTED "|fioispolnitelya=" + fioispolnitelya SKIP.
	PUT UNFORMATTED "|summ=" + summ SKIP.
	PUT UNFORMATTED "|accountCurreny=" + accountCurreny SKIP.
	PUT UNFORMATTED "|spisDate=" + STRING(TODAY,'99.99.9999') SKIP.
	PUT UNFORMATTED "|spisSumm=" + summ SKIP.
	PUT UNFORMATTED "|spisAccountCurreny=" + accountCurreny SKIP.
	PUT UNFORMATTED "|spisResult=" + spisResult SKIP.
	PUT UNFORMATTED "|spisPrim=" + spisPrim SKIP.
    END.

END. /* REPEAT */
INPUT CLOSE.
END PROCEDURE.

/*   Арест   */
PROCEDURE Arest.
    create blockobject.
    assign
        blockobject.beg-datetime  = DATETIME(TODAY,MTIME)
        blockobject.block-type    = "БлокСумм"
        blockobject.class-code    = "BlockAcct"
        blockobject.file-name    = "acct"
        blockobject.surrogate     = accountNumber + ","
        blockobject.user-id      = "SERV"
        blockobject.val[3]       = -1 * DECIMAL(summ)
        blockobject.txt[1]       = '1,2,3,4'
        blockobject.txt[2]       = "ФССП"
        blockobject.txt[3]       = 'Постановление'
        blockobject.txt[4]       = 'N ' + ENTRY(2,actNumber,"=") + ' от ' + ENTRY(2,actDate,"=")
        blockobject.txt[8]       = 'Арест И/П ' + ENTRY(2,execProcNumber,"=")  + ' от ' + ENTRY(2,execProcDate,"=") + ' id=' + ENTRY(2,id,"=")
        blockobject.txt[10]      = 'id=' + ENTRY(2,id,"=").
        VALIDATE blockobject NO-ERROR.
        spisResult = "Исполнен полностью".
        spisPrim = "Все требования, указанные в Исполнительном документе, выполнены в полном объёме.".
END PROCEDURE.

/*------- Снятие ареста ---------------------  */
PROCEDURE DeArest.

  FIND FIRST blockobject WHERE
  blockobject.class-code = 'BlockAcct' AND blockobject.file-name = 'acct' AND
  blockobject.surrogate = TRIM(accountNumber) + ',' AND blockobject.txt[2]='ФССП' AND
  val[3] = -1 * DECIMAL(summ) /*AND INDEX(blockobject.txt[4],TRIM(actNumber))>0 */ NO-ERROR.
  IF AVAILABLE blockobject THEN DO:
    IF (blockobject.end-datetime EQ ? OR blockobject.end-datetime >= DATETIME(STRING(TODAY,'99.99.9999') + ' ' + STRING(TIME,"HH:MM:SS"))) THEN DO:
      blockobject.end-datetime = DATETIME(TODAY,MTIME).
      blockobject.txt[5]      = "ФССП".
      blockobject.txt[6]      = "Постановление" + " id=" + ENTRY(2,id,"=").
      blockobject.txt[7]      = 'N ' + ENTRY(2,actNumber,"=") + ' от ' + ENTRY(2,actDate,"=").
      spisResult = "Исполнен полностью".
      spisPrim = "Все требования, указанные в Исполнительном документе, выполнены в полном объёме.".
    END.
    ELSE DO:
        spisResult = "Возврат без исполнения".
        spisPrim = "Арест был снят ранее".
    END.
  END.
  ELSE DO:
    spisResult = "Возврат без исполнения".
    spisPrim = "Арест по данному счету не найден".
  END.


END PROCEDURE.

/*   Взыскание   */
PROCEDURE Vzuskanie.

CREATE op.
assign
op.op-date = end-date
op.branch-id = "6600"                    /* ??????????отделение*/
op.doc-type = "0106"
op.doc-num = "1"                       /* номер документа */
op.doc-date = end-date
op.user-id = "SERV"
op.op-kind = "0106"                  /* код транзакции*/
op.op-value-date = end-date
op.doc-kind = "rec"                     /* тип документа */
op.op-status = "Ф"
op.contract-date = end-date
op.op-template = 1                      /* NN шабл. пров.*/
op.order-pay = "5"
op.acct-cat = "b"                       /* категория */
op.op-transaction = 824158              /* NN транз. */
op.due-date = end-date
op.details = "Взыскание по постановлению N " + ENTRY(2,actNumber,"=") + " от " + ENTRY(2,actDate,"=") + " И/П " + ENTRY(2,execProcNumber,"=")  + " от " + ENTRY(2,execProcDate,"=") + " id=" + ENTRY(2,id,"=") /* Содержание*/
op.Class-code = "opb"
op.ins-date = end-date
op.filial-id = "6600"                  /*филиал*/
op.ben-acct = account
.

/*  op.op-tran  = NEXT-VALUE(op-transaction-id)
  op.op-templ = 1
  op.doc-num = STRING(num) */

create op-entry.
assign
op-entry.op-date = end-date
op-entry.op = op.op
op-entry.op-entry = 1                             /* N проводки */
op-entry.type = "НБ"
op-entry.acct-db = accountNumber         /* ????????????счет дебета */
op-entry.acct-cr = "30102810566000000001"                           /* ????????????счет кредит */
op-entry.currency = ""
op-entry.amt-cur = 0
op-entry.amt-rub = DECIMAL(summ)                 /* ????????Сумма нац. вал.*/
op-entry.symbol = ""
op-entry.prev-year = no
op-entry.user-id = "SERV"
op-entry.value-date = op.op-date
op-entry.op-cod = "000000"                       /* Код операции */
op-entry.op-status = "ф"                         /* статус документа */
op-entry.acct-cat = "b"                          /* категория */
op-entry.qty = 0
op-entry.Class-Code = "op-entry"
op-entry.op-transaction = 824158                 /* транзакция */
op-entry.filial-id = "6600"                      /* филиал */
.


RELEASE banks-corr.
FIND FIRST banks-code WHERE banks-code.bank-code-type = "МФО-9"
                        AND banks-code.bank-code      = STRING(INT64(bik),"999999999")
NO-LOCK NO-ERROR.

IF AVAIL banks-code
          THEN FIND FIRST banks-corr WHERE banks-corr.bank-corr = banks-code.bank-id
                            AND CAN-FIND(FIRST banks OF banks-corr WHERE banks.flag-rkc = YES NO-LOCK)
NO-LOCK NO-ERROR.

IF AVAIL banks-corr THEN DO:
CREATE op-bank.
ASSIGN
   op-bank.op             = op.op
   op-bank.bank-code-type = "МФО-9"
   op-bank.bank-code      = bik
   op-bank.corr-acct      = banks-corr.corr-acct
.
END.
ELSE DO:
CREATE op-bank.
ASSIGN
   op-bank.op             = op.op
   op-bank.bank-code-type = "МФО-9"
   op-bank.bank-code      = bik
.
END.

UpdateSigns("opb",STRING(op.op), "inn-rec",ENTRY(2,inn,"="),?).
UpdateSigns("opb",STRING(op.op), "Kpp-rec",ENTRY(2,kpp,"="),?).

	spisResult = "Исполнен полностью".
	spisPrim = "Все требования, указанные в Исполнительном документе, выполнены в полном объёме.".

END PROCEDURE.

/*   Отмена взыскания   */
PROCEDURE DeVzuskanie.

/*
 здесь сделать вывод в протокол и все
*/

PUT UNFORMATTED "" SKIP(2).

    spisResult = "Исполнен полностью".
    spisPrim = "Все требования, указанные в Исполнительном документе, выполнены в полном объёме.".

END PROCEDURE.