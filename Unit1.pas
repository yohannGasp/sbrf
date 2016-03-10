unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,inifiles, StdCtrls, ComCtrls, ExtCtrls, DB, ADODB, Grids, DBGrids,
  Menus, ComObj, WordXP, OleServer,shellApi, Mask, DBCtrls, Buttons,
  ToolWin, ImgList, Registry;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    SGIN: TStringGrid;
    TabSheet3: TTabSheet;
    DataSource1: TDataSource;
    MainMenu1: TMainMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    ADOQuery2: TADOQuery;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    GroupBox2: TGroupBox;
    DBGrid1: TDBGrid;
    N8: TMenuItem;
    DateTimePicker2: TDateTimePicker;
    N2: TMenuItem;
    Label2: TLabel;
    Label3: TLabel;
    CoolBar1: TCoolBar;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    CheckBox1: TCheckBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    ImageList1: TImageList;
    N7: TMenuItem;
    procedure FormCreate(Sender: TObject);
    function  checkDouble(day,num,sum:string):boolean;
    procedure convertFile(in1,out1:string);
    procedure Log(mes:string);
    procedure message_list(ms, file_name:string);
    function  checkHashSum(in1:string):boolean;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure DateTimePicker1KeyPress(Sender: TObject; var Key: Char);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure active_menu;
    procedure Button1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);

  private
    ind_SG:integer;
  public
   SHABLON,delimeter,PATH_IN,PATH_OUT,ARHIV,DEN,PATH_LOGI,PATH_IN_KEY,PATH_CHECK,mask_file,PATH_IN_:string;
   INTERVAL:Integer;
   LOGI:Boolean;
   conn_string:string;
   Word: variant;
   PRINT:Boolean;
   Elem:Boolean;
   id:integer;
  end;

var
  Form1: TForm1;

function cut(var s_in:string;delims:string):string;

implementation

uses StrUtils, tools, Unit3, Unit4, Unit5;

{$R *.dfm}
{*******************************************************************************
   FormCreate
*******************************************************************************}
procedure TForm1.FormCreate(Sender: TObject);
var
 INF:TIniFile;int:double;
 Registry: TRegistry;
