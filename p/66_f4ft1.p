/*
   ��᭮��᪨� �� - ����᪨� �� ��� "���ᥫ�宧����"
   12.09.2014
   ���� �஢���� ������
*/

{globals.i}
{setdest.i}
{62-Lib.i}
{sh-defs.i}

DEF BUFFER b-op FOR op.
DEF BUFFER b-op-entry FOR op-entry.

DEF VAR vIdKlnt AS CHAR NO-UNDO.
DEF VAR vFlag1  AS LOGICAL.
DEF VAR vFlag2  AS LOGICAL.
DEF VAR vFlag3  AS LOGICAL.
DEF VAR Kol_Y AS INTEGER.
DEF VAR Kol_A AS INTEGER.

DEF temp-table tt
field nn like op.op
index i1 nn. 

{getdates.i}


put unformatted "���᫥��� / ����� " skip.
PUT UNFORMATTED "" SKIP(2).

FUNCTION GetCustAcct RETURNS CHAR (iAcct AS CHAR):
   DEF VAR vResult AS CHAR INIT "" NO-UNDO.
   DEF BUFFER b-acct FOR acct.

   FIND FIRST b-acct WHERE
              b-acct.acct EQ iAcct NO-LOCK NO-ERROR.

   IF AVAILABLE b-acct THEN
    vResult = STRING(b-acct.cust-id).

   RETURN vResult.
END FUNCTION.

Kol_Y = 0.
Kol_A = 0.

FOR EACH tt:
   DELETE tt.
END.



FOR EACH op WHERE
         op.op-date >= beg-date AND
         op.op-date <= end-date AND
         CAN-DO("!03rgs,!BOS*,!�������1,*",op.op-kind) AND
         CAN-DO("06",op.doc-type)
NO-LOCK,
FIRST op-entry OF op WHERE
          op-entry.acct-db BEGINS "47423" AND
          op-entry.acct-cr BEGINS "70601"
NO-LOCK
BREAK BY op.op-date:



vIdKlnt = "".
vIdKlnt = GetXAttrValue("op-entry", STRING(op-entry.op) + "," + STRING(op-entry.op-entry), "������").

IF vIdKlnt = "" THEN DO:

PUT UNFORMATTED "���᫥���   " op.op-date " " op.doc-num " " op.doc-type " " op.user-id " " op.op-kind " " SKIP.

/*
com-22,com-22_1,com-22_2,com-22_3,com-22_4,com-9091,0901_111,0901_109,0403,0311

0403mem - 0403
  ����ᮬ ���� ������, ⠪ ��� �த������ ����
  � �᫮���� ���� �ய�᪠�� � �� � ��祣� �� ������ �����
*/
/* ======================================================================================================================  */
IF CAN-DO("com-22,com-22_1,com-22_2,com-22_3,com-22_4,com-9091,0901_111,0901_109,0403,0311,031�_do,prRSHB,pdtnal",op.op-kind) THEN DO:

 vIdKlnt = "".
 vFlag1 = False.
 /* ���� ������ ��⮤�� 1 "����� ���+1" */
 FOR FIRST b-op WHERE
           b-op.op               <> op.op AND
           b-op.op-date          EQ op.op-date AND
           CAN-DO("06o",b-op.doc-type) AND
           b-op.user-id          EQ op.user-id AND
           b-op.op-kind          EQ op.op-kind
           AND INTEGER(b-op.doc-num) EQ (INTEGER(op.doc-num) + 1)
           AND NOT can-find(first tt where tt.nn = b-op.op)
 NO-LOCK,
 FIRST b-op-entry OF b-op WHERE
       b-op-entry.acct-cr EQ op-entry.acct-db
 NO-LOCK:
    PUT UNFORMATTED "�����       " b-op.op-date " " b-op.doc-num " " b-op.doc-type " " b-op.user-id " " b-op.op-kind SKIP.
    vFlag1 = True.
    vIdKlnt = "�_" + GetCustAcct(b-op-entry.acct-db).
    create tt.
    tt.nn = b-op.op.
 END.

 IF vFlag1 = False THEN DO:
        vFlag2 = False.
          /* ���� ������ ��⮤�� 2 ���� ����� */
        FOR FIRST b-op WHERE
                  b-op.op               <> op.op AND
                  b-op.op-date          EQ op.op-date AND
                  CAN-DO("06o",b-op.doc-type) AND
                  b-op.user-id          EQ op.user-id AND
                  b-op.op-kind          EQ op.op-kind
                  AND INTEGER(b-op.doc-num) > INTEGER(op.doc-num)
                  AND NOT can-find(first tt where tt.nn = b-op.op)                  
        NO-LOCK,
        FIRST b-op-entry OF b-op WHERE
              b-op-entry.acct-cr EQ op-entry.acct-db
        NO-LOCK:
          PUT UNFORMATTED "�����2      " b-op.op-date " " b-op.doc-num " " b-op.doc-type " " b-op.user-id " " b-op.op-kind SKIP.
          vFlag2 = True.
          vIdKlnt = "�_" + GetCustAcct(b-op-entry.acct-db).
          create tt.
	        tt.nn = b-op.op.
       END.
       IF vFlag2 = False THEN DO:
              vFlag3 = False.
                /* ���� ������ ��⮤�� 3 ����� ��� = */
                /* com-9091  com-22_3 com-22_4  */
              FOR FIRST b-op WHERE
                        b-op.op               <> op.op AND
                        b-op.op-date          EQ op.op-date AND
                        CAN-DO("06o",b-op.doc-type) AND
                        b-op.user-id          EQ op.user-id AND
                        b-op.op-kind          EQ op.op-kind
                        AND INTEGER(b-op.doc-num) = INTEGER(op.doc-num)
                        AND NOT can-find(first tt where tt.nn = b-op.op)                        
              NO-LOCK,
              FIRST b-op-entry OF b-op WHERE
                    b-op-entry.acct-cr EQ op-entry.acct-db
              NO-LOCK:
                  PUT UNFORMATTED "�����3      " b-op.op-date " " b-op.doc-num " " b-op.doc-type " " b-op.user-id " " b-op.op-kind SKIP.
                  vFlag3 = True.
                  vIdKlnt = "�_" + GetCustAcct(b-op-entry.acct-db).
                  create tt.
                  tt.nn = b-op.op.
              END.
             /* ���� ������ ��⮤�� 4  ⨯ ��� 0403mem 0403 */

       END. /*IF vFlag2 = False*/

 END. /*IF vFlag1 = False*/

