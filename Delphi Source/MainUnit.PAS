unit MainUnit;

interface

uses Winapi.Windows,System.Classes,Vcl.Graphics,Vcl.Forms,Vcl.Controls,Vcl.Menus,
     Vcl.Dialogs,Vcl.StdCtrls,Vcl.Buttons,Vcl.ExtCtrls,Vcl.ComCtrls,Vcl.ImgList,
     Vcl.StdActns,Vcl.ActnList,Vcl.ToolWin,Vcl.Imaging.pngimage,SysUtils,
     Vcl.ExtDlgs,System.ImageList,Vcl.Imaging.GIFimg,Vcl.Imaging.jpeg,LZRW1,
     AdvPageControl,System.UITypes,RegUtils,Vcl.ClipBrd,System.Actions,ShellApi,
     Vcl.Samples.Gauges,System.Types,Math;

type
  TMainForm = class(TForm)
    OpenPictureDialog1: TOpenPictureDialog;
    CharPanel: TPanel;
    sb_ScreenGrab: TScrollBox;
    sb_Map: TScrollBox;
    img_ScreenGrab: TImage;
    SmallCharPanel: TPanel;
    img_Map: TImage;
    SaveDialog1: TSaveDialog;
    mapcharpanel: TPanel;
    map_text: TMemo;
    lzrw11: Tlzrw1;
    Panel1: TPanel;
    Image1: TImage;
    MainArea: TAdvPageControl;
    tb_ScreenGrab: TAdvTabSheet;
    tb_Map: TAdvTabSheet;
    ActionList1: TActionList;
    LoadFromClipboard: TAction;
    SaveClipboard: TAction;
    sb_Characters: TScrollBox;
    charcursor: TShape;
    charselect: TShape;
    ZoomIn: TAction;
    ZoomOut: TAction;
    ProgressBar1: TGauge;
    fullcolourimage: TImage;
    ScreenGrabTab: TAction;
    ConvertedTab: TAction;
    charstorage: TImage;
    ReptonCharPanel: TImage;
    SaveScreenGrabDialog: TSaveDialog;
    PuzzlePiece: TImage;
    mapboundbox: TShape;
    ButtonPanel: TPanel;
    sb_LoadScreenGrab: TSpeedButton;
    sb_SaveScreenGrab: TSpeedButton;
    sb_DecodeStart: TSpeedButton;
    sb_SaveMap: TSpeedButton;
    sb_bulkconvert: TSpeedButton;
    sb_options: TSpeedButton;
    sb_about: TSpeedButton;
    InfoPanel: TPanel;
    lb_filename: TLabel;
    Label6: TLabel;
    lb_MapSize: TLabel;
    Label7: TLabel;
    lb_Origin: TLabel;
    Label1: TLabel;
    lb_maparea: TLabel;
    Label8: TLabel;
    lb_accuracy: TLabel;
    lb_MapColour: TLabel;
    cb_map_colour: TComboBox;
    Label4: TLabel;
    cb_game: TComboBox;
    lb_fullsizechar: TLabel;
    sh_accuracy: TShape;
    ProgressPanel: TPanel;
    function IsBitSet(v: Cardinal;b: Byte): Boolean;
    function SetBit(bit: Byte; setit: Boolean): Cardinal;
    procedure Extract(sx,sy,chars,chrsacross,w,h,bpp: Integer;parent: TObject;
      var char: array of TImage; var Atlas: TImage);
    procedure FormShow(Sender: TObject);
    procedure ExtractCharsFromResource(col: Byte;fullsize: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure sb_LoadScreenGrabClick(Sender: TObject);
    procedure ScreenGrabFromClipboard(Sender: TObject);
    procedure LoadScreenGrab(filename: String);
    procedure UpdateLabels;
    procedure DecodeScreen(Sender: TObject);
    function CompareBitmaps(var bmp_com: array of TByteDynArray;
           var bmp_map: TByteDynArray; var bigch: Integer; w,h: Cardinal): Byte;
    function GetRGB(colour: Byte; var data: TByteDynArray): Cardinal;
    function Diff(a,b: Cardinal): Cardinal;
    function AppVersion: String;
    procedure sb_SaveMapClick(Sender: TObject);
    function RemoveExt(filename: String): String;
    procedure SaveToClipboard(Sender: TObject);
    procedure SaveMap(img: TImage; filename: String; bmp,png,gif,jpg,csv,
                      confirmoverwrite: Boolean);
    procedure cb_map_colourChange(Sender: TObject);
    procedure ComboBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure sb_bulkconvertClick(Sender: TObject);
    function IsAnImage(filename: String):Boolean;
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure sb_MapResize(Sender: TObject);
    procedure img_ScreenGrabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure charcursorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CharSelectorClick(Sender: TObject);
    procedure ZoomInExecute(Sender: TObject);
    procedure ZoomOutExecute(Sender: TObject);
    procedure img_ScreenGrabMouseLeave(Sender: TObject);
    procedure SwitchProgress(turnon: Boolean);
    procedure ScreenGrabTabExecute(Sender: TObject);
    procedure ConvertedTabExecute(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ResetFields(colourchange: Boolean);
    procedure cb_gameChange(Sender: TObject);
    procedure sb_SaveScreenGrabClick(Sender: TObject);
    procedure InitiateSave(dialog: TSaveDialog);
    procedure lb_MapSizeMouseEnter(Sender: TObject);
    procedure lb_MapSizeMouseLeave(Sender: TObject);
    procedure lb_MapSizeClick(Sender: TObject);
    procedure mapboundboxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mapboundboxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mapboundboxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lb_MapSizeDblClick(Sender: TObject);
    procedure SetRegistry;
    procedure sb_optionsClick(Sender: TObject);
    procedure sb_aboutClick(Sender: TObject);
    procedure ExtractPictureArea(var image: TImage;src: TRect;
      var bmp_map: TByteDynArray); overload;
  private
   fullsize_char,
   mapsize_char      : array of TImage;
   map               : array of array of Integer;
   map_prob          : array of array of Cardinal;
   Atlas             : TImage;
   fullsize_loaded,
   screengrab_loaded,
   debugapp,
   editboundbox,
   boundboxmove      : Boolean;
   originx,
   originy,
   det_originx,
   det_originy,
   errors,
   mapareax,
   mapareay          : Cardinal;
   boundboxedit      : Byte;
   grab_width,
   grab_height,
   det_grab_width,
   det_grab_height,
   Image_SX,
   Image_SY,
   Image_LX,
   Image_LY,
   charX,charY,
   selectedchar,
   bboxX,bboxY       : Integer;
   curr_folder,
   img_filename      : String;
   //***** Debug section *******************************************************
   debug             : TImage;
   //***** Debug section *******************************************************
   const
    App_Title       = 'Repton Map Decoder';
    App_Date        = 'beta';
    map_colours      : array[0..5] of String  //Colour names
                    = ('Blue', 'Cyan', 'Green','Magenta','Orange','Red');
    map_rgbs         : array[0..5] of Cardinal //RGBs of above colours
                    = ($FF0000,$FFFF00,$00FF00,$FF00FF,  $0099FF, $0000FF);
    repchars         : array[0..1,0..34] of Byte //PC Repton character references
                    = ((  1,  2,  3,  7,  8,  9, 10, 11,
                         12, 13, 14, 15, 16, 17, 18, 19,
                         20, 21, 22, 23, 24, 25, 26, 28,
                         29, 30, 31, 32, 33, 34, 38,  6,
                         78,  0,  0),
                       (  1,  2,  6,  3, 16, 28, 25, 29,
                         24,  7,  8,  9, 10, 13, 14, 15,
                         12, 11, 18, 19, 20, 22, 30, 31,
                        253, 38, 80, 35, 32, 33, 78,254,
                          5,  3, 28));
    num_chars        : array[0..1] of Byte
                    = (33,35); //Number of characters in an atlas
    grab_min_width  =  512; //Map size
    grab_min_height =  480; //Map size
    grab_max_width  = 1024; //Editor window size
    grab_max_height =  768; //Editor window size
    map_char_width  =   16; //Size of characters on map
    map_char_height =   15; //Size of characters on map
    full_chr_width  =   64; //Size of full size characters
    full_chr_height =   64; //Size of full size characters
    char_sel_width  =   32; //Size of full size character in selector box
    char_sel_height =   32; //Size of full size character in selector box
    def_map_width   =   32; //Size of map, in characters
    def_map_height  =   32; //Size of map, in characters
    def_prob_match  =   88; //Probability of a match - character, default
    def_pix_match   =   90; //Probability of a match - pixel, default
    def_repton_match=   96; //Probability of a match - Repton in game/editor, default
    def_fnamemap    = '%s-decode';
    strflags        = [rfReplaceAll,rfIgnoreCase];
    //Overloaded procedures/functions
    procedure ExtractPictureArea(var image: TImage;var bitmap: TBitmap;
      var ms: TMemoryStream;src: TRect;var bmp_map: TByteDynArray); overload;
  public
   prob_match,
   pix_match,
   repton_match      : Byte;
   puzzpiece         : Boolean;
   const
    crHandFlat      =    1;
  end;

var
  MainForm: TMainForm;

{
To Do:
* Compress (and decompress) the resources using:
  System.ZLib.TZDecompressionStream
* Integrate into Repton Map Display (multi platform version)
}

implementation

{$R *.dfm}

uses
 BulkConvUnit, AboutUnit, OptionsUnit;

{-------------------------------------------------------------------------------
Tests to see if a particular bit is set in an Cardinal
-------------------------------------------------------------------------------}
function TMainForm.IsBitSet(v: Cardinal; b: Byte): Boolean;
var
 x: Cardinal;
begin
 if b<32 then
 begin
  x:=1 shl b;
  Result:=((v AND x)=x);
 end else Result:=False;
end;

{-------------------------------------------------------------------------------
Display a bounding box over the detected map size so it can be edited
-------------------------------------------------------------------------------}
procedure TMainForm.lb_MapSizeClick(Sender: TObject);
begin
 if (grab_width>0) and (grab_height>0) and (not sb_SaveMap.Enabled) then
  editboundbox:=not editboundbox;
end;

{-------------------------------------------------------------------------------
Reset the bounding box to the detected size and origin
-------------------------------------------------------------------------------}
procedure TMainForm.lb_MapSizeDblClick(Sender: TObject);
begin
 //Update the origin and grab size
 originx           :=det_originx;
 mapboundbox.Left  :=originx;
 originy           :=det_originy;
 mapboundbox.Top   :=originy;
 grab_width        :=det_grab_width;
 mapboundbox.Width :=grab_width*map_char_width;
 grab_height       :=det_grab_height;
 mapboundbox.Height:=grab_height*map_char_height;
 UpdateLabels;
end;

{-------------------------------------------------------------------------------
Display a bounding box over the detected map size
-------------------------------------------------------------------------------}
procedure TMainForm.lb_MapSizeMouseEnter(Sender: TObject);
var
 zoomfactor: Real;
begin
 if (grab_width>0) and (grab_height>0) and (not sb_SaveMap.Enabled) then
 begin
  //Work out the zoom factor, as a fraction
  zoomfactor         :=img_ScreenGrab.Width/img_ScreenGrab.Picture.Width;
  //Setup the bounding box
  mapboundbox.Top    :=Round(img_ScreenGrab.Top +(Integer(originy)*zoomfactor));
  mapboundbox.Left   :=Round(img_ScreenGrab.Left+(Integer(originx)*zoomfactor));
  mapboundbox.Width  :=Round(grab_width *map_char_width *zoomfactor);
  mapboundbox.Height :=Round(grab_height*map_char_height*zoomfactor);
  //And display it
  mapboundbox.Visible:=True;
  boundboxedit:=0;
  boundboxmove:=False;
 end;
end;

{-------------------------------------------------------------------------------
Remove the bounding box over the detected map size
-------------------------------------------------------------------------------}
procedure TMainForm.lb_MapSizeMouseLeave(Sender: TObject);
begin
 if not editboundbox then mapboundbox.Visible:=False;
end;

{-------------------------------------------------------------------------------
Set a specific bit in a cardinal
-------------------------------------------------------------------------------}
function TMainForm.SetBit(bit: Byte; setit: Boolean): Cardinal;
begin
 if (setit) and (bit<32) then Result:=1 shl bit
                         else Result:=0;
end;

{-------------------------------------------------------------------------------
Set up the form when creating
-------------------------------------------------------------------------------}
procedure TMainForm.FormCreate(Sender: TObject);
begin
 Application.Title           :=App_Title;
 Caption                     :=Application.Title+' v'+AppVersion;
 //***** Debug section ******************************************************
 debugapp         :=False; //To produce a colour changed screen grab
 //***** Debug section ******************************************************
end;

{-------------------------------------------------------------------------------
Setup the form when showing
-------------------------------------------------------------------------------}
procedure TMainForm.FormShow(Sender: TObject);
var
 i    : Byte;
 flags: Cardinal;
begin
 //Setup the about box form
 AboutForm.lb_title.Caption  :=Application.Title;
 AboutForm.lb_version.Caption:='Version '+AppVersion+' ('+App_Date+')';
 //Read the registry
 flags                          :=GetRegValI('Flags',$11);
 BulkConvForm.cb_SaveBMP.Checked:=IsBitSet(flags, 0);
 BulkConvForm.cb_SaveGIF.Checked:=IsBitSet(flags, 1);
 BulkConvForm.cb_SavePNG.Checked:=IsBitSet(flags, 2);
 BulkConvForm.cb_SaveJPG.Checked:=IsBitSet(flags, 3);
 BulkConvForm.cb_SaveCSV.Checked:=IsBitSet(flags, 4);
 puzzpiece                      :=IsBitSet(flags, 5);
 prob_match                     :=GetRegValI('ProbMatch',def_prob_match);
 pix_match                      :=GetRegValI('PixelMatch',def_pix_match);
 repton_match                   :=GetRegValI('ReptonMatch',def_repton_match);
 BulkConvForm.ed_filename.Text  :=GetRegValS('MapName',def_fnamemap);
 OptionsForm.rg_CharRef.ItemIndex:=GetRegValI('CharRef',0);
 if puzzpiece then
  OptionsForm.rg_puzzlepiece.ItemIndex:=1
 else
  OptionsForm.rg_puzzlepiece.ItemIndex:=0;
 //Create the temporary TImage container
 Atlas         :=TImage.Create(MainForm);
 Atlas.AutoSize:=True;
 //Populate the colour drop down box
 for i:=Low(map_colours) to High(map_colours) do
  cb_map_colour.Items.Add(map_colours[i]);
 //Get the current directory
 curr_folder                 :=GetCurrentDir;
 //Initiate some flags
 fullsize_loaded             :=True;  //If the full size characters are loaded
 screengrab_loaded           :=False; //Screengrab is loaded
 sb_DecodeStart.Enabled      :=False; //Disable the 'Decode Start' button
 sb_SaveMap.Enabled          :=False; //Disable the 'Save Map' button
 editboundbox                :=False; //Editable bounding box
 MainArea.ActivePageIndex    :=0;     //Set the active tab
 ExtractCharsFromResource(0,True);    //Get the default atlas (Repton 1 Blue)
 cb_map_colour.ItemIndex     :=0;     //Set the colour to Blue
 BulkConvForm.GroupBox1.Color:=clBlack;
 lb_filename.Caption         :='';    //Clear the filename
 //Turn off the progress indicator
 SwitchProgress(False);
 //Setup the storage container
 charstorage.Width           :=char_sel_width;
 charstorage.Height          :=char_sel_height;
 //And the character selector
 charselect.Top              :=lb_fullsizechar.Top+lb_fullsizechar.Height;
 charselect.Width            :=char_sel_width;
 charselect.Height           :=char_sel_height;
 charselect.Left             :=0;
 //And finally the map character cursor
 charcursor.Width            :=map_char_width+8;
 charcursor.Height           :=map_char_height+8;
 selectedchar                :=-1;
 //Load the custom cursors
 Screen.Cursors[crHandFlat]  :=LoadCursor(HInstance,'HandFlat');
 //And set the Full Size Map cursor to it
 sb_Map.Cursor               :=crHandFlat;
 //Set up the probability match captions and sliders
 OptionsForm.lb_prob_match.Caption       :=IntToStr(prob_match)+'%';
 OptionsForm.prob_match_slider.Position  :=prob_match;
 OptionsForm.lb_repton_match.Caption     :=IntToStr(repton_match)+'%';
 OptionsForm.repton_match_slider.Position:=repton_match;
 OptionsForm.lb_pixel_match.Caption      :=IntToStr(pix_match)+'%';
 OptionsForm.pixel_match_slider.Position :=pix_match;
 //Setup the keyboard shortcuts
 ZoomIn.ShortCut             :=16571; //Ctrl + +
 ZoomOut.ShortCut            :=16573; //Ctrl + -
 //Turn Repton to 8bpp
 ReptonCharPanel.Picture.Bitmap.PixelFormat:=pf8bit;
end;

{-------------------------------------------------------------------------------
Extracts, and decompresses, an atlas from a resource then splits it
-------------------------------------------------------------------------------}
procedure TMainForm.ExtractCharsFromResource(col: Byte;fullsize: Boolean);
var
 res  : TResourceStream;
 hdr  : array[0..3] of Byte;
 ms   : TMemoryStream;
 S    : String;
 ch   : Integer;
 chrs : Byte;
begin
 S:='';
 res:=nil;
 chrs:=0;
 //Format of resource name is:
 // R<game>_<colour>_<map?>_Atlas where:
 // <game>   : 1 = Repton 1, 2 = Repton 2
 // <colour> : Colour name
 // <map?>   : 'Map' if map characters, blank if not (drop the second '_')
 if col<10 then
 begin
  if not fullsize then S:='_Map';
  res:=TResourceStream.Create(hInstance,'R'+IntToStr(cb_game.ItemIndex+1)+'_'+
                              map_colours[col mod Length(map_colours)]+S+'_Atlas',
                              RT_RCDATA);
  chrs:=num_chars[cb_game.ItemIndex];
 end;
 if col>9 then
 begin
  case col of
   10: S:='Diamonds';
  end;
  res :=TResourceStream.Create(hInstance,S,RT_RCDATA);
  chrs:=6;
 end;
 res.Position:=0;
 res.ReadBuffer(hdr,4);
 res.Position:=0;
 ms:=TMemoryStream.Create;
 ms.Position:=0;
 //Resource is compressed, so uncompress
 if  (hdr[0]=ord('!'))
 and (hdr[1]=ord('H'))
 and (hdr[2]=ord('Z'))
 and (hdr[3]=ord('L')) then
 begin
  lzrw11.InputStream :=res;
  lzrw11.OutputStream:=ms;
  lzrw11.Decompress;
 end
 else res.SaveToStream(ms);
 ms.Position:=0;
 //Load into the temporary storage
 Atlas.Picture.Bitmap.LoadFromStream(ms);
 res.Free;
 ms.Free;
 if fullsize then
 begin
  //Free up old characters
  if Length(fullsize_char)>0 then
   for ch:=0 to Length(fullsize_char)-1 do
    if fullsize_char[ch]<>nil then
     fullsize_char[ch].Free;
  SetLength(fullsize_char,0);
  //Now split the atlas
  SetLength(fullsize_char,chrs);
  Extract(0,0,chrs,16,full_chr_width,full_chr_height,16,
          sb_Characters,fullsize_char,Atlas);
  //Make sure the characters are of the correct size, and stretch is on
  //They will be stored full size (64x64), but displayed half size
  for ch:=0 to chrs-1 do
  begin
   fullsize_char[ch].Width  :=char_sel_width;
   fullsize_char[ch].Height :=char_sel_height;
   fullsize_char[ch].Stretch:=True;
   fullsize_char[ch].Top    :=lb_fullsizechar.Top+lb_fullsizechar.Height+
                              ((ch+1) div 5)*char_sel_height;
   fullsize_char[ch].Left   :=((ch+1) mod 5)*char_sel_width;
   fullsize_char[ch].OnClick:=CharSelectorClick;
  end;
 end;
 //Map characters
 if not fullsize then
 begin
  //Free the currently open ones
  if Length(mapsize_char)>0 then
   for ch:=0 to Length(mapsize_char)-1 do
    if mapsize_char[ch]<>nil then
     mapsize_char[ch].Free;
  SetLength(mapsize_char,0);
  //Then split the atlas - these are not visible
  SetLength(mapsize_char,chrs);
  Extract(0,0,chrs,16,map_char_width,map_char_height,8,
          mapcharpanel,mapsize_char,Atlas);
 end;
end;

{-------------------------------------------------------------------------------
Bulk Decode a load of screen grabs
-------------------------------------------------------------------------------}
procedure TMainForm.sb_aboutClick(Sender: TObject);
begin
 AboutForm.ShowModal;
end;

{-------------------------------------------------------------------------------
Bulk Decode a load of screen grabs
-------------------------------------------------------------------------------}
procedure TMainForm.sb_bulkconvertClick(Sender: TObject);
var
 i            : integer;
 filename,
 opt_mapname,
 mapname      : String;
begin
 //Open the form to get source and destination, plus save options
 BulkConvForm.ShowModal;
 //If user clicked OK, carry on
 if BulkConvForm.ModalResult=mrOK then
 begin
  //Iterate through them
  for i:=0 to BulkConvForm.ListBox1.Items.Count-1 do
  begin
   filename:=BulkConvForm.ListBox1.Items[i];
   //Load a file
   LoadScreenGrab(BulkConvForm.Source.Caption+'\'+filename);
   //Decode it
   DecodeScreen(nil);
   //Save it
   if sb_SaveMap.Enabled then
   begin
    {Wildcard translations}
    opt_mapname:=BulkConvForm.ed_filename.Text;
    mapname:=StringReplace(opt_mapname,'%%','%',strflags);
    mapname:=StringReplace(mapname,'%g',IntToStr(cb_game.ItemIndex+1),strflags);
    mapname:=StringReplace(mapname,'%s',RemoveExt(filename),strflags);
    SaveMap(img_Map,
            BulkConvForm.Dest.Caption+'\'+mapname,
            BulkConvForm.cb_SaveBMP.Checked,
            BulkConvForm.cb_SavePNG.Checked,
            BulkConvForm.cb_SaveGIF.Checked,
            BulkConvForm.cb_SaveJPG.Checked,
            BulkConvForm.cb_SaveCSV.Checked,
            False);
   end;
  end;
  ResetFields(True);
 end;
end;

{-------------------------------------------------------------------------------
Decode a screen grab into a full size screen
-------------------------------------------------------------------------------}
procedure TMainForm.DecodeScreen(Sender: TObject);
var
 x,y,
 prob    : Byte;
 ch,
 bigch   : Integer;
 match   : array of Cardinal;
 map_char: TBitmap;
 bmp_map : TByteDynArray;
 bmp_com : array of TByteDynArray;
 ms      : TMemoryStream;
 src,
 dest    : TRect;
begin
 //Will only continue to decode the screen if there is something to decode
 if sb_DecodeStart.Enabled then
 begin
  //Disable the 'Save Map' button
  sb_SaveMap.Enabled           :=False;
  //Remove the bounding box
  editboundbox:=False;
  lb_MapSizeMouseLeave(Sender);
  //Set the active page to the decoded tab
  MainArea.ActivePageIndex     :=1;
  //Create the container for temporary storage of the current map character
  map_char                     :=TBitmap.Create;
  map_char.Width               :=map_char_width;
  map_char.Height              :=map_char_height;
  //Create the memory stream used to access the raw bitmap data
  ms                           :=TMemoryStream.Create;
  //Set the scroll bar positions to zero
  sb_Map.HorzScrollBar.Position:=0;
  sb_Map.VertScrollBar.Position:=0;
  //Set the size and position of the decoded map
  img_Map.Width                :=fullsize_char[0].Picture.Bitmap.Width *grab_width;
  img_Map.Height               :=fullsize_char[0].Picture.Bitmap.Height*grab_height;
  img_Map.Top                  :=0;
  img_Map.Left                 :=0;
  //Initiate the map and probability array sizes
  SetLength(map,grab_width,grab_height);
  SetLength(map_prob,grab_width,grab_height);
  //And empty them
  for y:=0 to grab_height-1 do
   for x:=0 to grab_width-1 do
   begin
    map[x,y]     :=0;
    map_prob[x,y]:=0;
   end;
  //Reset the error counter
  errors:=0;
  //Turn on the progress indicator
  SwitchProgress(True);
  //Extract the currently selected map characters into an array
  SetLength(match,num_chars[cb_game.ItemIndex]);
  ExtractCharsFromResource(cb_map_colour.ItemIndex,False);
  //Then extract the raw bitmap data into a byte array
  SetLength(bmp_com,Length(match));
  for ch:=0 to Length(match)-1 do
  begin
   ms.Clear;
   mapsize_char[ch].Picture.Bitmap.SaveToStream(ms);
   ms.Position:=0;
   SetLength(bmp_com[ch],ms.Size);
   ms.ReadBuffer(bmp_com[ch,0],ms.Size);
  end;
  //Now we'll go through the map and extract and compare each character
  for y:=0 to grab_height-1 do
   for x:=0 to grab_width-1 do
   begin
    //Setup the source rectangle
    src.Top    :=originy+y*map_char_height;
    src.Left   :=originx+x*map_char_width;
    src.Width  :=map_char_width;
    src.Height :=map_char_height;
    //Get the part of the picture into our array
    ExtractPictureArea(img_ScreenGrab,map_char,ms,src,bmp_map);
    //Now let's compare this with every map character
    prob:=CompareBitmaps(bmp_com,bmp_map,bigch,map_char_width,map_char_height);
    //Copy the full size character onto the full size map
    if prob>=prob_match then //If character is at or above probability of a match
     if (bigch>=0) and (bigch<Length(fullsize_char)) then
      img_Map.Canvas.Draw(x*full_chr_width,
                          y*full_chr_height,
                          fullsize_char[bigch].Picture.Graphic);
    if prob<prob_match then
    begin
     if puzzpiece then
      img_Map.Canvas.Draw(x*full_chr_width,
                          y*full_chr_height,
                          PuzzlePiece.Picture.Graphic);
     if not puzzpiece then
     begin //Character is less than probablity of a match
      //Setup the destination rectangle
      dest.Top   :=0;
      dest.Left  :=0;
      dest.Width :=char_sel_width;
      dest.Height:=char_sel_height;
      //And the source rectangle
      src.Left   :=(x*map_char_width)+originx;
      src.Top    :=(y*map_char_height)+originy;
      src.Width  :=map_char_width;
      src.Height :=map_char_height;
      //We'll use the charstorage as temporary storage
      charstorage.Canvas.CopyRect(dest,fullcolourimage.Canvas,src);
      //Reset the destination to the new image
      dest.Top   :=y*full_chr_height;
      dest.Left  :=x*full_chr_width;
      dest.Width :=full_chr_width;
      dest.Height:=full_chr_height;
      //Stretch and Draw it on
      img_Map.Canvas.StretchDraw(dest,charstorage.Picture.Graphic);
      //Empty the charstorage container
      charstorage.Picture:=nil;
     end;
     //Reset the character ID
     bigch      :=-1;
     //Increase the error counter
     inc(errors);
    end;
    //Update the progress indicator
    ProgressBar1.Progress:=Round((((y*grab_width)+x)/(grab_width*grab_height))
                                    *ProgressBar1.MaxValue);
    //Mark up the map arrays
    map[x,y]:=bigch;
    map_prob[x,y]:=prob;
   end;
  //We've finished with these variables
  map_char.Free;
  ms.Free;
  //We can now enable/disable the appropriate controls
  sb_SaveMap.Enabled   :=True;
  //and fire up the character selector cursor
  charselect.Visible   :=True;
  charselect.BringToFront;
  charselect.Top:=lb_fullsizechar.Top+lb_fullsizechar.Height;
  charselect.Left:=0;
  //Resetting the currently selected cursor to default
  selectedchar:=-1;
  //And turn off the progress indicator
  SwitchProgress(False);
  //Report the success rate
  ch:=100-Round((errors/(grab_width*grab_height))*100);
  lb_accuracy.Caption:=IntToStr(ch)+'%';
  if  ch<26              then sh_accuracy.Brush.Color:=clRed;    //Red = BAD
  if (ch>24) and (ch<50) then sh_accuracy.Brush.Color:=clFuchsia;//  |
  if (ch>49) and (ch<75) then sh_accuracy.Brush.Color:=clYellow; //  |
  if  ch>74              then sh_accuracy.Brush.Color:=clLime;   //Green = GOOD
 end;
end;

{-------------------------------------------------------------------------------
Compare a bitmap (bmp_map) with array of bitmaps (bmp_com)
-------------------------------------------------------------------------------}
function TMainForm.CompareBitmaps(var bmp_com: array of TByteDynArray;
           var bmp_map: TByteDynArray; var bigch: Integer; w,h: Cardinal): Byte;
var
 ch    : Integer;
 big,i,
 size,
 poff  : Cardinal;
 match : array of Cardinal;
begin
 SetLength(match,Length(bmp_com));
 ch:=-1;   //Current character in the atlas
 big:=0;   //Best match, so far (match score)
 bigch:=0; //Best match, so far (character ID)
 repeat
  //Go to the next character in the atlas
  inc(ch);
  //Set the match score to zero
  match[ch]:=0;
  //Get bigger of the two characters...in theory, they should be identical
  if Length(bmp_com[ch])>Length(bmp_map) then
   size:=Length(bmp_com[ch])
  else
   size:=Length(bmp_map);
  //Get the pixel offset
  poff:=bmp_map[$A]+bmp_map[$B]*$100+bmp_map[$C]*$10000+bmp_map[$D]*$1000000;
  //Now compare the pixel data
  for i:=poff to size-1 do
   //The comparison of each pixel will produce a score - the higher the score
   //the more probability of a match
   inc(match[ch],Diff(GetRGB(bmp_com[ch,i],bmp_com[ch])
                     ,GetRGB(bmp_map[i]   ,bmp_map)));
  //Is this a better match than what has been found already?
  if match[ch]>big then
  begin
   //Yes, so take a note
   big:=match[ch];
   bigch:=ch;
  end;
  //And continue until we have gone through all characters, or found a
  //perfect match
 until (ch=Length(match)-1) or (big=w*h*$100);
 //This function returns the probability of the most likely match.
 Result:=Round((big/(w*h*$100))*100);
end;

{-------------------------------------------------------------------------------
Get the RGB colour from the palette of the raw bitmap held in 'data'
-------------------------------------------------------------------------------}
function TMainForm.GetRGB(colour: Byte; var data: TByteDynArray): Cardinal;
begin
 //Palette is held from offset $36 into the raw bitmap data (i.e. after the DIB
 //header). +0 is Blue, +1 is Green, +2 is Red, +3 is Alpha (ignored)
 Result:=data[$36+colour*4]*$10000 //B
        +data[$37+colour*4]*$100   //G
        +data[$38+colour*4];       //R
end;

{-------------------------------------------------------------------------------
The game selector drop down has changed
-------------------------------------------------------------------------------}
procedure TMainForm.cb_gameChange(Sender: TObject);
begin
 //If we have something loaded, then reload it and re-analyse it.
 if img_filename<>'' then
  LoadScreenGrab('reload');
 //And change the character set accordingly.
 cb_map_colourChange(Sender);
end;

{-------------------------------------------------------------------------------
The map colour selector drop down has changed
-------------------------------------------------------------------------------}
procedure TMainForm.cb_map_colourChange(Sender: TObject);
begin
 ExtractCharsFromResource(cb_map_colour.ItemIndex,True);
 ResetFields(False);
end;

{-------------------------------------------------------------------------------
Mouse button pressed - draw the selected character on the map
-------------------------------------------------------------------------------}
procedure TMainForm.charcursorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 dest: TRect;
begin
 if sb_SaveMap.Enabled then
  if  (charX<grab_Width) and (charY<grab_Height)
  and (charX>=0) and (charY>=0) then
  begin
   //Temporarily hide the cursor (will be unhidden when mouse is released)
   charcursor.Visible:=False;
   //Set up the rectangle on the full size map
   dest.Left:=charX*full_chr_width;
   dest.Top:=charY*full_chr_height;
   dest.Width:=full_chr_width;
   dest.Height:=full_chr_height;
   //Stretch and paste the temporary container onto the full size map
   if selectedchar=-1 then
    img_Map.Canvas.StretchDraw(dest,charstorage.Picture.Graphic)
   else
    img_Map.Canvas.StretchDraw(dest,fullsize_char[selectedchar].Picture.Graphic);
   map[charX,charY]:=selectedchar;
  end;
end;

{-------------------------------------------------------------------------------
Zoom in on either map
-------------------------------------------------------------------------------}
procedure TMainForm.ZoomInExecute(Sender: TObject);
begin
 if MainArea.ActivePageIndex=1 then
  if sb_SaveMap.Enabled then
   if img_Map.Width<full_chr_width*grab_width then
   begin
    img_Map.Width:=img_Map.Width*2;
    img_Map.Height:=img_Map.Height*2;
    sb_MapResize(Sender);
   end;
 if MainArea.ActivePageIndex=0 then
  if sb_DecodeStart.Enabled then
   if img_ScreenGrab.Width<img_ScreenGrab.Picture.Width*4 then
   begin
    img_ScreenGrab.Width:=img_ScreenGrab.Width*2;
    img_ScreenGrab.Height:=img_ScreenGrab.Height*2;
    charstorage.Picture:=nil;
    charcursor.Visible:=False;
    if mapboundbox.Visible then
     lb_MapSizeMouseEnter(Sender);
   end;
end;

{-------------------------------------------------------------------------------
Zoom out on either map
-------------------------------------------------------------------------------}
procedure TMainForm.ZoomOutExecute(Sender: TObject);
begin
 if MainArea.ActivePageIndex=1 then
  if sb_SaveMap.Enabled then
   if img_Map.Width>(full_chr_width*grab_width)div 8 then
   begin
    img_Map.Width:=img_Map.Width div 2;
    img_Map.Height:=img_Map.Height div 2;
    sb_MapResize(Sender);
   end;
 if MainArea.ActivePageIndex=0 then
  if sb_DecodeStart.Enabled then
   if img_ScreenGrab.Width>img_ScreenGrab.Picture.Width then
   begin
    img_ScreenGrab.Width:=img_ScreenGrab.Width div 2;
    img_ScreenGrab.Height:=img_ScreenGrab.Height div 2;
    charstorage.Picture:=nil;
    charcursor.Visible:=False;
    if mapboundbox.Visible then
     lb_MapSizeMouseEnter(Sender);
   end;
end;

{-------------------------------------------------------------------------------
The map colour drop down box owner draw procedure - adds the colour
-------------------------------------------------------------------------------}
procedure TMainForm.ComboBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
 R: TRect;
begin
 with Control as TComboBox do
 begin
  Canvas.Brush.Color:=map_rgbs[Index]; //Fill colour
  R.Top             :=Rect.Top;
  R.Height          :=Rect.Height;
  R.Left            :=Rect.Left;//+(Rect.Width div 2);
  R.Width           :=Rect.Width;// div 2;
  Canvas.FillRect(R);
  //Text colour
  Canvas.Font.Color:=map_rgbs[Index] XOR $FFFFFF;
  Canvas.TextOut(Rect.Left,Rect.Top,TComboBox(Control).Items[Index]);
 end;
end;

{-------------------------------------------------------------------------------
Key shortcut to screen grab tab
-------------------------------------------------------------------------------}
procedure TMainForm.ScreenGrabTabExecute(Sender: TObject);
begin
 MainArea.ActivePageIndex:=0;
end;

{-------------------------------------------------------------------------------
Key shortcut to full size map tab
-------------------------------------------------------------------------------}
procedure TMainForm.ConvertedTabExecute(Sender: TObject);
begin
 MainArea.ActivePageIndex:=1;
end;

{-------------------------------------------------------------------------------
Work out the difference between RGB colours a and b and assign a score
-------------------------------------------------------------------------------}
function TMainForm.Diff(a,b: Cardinal): Cardinal;
var
 r1,b1,g1,
 r2,b2,g2 : Byte;
begin
 //Split a into R,G and B components
 r1:= a AND $0000FF;
 g1:=(a AND $00FF00)shr  8;
 b1:=(a AND $FF0000)shr 16;
 //Split b into R,G and B components
 r2:= b AND $0000FF;
 g2:=(b AND $00FF00)shr  8;
 b2:=(b AND $FF0000)shr 16;
 //Use the 'closest colour' calculation to work out how close they are
 Result:=$100-Round(sqrt(Power((r2-r1)*0.299,2)
                        +Power((g2-g1)*0.587,2)
                        +Power((b2-b1)*0.114,2)));
 //(We subject from $100 so that the higher the number, the more likely it is)
end;

{-------------------------------------------------------------------------------
Show the Open Screen Grab dialogue box
-------------------------------------------------------------------------------}
procedure TMainForm.sb_LoadScreenGrabClick(Sender: TObject);
begin
 if OpenPictureDialog1.Execute then
  LoadScreenGrab(OpenPictureDialog1.FileName);
end;

{-------------------------------------------------------------------------------
Key shortcut to load the screen grab from clipboard
-------------------------------------------------------------------------------}
procedure TMainForm.ScreenGrabFromClipboard(Sender: TObject);
begin
 if Clipboard.HasFormat(cf_BitMap) then
  LoadScreenGrab('');
end;

{-------------------------------------------------------------------------------
The map is being resized
-------------------------------------------------------------------------------}
procedure TMainForm.sb_MapResize(Sender: TObject);
begin
 Image_LX:=(img_Map.Width-sb_Map.ClientWidth)*-1;
 Image_LY:=(img_Map.Height-sb_Map.ClientHeight)*-1;
end;

{-------------------------------------------------------------------------------
Options buttons clicked
-------------------------------------------------------------------------------}
procedure TMainForm.sb_optionsClick(Sender: TObject);
begin
 OptionsForm.ShowModal;
end;

{-------------------------------------------------------------------------------
Load a screen grab, and try and detect game and main colour
-------------------------------------------------------------------------------}
procedure TMainForm.LoadScreenGrab(filename: String);
var
 ms          : TMemoryStream;
 buffer      : TByteDynArray;
 colour,
 colours     : array of Cardinal;
 x,y,z,c,d,
 direction   : Integer;
 width,
 ptr,pass,
 startx,
 starty,
 rgb,len,
 map_colour,
 total_pix,
 pixels,
 big,Ci,Di   : Cardinal;
 bitmap      : TBitmap;
 sizeOK,
 editor,
 game,
 gamechange,
 canchange   : Boolean;
 prob,
 newgame     : Byte;
 bmp_map     : TByteDynArray;
 bmp_com     : array of TByteDynArray;
 src         : TRect;
 //Function to convert x,y co-ordinates into a pixel offset
 function GetPTR(x,y: Cardinal): Cardinal;
 var
  poff: Cardinal;
 begin
  //Get the pixel offset
  poff:=buffer[$A]+buffer[$B]*$100+buffer[$C]*$10000+buffer[$D]*$1000000;
  //Calculate the offset
  Result:=poff+((Cardinal(img_ScreenGrab.Picture.Bitmap.Height)-y)*width)+x;
  //If outside the pixel data, set to the beginning or end
  if Result>=Cardinal(Length(buffer)) then Result:=Length(buffer)-1;
  if Result<poff then Result:=poff;
 end;
 //Function to validate the map size
 function ValidateSize(grab_size: Integer): Boolean;
 begin
  Result:=((grab_size mod 8)=0) and (grab_size<33) and (grab_size>0);
 end;
begin
 //Setup the game change flags, to change the Combo Box game selector
 newgame   :=cb_game.ItemIndex;
 gamechange:=False;
 canchange :=True;
 //Hide the bounding box
 editboundbox:=False;
 mapboundbox.Visible:=False;
 //Load the image, or copy from clipboard --------------------------------------
 if ((IsAnImage(filename)) or (filename='')) and (filename<>'reload') then
 begin
  ResetFields(True);
  //Default size
  grab_width             :=def_map_width;
  grab_height            :=def_map_height;
  //and hide the cursor
  charcursor.Visible     :=False;
  //Load file, whatever the format
  if filename='' then //Get the image from the clipboard
  try
   img_ScreenGrab.Picture.LoadFromClipboardFormat(cf_BitMap,
                                            Clipboard.GetAsHandle(cf_BitMap),0);
  except
   exit;
  end
  else //Otherwise load from a file
   img_ScreenGrab.Picture.LoadFromFile(filename);
  img_ScreenGrab.AutoSize       :=False;
  img_filename:=filename;
  //Reposition the image
  img_ScreenGrab.Top :=0;
  img_ScreenGrab.Left:=0;
 end;
 //User has changed the game selector drop down --------------------------------
 if filename='reload' then
 begin
  filename :=img_filename;
  canchange:=False; //Do not auto-change back
 end;
 //-----------------------------------------------------------------------------
 //If there is a screen grab, then determine whether it is a valid size, what
 //game it is, and what colour it is (where possible)
 if img_ScreenGrab.Picture<>nil then
 begin
  //First, setup ---------------------------------------------------------------
  //Flag to indicate whether the size is OK
  sizeOK:=False;
  //Convert to bitmap
  bitmap                        :=TBitmap.Create;
  bitmap.Width                  :=img_ScreenGrab.Width;
  bitmap.Height                 :=img_ScreenGrab.Height;
  bitmap.Canvas.Draw(0,0,img_ScreenGrab.Picture.Graphic);
  //Take a copy of the full colour image
  fullcolourimage.Picture.Bitmap:=bitmap;
  //before reducing the colour depth
  bitmap.PixelFormat            :=pf8bit;
  //Then copy back, as a bitmap
  img_ScreenGrab.Picture.Bitmap :=bitmap;
  bitmap.Free;
  //Basic check: Is it within size boundaries? ---------------------------------
  editor:=False;
  game  :=False;
  if  (img_ScreenGrab.Picture.Bitmap.Width  mod map_char_width=0)
  and (img_ScreenGrab.Picture.Bitmap.Height mod map_char_height=0) then
  begin
   x:=img_ScreenGrab.Picture.Bitmap.Width  div map_char_width;
   y:=img_ScreenGrab.Picture.Bitmap.Height div map_char_height;
   sizeOK:=ValidateSize(x) and ValidateSize(y);
  end;
  //Could be editor? -----------------------------------------------------------
  if  (img_ScreenGrab.Picture.Bitmap.Width >grab_min_width)
  and (img_ScreenGrab.Picture.Bitmap.Height>grab_min_height)
  and (img_ScreenGrab.Picture.Bitmap.Width <=grab_max_width)
  and (img_ScreenGrab.Picture.Bitmap.Height<=grab_max_height) then
  begin
   editor:=True;
   sizeOK:=True;
   game:=True;
  end;
  if sizeOK then
  begin
   if not editor then
   begin
    //Not in an editor window, so get the grab size in characters
    grab_width :=img_ScreenGrab.Picture.Bitmap.Width  div map_char_width;
    grab_height:=img_ScreenGrab.Picture.Bitmap.Height div map_char_height;
   end;
   //Copy the grab into a byte array for easier access -------------------------
   //Convert the image into 8bpp
   img_ScreenGrab.Picture.Bitmap.PixelFormat:=pf8bit;
   //Copy the image into an array of bytes
   ms         :=TMemoryStream.Create;
   ms.Position:=0;
   img_ScreenGrab.Picture.Bitmap.SaveToStream(ms);
   ms.Position:=0;
   SetLength(buffer,ms.Size);
   ms.ReadBuffer(buffer[0],ms.Size);
   ms.Free;
   //Get the position of the pixel data
   pixels:=buffer[$A]+buffer[$B]*$100+buffer[$C]*$10000+buffer[$D]*$1000000;
   //Set the flag that the screen grab is loaded
   screengrab_loaded:=True;
   //Work out the bitmap row width, which needs to be padded to 4 bytes
   width:=((img_ScreenGrab.Picture.Bitmap.Width+3) div 4)*4;
   //Determine the origin ------------------------------------------------------
   //Default origin
   originx  :=0;
   originy  :=0;
   //Default map area
   mapareax :=0;
   mapareay :=0;
   //Map is inside an editor/game window. Determine whether editor or game
   if (editor) or (game) then
   begin
    pass    :=0;
    repeat
     //First pass, look for a string of 204px of R:0;G:0;B:0 (editor window)
     //(Could be a 34 run of R:0;G:120;B:215 in the panel)
     //This is where the character panel appears
     startx :=549;
     starty :=147;
     rgb    :=$000000;
     len    :=204;
     game   :=False;
     //Second pass, Look for a string of 124px of R:204;G:51;B:0
     //game window in either game
     if pass=1 then
     begin
      startx:=514;
      starty:=3;
      rgb   :=$0033CC;
      len   :=124;
      editor:=False;
      game  :=True;
     end;
     if (originx=0) and (originy=0) then
     begin
      //Where to start looking
      originx:=startx;
      originy:=starty;
      repeat
       x:=0;//counter for number of pixels
       //Begin looking for a pixel
       repeat
       //Across
        inc(originx);
        if originx>=Cardinal(img_ScreenGrab.Picture.Bitmap.Width)-len then
        begin
         //Then down
         inc(originy);
         originx:=startx;
        end;
        ptr:=GetPTR(originx,originy);
       until (originy>=Cardinal(img_ScreenGrab.Picture.Bitmap.Height))
          or (GetRGB(buffer[ptr],buffer)=rgb);
       //Black pixel found - is there a string of length?
       if GetRGB(buffer[ptr],buffer)=rgb then
       begin
        inc(x); //counter
        repeat
         inc(originx);
         ptr:=GetPTR(originx,originy);
         if GetRGB(buffer[ptr],buffer)=rgb then
          inc(x);
        until (originx>=Cardinal(img_ScreenGrab.Picture.Bitmap.Width))
          or (GetRGB(buffer[ptr],buffer)<>rgb);
       end;
      until (Cardinal(x)=len)
         or (originy>=Cardinal(img_ScreenGrab.Picture.Bitmap.Height)-len);
      if Cardinal(x)<>len then
      begin
       //Did not find the length of pixels required
       originx:=0;
       originy:=0;
      end;
      //Determine which game ---------------------------------------------------
      //Confirmed an editor or game screen
      if (Cardinal(x)=len) and ((editor) or (game)) then
      begin
       //originx-len and originy contain the location of the character panel
       startx:=originx-(len-1);
       starty:=originy;
       //So now we look for Repton
       //Transfer the reference image into a byte array
       SetLength(bmp_com,1);
       ms:=TMemoryStream.Create;
       ms.Position:=0;
       ReptonCharPanel.Picture.Bitmap.SaveToStream(ms);
       ms.Position:=0;
       SetLength(bmp_com[0],ms.Size);
       ms.ReadBuffer(bmp_com[0,0],ms.Size);
       //The characters in the panel are 32x32px in size, with 1 px black around
       //Blank (top left character) is at position 0,0
       z:=1;
       repeat
        //Setup the source rectangle
        if z=1 then
        begin
         if editor then //Repton 1 is at position 3x3 = 3*34px x 3*34px
         begin
          src.Top    :=starty+3*34;
          src.Left   :=startx+3*34;
         end;
         if game then //Repton 1 will be 18x295px
         begin
          src.Top    :=starty+295;
          src.Left   :=startx+18;
         end;
        end;
        if z=2 then
        begin
         if editor then //Repton 2 is at position 1x4 = 1*34px x 4x34px
         begin
          src.Top    :=starty+4*34;
          src.Left   :=startx+1*34;
         end;
         if game then //Repton 2 will be 18x360px
         begin
          src.Top    :=starty+360;
          src.Left   :=startx+18;
         end;
        end;
        src.Width  :=34;
        src.Height :=34;
        ExtractPictureArea(img_ScreenGrab,src,bmp_map);
        //Compare the images
        prob:=CompareBitmaps(bmp_com,bmp_map,c,34,34);
        //Increase the game reference
        inc(z);
       until (z=3) or (prob>=repton_match);
       //Decrease the game reference - it will be one higher than it should be
       dec(z);
       //Free up the controls
       ms.Free;
       //Once Repton is found, we will know which game it is, so can compensate
       //and point towards the map.
       if prob>=prob_match then
       begin
        if editor then
        begin
         //Repton 1 map is 174px above the character panel
         if z=1 then originy:=starty-174;
         //Repton 2 map is 147px above the character panel
         if z=2 then originy:=starty-147;
         //Both maps are 549px to the left of the panel
         originx:=startx-549;
         //And finally set the combo box to the appropriate game
         newgame:=z-1;
         gamechange:=True;
        end;
        if game then
        begin
         //So set the combo box to the appropriate game
         newgame:=z-1;
         gamechange:=True;
         //The game screen is the 514 pixels to the left and 3 pixels up
         originx:=startx-514;
         originy:=starty-3;
        end;
       end;
      end;
     end;
     inc(pass);
    until (originx>0) or (originy>0) or (pass=2);
    //Could not find the origin, so exit the procedure
    if (originx=0) and (originy=0) then exit;
    //Determine level size -----------------------------------------------------
    //Need to find the size of the PC Repton 2 level
    //This could alter the origin
    //The original origin will be the map area
    mapareax:=originx;
    mapareay:=originy;
    if editor then
    //In an editor window. Most of the map will be the window background colour
    begin
     //Find the background colour of the window (pixel just above the origin)
     ptr :=GetPTR(originx,originy-1);
     pass:=GetRGB(buffer[ptr],buffer);
     //Direction of search - L to R and T to B doesn't always work
     direction:=0; //0: L2R/T2B; 1: L2R/B2T; 2: R2L/T2B; 3: R2L/B2T
     repeat
      //Retrieve the original origin
      originx:=mapareax;
      originy:=mapareay;
      //Then move the origin to the first pixel that isn't that colour
      //(we compare using YUV here, and use the probability match system)
      x:=-map_char_width;
      y:=1;
      repeat
       //We move across in charater widths, instead of pixel by pixel
       inc(x,map_char_width);
       //But only to the centre of the map
       if x>16*map_char_width then
       begin
        //So we then move to the next row
        x:=0;
        inc(y,map_char_height);
       end;
       //Which direction of search?
       case direction of
        //Left to Right;Top to Bottom
        0: ptr:=GetPTR(originx+Cardinal(x),                         
                       originy+Cardinal(y));
        //Left to Right;Bottom to Top
        1: ptr:=GetPTR(originx+Cardinal(x),
                       originy+((32*map_char_height)-Cardinal(y)));
        //Right to Left;Top to Bottom
        2: ptr:=GetPTR(originx+((32*map_char_width)-Cardinal(x)),
                       originy+Cardinal(y));
        //Right to Left;Bottom to Top
        3: ptr:=GetPTR(originx+((32*map_char_width)-Cardinal(x)),
                       originy+((32*map_char_height)-Cardinal(y)));
       end;
       //Get the colour
       z:=GetRGB(buffer[ptr],buffer);
       //Work out the difference, as a percentage
       len:=Round((Diff(pass,z)/$100)*100);
       //And we continue until we find a pixel not of the screen colour
       //or we reach the middle row of the map
      until (len<pix_match{Cardinal(z)<>pass}) or (y>16*map_char_height);
      //If we are not at the middle row, we must have found the map
      if y<16*map_char_height then
      begin
       //So point the origin towards it
       inc(originx,x);
       inc(originy,y-1);
       //Reduce the map size accordingly
       grab_width:=32-(x div map_char_width)*2;
       grab_height:=32-(y div map_char_height)*2;
      end;
      inc(direction);
     until (ValidateSize(grab_width) and ValidateSize(grab_height))
        or (direction=4);
    end;
    //Are we in a Repton 2 game window? If it is smaller than 32 high, there will
    //be a thin line of orange above the map. Similarly, if it is smaller than
    //32 wide, there will be a vertical orange line to the left.
    //First we check for any non-black pixels
    if game then
    begin
     //We will make two passes.
     z:=0;
     //We need to remember the y
     starty:=0;
     repeat
      //First pass checks for the height
      //Second pass checks for the width
      y:=0;
      x:=0;
      repeat
       //Move across or down, depending on the pass
       if z=0 then inc(y);
       if z=1 then inc(x);
       //Get the pointer into the raw data
       ptr:=GetPTR(originx+Cardinal(x),originy+Cardinal(y)+1);
       //In order to get the pixel colour
       pass:=GetRGB(buffer[ptr],buffer);
       //First pass: check it hasn't gone past the half way point down
       if z=0 then
        if y>=16*map_char_height then
        begin
         //If it does, move back to the top and move across a character
         inc(x,map_char_width);
         y:=0;
        end;
       //Second pass: check it hasn't gone past the half way point across
       if z=1 then
        if x>=16*map_char_width then
        begin
         //If it does, move back to the left and move down a character
         inc(y,map_char_height);
         x:=0;
        end;
       //And carry on until we reach the middle, or we find a non-black pixel
      until (y>=16*map_char_height)
         or (x>=16*map_char_width)
         or (Round((Diff(pass,$000000)/$100)*100)<pix_match);
      //Check for a line of orange pixels
      //Line has to be, at least, 24*map_char_width pixels long or
      //24*map_char_height pixels high. Otherwise, this can fail on some levels
      //which are actually 32x32
      if ((z=0) and (y<16*map_char_height))
      or ((z=1) and (x<16*map_char_width)) then
      begin
       d:=0; //Counter for number of orange pixels
       len:=24*map_char_width;
       if z=1 then len:=24*map_char_height;
       for c:=0 to len-1 do
       begin
        //Get the pointer into the raw data
        if z=0 then
         ptr:=GetPTR(originx+Cardinal(x)+Cardinal(c),originy+Cardinal(y)+1)
        else
         ptr:=GetPTR(originx+Cardinal(x),originy+Cardinal(y)+Cardinal(c));
        //In order to get the pixel colour
        pass:=GetRGB(buffer[ptr],buffer);
        //Check the pixel is orange
        prob:=Round((Diff(pass,$0080FF)/$100)*100);
        if prob>=pix_match then inc(d);
       end;
       //Is there a thin line of the length we want?
       if d<Integer(len) then
        //No, so reset the x or y to bigger than is allowed
        if z=0 then y:=24*map_char_height else x:=24*map_char_width;
       //First pass, save y as this gets corrupted
       if z=0 then starty:=y;
      end;
      //Move onto the next pass
      inc(z);
     until z=2;
     //Retrieve y
     y:=starty;
     //Have the lines been found?
     if (y<16*map_char_height) or (x<16*map_char_width) then
     begin
      //Work out the grab size and move the origin down and across
      grab_width:=32-(x div map_char_width)*2;
      //Check if the width/height is a valid size first
      if not ValidateSize(grab_width) then grab_width:=32;
      //If the grab width/height is 32, originx/y won't change
      inc(originx,((32-grab_width)*map_char_width)div 2);
      //As above, but for height
      grab_height:=32-((y+4) div map_char_height)*2;
      if not ValidateSize(grab_height) then grab_height:=32;
      inc(originy,((32-grab_height)*map_char_height)div 2);
     end;
    end;
    //Set/Reset the OK flag
    sizeOK:=ValidateSize(grab_width) and ValidateSize(grab_height);
    //As we are in an editor or game, there will be a map so use the max size
    //of 32x32 and the detected map area
    if not sizeOK then
    begin
     grab_width :=32;
     grab_height:=32;
     originx    :=mapareax;
     originy    :=mapareay;
     sizeOK     :=True;
    end;
   end;
   if sizeOK then
   begin
    //If the size is smaller than a Repton 1 game screen, automatically change
    //to Repton 2
    if (grab_width<32) or (grab_height<32) then
    begin
     newgame:=1;
     gamechange:=True;
    end;
    //Determine the main colour ------------------------------------------------
    //Work out main colour - we do this using the 'closest colour' method.
    //First, set up the counting array
    SetLength(colour,Length(map_rgbs));
    //And empty it
    for x:=0 to Length(map_rgbs)-1 do colour[x]:=0;
    //This is used to work out the percentage of colour in the grab
    total_pix:=grab_height*map_char_height*grab_width*map_char_width;
    //Copy the known colours and add some extras
    SetLength(colours,Length(map_rgbs)+4);
    for x:=0 to Length(map_rgbs)-1 do colours[x]:=map_rgbs[x];
    //We're adding some colours to ignore which could otherwise skew the results
    x:=Length(map_rgbs);
    colours[x  ]:=$000000; //Black
    colours[x+1]:=$00CCCC; //Yellow
    colours[x+2]:=$FFFFFF; //White
    colours[x+3]:=$777777; //Grey
    //***** Debug section ******************************************************
    //Creates a separate image with the closest colours
    if debugapp then //Set this flag to true at the top of the unit
    begin
     if debug<>nil then debug.Free;
     debug:=TImage.Create(img_ScreenGrab.Owner);
     debug.Parent:=img_ScreenGrab.Parent;
     debug.Width:=img_ScreenGrab.Width;
     debug.Height:=img_ScreenGrab.Height;
     debug.Top:=0;
     debug.Left:=img_ScreenGrab.Width;
    end;
    //Note that this debug will slow down the application
    //***** Debug section ******************************************************
    //Now iterate through the entire map
    for y:=0 to (grab_height*map_char_height)-1 do
     for x:=0 to (grab_width*map_char_width)-1 do
     begin
      //Pointer to the pixel at x,y (offset from originx,originy)
      ptr:=GetPTR(originx+Cardinal(x),originy+Cardinal(y));
      //Get the colour of the pixel
      pass:=GetRGB(buffer[ptr],buffer);
      //Set up some markers
      Ci:=0; //Closest match
      c:=-1; //So far, closest colour
      for z:=0 to Length(colours)-1 do
      begin
       Di:=$100-Diff(pass,colours[z]);
       //Is it a closer match than what we have found (if we have found one)?
       if (Di<Ci) or (c=-1) then
       begin
        //So, take note
        Ci:=Di;
        c:=z;
       end;
      end;
      //Increase the count for colour found, unless it is black
      if c<Length(colour) then inc(colour[c])
      //If it was black or white, then decrease the total number of pixels taken
      //account of
      else dec(total_pix);
      //***** Debug section ****************************************************
      if debugapp then
       if c<Length(colour) then debug.Canvas.Pixels[x,y]:=colours[c]
                           else debug.Canvas.Pixels[x,y]:=$000000;
      //***** Debug section ****************************************************
     end;
    //Now to find the one that occurs the most
    big:=0;
    map_colour:=0;
    for z:=0 to Length(map_rgbs)-1 do
    begin
     if total_pix>0 then
      cb_map_colour.Items[z]:=map_colours[z]+': '
                             +IntToStr(Round((colour[z]/total_pix)*100))+'%';
     if colour[z]>big then
     begin
      big:=colour[z];
      map_colour:=z;
     end;
    end;
    //Count the number of diamonds in each colour
    //This will give another indication on which colour to use
    {}
    //Update the right hand detail panel ---------------------------------------
    //Change the game selector, only if required and is not a reload
    if (gamechange) and (canchange) then cb_game.ItemIndex:=newgame;
    //Ensure that, if it is Repton 1 screen, that the size is correct
    if (cb_game.ItemIndex=0) and (grab_width<>32) and (grab_height<>32) then
     sizeOK:=False;
    //Now set the drop down list
    cb_map_colour.ItemIndex:=map_colour;
    //Extract the appropriate characters
    ExtractCharsFromResource(cb_map_colour.ItemIndex,True);
   end;
  end;
  //Display the filename
  if filename<>'' then
   lb_filename.Caption:=ExtractFileName(filename)
  else
   lb_filename.Caption:='<clipboard>';
  if not sizeOK then
  begin
   //Default origin and grab size
   originx    :=0;
   originy    :=0;
   grab_width :=32;
   grab_height:=32;
  end;
  //Store the detected origin and grab size
  det_originx    :=originx;
  det_originy    :=originy;
  det_grab_width :=grab_width;
  det_grab_height:=grab_height;
  //And update the labels
  UpdateLabels;
  sb_DecodeStart.Enabled:={(sizeOK)
                      and} (fullsize_loaded)
                      AND (screengrab_loaded);
  sb_SaveScreenGrab.Enabled:=(screengrab_loaded)
                         and (lb_filename.Caption='<clipboard>');
  MainArea.ActivePageIndex:=0;
 end;
end;

{-------------------------------------------------------------------------------
Update the labels
-------------------------------------------------------------------------------}
procedure TMainForm.UpdateLabels;
begin
 //Map size label
 lb_MapSize.Caption:=IntToStr(grab_width)+'x'+IntToStr(grab_height);
 //Origin label
 lb_Origin.Caption :=IntToStr(originx)   +','+IntToStr(originy);
 //Map area label
 lb_maparea.Caption:=IntToStr(mapareax)  +','+IntToStr(mapareay);
end;

{-------------------------------------------------------------------------------
User has clicked on the bounding box
-------------------------------------------------------------------------------}
procedure TMainForm.mapboundboxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 //Set the flag to indicate resize/moving is happening
 boundboxmove:=True;
 //Starting position
 bboxX:=X;
 bboxY:=Y;
end;

{-------------------------------------------------------------------------------
User is moving the mouse over the bounding box
-------------------------------------------------------------------------------}
procedure TMainForm.mapboundboxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 neworiginx,
 neworiginy,
 newsizex,
 newsizey,
 newgrabw,
 newgrabh    : Integer;
const
 //Number of pixels of edge to determine if user is resizing or moving
 boundary=6; //The smaller the number, the more sensitive
begin
 if not boundboxmove then //User is not holding down a mouse button
 begin
  //Change the mouse cursor
  //The cursor for most of the box will be a 'move' cursor
  mapboundbox.Cursor:=crSizeAll;
  //If near the edges, use the edge sizing cursor
  if (X<boundary) or (X>mapboundbox.Width-boundary)  then 
   mapboundbox.Cursor:=crSizeWE;  //Left or Right edge
  if (Y<boundary) or (Y>mapboundbox.Height-boundary) then 
   mapboundbox.Cursor:=crSizeNS;  //Top or Bottom edge
  //Or the corner sizing cursor
  if ((X<boundary) and (Y<boundary))                      
  or ((X>mapboundbox.Width-boundary) and (Y>mapboundbox.Height-boundary)) then
   mapboundbox.Cursor:=crSizeNWSE;//Top Left or Bottom Right corner
  if ((X<boundary) and (Y>mapboundbox.Height-boundary))   
  or ((X>mapboundbox.Width-boundary) and (Y<boundary)) then
   mapboundbox.Cursor:=crSizeNESW;//Top Right or Bottom Left corner
  //Setup the flag to indicate where the cursor is
  boundboxedit:=0;  //Default - Move
  if X<boundary then                                
   boundboxedit:=1; //Left edge
  if X>mapboundbox.Width-boundary then              
   boundboxedit:=2; //Right edge
  if Y<boundary then                                
   boundboxedit:=3; //Top edge
  if Y>mapboundbox.Height-boundary then             
   boundboxedit:=4; //Bottom edge
  if (X<boundary) and (Y<boundary) then             
   boundboxedit:=5; //Top Left corner
  if (X>mapboundbox.Width-boundary)
  and (Y>mapboundbox.Height-boundary) then          
   boundboxedit:=6; //Bottom Right corner
  if (X<boundary) and (Y>mapboundbox.Height-boundary) then 
   boundboxedit:=7; //Bottom Left corner                                
  if (X>mapboundbox.Width-boundary) and (Y<boundary) then  
   boundboxedit:=8; //Top Right corner
 end;
 if boundboxmove then     //User is holding down a mouse button
 begin
  //First save the current position - these are used for range checking later on
  neworiginx:=mapboundbox.Left;
  neworiginy:=mapboundbox.Top;
  newsizex  :=mapboundbox.Width;
  newsizey  :=mapboundbox.Height;
  //Move control
  if boundboxedit=0 then
  begin
   //Move horizontally
   neworiginx:=mapboundbox.Left+(X-bboxX);
   //Move vertically
   neworiginy:=mapboundbox.Top +(Y-bboxY);
  end;
  if (boundboxedit>0) and (cb_game.ItemIndex=1) then
  begin
   //Resize control (this moves both edges)
   //First, limit the movement to char sizes
   X:=(X div (map_char_width*4)) *(map_char_width*4);
   Y:=(Y div (map_char_height*4))*(map_char_height*4);
   //Left edge
   if (boundboxedit=1) or (boundboxedit=5) or (boundboxedit=7) then
   begin
    newgrabw:=(mapboundbox.Width-(X*2)) div map_char_width;
    if (newgrabw<=32) and (newgrabw>=8) then
    begin
     neworiginx:=mapboundbox.Left+X;
     newsizex  :=newgrabw*map_char_width;
    end;
   end;
   //Right edge
   if (boundboxedit=2) or (boundboxedit=6) or (boundboxedit=8) then
   begin
    newgrabw:=(mapboundbox.Width-((mapboundbox.Width-X)*2)) div map_char_width;
    if (newgrabw<=32) and (newgrabw>=8) then
    begin
     neworiginx:=mapboundbox.Left+(mapboundbox.Width-X);
     newsizex  :=newgrabw*map_char_width;
    end;
   end;
   //Top edge
   if (boundboxedit=3) or (boundboxedit=5) or (boundboxedit=8) then
   begin
    newgrabh:=(mapboundbox.Height-(Y*2)) div map_char_height;
    if (newgrabh<=32) and (newgrabh>=8) then
    begin
     neworiginy:=mapboundbox.Top+Y;
     newsizey  :=newgrabh*map_char_height;
    end;
   end;
   //Bottom edge
   if (boundboxedit=4) or (boundboxedit=6) or (boundboxedit=7) then
   begin
    newgrabh:=(mapboundbox.Height-((mapboundbox.Height-Y)*2))div map_char_height;
    if (newgrabh<=32) and (newgrabh>=8) then
    begin
     neworiginy:=mapboundbox.Top+(mapboundbox.Height-Y);
     newsizey  :=newgrabh*map_char_height;
    end;
   end;
  end;
  //Update the bounding box, ensuring it is not beyond the size of the grab
  if (neworiginx>=0) and (neworiginx+newsizex<=img_ScreenGrab.Width) then
   mapboundbox.Left  :=neworiginx;
  if (neworiginy>=0) and (neworiginy+newsizey<=img_ScreenGrab.Height) then
   mapboundbox.Top   :=neworiginy;
  if neworiginx+newsizex<=img_ScreenGrab.Width then 
   mapboundbox.Width :=newsizex;
  if neworiginy+newsizey<=img_ScreenGrab.Height then
   mapboundbox.Height:=newsizey;
  //Update the origin and grab size
  originx    :=mapboundbox.Left;
  originy    :=mapboundbox.Top;
  grab_width :=mapboundbox.Width  div map_char_width;
  grab_height:=mapboundbox.Height div map_char_height;
  UpdateLabels;
 end;
end;

{-------------------------------------------------------------------------------
User has released mouse click on the bounding box
-------------------------------------------------------------------------------}
procedure TMainForm.mapboundboxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 //Reset the flag
 boundboxmove:=False;
end;

{-------------------------------------------------------------------------------
Show the Save Map dialogue box, and save the image
-------------------------------------------------------------------------------}
procedure TMainForm.sb_SaveMapClick(Sender: TObject);
begin
 //Setup a default filename
 SaveDialog1.FileName:=Copy(ExtractFileName(img_filename),1,
    Length(ExtractFileName(img_filename))-Length(ExtractFileExt(img_filename)))
    +' Decode'+ExtractFileExt(img_filename);
 //Do the saving
 InitiateSave(SaveDialog1);
end;

{-------------------------------------------------------------------------------
Saves a screen grab to disc
-------------------------------------------------------------------------------}
procedure TMainForm.sb_SaveScreenGrabClick(Sender: TObject);
begin
 InitiateSave(SaveScreenGrabDialog);
end;

{-------------------------------------------------------------------------------
Initiates a save
-------------------------------------------------------------------------------}
procedure TMainForm.InitiateSave(dialog: TSaveDialog);
var
 bmp,png,gif,jpg,csv: Boolean;
 img: TImage;
begin
 if dialog.Execute then
 begin
  bmp:=ExtractFileExt(dialog.FileName)='.bmp';
  png:=ExtractFileExt(dialog.FileName)='.png';
  gif:=ExtractFileExt(dialog.FileName)='.gif';
  jpg:=ExtractFileExt(dialog.FileName)='.jpeg';
  csv:=ExtractFileExt(dialog.FileName)='.csv';
  if dialog=SaveDialog1 then img:=img_Map
                         else img:=img_ScreenGrab;
  SaveMap(img,dialog.FileName,bmp,png,gif,jpg,csv,True);
 end;
end;

{-------------------------------------------------------------------------------
Removes the extension from a filename
-------------------------------------------------------------------------------}
function TMainForm.RemoveExt(filename: String): String;
var
 ext: String;
begin
 ext:=ExtractFileExt(filename);
 Result:=Copy(filename,1,Length(filename)-Length(ext));
end;

{-------------------------------------------------------------------------------
Saves the full size map to clipboard
-------------------------------------------------------------------------------}
procedure TMainForm.SaveToClipboard(Sender: TObject);
begin
 if sb_SaveMap.Enabled then
  SaveMap(img_Map,'',false,false,false,false,false,false);
end;

{-------------------------------------------------------------------------------
Saves the map in the specified format(s)
-------------------------------------------------------------------------------}
procedure TMainForm.SaveMap(img: TImage; filename: String; bmp,png,gif,jpg,csv,
  confirmoverwrite: Boolean);
var
 pngimg  : TPNGImage;
 gifimg  : TGIFImage;
 jpegimg : TJPEGImage;
 MyFormat: Word;
 AData   : THandle;
 APalette: HPALETTE;
 x,y,C   : Integer;
 L       : String;
const
 confirm = ' already exists. Overwrite?';
begin
 if filename<>'' then //Save to file
 begin
  SwitchProgress(True);
  //Remove any extension
  filename:=RemoveExt(filename);
  //Confirm any overwrites
  if confirmoverwrite then
  begin
   if bmp then
    if FileExists(filename+'.bmp') then
     bmp:=MessageDlg('"'+filename+'.bmp"'+confirm,mtConfirmation,
                   [mbYes,mbNo],0,mbNo)=mrYes;
   if png then
    if FileExists(filename+'.png') then
     png:=MessageDlg('"'+filename+'.png"'+confirm,mtConfirmation,
                   [mbYes,mbNo],0,mbNo)=mrYes;
   if gif then
    if FileExists(filename+'.gif') then
     gif:=MessageDlg('"'+filename+'.gif"'+confirm,mtConfirmation,
                   [mbYes,mbNo],0,mbNo)=mrYes;
   if jpg then
    if FileExists(filename+'.jpeg') then
     jpg:=MessageDlg('"'+filename+'.jpeg"'+confirm,mtConfirmation,
                   [mbYes,mbNo],0,mbNo)=mrYes;
   if csv then
    if FileExists(filename+'.csv') then
     csv:=MessageDlg('"'+filename+'.csv"'+confirm,mtConfirmation,
                   [mbYes,mbNo],0,mbNo)=mrYes;
  end;
  //Do the saving
  if bmp then img.Picture.Bitmap.SaveToFile(filename+'.bmp');
  ProgressBar1.Progress:=20;
  if png then
  begin
   pngimg:=TPNGImage.Create;
   pngimg.Assign(img.Picture.Bitmap);
   pngimg.SaveToFile(filename+'.png');
   pngimg.Free;
  end;
  ProgressBar1.Progress:=40;
  if gif then
  begin
   gifimg:=TGIFImage.Create;
   gifimg.Assign(img.Picture.Bitmap);
   gifimg.SaveToFile(filename+'.gif');
   gifimg.Free;
  end;
  ProgressBar1.Progress:=60;
  if jpg then
  begin
   jpegimg:=TJPEGImage.Create;
   jpegimg.CompressionQuality:=100;
   jpegimg.Assign(img.Picture.Bitmap);
   jpegimg.SaveToFile(filename+'.jpeg');
   jpegimg.Free;
  end;
  ProgressBar1.Progress:=80;
  if csv then
  begin
   map_text.Clear;
   //Remove the colour counter from the string
   L:=cb_map_colour.Items[cb_map_colour.ItemIndex];
   C:=pos(': ',L)-1;
   if C>0 then
    L:=copy(L,1,C);
   //before adding it to the CSV
   map_text.Lines.Add(L);
   for y:=0 to grab_height-1 do
   begin
    L:='';
    for x:=0 to grab_width-1 do
    begin
     if map[x,y]>=0 then
     begin
     C:=0;
      case OptionsForm.rg_CharRef.ItemIndex of
       0: C:=map[x,y];
       1: C:=repchars[cb_game.ItemIndex,map[x,y]];
      end;
      L:=L+IntToStr(C);
     end
     else
      L:=L+'unk';
     if x<grab_width-1 then L:=L+',';
    end;
    map_text.Lines.Add(L);
   end;
   map_text.Lines.SaveToFile(filename+'.csv');
{   map_text.Clear;
   for y:=0 to grab_height-1 do
   begin
    L:='';
    for x:=0 to grab_width-1 do
    begin
     L:=L+IntToStr(map_prob[x,y]);
     if x<grab_width-1 then L:=L+',';
    end;
    map_text.Lines.Add(L);
   end;
   map_text.Lines.SaveToFile(filename+'_probability.csv');}
  end;
  SwitchProgress(False);
 end;
 if filename='' then //Save to clipboard
 begin
  img.Picture.Bitmap.SaveToClipboardFormat(MyFormat,AData,APalette);
  Clipboard.SetAsHandle(MyFormat,AData);
 end;
end;

{-------------------------------------------------------------------------------
Splits an Atlas into the component characters
-------------------------------------------------------------------------------}
procedure TMainForm.Extract(sx,sy,chars,chrsacross,w,h,bpp: Integer;parent: TObject;
  var char: array of TImage; var Atlas: TImage);
var
 ch   : Integer;
 dest,
 src  : TRect;
begin
 //Setup the destination rectangle
 dest.Top   :=0;
 dest.Left  :=0;
 dest.Bottom:=h;
 dest.Right :=w;
 //Extract the characters
 for ch:=0 to chars-1 do
 begin
  //Position of the character within the atlas
  src.Left  :=sx+(ch mod chrsacross)*w;
  src.Top   :=sy+(ch div chrsacross)*h;
  src.Width :=w;
  src.Height:=h;
  //Create the character container
  if char[ch]=nil then
  begin
   char[ch]:=TImage.Create(parent as TComponent);
   char[ch].Parent:=parent as TWinControl;
  end;
  //Change bpp
//  case bpp of
//   16:char[ch].Picture.Bitmap.PixelFormat:=pf16bit;
//   32:char[ch].Picture.Bitmap.PixelFormat:=pf32bit;
//  else
//   char[ch].Picture.Bitmap.PixelFormat:=pf8bit; //8bpp by default
//  end;}
  //Position it in the form
  char[ch].Top   :=0;//(ch div 5)*h;
  char[ch].Left  :=(ch*w);//(ch mod 5)*w;
  char[ch].Width :=w;
  char[ch].Height:=h;
  char[ch].Tag   :=ch;
  //Extract that part from the main atlas
  char[ch].Canvas.CopyRect(dest,Atlas.Canvas,src);
  //Change bpp
  case bpp of
//   16:char[ch].Picture.Bitmap.PixelFormat:=pf16bit;
   16,32:char[ch].Picture.Bitmap.PixelFormat:=pf32bit;
  else
   char[ch].Picture.Bitmap.PixelFormat:=pf8bit; //8bpp by default
  end;
  //Show it
  char[ch].Visible:=True;
 end;
end;

{-------------------------------------------------------------------------------
Extract the application version number from the executable
-------------------------------------------------------------------------------}
function TMainForm.AppVersion: String;
var
 sFileName   : String;
 iBufferSize,
 iDummy      : DWORD;
 pBuffer,
 pFileInfo   : Pointer;
 iVer        : array[1..4] of Word;
begin
 Result:='';
 SetLength(sFileName,MAX_PATH+1);
 SetLength(sFileName,GetModuleFileName(hInstance,PChar(sFileName),MAX_PATH+1));
 iBufferSize:=GetFileVersionInfoSize(PChar(sFileName),iDummy);
 if (iBufferSize>0) then
 begin
  GetMem(pBuffer,iBufferSize);
  try
   GetFileVersionInfo(PChar(sFileName),0,iBufferSize,pBuffer);
   VerQueryValue(pBuffer,'\',pFileInfo,iDummy);
   iVer[1]:=HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS); {Major}
   iVer[2]:=LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS); {Minor}
   iVer[3]:=HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS); {Release}
   iVer[4]:=LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS); {Build}
  finally
   FreeMem(pBuffer);
  end;
  Result:=Format('%d.%.2d',[iVer[1],iVer[2]]{,iVer[3],iVer[4]]});
  {$IFDEF WIN32}
  Result:=Result+'-x86';
  {$ENDIF}
  {$IFDEF WIN64}
  Result:=Result+'-x64';
  {$ENDIF}
  {$IFDEF MACOS}
  Result:=Result+'-OSX';
  {$ENDIF}
 end;