begin
  INF      :=TIniFile.Create(ExtractFilePath(Application.ExeName)+'sp.ini');
  SHABLON  :=inf.ReadString('Settings','SHABLON','');
  delimeter:=inf.ReadString('Settings','delimeter','');
  PATH_IN  :=inf.ReadString('Settings','PATH_IN','');Label9.Caption:=PATH_IN;
  PATH_OUT :=inf.ReadString('Settings','PATH_OUT','');Label11.Caption:=PATH_OUT;
  ARHIV    :=inf.ReadString('Settings','ARHIV','');Label13.Caption:=ARHIV;
  INTERVAL :=inf.ReadInteger('Settings','INTERVAL',10000);int:=INTERVAL/1000;Label15.Caption:=floattostr(int);
  PATH_LOGI:=inf.ReadString('Settings','PATH_LOGI','');Label16.Caption:=PATH_LOGI;
  LOGI     :=inf.ReadBool('Settings','LOGI',false);  CheckBox1.Checked:=LOGI;
  PATH_IN_KEY:=inf.ReadString('Settings','PATH_IN_KEY','');label7.Caption:=PATH_IN_KEY;
  PATH_CHECK:=inf.ReadString('Settings','PATH_CHECK','');Label18.Caption:=PATH_CHECK;
  PATH_IN_:=inf.ReadString('Settings','PATH_IN_','');Label5.Caption:=PATH_IN_;
  mask_file:=inf.ReadString('Settings','mask_file','');Label20.Caption:=mask_file;
  INF.Free;

 if (PATH_IN='') or (PATH_OUT='') or (ARHIV='') or (SHABLON='') or (delimeter='') then
  begin
   MessageDlg('Заданы не все обязательные параметры :'+#10#13#10#13+
   'PATH_IN='+PATH_IN+#10#13+'PATH_OUT='+PATH_OUT+#10#13+ 'ARHIV='+ARHIV+#10#13+'SHABLON='+LeftStr(SHABLON,5)+#10#13+'delimeter='+delimeter, mtError,[mbOk], 0);
   Halt(0);
 end;

 conn_string:='Provider=VFPOLEDB.1;Data Source='+ExtractFilePath(Application.ExeName)+'base.dbf;Mode=Share Deny None;User ID="";Mask Password=False;Cache Authentication=False;Encrypt Password=False;Collating Sequence=MACHINE;';
//              'DSN="";DELETED=True;CODEPAGE=1251;MVCOUNT=16384;ENGINEBEHAVIOR=90;TABLEVALIDATE=3;REFRESH=5;VARCHARMAPPING=False;ANSI=True;REPROCESS=5;'
 try
   ADOConnection1.ConnectionString:=conn_string;
   ADOConnection1.Connected:=true;
   ADOQuery2.SQL.Clear;
   ADOQuery2.SQL.Add('select id from base order by id desc');
   ADOQuery2.Close;
   ADOQuery2.Open;
   if ADOQuery2.FieldByName('id').AsString <> '' then
   id:=strtoint(ADOQuery2.FieldByName('id').AsString) else
   id:=0;
   ADOQuery2.Close;
   ADOQuery2.SQL.Clear;
 except
    on E: Exception do begin
      Log('Ошибка соединения с БД: ' + e.Message);
      ShowMessage('Ошибка соединения с БД: ' + e.Message);
      Halt;
    end;  
 end;

 if not DirectoryExists(ARHIV) then CreateDir(ARHIV);
 {переинициализируется при каждом копировании}
 DEN:=copy(DateToStr(Now),7,4)+copy(DateToStr(Now),4,2)+copy(DateToStr(Now),1,2)+'\';
 {также создается новый день при каждом копировании файлов}
 if not DirectoryExists(ARHIV+DEN) then CreateDir(ARHIV+DEN);
// if not DirectoryExists(ARHIV+'BAD_CHECK') then CreateDir(ARHIV+'BAD_CHECK');

  Timer1.Interval:=INTERVAL;
  Timer1.Enabled:=True;
  Form1.Caption:='Мониторинг запущен';

  SGIN.Rows[0].Add('Дата');
  SGIN.Rows[0].Add('Время');
  SGIN.Rows[0].Add('Информация');
  SGIN.Rows[0].Add('Файл');
  ind_SG:=1;
  message_list('Начало обработки','');
  DateTimePicker1.Date:=now;
  DateTimePicker2.Date:=now;
  DateTimePicker1Change(self);

  Registry:=TRegistry.Create;
  Registry.RootKey:=HKEY_CURRENT_USER;
  Registry.OpenKey('Control Panel\International',False);
  if Registry.ReadString('sDecimal')<>'.' then begin
    MessageDlg('Разделитель целой и дробной части не точка, изменяем на точку', mtInformation,[mbOk], 0);
    Registry.WriteString('sDecimal','.');
  end;
  Registry.Free;

end;
{*******************************************************************************
  Ковентирование WinToDos
*******************************************************************************}
function WinToDos( const Src: AnsiString ) : AnsiString;
begin
  SetLength( Result, Length(Src) );
  if Src <> '' then
     CharToOem( PChar(Src), PChar(Result));
     // можно и так: CharToOemBuff( PChar(Src), PChar(Result), length(Src) );
end;
{*******************************************************************************
  Ковентирование DosToWin
*******************************************************************************}
function DosToWin(St: string): string;
var
  Ch: PChar;
begin
  Ch := StrAlloc(Length(St) + 1);
  OemToAnsi(PChar(St), Ch);
  Result := Ch;
  StrDispose(Ch)
end;
{*******************************************************************************
  CUT
*******************************************************************************}
function cut(var s_in:string;delims:string):string;
begin
  try
    Result:=copy(s_in,1,pos(delims,s_in)-1);
    delete(s_in,1,pos(delims,s_in));
  except
  end;
end;
{*******************************************************************************
  Ковентирование Convert
*******************************************************************************}
procedure TForm1.convertFile(in1, out1: string);
var
  f_in,f_out:textfile;
  strRes,tmpShablon,elementShablon,tmpStr, stroka, elem, val, tag:string;
  first_elem,first_elem_1,first_elem_2,first_elem_3,first_elem_4:string;
  num_pp:integer; // номер п/п

  DT3:string;  // Тип бизнес-сообщения
  PA10:string; // Участник-отправитель
  RC10:string; // Участник-получатель
  AM17:string; // Сумма
  DE1:string;  // Точность для сумм в полях AM, QA, AX
  CU3:string;  // Код валюты РФ (код ISO)

  SH2:string;  // Вид операции
  MT3:string;  // Тип сообщения
  // банк инициатор
  PNxxx:string; // Наименование плательщика
  SIxx:string;  // ИНН плательщика
  SAxx:string;  // Номер счета плательщика
  SBxxx:string; // Наименование банка пла-тельщика
  SNxx:string;  // Код банка плательщика бик
  SKxx:string;  // Корсчет банка плательщика
  SSx:string;   // Расчетная система банка плательщика
  // бенефициар
  RNxxx:string; // Наименование получателя
  RIxx:string;  // ИНН получателя
  RAxx:string;  // Номер счета получателя
  BNxxx:string; // Наименование банка получа-теля
  BCxx:string;  // Код банка получателя бик
  BKxx:string;  // Корсчет банка получателя
  RSx:string;   // Расчетная система банка получателя
  PPxxx:string; // Назначение платежа

  LD6:string;  // Дата обработки
  IN16:string; // Информация о внесистемном документе
  IN16_1:string; //	префикс
  IN16_2:string; //	"	номер клиентского поручения
  IN16_3:string; //	"	дата клиентского поручения
  IN16_4:string; //	"	очередность платежа

  SC2:string;  // Условия перевода
  SD6:string;  // ДПП дата
  PT4:string;  // Тип обслуживания
  DH6:string;  // Cписано со счета плательщи-ка дата
  ED6:string;  // Поступило в банк плательщи-ка дата

  KPx:string;  // КПП плательщика
  KRx:string;  // КПП получателя
begin
  try
    AssignFile(f_in, in1);
    Reset(f_in);
    ReadLn(f_in,stroka);
    AssignFile(f_out, out1);
    rewrite(f_out);

    num_pp:=0;
    while not eof(f_in) do begin
         ReadLn(f_in,stroka);
         if pos('AM17:',stroka) <> 0 then begin     // проверка строк

         first_elem:=cut(stroka,'|');
         first_elem_1:=LeftStr(first_elem,3); // сигнатура
         first_elem_2:='';                    // дата
         first_elem_3:='';                    // код участника
         first_elem_4:=RightStr(first_elem,6);// номер документа
         while Pos('|',stroka) <> 0 do begin
           elem:=cut(stroka,'|');
           val:=copy(elem,pos(':',elem) + 1,length(elem));
           tag:=cut(elem,':');

          if      tag = 'DT3'  then DT3:=val
          else if tag = 'PA10' then PA10:=val
          else if tag = 'RC10' then RC10:=val
          else if tag = 'AM17' then AM17:=val
          else if tag = 'DE1'  then DE1:=val
          else if tag = 'CU3'  then CU3:=val

          else if tag = 'SH2' then SH2:=val
          else if tag = 'MT3' then MT3:=val

          else if pos('PN',tag) <> 0 then PNxxx:=val
          else if pos('SI',tag) <> 0 then SIxx:=val
          else if pos('SA',tag) <> 0 then SAxx:=val
          else if pos('SB',tag) <> 0 then SBxxx:=val
          else if pos('SN',tag) <> 0 then SNxx:=val
          else if pos('SK',tag) <> 0 then SKxx:=val
          else if pos('SS',tag) <> 0 then SSx:=val

          else if pos('RN',tag) <> 0 then RNxxx:=val
          else if pos('RI',tag) <> 0 then RIxx:=val
          else if pos('RA',tag) <> 0 then RAxx:=val
          else if pos('BN',tag) <> 0 then BNxxx:=val
          else if pos('BC',tag) <> 0 then BCxx:=val
          else if pos('BK',tag) <> 0 then BKxx:=val
          else if pos('RS',tag) <> 0 then RSx:=val
          else if pos('PP',tag) <> 0 then PPxxx:=val

          else if tag = 'LD6'  then LD6:=val
          else if tag = 'IN16' then IN16:=val
          else if tag = 'SC2'  then SC2:=val
          else if tag = 'SD6'  then SD6:=val
          else if tag = 'PT4'  then PT4:=val
          else if tag = 'DH6'  then DH6:=val
          else if tag = 'ED6'  then ED6:=val

          else if pos('KP',tag) <> 0 then KPx:=val
          else if pos('KR',tag) <> 0 then KRx:=val
         end;

      // обработка
      if DE1<>'' then begin
        AM17:=LeftStr(AM17, length(AM17) - strtoint(DE1)) + '.' + RightStr(AM17,strtoint(DE1));
        AM17:=left_null_to_space(AM17);
      end else begin
        AM17:=LeftStr(AM17, length(AM17) - 2) + '.' + RightStr(AM17,2);
        AM17:=left_null_to_space(AM17);
      end;
      if CU3='RUR' then CU3:='810';

      IN16_1:=LeftStr(IN16,3); // "	префикс
      IN16_2:=Copy(IN16,4,6);  // "	номер клиентского поручения
      IN16_3:=Copy(IN16,10,6); // "	дата клиентского по-ручения
      IN16_4:=RightStr(IN16,1);// "	очередность платежа

      if LD6<>'' then begin
        LD6:=LeftStr(ld6,2)+'.'+copy(ld6,3,2)+'.20'+RightStr(LD6,2);
        LD6:= FormatDateTime('yyyy/mm/dd', strtodatetime(LD6));
        Delete(ld6,5,1);
        Delete(ld6,7,1);
      end;

      if SD6<>'' then begin
        SD6:=LeftStr(SD6,2)+'.'+copy(SD6,3,2)+'.20'+RightStr(SD6,2);
        SD6:= FormatDateTime('yyyy/mm/dd', strtodatetime(SD6));
        Delete(SD6,5,1);
        Delete(SD6,7,1);
      end;

      if DH6<>'' then begin
        DH6:=LeftStr(DH6,2)+'.'+copy(DH6,3,2)+'.20'+RightStr(DH6,2);
        DH6:= FormatDateTime('yyyy/mm/dd', strtodatetime(DH6));
        Delete(DH6,5,1);
        Delete(DH6,7,1);
      end;

      if ED6<>'' then begin
        ED6:=LeftStr(ED6,2)+'.'+copy(ED6,3,2)+'.20'+RightStr(ED6,2);
        ED6:= FormatDateTime('yyyy/mm/dd', strtodatetime(ED6));
        Delete(ED6,5,1);
        Delete(ED6,7,1);
      end;
      // входящие поручения
      if SH2 = '01' then MT3:='4'
      // входящие требования
      else if SH2 = '02' then MT3:='1';

      // проверка на дубли
      if not checkDouble(LD6,first_elem_4,AM17) then begin
        ADOQuery2.Insert; inc(id);
        ADOQuery2.FieldByName('id').AsInteger:=id;
        ADOQuery2.FieldByName('NUM').AsString:=first_elem_4;
        ADOQuery2.FieldByName('PA10').AsString:=PA10;
        ADOQuery2.FieldByName('RC10').AsString:=RC10;
        ADOQuery2.FieldByName('AM17').AsString:=AM17;
        ADOQuery2.FieldByName('CU3').AsString:=CU3;
        ADOQuery2.FieldByName('SH2').AsString:=SH2;
        ADOQuery2.FieldByName('MT3').AsString:=MT3;
        ADOQuery2.FieldByName('PNxxx').AsString:=PNxxx;
        ADOQuery2.FieldByName('SIxx').AsString:=SIxx;
        ADOQuery2.FieldByName('SAxx').AsString:=SAxx;
        ADOQuery2.FieldByName('SBxxx').AsString:=SBxxx;
        ADOQuery2.FieldByName('SNxx').AsString:=SNxx;
        ADOQuery2.FieldByName('SKxx').AsString:=SKxx;
        ADOQuery2.FieldByName('SSx').AsString:=SSx;
        ADOQuery2.FieldByName('RNxxx').AsString:=RNxxx;
        ADOQuery2.FieldByName('RIxx').AsString:=RIxx;
        ADOQuery2.FieldByName('RAxx').AsString:=RAxx;
        ADOQuery2.FieldByName('BNxxx').AsString:=BNxxx;
        ADOQuery2.FieldByName('BCxx').AsString:=BCxx;
        ADOQuery2.FieldByName('BKxx').AsString:=BKxx;
        ADOQuery2.FieldByName('RSx').AsString:=RSx;
        ADOQuery2.FieldByName('PPxxx').AsString:=PPxxx;
        ADOQuery2.FieldByName('LD6').AsString:=LD6;
        ADOQuery2.FieldByName('IN16').AsString:=IN16;
        ADOQuery2.FieldByName('SC2').AsString:=SC2;
        ADOQuery2.FieldByName('SD6').AsString:=SD6;
        ADOQuery2.FieldByName('PT4').AsString:=PT4;
        ADOQuery2.FieldByName('DH6').AsString:=DH6;
        ADOQuery2.FieldByName('ED6').AsString:=ED6;
        ADOQuery2.FieldByName('KPx').AsString:=KPx;
        ADOQuery2.FieldByName('KRx').AsString:=KRx;
        ADOQuery2.FieldByName('NAME_FILE').AsString:=ExtractFileName(in1);
        ADOQuery2.Post;

      strRes:='';
      if SHABLON <> '' then begin
        tmpShablon:= SHABLON;
        while Pos('#',tmpShablon) <> 0 do begin

          elementShablon:= cut(tmpShablon,'#');
          tmpStr:= '';

          //формулы
          if      elementShablon = 'DT3'  then tmpStr:=DT3
          else if elementShablon = 'PA10' then tmpStr:=PA10
          else if elementShablon = 'RC10' then tmpStr:=RC10
          else if elementShablon = 'AM17' then tmpStr:=AM17
          else if elementShablon = 'DE1'  then tmpStr:=DE1
          else if elementShablon = 'CU3'  then tmpStr:=CU3

          else if elementShablon = 'SH2' then tmpStr:=SH2
          else if elementShablon = 'MT3' then tmpStr:=MT3

          else if elementShablon = 'PNxxx' then tmpStr:=PNxxx
          else if elementShablon = 'SIxx'  then tmpStr:=SIxx
          else if elementShablon = 'SAxx'  then tmpStr:=SAxx
          else if elementShablon = 'SBxxx' then tmpStr:=SBxxx
          else if elementShablon = 'SNxx'  then tmpStr:=SNxx
          else if elementShablon = 'SKxx'  then tmpStr:=SKxx
          else if elementShablon = 'SSx'   then tmpStr:=SSx

          else if elementShablon = 'RNxxx' then tmpStr:=RNxxx
          else if elementShablon = 'RIxx'  then tmpStr:=RIxx
          else if elementShablon = 'RAxx'  then tmpStr:=RAxx
          else if elementShablon = 'BNxxx' then tmpStr:=BNxxx
          else if elementShablon = 'BCxx'  then tmpStr:=BCxx
          else if elementShablon = 'BKxx'  then tmpStr:=BKxx
          else if elementShablon = 'RSx'   then tmpStr:=RSx
          else if elementShablon = 'PPxxx' then tmpStr:=PPxxx
          else if elementShablon = 'PPxxx+PNxxx' then tmpStr:=PPxxx + ' Плательщик:' + PNxxx + ',Счет:' + SAxx + ',Банк:' + SBxxx

          else if elementShablon = 'LD6'    then tmpStr:=LD6
          else if elementShablon = 'IN16_1' then tmpStr:=IN16_1
          else if elementShablon = 'IN16_2' then tmpStr:=IN16_2
          else if elementShablon = 'IN16_3' then tmpStr:=IN16_3
          else if elementShablon = 'IN16_4' then tmpStr:=IN16_4

          else if elementShablon = 'SC2'  then tmpStr:=SC2
          else if elementShablon = 'SD6'  then tmpStr:=SD6
          else if elementShablon = 'PT4'  then tmpStr:=PT4
          else if elementShablon = 'DH6'  then tmpStr:=DH6
          else if elementShablon = 'ED6'  then tmpStr:=ED6

          else if elementShablon = 'KPx'  then tmpStr:=KPx
          else if elementShablon = 'KRx'  then tmpStr:=KRx

          else if elementShablon = 'numpp' then begin inc(num_pp); tmpStr:= inttostr(num_pp) end
          else if elementShablon = 'NUMH'  then tmpStr:= first_elem_4

          //одни разделители
          else if elementShablon = ''      then tmpStr:=''
          // static
          else if elementShablon[1] = '''' then tmpStr:= copy(elementShablon, 2, Length(elementShablon) - 2);

          strRes:= strRes + tmpStr + delimeter;
        end; {while Pos('#',tmpShablon) <> 0 do begin}

      end;

      WriteLn(f_out,WinToDos(strRes));
    end {дубли}
  else message_list('Повторный документ: дата ' + LD6 + ' номер ' + first_elem_4 + ' сумма ' + AM17,ExtractFileName(in1));
    end; {if stroka <> 'AM17:' then}
end;{while}

  finally
    closefile(f_in);
    closefile(f_out);
  end;
end;
{****************************************************************************
  Логи пишем по принципу открыли файл, записали, закрыли
  не держим файл постоянно открытым, т.к. записи буферизуются
*****************************************************************************}
procedure TForm1.Log(mes: string);
var
  Stream: TFileStream;
begin
  if LOGI then begin
    if not FileExists(PATH_LOGI) then Stream := TFileStream.Create(PATH_LOGI,fmCreate)
    else Stream := TFileStream.Create(PATH_LOGI,fmOpenWrite);
    try
      Stream.Seek(0, soFromEnd);
      mes:=DateTimeToStr(now)+' '+mes+#10;
      Stream.WriteBuffer(Pointer(mes)^, Length(mes));
    finally
      Stream.Free;
    end;
  end;
end;
{**********************************************************************
    вывод на лмст и в лог
************************************************************************}
procedure TForm1.message_list(ms,file_name: string);
begin
//  ListBox1.Items.Add(DateTimeToStr(now)+' '+ms);
  SGIN.Rows[ind_SG].Add(Datetostr(date));
  SGIN.Rows[ind_SG].Add(timetostr(time));
  SGIN.Rows[ind_SG].Add(ms);
  SGIN.Rows[ind_SG].Add(file_name);
  inc(ind_SG);
  Log(ms + ' ' + file_name);
end;
{**********************************************************************
    проверка хэш-суммы
************************************************************************}
function TForm1.checkHashSum(in1: string): boolean;
begin
  ShellExecute(0,'open',PChar(PATH_CHECK+'check.bat'), pchar(''),pchar(PATH_CHECK), SW_SHOW);
  Result:=true;
end;
{**********************************************************************
    основная процедура
************************************************************************}
procedure TForm1.Timer1Timer(Sender: TObject);
var
//  key_sr,sr,in_sr: TSearchRec;
//  se,ee:string;
  th:main;
begin

th:=main.Create(true);
th.Resume;

{se:=timetostr(now);
ee:=cut(se,':') + cut(se,':') + se;

if SysUtils.FindFirst(PATH_IN_+mask_file, faAnyFile, in_sr) = 0 then
  repeat
    if (in_sr.Name<>'.') and (in_sr.Name <>'..') and (in_sr.Attr<>faDirectory) then begin
      message_list('Входящий ',in_sr.Name);
      MoveFile(Pchar(PATH_IN_+in_sr.Name),Pchar(PATH_IN_KEY+in_sr.Name));
    end;
  until FindNext(in_sr) <> 0;
FindClose(in_sr);
Sleep(2000);

if SysUtils.FindFirst(PATH_IN_KEY+mask_file, faAnyFile, key_sr) = 0 then begin
  repeat
    if (key_sr.Name<>'.') and (key_sr.Name<>'') and (key_sr.Name <>'..') and (key_sr.Attr<>faDirectory) then begin
      message_list('Проверка хэш ',key_sr.Name);
      checkHashSum(PATH_IN_KEY + key_sr.Name);
    end;
  until FindNext(key_sr) <> 0;
  FindClose(key_sr);
end;
Sleep(2000);
if SysUtils.FindFirst(PATH_IN+mask_file, faAnyFile, sr) = 0 then
 repeat
    if (sr.Name<>'.') and (sr.Name <>'..') and (sr.Attr<>faDirectory) then begin
        convertFile(PATH_IN + sr.Name, PATH_OUT + sr.Name + '.txt');
        message_list('Обработан',sr.Name);
        Sleep(1000);
        MoveFile(Pchar(PATH_IN+sr.Name),Pchar(ARHIV+DEN+sr.Name+'_'+ee));
        message_list('-------------------------','');
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);}
end;


procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if Dialogs.MessageDlg('Закрыть программу ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then CanClose:=false else begin
    Log('Конец обработки');
 end;
end;
{**********************************************************************
    проверка на дубли
************************************************************************}
function TForm1.checkDouble(day,num,sum:string):boolean;
begin
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select * from base where ld6 = :d and num = :num and am17 = :sum');
  ADOQuery1.Parameters.ParamByName('d').Value:=day;
  ADOQuery1.Parameters.ParamByName('num').Value:=num;
  ADOQuery1.Parameters.ParamByName('sum').Value:=sum;
  ADOQuery1.Close;
  ADOQuery1.Open;
  if ADOQuery1.RecordCount > 0 then Result:=true
  else result:=false;
end;
{**********************************************************************
    просмотр одного документа
************************************************************************}
procedure TForm1.N1Click(Sender: TObject);
var
  templ,LD6,ED6,DH6:string;
begin
 try
  Word:=CreateOleObject('Word.Application');
  templ:=ExtractFilePath(Application.ExeName)+'template\';
  Word.Documents.Add(templ+'pp.docx');
  Word.Selection.Find.MatchSoundsLike := False;
  Word.Selection.Find.MatchAllWordForms := False;
  Word.Selection.Find.MatchWholeWord := False;
  Word.Selection.Find.Format := False;
  Word.Selection.Find.Forward := True;
  Word.Selection.Find.ClearFormatting;
  Word.Selection.Find.Text:='AM17';
  Word.Selection.Find.Replacement.Text:=Trim(ADOQuery2.FieldByName('AM17').AsString);
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SUMP';
  Word.Selection.Find.Replacement.Text:=Tools.MoneyToString(StrToFloat(Trim(ADOQuery2.FieldByName('AM17').AsString)));
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  ED6:=ADOQuery2.FieldByName('ED6').AsString;
  ED6:=RightStr(ED6,2)+'.'+copy(ED6,5,2)+'.'+LeftStr(ED6,4);
  Word.Selection.Find.Text:='ED6';
  Word.Selection.Find.Replacement.Text:=ED6;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='KPx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('KPx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='KRx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('KRx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SH2';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SH2').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='MT3';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('MT3').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='PNxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('PNxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SIxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SIxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SAxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SAxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SBxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SBxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SNxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SNxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SKxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SKxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='RNxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('RNxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='RIxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('RIxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='RAxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('RAxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='BNxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('BNxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='BCxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('BCxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='BKxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('BKxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='PPxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('PPxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);

  LD6:=ADOQuery2.FieldByName('LD6').AsString;
  LD6:=RightStr(LD6,2)+'.'+copy(ld6,5,2)+'.'+LeftStr(ld6,4);
  Word.Selection.Find.Text:='LD6';
  Word.Selection.Find.Replacement.Text:=LD6;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);

  DH6:=ADOQuery2.FieldByName('DH6').AsString;
  DH6:=RightStr(DH6,2)+'.'+copy(DH6,5,2)+'.'+LeftStr(DH6,4);
  Word.Selection.Find.Text:='DH6';
  Word.Selection.Find.Replacement.Text:=DH6;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);

  Word.Selection.Find.Text:='NUM';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('NUM').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='IN4';
  Word.Selection.Find.Replacement.Text:=RightStr(ADOQuery2.FieldByName('IN16').AsString,1);
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);

  Word.Visible:=Visible;

  if PRINT then begin
    Word.ActiveDocument.PageSetup.Orientation:=0;
    Word.ActiveDocument.PrintPreview;
//    Word.ActiveDocument.PrintOut;
  end;

 finally
  Word:=Null;
 end;

end;

procedure TForm1.N2Click(Sender: TObject);
begin
  PRINT:=true;
  N1Click(self);
  PRINT:=false;
end;
{**********************************************************************
    просмотр всех документов
************************************************************************}
procedure TForm1.N6Click(Sender: TObject);
var
  templ,LD6,ED6,DH6:string;
  i:integer;
begin
  try
    Word:=CreateOleObject('Word.Application');i:=0;
    Word.Visible:=Visible;
    templ:=ExtractFilePath(Application.ExeName)+'template\';
    ADOQuery2.Open;
    ADOQuery2.First;
    Word.Documents.Add(templ+'pp.docx');
    Word.Selection.WholeStory;
    Word.Selection.Copy;
    while not ADOQuery2.Eof do begin
      if (elem=false) or (elem and DBGrid1.SelectedRows.CurrentRowSelected = True) then begin
      inc(i);
      Word.Selection.Find.MatchSoundsLike := False;
      Word.Selection.Find.MatchAllWordForms := False;
      Word.Selection.Find.MatchWholeWord := False;
      Word.Selection.Find.Format := False;
      Word.Selection.Find.Forward := True;
      Word.Selection.Find.ClearFormatting;
  Word.Selection.Find.Text:='AM17';
  Word.Selection.Find.Replacement.Text:=Trim(ADOQuery2.FieldByName('AM17').AsString);
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SUMP';
  Word.Selection.Find.Replacement.Text:=Tools.MoneyToString(StrToFloat(Trim(ADOQuery2.FieldByName('AM17').AsString)));
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  ED6:=ADOQuery2.FieldByName('ED6').AsString;
  ED6:=RightStr(ED6,2)+'.'+copy(ED6,5,2)+'.'+LeftStr(ED6,4);
  Word.Selection.Find.Text:='ED6';
  Word.Selection.Find.Replacement.Text:=ED6;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='KPx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('KPx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='KRx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('KRx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SH2';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SH2').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='MT3';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('MT3').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='PNxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('PNxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SIxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SIxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SAxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SAxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SBxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SBxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SNxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SNxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='SKxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('SKxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='RNxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('RNxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='RIxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('RIxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='RAxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('RAxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='BNxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('BNxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='BCxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('BCxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='BKxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('BKxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='PPxxx';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('PPxxx').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);

  LD6:=ADOQuery2.FieldByName('LD6').AsString;
  LD6:=RightStr(LD6,2)+'.'+copy(ld6,5,2)+'.'+LeftStr(ld6,4);
  Word.Selection.Find.Text:='LD6';
  Word.Selection.Find.Replacement.Text:=LD6;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);

  DH6:=ADOQuery2.FieldByName('DH6').AsString;
  DH6:=RightStr(DH6,2)+'.'+copy(DH6,5,2)+'.'+LeftStr(DH6,4);
  Word.Selection.Find.Text:='DH6';
  Word.Selection.Find.Replacement.Text:=DH6;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);

  Word.Selection.Find.Text:='NUM';
  Word.Selection.Find.Replacement.Text:=ADOQuery2.FieldByName('NUM').AsString;
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);
  Word.Selection.Find.Text:='IN4';
  Word.Selection.Find.Replacement.Text:=RightStr(ADOQuery2.FieldByName('IN16').AsString,1);
  Word.Selection.Find.Execute(Replace:=wdReplaceAll);

 // if not last page to add new page
  if ((elem=false) and (i < ADOQuery2.RecordCount)) or ((elem) and (i < DBGrid1.SelectedRows.Count)) then begin
      Word.Selection.EndKey($6);
      Word.Selection.InsertBreak;
      Word.Selection.Paste; // template

      word.Selection.GoTo(wdGoToBookmark, emptyParam, emptyParam, 'beg');// переход на закладку
      Word.ActiveDocument.Bookmarks.Item('beg').delete;
  end;

      if PRINT then begin
        Word.ActiveDocument.PageSetup.Orientation:=0;
        Word.ActiveDocument.PrintPreview;
    //    Word.ActiveDocument.PrintOut;
      end;
      
      end;{      if DBGrid1.SelectedRows.CurrentRowSelected = True then begin}
      ADOQuery2.Next;
    end;
  except
    Word:=Null;
  end;

end;
{**********************************************************************
    просмотр отмеченных документов
************************************************************************}
procedure TForm1.N7Click(Sender: TObject);
begin
Elem:=true;
N6Click(self);
Elem:=false;
end;

procedure TForm1.DateTimePicker1KeyPress(Sender: TObject; var Key: Char);
begin
  KEY:=#0;
end;
{**********************************************************************
    активность меню
************************************************************************}
procedure TForm1.active_menu;
begin
  if ADOQuery2.RecordCount = 0 then begin
    n1.Enabled:=false;
    n6.Enabled:=false;
    n2.Enabled:=false;
  end else begin
    n1.Enabled:=true;
    n6.Enabled:=true;
    n2.Enabled:=true;
  end;
end;
{**********************************************************************
    даты
************************************************************************}
procedure TForm1.DateTimePicker1Change(Sender: TObject);
var
  d1,d2:string;
begin
  d1:=FormatDateTime('yyyy/mm/dd', DateTimePicker1.Date);
  Delete(d1,5,1);
  Delete(d1,7,1);
  StatusBar1.SimpleText:=d1;

  d2:=FormatDateTime('yyyy/mm/dd', DateTimePicker2.Date);
  Delete(d2,5,1);
  Delete(d2,7,1);
  StatusBar1.SimpleText:=StatusBar1.SimpleText+' '+d2;

  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('select * from base where :d1 <= ld6 and ld6 <= :d2');
  ADOQuery2.Parameters.ParamByName('d1').Value:=d1;
  ADOQuery2.Parameters.ParamByName('d2').Value:=d2;
  ADOQuery2.Close;
  ADOQuery2.Open;

  active_menu;
end;
{**********************************************************************
    Все документы
************************************************************************}
procedure TForm1.Button1Click(Sender: TObject);
begin
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('select * from base');
  ADOQuery2.Close;
  ADOQuery2.Open;
  StatusBar1.SimpleText:='';
  active_menu;
end;
{**********************************************************************
    о программе
************************************************************************}
procedure TForm1.N4Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;
{**********************************************************************
    форма записи
************************************************************************}
procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
  Form5.ShowModal;
end;
{**********************************************************************
    отметки
************************************************************************}
procedure TForm1.DBGrid1CellClick(Column: TColumn);
begin
StatusBar1.SimpleText:='Количество отмеченных документов: '+inttostr(DBGrid1.SelectedRows.Count);
end;

end.