END. /*IF op.op-kind EQ "0403mem" THEN DO:*/
/* ====================================================================================================================== */
IF op.op-kind EQ "0403mem" THEN DO:

/* ᤥ���� �஢��� �� op.op */

 vIdKlnt = "".
 vFlag1 = False.
 /* ���� ������ ��⮤�� 1 "����� ���+1" */
 FOR FIRST b-op WHERE
           b-op.op               <> op.op AND
           b-op.op-date          EQ op.op-date AND
           CAN-DO("06o",b-op.doc-type) AND
           b-op.user-id          EQ op.user-id AND
           b-op.op-kind          EQ "0403"
           AND INTEGER(b-op.doc-num) EQ (INTEGER(op.doc-num) + 1)
           AND NOT can-find(first tt where tt.nn = b-op.op)           
 NO-LOCK,
 FIRST b-op-entry OF b-op WHERE
       b-op-entry.acct-cr EQ op-entry.acct-db
 NO-LOCK:
    PUT UNFORMATTED "����� 0403  " b-op.op-date " " b-op.doc-num " " b-op.doc-type " " b-op.user-id " " b-op.op-kind SKIP.
    vFlag1 = True.
    vIdKlnt = "�_" + GetCustAcct(b-op-entry.acct-db).
    create tt.
    tt.nn = b-op.op.
 END.

 IF vFlag1 = False THEN DO:
        vFlag2 = False.
          /* ���� ������ ��⮤�� 2 ���� ����� */
        FOR FIRST b-op WHERE
                  b-op.op               <> op.op AND
                  b-op.op-date          EQ op.op-date AND
                  CAN-DO("06o",b-op.doc-type) AND
                  b-op.user-id          EQ op.user-id AND
                  b-op.op-kind          EQ "0403"
                  AND INTEGER(b-op.doc-num) > INTEGER(op.doc-num)
                  AND NOT can-find(first tt where tt.nn = b-op.op)                  
        NO-LOCK,
        FIRST b-op-entry OF b-op WHERE
              b-op-entry.acct-cr EQ op-entry.acct-db
        NO-LOCK:
           PUT UNFORMATTED "�����2 0403 " b-op.op-date " " b-op.doc-num " " b-op.doc-type " " b-op.user-id " " b-op.op-kind SKIP.
           vFlag2 = True.
           vIdKlnt = "�_" + GetCustAcct(b-op-entry.acct-db).
           create tt.
           tt.nn = b-op.op.
       END.
       IF vFlag2 = False THEN DO:
              vFlag3 = False.
                /* ���� ������ ��⮤�� 3 ����� ��� = */
                /* com-9091  com-22_3 com-22_4  */
              FOR FIRST b-op WHERE
                        b-op.op               <> op.op AND
                        b-op.op-date          EQ op.op-date AND
                        CAN-DO("06o",b-op.doc-type) AND
                        b-op.user-id          EQ op.user-id AND
                        b-op.op-kind          EQ "0403"
                        AND INTEGER(b-op.doc-num) = INTEGER(op.doc-num)
                        AND NOT can-find(first tt where tt.nn = b-op.op)                        
              NO-LOCK,
              FIRST b-op-entry OF b-op WHERE
                    b-op-entry.acct-cr EQ op-entry.acct-db
              NO-LOCK:
                  PUT UNFORMATTED "�����3 0403 " b-op.op-date " " b-op.doc-num " " b-op.doc-type " " b-op.user-id " " b-op.op-kind SKIP.
                  vFlag3 = True.
                  vIdKlnt = "�_" + GetCustAcct(b-op-entry.acct-db).
                  create tt.
                  tt.nn = b-op.op.
              END.
             /* ���� ������ ��⮤�� 4  ⨯ ��� 0403mem 0403 */

       END. /*IF vFlag2 = False*/

 END. /*IF vFlag1 = False*/

END. /*IF op.op-kind EQ "0403mem" THEN DO:*/



  IF vIdKlnt <> "" THEN DO:
/*    UpdateSigns("op-entry", STRING(op-entry.op) + "," + STRING(op-entry.op-entry), "������",vIdKlnt,?).*/
    PUT UNFORMATTED "��⠭����� id " vIdKlnt SKIP.
    vIdKlnt = "".
    Kol_Y = Kol_Y + 1.
  END.

  put unformatted "----------------------------------------------------------" skip.
  Kol_A = Kol_A + 1.

 END. /* IF vIdKlnt = ""  */


END.

PUT UNFORMATTED "" SKIP(4).
PUT UNFORMATTED "�ᥣ� �஢���� �� ���᫥���: " Kol_A         SKIP.
PUT UNFORMATTED "��⠭������ id ��:            " Kol_Y         SKIP.
PUT UNFORMATTED "�� ������� �����:            " Kol_A - Kol_Y SKIP.
PUT UNFORMATTED "" SKIP(2).
PUT UNFORMATTED  string(today,"99/99/9999") " " string(time,"hh:mm:ss") SKIP(1).

{preview.i}