end;

{-------------------------------------------------------------------------------
Tests to see if file 'filename' is a known image format
-------------------------------------------------------------------------------}
function TMainForm.IsAnImage(filename: String):Boolean;
var
 size,j    : Integer;
 pngfound,
 bmpfound,
 giffound  : Boolean;
 buffer    : array[0..$F] of Byte;
 F         : TFileStream;
 const
  pngsig: array[0..$F] of Byte=($89,$50,$4E,$47
                               ,$0D,$0A,$1A,$0A
                               ,$00,$00,$00,$0D
                               ,$49,$48,$44,$52);
begin
 //We need to know the size of the file
 size:=0;
 //Clear the buffer
 for j:=0 to 15 do buffer[j]:=0;
 if FileExists(filename) then
 begin
  //Load the file - if file is already open, it will error
  try
   F:=TFileStream.Create(filename,fmOpenRead);
   size:=F.Size;
   F.Position:=0;
   F.Read(buffer[0],16);
   F.Free;
  except
   //Exception
  end;
  //Bitmaps:
  //The first two bytes should be 'BM', and the next four should be the filesize
  //which will match what we got before
  bmpfound:=(buffer[0]=ord('B')) and (buffer[1]=ord('M'))
        and (buffer[2]+buffer[3]*$100+buffer[4]*$10000+buffer[5]*$1000000=size);
  //PNG:
  //First sixteen bytes will be: 89 50 4E 47 0D 0A 1A 0A 00 00 00 0D 49 48 44 52
  pngfound:=True;
  for j:=0 to 15 do
   if buffer[j]<>pngsig[j] then pngfound:=False;
  //GIF:
  //Starts 'GIF87a' or 'GIF89a'
  giffound:=(buffer[0]=ord('G'))and(buffer[1]=ord('I'))and(buffer[2]=ord('F'))
         and(buffer[3]=ord('8'))and(buffer[5]=ord('a'))
         and((buffer[4]=ord('7'))or(buffer[4]=ord('9')));
  Result:=(bmpfound or pngfound or giffound) and FileExists(filename);
 end else Result:=False;
