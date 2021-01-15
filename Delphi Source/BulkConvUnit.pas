unit BulkConvUnit;

interface

uses
  Windows,Messages,SysUtils,Variants,Classes,Graphics,Controls,Forms,MainUnit,
  Dialogs,StdCtrls,Buttons,Grids,ComCtrls,ShBrowseU,RegUtils;

type
  TBulkConvForm = class(TForm)
    Cancel: TSpeedButton;
    Execute: TSpeedButton;
    ListBox1: TListBox;
    Source: TLabel;
    Dest: TLabel;
    Copy: TSpeedButton;
    sb_source: TSpeedButton;
    sb_dest: TSpeedButton;
    GroupBox1: TGroupBox;
    cb_SaveCSV: TCheckBox;
    cb_SaveJPG: TCheckBox;
    cb_SavePNG: TCheckBox;
    cb_SaveGIF: TCheckBox;
    cb_SaveBMP: TCheckBox;
    Label1: TLabel;
    ed_filename: TEdit;
    procedure sb_destClick(Sender: TObject);
    procedure sb_sourceClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TickBoxChanged(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BulkConvForm: TBulkConvForm;

implementation

{$R *.dfm}

procedure TBulkConvForm.CancelClick(Sender: TObject);
begin
 ModalResult:=mrCancel;
end;

procedure TBulkConvForm.CopyClick(Sender: TObject);
begin
  Dest.Caption:=Source.Caption;
end;

procedure TBulkConvForm.ExecuteClick(Sender: TObject);
var
 FindResult: integer;
 SearchRec : TSearchRec;
begin
 ListBox1.Clear;
 FindResult := FindFirst(Source.Caption+'/*.*', faAnyFile - faDirectory, SearchRec);
 while FindResult = 0 do
 begin
   ListBox1.Items.Add(SearchRec.Name);
   FindResult := FindNext(SearchRec);
 end;
 FindClose(SearchRec);
 SetRegValS('MapName',ed_filename.Text);
 ModalResult:=mrOK;
end;

procedure TBulkConvForm.FormCreate(Sender: TObject);
begin
 Source.Caption:='C:\';
 Dest.Caption:='C:\';
end;

procedure TBulkConvForm.sb_destClick(Sender: TObject);
begin
 with TShBrowse.Create do begin
  Caption:='Destination Folder';
  UserMessage:='Select the destination folder';
  InitFolder:=Dest.Caption;
  if Execute then
   Dest.Caption:=Folder;
  Free;
 end;
end;

procedure TBulkConvForm.sb_sourceClick(Sender: TObject);
begin
 with TShBrowse.Create do begin
  Caption:='Source Folder';
  UserMessage:='Select the source folder';
  InitFolder:=Source.Caption;
  if Execute then
   Source.Caption:=Folder;
  Free;
 end;
end;

procedure TBulkConvForm.TickBoxChanged(Sender: TObject);
var
 flags: Cardinal;
begin
 flags:=0;
 flags:=flags OR MainForm.setbit(0,cb_SaveBMP.Checked);
 flags:=flags OR MainForm.setbit(1,cb_SaveGIF.Checked);
 flags:=flags OR MainForm.setbit(2,cb_SavePNG.Checked);
 flags:=flags OR MainForm.setbit(3,cb_SaveJPG.Checked);
 flags:=flags OR MainForm.setbit(4,cb_SaveCSV.Checked);
 SetRegValI('Flags',flags);
end;

end.
