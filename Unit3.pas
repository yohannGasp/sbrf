unit Unit3;

interface

uses
  Classes,SysUtils,Windows;

type
  main = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure UpdateCaption;
  end;

implementation

uses Unit1;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure main.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ main }

procedure main.UpdateCaption;
begin
  Form1.Caption := main.ClassName;
end;


procedure main.Execute;
var
  key_sr,sr,in_sr: TSearchRec;
  se,ee:string;
begin
se:=timetostr(now);
ee:=cut(se,':') + cut(se,':') + se;
form1.Timer1.Enabled:=false;
if SysUtils.FindFirst(form1.PATH_IN_+form1.mask_file, faAnyFile, in_sr) = 0 then
  repeat
    if (in_sr.Name<>'.') and (in_sr.Name <>'..') and (in_sr.Attr<>faDirectory) then begin
      form1.message_list('Входящий ',in_sr.Name);
      MoveFile(Pchar(form1.PATH_IN_+in_sr.Name),Pchar(form1.PATH_IN_KEY+in_sr.Name));
    end;
    sleep(2000);
  until FindNext(in_sr) <> 0;
  Sysutils.FindClose(in_sr);
Sleep(2000);

if SysUtils.FindFirst(form1.PATH_IN_KEY+form1.mask_file, faAnyFile, key_sr) = 0 then begin
//  repeat
//    if (key_sr.Name<>'.') and (key_sr.Name<>'') and (key_sr.Name <>'..') and (key_sr.Attr<>faDirectory) then begin
      form1.message_list('Проверка хэш ','');
      form1.checkHashSum(form1.PATH_IN_KEY + key_sr.Name);
//    end;
//    sleep(2000);
//  until FindNext(key_sr) <> 0;
sysutils.FindClose(key_sr);
end;
Sleep(2000);
if SysUtils.FindFirst(form1.PATH_IN+form1.mask_file, faAnyFile, sr) = 0 then
 repeat
    if (sr.Name<>'.') and (sr.Name <>'..') and (sr.Attr<>faDirectory) then begin
        form1.convertFile(form1.PATH_IN + sr.Name, form1.PATH_OUT + 'fr' + sr.Name + '.txt');
        form1.message_list('Обработан',sr.Name);
        Sleep(2000);
        MoveFile(Pchar(form1.PATH_IN+sr.Name),Pchar(form1.ARHIV+form1.DEN+sr.Name+'_'+ee));
    end;
    sleep(2000);  
  until FindNext(sr) <> 0;
  sysutils.FindClose(sr);
  Synchronize(UpdateCaption);
form1.Timer1.Enabled:=true;
end;



end.