end;

{-------------------------------------------------------------------------------
User clicked on RRP logo, so load the webpage
-------------------------------------------------------------------------------}
procedure TMainForm.Image1Click(Sender: TObject);
begin
 ShellExecute(Application.Handle,PChar('open'),PChar('http://www.reptonresourcepage.co.uk'),PChar(0),nil,SW_NORMAL);
end;

{-------------------------------------------------------------------------------
Mouse click event over High Res Map
-------------------------------------------------------------------------------}
procedure TMainForm.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 zoomfactor: Real;
begin
 if Sender is TImage then
  //Is the Left Mouse button being held down
  if ssLeft in Shift then
  begin
   //CTRL is held down, so place a character
   if ssCtrl in Shift then
   begin
    //Work out the zoom factor, as a fraction
    zoomfactor:=TImage(Sender).Width/TImage(Sender).Picture.Width;
    //And recalculate the X,Y co-ordinates to compensate
    X:=Round(X/zoomfactor);
    Y:=Round(Y/zoomfactor);
    //Work out the character position
    charX:=(X-Integer(originx)) div full_chr_width;
    charY:=(Y-Integer(originy)) div full_chr_height;
    //Place the character
    charcursorMouseDown(Sender,Button,Shift,X,Y);
   end;
   //CTRL is not held down, so pan the image
   if not (ssCtrl in Shift) then
   begin
    Image_SX:=X;
    Image_SY:=Y;
   end;
  end;
