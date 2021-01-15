unit RegUtils;

interface

uses
 Registry;

 procedure OpenReg(key: String);
 function DeleteKey(key: String): Boolean;
 function GetRegValS(V: String;D: String): String;
 procedure GetRegValA(V: String;var D: array of Byte);
 function GetRegValI(V: String;D: Cardinal): Cardinal;
 function GetRegValB(V: String;D: Boolean): Boolean;
 procedure SetRegValS(V: String;D: String);
 procedure SetRegValA(V: String;var D: array of Byte);
 procedure SetRegValI(V: String;D: Cardinal);
 procedure SetRegValB(V: String;D: Boolean);
var
 RRPReg: TRegistry;
const
 RegKey='\Software\GJH Software\Repton\MapDecoder';

implementation

{-------------------------------------------------------------------------------
Open the registry key
-------------------------------------------------------------------------------}
procedure OpenReg(key: String);
begin
 RRPReg:=TRegistry.Create;
 if key<>'' then key:='\'+key;
 RRPReg.OpenKey(RegKey+key,true);
end;

{-------------------------------------------------------------------------------
Function to delete a key from the registry
-------------------------------------------------------------------------------}
function DeleteKey(key: String): Boolean;
var x: Boolean;
begin
 x:=True;
 OpenReg('');
 if RRPReg.ValueExists(key) then x:=RRPReg.DeleteValue(key);
 RRPReg.Free;
 Result:=x;
end;

{-------------------------------------------------------------------------------
Function to read a string from the registry, or create it if it doesn't exist
-------------------------------------------------------------------------------}
function GetRegValS(V: String;D: String): String;
var X: String;
begin
 OpenReg('');
 If RRPReg.ValueExists(V) then
  X:=RRPReg.ReadString(V)
 else
 begin
  X:=D;
  RRPReg.WriteString(V,X);
 end;
 RRPReg.Free;
 Result:=X;
end;

{-------------------------------------------------------------------------------
Function to read an array from the registry, or create it if it doesn't exist
-------------------------------------------------------------------------------}
procedure GetRegValA(V: String;var D: array of Byte);
var s: Integer;
begin
 OpenReg('');
 If RRPReg.ValueExists(V)then
 begin
  s:=RRPReg.GetDataSize(V);
  RRPReg.ReadBinaryData(V,D,s);
 end
 else
  RRPReg.WriteBinaryData(V,D,SizeOf(D));
 RRPReg.Free;
end;

{-------------------------------------------------------------------------------
Function to read an integer from the registry, or create it if it doesn't exist
-------------------------------------------------------------------------------}
function GetRegValI(V: String;D: Cardinal): Cardinal;
var X: Cardinal;
begin
 OpenReg('');
 If RRPReg.ValueExists(V) then
  X:=RRPReg.ReadInteger(V)
 else
 begin
  X:=D;
  RRPReg.WriteInteger(V,X);
 end;
 RRPReg.Free;
 Result:=X;
end;

{-------------------------------------------------------------------------------
Function to read a boolean from the registry, or create it if it doesn't exist
-------------------------------------------------------------------------------}
function GetRegValB(V: String;D: Boolean): Boolean;
var X: Boolean;
begin
 OpenReg('');
 If RRPReg.ValueExists(V) then
  X:=RRPReg.ReadBool(V)
 else
 begin
  X:=D;
  RRPReg.WriteBool(V,X);
 end;
 RRPReg.Free;
 Result:=X;
end;

{-------------------------------------------------------------------------------
Function to save a string to the registry
-------------------------------------------------------------------------------}
procedure SetRegValS(V: String;D: String);
begin
 OpenReg('');
 RRPReg.WriteString(V,D);
 RRPReg.Free;
end;

{-------------------------------------------------------------------------------
Function to save an array to the registry
-------------------------------------------------------------------------------}
procedure SetRegValA(V: String;var D: array of Byte);
begin
 OpenReg('');
 RRPReg.WriteBinaryData(V,D,SizeOf(D));
 RRPReg.Free;
end;

{-------------------------------------------------------------------------------
Function to save an integer to the registry
-------------------------------------------------------------------------------}
procedure SetRegValI(V: String;D: Cardinal);
begin
 OpenReg('');
 RRPReg.WriteInteger(V,D);
 RRPReg.Free;
end;

{-------------------------------------------------------------------------------
Function to save a boolean to the registry
-------------------------------------------------------------------------------}
procedure SetRegValB(V: String;D: Boolean);
begin
 OpenReg('');
 RRPReg.WriteBool(V,D);
 RRPReg.Free;
end;

end.
