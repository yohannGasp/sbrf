/* OV-SB-KEY.P
  Процедура генерации ключевого числа для выходной формы в Сбербанк. */

def input parameter parent$ as handle no-undo.
def input parameter name$ as char.
def input parameter parm as raw.
def output parameter out-key as char.

def var i as int.
def var j as int.
def var p as char extent 3.
def var n as int.
def var code as int extent 3.

{m-raw2sa.i parm p n "return '7'"}
if int(p[1]) > 0 then do:
  input from '/bankier/adfil/Baza07.dat'.
  repeat on error undo, leave:
    import code out-key.
    if code[1] = 1 and code[2] = int(p[2]) or 
       code[1] = 2 and code[3] = int(p[3]) then return.
  end.
end.  
out-key = '999999'.