end;

{-------------------------------------------------------------------------------
Mouse move event over High Res Map
-------------------------------------------------------------------------------}
procedure TMainForm.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 NX: Integer;
 NY: Integer;
begin
 if Sender is TImage then
 begin
  //Is CTRL held down. If so, change the cursor as we are placing a character
  if ssCtrl in Shift then
  begin
   TImage(Sender).Cursor:=crDefault;
   //We also need to put a red box over the map
  end
  else
   //Otherwise, make sure that the cursor is a hand, as we are panning
   TImage(Sender).Cursor:=crHandFlat;
  //Is the left mouse button held down
  if ssLeft in Shift then
  begin
   //The CTRL key is not held down, so pan (and remove any cursor)
   if not (ssCtrl in Shift) then
   begin
    NX:=(-sb_Map.HorzScrollBar.Position)+X-Image_SX;
    NY:=(-sb_Map.VertScrollBar.Position)+Y-Image_SY;
    if (NX<0) and (NX>Image_LX) then
     sb_Map.HorzScrollBar.Position:=-NX;
    if (NY<0) and (NY>Image_LY) then
     sb_Map.VertScrollBar.Position:=-NY;
   end;
  end;
 end;
end;

{-------------------------------------------------------------------------------
User is selecting a character from the selector box
-------------------------------------------------------------------------------}
procedure TMainForm.CharSelectorClick(Sender: TObject);
begin
 if Sender is TImage then
  if sb_SaveMap.Enabled then
  begin
   charselect.Top:=TImage(Sender).Top;
   charselect.Left:=TImage(Sender).Left;
   charselect.BringToFront;
   selectedchar:=TImage(Sender).Tag;
  end;
end;

{-------------------------------------------------------------------------------
Mouse is leaving the screen grab image, so remove the cursor
-------------------------------------------------------------------------------}
procedure TMainForm.img_ScreenGrabMouseLeave(Sender: TObject);
begin
 charstorage.Picture:=nil;
 charcursor.Visible:=False;
end;

{-------------------------------------------------------------------------------
Mouse is moving across the screen grab image, so move the cursor
-------------------------------------------------------------------------------}
procedure TMainForm.img_ScreenGrabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
 source,dest: TRect;
 zoomfactor: Real;
begin
 if sb_SaveMap.Enabled then
 begin
  //Work out the zoom factor, as a fraction
  zoomfactor:=img_ScreenGrab.Width/img_ScreenGrab.Picture.Width;
  //And recalculate the X,Y co-ordinates to compensate
  X:=Round(X/zoomfactor);
  Y:=Round(Y/zoomfactor);
  //Work out the character position
  charX:=(X-Integer(originx)) div map_char_width;
  charY:=(Y-Integer(originy)) div map_char_height;
  if  (charX<grab_Width) and (charY<grab_Height)
  and (charX>=0) and (charY>=0) then
  begin
   //Set up the source rectangle
   source.Left:=(charX*map_char_width)+Integer(originx);
   source.Top:=(charY*map_char_height)+Integer(originy);
   source.Width:=map_char_width;
   source.Height:=map_char_height;
   //Set up the destination rectangle
   dest.Left:=0;
   dest.Top:=0;
   dest.Width:=char_sel_width;
   dest.Height:=char_sel_height;
   //The co-ordinates need to have the zoomfactor removed, and then have the
   //scrollbar position taken into account
   charcursor.Top:=Round((source.Top*zoomfactor)-sb_ScreenGrab.VertScrollBar.Position);
   charcursor.Left:=Round((source.Left*zoomfactor)-sb_ScreenGrab.HorzScrollBar.Position);
   charcursor.Width:=Round(source.Width*zoomfactor);
   charcursor.Height:=Round(source.Height*zoomfactor);
   if (X>=charcursor.Left) and (Y>=charcursor.Top) then
   begin
    //Place the 'cursor'
    charcursor.Visible:=True;
    //Copy the character specified into container
    charstorage.Canvas.CopyRect(dest,fullcolourimage.Canvas,source);
   end;
  end
  else
  begin
   charstorage.Picture:=nil;
   charcursor.Visible:=False;
  end;
 end;
end;

{-------------------------------------------------------------------------------
Turn the progress indicator on or off
-------------------------------------------------------------------------------}
procedure TMainForm.SwitchProgress(turnon: Boolean);
begin
 ProgressBar1.Progress:=0;
 ProgressBar1.Visible :=turnon;
 sh_accuracy.Visible:=not ProgressBar1.Visible;
end;

{-------------------------------------------------------------------------------
Reset the application
-------------------------------------------------------------------------------}
procedure TMainForm.ResetFields(colourchange: Boolean);
begin
 if colourchange then
 begin
  //Remove any screengrab
  img_ScreenGrab.Picture   :=nil;
  img_ScreenGrab.Width     :=0;
  img_ScreenGrab.Height    :=0;
  img_ScreenGrab.AutoSize  :=True;
  //Disable the buttons
  sb_DecodeStart.Enabled   :=False;
  sb_SaveScreenGrab.Enabled:=False;
  //And hide the character selector
  charselect.Visible       :=True;
  //reset the fields
  lb_MapSize.Caption       :='';
  lb_Origin.Caption        :='';
  lb_accuracy.Caption      :='';
  sh_accuracy.Brush.Color  :=clBlack;
  cb_map_colour.ItemIndex  :=0;
  ExtractCharsFromResource(cb_map_colour.ItemIndex,True);
 end;
 sb_SaveMap.Enabled        :=False;
 MainArea.ActivePageIndex:=0;
 //Remove any decoded map
 img_map.Picture           :=nil;
 img_map.Width             :=0;
 img_map.Height            :=0;
end;

{-------------------------------------------------------------------------------
Update the registry
-------------------------------------------------------------------------------}
procedure TMainForm.SetRegistry;
var
 flags: Cardinal;
begin
 flags:=$00;
 flags:=flags OR SetBit(0,BulkConvForm.cb_SaveBMP.Checked);
 flags:=flags OR SetBit(1,BulkConvForm.cb_SaveGIF.Checked);
 flags:=flags OR SetBit(2,BulkConvForm.cb_SavePNG.Checked);
 flags:=flags OR SetBit(3,BulkConvForm.cb_SaveJPG.Checked);
 flags:=flags OR SetBit(4,BulkConvForm.cb_SaveCSV.Checked);
 flags:=flags OR SetBit(5,puzzpiece);
 SetRegValI('Flags',flags);
end;

{-------------------------------------------------------------------------------
Extract a part of an image to a Byte Array
-------------------------------------------------------------------------------}
procedure TMainForm.ExtractPictureArea(var image: TImage;src: TRect;
  var bmp_map: TByteDynArray);
var
 bitmap: TBitmap;
 ms    : TMemoryStream;
begin
 //Create the containers
 ms:=TMemoryStream.Create;
 bitmap:=TBitmap.Create;
 ExtractPictureArea(image,bitmap,ms,src,bmp_map);
 //Finally free up the containers we created
 ms.Free;
 bitmap.Free;
end;
{This overloaded procedure takes a pre-created TBitmap and TMemoryStream to
increase the speed when used many times over (such as in DecodeScreen)}
procedure TMainForm.ExtractPictureArea(var image: TImage;var bitmap: TBitmap;
  var ms: TMemoryStream;src: TRect; var bmp_map: TByteDynArray);
var
 dest  : TRect;
begin
 //Set the size of the bitmap
 bitmap.Width:=src.Width;
 bitmap.Height:=src.Height;
 //Set the destination rectangle
 dest.Top   :=0;
 dest.Left  :=0;
 dest.Height:=src.Height;
 dest.Width :=src.Width;
 //Then copy the character off the supplied image into our container
 bitmap.Canvas.CopyRect(dest,image.Canvas,src);
 //Set it to 8bpp
 bitmap.PixelFormat:=pf8bit;
 //And copy it into a byte array (i.e. extract the raw bitmap data)
 ms.Clear;
 bitmap.SaveToStream(ms);
 ms.Position:=0;
 if Length(bmp_map)<>ms.Size then SetLength(bmp_map,ms.Size);
 ms.ReadBuffer(bmp_map[0],ms.Size);
end;

end.
