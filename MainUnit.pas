unit MainUnit;

{
Repton Map Decoder 2.00 written by Gerald Holdsworth
Written to fine tune code before inclusion into Repton Map Creator

Copyright ©2018-2025 Gerald Holdsworth gerald@hollypops.co.uk

This source is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public Licence as published by the Free
Software Foundation; either version 3 of the Licence, or (at your option)
any later version.

This code is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public Licence for more
details.

A copy of the GNU General Public Licence is available on the World Wide Web
at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
Boston, MA 02110-1335, USA.
}

{$mode objfpc}{$H+}

interface

uses
 Classes,SysUtils,Forms,Controls,Graphics,Dialogs,ExtCtrls,StdCtrls,Math;

type
 TCoords = record
   X: Cardinal;
   Y: Cardinal;
 end;
 TSize = record
   Width : Integer;
   Height: Integer;
 end;

 { TMainForm }

 TMainForm = class(TForm)
  img_ScreenGrab: TImage;
  imgRepton: TImage;
  DetailsPanel: TPanel;
  Repton1MapChars: TImageList;
  Repton2MapChars: TImageList;
  procedure FormCreate(Sender: TObject);
  procedure FormShow(Sender: TObject);
  procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
  function CreateLabel(Lparent: TObject): TLabel;
  { ---- functions we need in the final application ---- }
  function FindMap(var map: TRect; var mapsize: TSize; var chars: TRect): Byte;
  function FindColour(chars: TRect): Byte;
  procedure DecodeMap(mapsize: TSize);
  function CreateCharPanel(colour: Byte;repton: Byte): TImage;
  function IsAnImage(filename: String):Boolean;
  function GetRGB(x,y: Cardinal; var data: array of Byte): Cardinal;
  function GetRGB(pixel: TCoords; var data: array of Byte): Cardinal; overload;
  function Diff(a,b: Cardinal;retvalue: Boolean=False): Real;
  function CompareBitmaps(var bmp_map: array of Byte; var bigch: Integer): Byte;
 private
  lblGame,
  lblGameTitle,
  lblMapSize,
  lblMapSizeTitle,
  lblColour,
  lblColourTitle  : TLabel; //Detected map details
  memTheMap       : TMemo;  //Text representation of the decoded map
  charpanel,                //Container for the character panel
  themap,                   //Container for the original map
  decodedmap      : TImage; //Container for the decoded map
  maparray        : array of array of Integer;//The decoded map, as numbers
  multiplier      : Byte;   //For grabs that are bigger or smaller than 100%
  atlas           : array of array of Byte;//Raw data for each character
  const
   //Character size of characters on map
   charwidth =16;
   charheight=15;
   //Pixel match threshold
   pixmatch  =90;
   //Character match threshold
   charmatch =88;
   //Repton map colours
   map_colours: array[0..6] of String=('none',
                                       'Blue',
                                       'Cyan',
                                       'Green',
                                       'Magenta',
                                       'Orange',
                                       'Red');
 public
 end;

var
 MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormDropFiles(Sender: TObject;
 const FileNames: array of string);
var
 map    : TRect=();
 mapsize: TSize=();
 chars  : TRect=();
 repton : Byte=0;
 colour : Byte=0;
begin
 //Load the image
 if IsAnImage(FileNames[0]) then
 begin
  //Destroy the character panel and map, if they have been created
  if Assigned(charpanel) then charpanel.Free;
  if Assigned(themap)    then themap.Free;
  if Assigned(memTheMap) then memTheMap.Free;
  charpanel:=nil;
  themap   :=nil;
  memTheMap:=nil;
  //Make the screen grab visible
  img_ScreenGrab.Visible:=True;
  //Load the file
  img_ScreenGrab.Picture.LoadFromFile(FileNames[0]);
  //Find the map and character panel
  repton:=FindMap(map,mapsize,chars);
  //Found something? Then display it
  if repton>0 then
  begin
   //Show the details in the panel
   lblGame.Caption     :='Repton '+IntToStr(repton);
   lblMapSize.Caption  :=IntToStr(mapsize.Width)
                        +'x'
                        +IntToStr(mapsize.Height);
   colour              :=FindColour(chars);
   lblColour.Caption   :=map_colours[colour];
   //Create the character panel graphic - where we will compare our characters from
   charpanel           :=CreateCharPanel(colour,repton);
   charpanel.Top       :=lblColourTitle.Top+lblColourTitle.Height;
   charpanel.Left      :=(DetailsPanel.Width-charpanel.Width)div 2;
   //Create the map graphic
   themap              :=Timage.Create(MainForm);
   themap.Parent       :=MainForm;
   themap.Visible      :=True;
   themap.Width        :=mapsize.Width*charwidth;
   themap.Height       :=mapsize.Height*charheight;
   themap.Left         :=0;
   themap.Top          :=0;//charpanel.Top+charpanel.Height+8;
   //Copy the map across, keeping the same size
   themap.Canvas.CopyRect(Rect(0,0,themap.Width,themap.Height),
                          img_ScreenGrab.Canvas,
                          Rect(map.Left,map.Top,map.Left+map.Width,map.top+map.Height));
   //Create the Memo for the text representation
   memTheMap:=TMemo.Create(MainForm);
   memTheMap.Parent    :=MainForm;
   memTheMap.Visible   :=True;
   memTheMap.Width     :=DetailsPanel.Left-themap.Width-8;
   memTheMap.Height    :=Height;
   memTheMap.Top       :=0;
   memTheMap.ReadOnly  :=True;
   memTheMap.Left      :=themap.Width+4;
   memTheMap.Font.Name :='Courier New';
   memTheMap.Font.Size :=12;
   memTheMap.ScrollBars:=ssAutoBoth;
   memTheMap.Lines.Add('Repton '+IntToStr(repton)+' '
                      +'Size: '+IntToStr(mapsize.Width)
                               +'x'
                               +IntToStr(mapsize.Height)+' '
                      +'Colour: '+map_colours[colour]);
   memTheMap.Lines.Add(StringOfChar('*',mapsize.Width*3));
   memTheMap.Lines.Add('');
   //Hide the screengrab
   img_ScreenGrab.Visible:=False;
   //Decode the map
   DecodeMap(mapsize);
  end
  else//Couldn't detect a suitable map
  begin
   //Leave the screengrab on screen but reset the details
   lblGame.Caption   :='none';
   lblMapSize.Caption:='none';
   lblColour.Caption :='none';
  end;
 end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
 procedure SetUpLabel(L: TLabel);
 begin
  L.AutoSize   :=False;
  L.Width      :=DetailsPanel.Width div 2;
 end;
 procedure SetUpTitleLabel(L: TLabel;C: String);
 begin
  SetUpLabel(L);
  L.Caption    :=C;
  L.Left       :=0;
  L.Alignment  :=taRightJustify;
  L.Font.Style :=[fsBold];
 end;
 procedure SetUpInfoLabel(L: TLabel);
 begin
  SetUpLabel(L);
  L.Left       :=DetailsPanel.Width div 2;
  L.Alignment  :=taLeftJustify;
  L.Font.Style :=[];
 end;
begin
 //Create the game details
 lblGameTitle       :=CreateLabel(DetailsPanel);
 SetUpTitleLabel(lblGameTitle   ,'Game:');
 lblGameTitle.Top   :=imgRepton.Top+imgRepton.Height;
 lblGame            :=CreateLabel(DetailsPanel);
 SetUpInfoLabel(lblGame);
 lblGame.Top        :=lblGameTitle.Top;
 //Create the map size details
 lblMapSizeTitle    :=CreateLabel(DetailsPanel);
 SetUpTitleLabel(lblMapSizeTitle,'Map Size:');
 lblMapSizeTitle.Top:=lblGameTitle.Top+lblGameTitle.Height;
 lblMapSize         :=CreateLabel(DetailsPanel);
 SetUpInfoLabel(lblMapSize);
 lblMapSize.Top     :=lblMapSizeTitle.Top;
 //Create the colour details
 lblColourTitle     :=CreateLabel(DetailsPanel);
 SetUpTitleLabel(lblColourTitle ,'Colour:');
 lblColourTitle.Top :=lblMapSizeTitle.Top+lblMapSizeTitle.Height;
 lblColour          :=CreateLabel(DetailsPanel);
 SetUpInfoLabel(lblColour);
 lblColour.Top      :=lblColourTitle.Top;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin

end;

function TMainForm.CreateLabel(Lparent: TObject): TLabel;
begin
 Result:=TLabel.Create(Lparent as TComponent);
 Result.Parent:=Lparent as TWinControl;
 Result.Visible:=True;
end;

{-------------------------------------------------------------------------------
Find the map and the size, along with the character panel
-------------------------------------------------------------------------------}
function TMainForm.FindMap(var map: TRect; var mapsize: TSize;
                                                        var chars: TRect): Byte;
var
 ms          : TMemoryStream;
 buffer      : array of Byte;
 pass        : Byte=0;
 start       : TCoords=();
 rgb         : Cardinal=0;
 len         : Cardinal=0;
 game        : Boolean=False;
 editor      : Boolean=False;
 x           : Cardinal=0;
 y           : Cardinal=0;
 grab        : TSize=();
 origin      : TCoords=();
begin
 Result:=0;
 //Remove any character selector
 for y:=0 to img_ScreenGrab.Height-1 do
  for x:=0 to img_ScreenGrab.Width-1 do
   if Diff($BD6B2E,img_ScreenGrab.Canvas.Pixels[x,y])>=pixmatch then
    img_ScreenGrab.Canvas.Pixels[x,y]:=$000000;
 //Save to our buffer
 ms:=TMemoryStream.Create;
 ms.Position:=0;
 //First copy into the memory stream
 img_ScreenGrab.Picture.Bitmap.SaveToStream(ms);
 ms.Position:=0;
 //And now into the buffer
 SetLength(buffer,ms.Size);
 ms.ReadBuffer(buffer[0],ms.Size);
 ms.Free;
 //We can now interrogate the image directly
 //So, get the size
 grab.width :=buffer[$12]+buffer[$13]<<8+buffer[$14]<<16+buffer[$15]<<24;
 grab.height:=buffer[$16]+buffer[$17]<<8+buffer[$18]<<16+buffer[$19]<<24;
 multiplier :=Round(grab.width/795);
 pass       :=0;
 origin.x   :=0;
 origin.y   :=0;
 repeat
  case pass of
   0:
    begin
     //First pass, look for a string of 204px of R:0;G:0;B:0 (editor window)
     //(Could be a 34 run of R:0;G:120;B:215 in the panel)
     //This is where the character panel appears
     start.x:=549*multiplier;
     start.y:=147*multiplier;
     rgb    :=$000000;
     len    :=204*multiplier; // +/- 4px
     game   :=False;
    end;
   1:
    begin
     //Second pass, Look for a string of 124px of R:204;G:51;B:0
     //game window in either game
     start.x:=514*multiplier;
     start.y:=3*multiplier;
     rgb    :=$0033CC;
     len    :=124*multiplier; // +/- 4px
     editor :=False;
     game   :=True;
    end;
  end;
  if(origin.x=0)and(origin.y=0)then
  begin
   //Where to start looking
   origin:=start;
   repeat
    x:=0;//counter for number of pixels
    //Begin looking for a pixel
    repeat
     //Across
     inc(origin.x);
     if origin.x>=grab.width then
     begin
      //Then down
      inc(origin.y);
      origin.x:=start.x;
     end;
    until(origin.y>=grab.height)or(Diff(rgb,GetRGB(origin,buffer))>=pixmatch);
    //Black pixel found - is there a string of length?
    if Diff(rgb,GetRGB(origin,buffer))>=pixmatch then
    begin
     inc(x); //counter
     repeat
      inc(origin.x);
      if Diff(rgb,GetRGB(origin,buffer))>=pixmatch then inc(x);
     until(origin.x>=grab.width)or(Diff(rgb,GetRGB(origin,buffer))<pixmatch);
    end;
   until((x>len-4*multiplier)and(x<len+4*multiplier))or(origin.y>=grab.height);
   if(x<=len-4*multiplier)or(x>=len+4*multiplier) then
   begin
    //Did not find the length of pixels required
    origin.x:=0;
    origin.y:=0;
   end;
  end;
  inc(pass);
 until((origin.x>0)and(origin.y>0))or(pass=2);
 //Found something?
 if(origin.x>0)and(origin.y>0)then
 begin
  if(origin.y>240*multiplier)and(origin.y<250*multiplier)then //Repton 1
  begin
   Result        :=1;
   map.Top       :=origin.y-174*multiplier;
   mapsize.Width :=32;
   mapsize.Height:=32;
  end;
  map.Left    :=origin.x-(len-1)-549*multiplier;
  chars.Left  :=origin.x-6*34*multiplier;
  chars.Top   :=origin.y-1;
  if(origin.y>210*multiplier)and(origin.y<220*multiplier)then //Repton 2
  begin
   Result        :=2;
   map.Top       :=origin.y-147*multiplier;
   //Find the background colour of the window (pixel just above the origin)
   rgb:=GetRGB(map.Left,map.Top-1,buffer);
   origin.x:=map.Left+(charwidth *multiplier div 2);
   origin.y:=map.Top +(charheight*multiplier div 2);
   repeat
    if Diff(rgb,GetRGB(origin,buffer))>pixmatch then
    begin
     inc(origin.x,charwidth*multiplier);
     if(origin.x-map.Left)div charheight*multiplier>15 then
     begin
      origin.x:=map.Left+(charwidth*multiplier  div 2);
      inc(origin.y,charheight*multiplier);
     end;
    end;
   until(Diff(rgb,GetRGB(origin,buffer))<pixmatch)
      or((origin.y-map.Top)div charheight*multiplier>15);
   if Diff(rgb,GetRGB(origin,buffer))>=pixmatch then exit; //Failed to find map
   //Map size in characters
   mapsize.Width :=32-((origin.x-map.Left)div charwidth *multiplier)*2;
   mapsize.Height:=32-((origin.y-map.Top )div charheight*multiplier)*2;
  end;
  //Character panel size
  chars.Width :=6*34*multiplier;
  chars.Height:=6*34*multiplier;
  //Map size and location
  map.Left    :=map.Left
               +((32*charwidth *multiplier)
                -(mapsize.Width *charwidth *multiplier))
               div 2;
  map.Top     :=map.Top
               +((32*charheight*multiplier)
                -(mapsize.Height*charheight*multiplier))
               div 2;
  map.Width   :=mapsize.Width *charwidth *multiplier;
  map.Height  :=mapsize.Height*charheight*multiplier;
 end;
end;

{-------------------------------------------------------------------------------
Find the colour of the map
-------------------------------------------------------------------------------}
function TMainForm.FindColour(chars: TRect): Byte;
const
 map_rgbs: array of Cardinal=($000000, //Black/none
                              $FF0000, //Blue
                              $FFFF00, //Cyan
                              $00FF00, //Green
                              $FF00FF, //Magenta
                              $0099FF, //Orange
                              $0000FF);//Red
var
 ms      : TMemoryStream;
 buffer  : array of Byte;
 x       : Cardinal=0;
 y       : Cardinal=0;
 c       : Byte=0;
 R       : Cardinal=0;
 G       : Cardinal=0;
 B       : Cardinal=0;
 O       : Cardinal=0;
 Col     : Cardinal=0;
 Hc      : Cardinal=0;
begin
 Result:=0;
 //Can only detect colour if we have found the panel
 if(chars.Width>0)and(chars.Height>0)then
 begin
  //Save to our buffer
  ms:=TMemoryStream.Create;
  ms.Position:=0;
  //First copy into the memory stream
  img_ScreenGrab.Picture.Bitmap.SaveToStream(ms);
  ms.Position:=0;
  //And now into the buffer
  SetLength(buffer,ms.Size);
  ms.ReadBuffer(buffer[0],ms.Size);
  ms.Free;
  //Reset the colour counts
  //Scan the character panel for the most common colour
{  for }y:=82*multiplier;// to chars.Height-1 do
   for x:=0 to chars.Width-1 do
   begin
    Col:=GetRGB(chars.Left+x,chars.Top+y,buffer);
    if (Col     AND$FF)>=$C0 then inc(R);
    if((Col>> 8)AND$FF)>=$C0 then inc(G)
    else
    if((Col>> 8)AND$FF)>=$60 then inc(O);
    if((Col>>16)AND$FF)>=$C0 then inc(B);
   end;
  //Work out the highest value
  Hc:=0;
  if R>Hc then Hc:=R;
  if G>Hc then Hc:=G;
  if B>Hc then Hc:=B;
  if O>Hc then Hc:=O;
  //Use that to calculate the other two components
  if G>O then
   Col:=Round((R/Hc)*$FF)+Round((G/Hc)*$FF)<<8+Round((B/Hc)*$FF)<<16
  else //Compensates for Orange
   Col:=Round((R/Hc)*$FF)+Round((O/Hc)*$99)<<8+Round((B/Hc)*$FF)<<16;
  //Default return value
  Result:=0;
  //Find the closest colour to what we've worked out
  for c:=Low(map_rgbs)to High(map_rgbs)do
   if Diff(map_rgbs[c],Col)>=pixmatch then Result:=c;
 end;
end;

{-------------------------------------------------------------------------------
Create the char panel from the grab, removing lines
-------------------------------------------------------------------------------}
function TMainForm.CreateCharPanel(colour: Byte;repton: Byte): TImage;
var
 sx  : Integer=0;
 sy  : Integer=0;
 dx  : Integer=0;
 dy  : Integer=0;
 dest: TRect=();
 src : TRect=();
 ms  : TMemoryStream;
 img : TBitmap;
 pnl : TImage;
begin
 Result:=nil;
 //Can only detect colour if we have found the panel
 if colour>0 then
 begin
  //The resulting container
  Result:=Timage.Create(DetailsPanel);
  Result.Parent :=DetailsPanel;
  Result.Visible:=True;
  Result.Width  :=6*charwidth;
  Result.Height :=6*charheight;
  Result.Left   :=0;
  Result.AntialiasingMode:=amOff;
  //This is to contain the selected character atlas
  pnl:=TImage.Create(Self);
  pnl.Width:=256;
  pnl.Height:=45;
  if repton=1 then
  begin
   Repton1MapChars.Draw(pnl.Canvas,0,0,colour-1);
   SetLength(atlas,33);
  end;
  if repton=2 then
  begin
   Repton2MapChars.Draw(pnl.Canvas,0,0,colour-1);
   SetLength(atlas,35);
  end;
  //Use this to copy each character into the atlas
  img:=TBitmap.Create;
  img.Width :=charwidth;
  img.Height:=15;
  ms:=TMemoryStream.Create;
  //Populate it from the screen grab, removing the lines between
  dx:=0;
  dy:=0;
  for sy:=0 to 2 do
   for sx:=0 to 15 do
   begin
    dest.Left  :=dx*charwidth;
    dest.Top   :=dy*charheight;
    dest.Width :=charwidth;
    dest.Height:=charheight;
    src.Left   :=sx*charwidth;
    src.Top    :=sy*charheight;
    src.Width  :=charwidth;
    src.Height :=charheight;
    Result.Canvas.CopyRect(dest,pnl.Canvas,src);
    //Copy the raw data
    if((repton=1)and((dy<5)or((dy=5)and(dx<3))))
    or((repton=2)and((dy<5)or((dy=5)and(dx<5))))then
    begin
     img.Canvas.CopyRect(Rect(0,0,charwidth,charheight),
                         pnl.Canvas,
                         src);
     ms.Position:=0;
     img.SaveToStream(ms);
     ms.Position:=0;
     SetLength(atlas[dy*6+dx],ms.Size);
     ms.ReadBuffer(atlas[dy*6+dx][0],ms.Size);
    end;
    inc(dx);
    if dx=6 then
    begin
     inc(dy);
     dx:=0;
    end;
   end;
  img.Free;
  ms.Free;
  pnl.Free;
 end;
end;

{-------------------------------------------------------------------------------
Decodes the map
-------------------------------------------------------------------------------}
procedure TMainForm.DecodeMap(mapsize: TSize);
var
 x       : Integer=0;
 y       : Integer=0;
 ch      : Integer=-1;
 line    : String='';
 testchar: TBitmap=nil;
 ms      : TMemoryStream=nil;
 bmp     : array of Byte=();
 src     : TRect=();
begin
 if(mapsize.Width>8)or(mapsize.Height>8)then
 begin
  ms      :=TMemoryStream.Create;
  testchar:=TBitmap.Create;
  for y:=0 to mapsize.Height-1 do
  begin
   line:='';
   for x:=0 to mapsize.Width-1 do
   begin
    //Grab a section of the map
    src.Top   :=y*charheight;//*multiplier;
    src.Left  :=x*charwidth;// *multiplier;
    src.Width :=charwidth;// *multiplier;
    src.Height:=charheight;//*multiplier;
    testchar.Width :=src.Width;
    testchar.Height:=src.Height;
    testchar.Canvas.CopyRect(Rect(0,0,charwidth{*multiplier},charheight{*multiplier}),
                             themap.Canvas,
                             src);
    ms.Position:=0;
    testchar.SaveToStream(ms);
    ms.Position:=0;
    SetLength(bmp,ms.Size);
    ms.ReadBuffer(bmp[0],ms.Size);
    CompareBitmaps(bmp,ch);
    if ch>0 then line:=line+RightStr('00'+IntToStr(ch),2)+' ';
    if ch=0 then line:=line+'   ';
    if ch<0 then line:=line+'-- ';
   end;
   memTheMap.Lines.Add(line);
  end;
  ms.Free;
  testchar.Free;
 end;
end;

{-------------------------------------------------------------------------------
Tests to see if file 'filename' is a known image format
-------------------------------------------------------------------------------}
function TMainForm.IsAnImage(filename: String):Boolean;
var
 size      : Integer=0;
 j         : Integer=0;
 pngfound  : Boolean=False;
 bmpfound  : Boolean=False;
 giffound  : Boolean=False;
 buffer    : array[0..$F] of Byte;
 F         : TFileStream;
 const
  //PNG Signature
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
   on E:Exception do ShowMessage('Failed to load image');
  end;
  //Bitmaps:
  //The first two bytes should be 'BM', and the next four should be the filesize
  //which will match what we got before
  bmpfound:=(buffer[0]=ord('B')) and (buffer[1]=ord('M'))
        and (buffer[2]+buffer[3]<<8+buffer[4]<<16+buffer[5]<<24=size);
  //PNG:
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
Get the RGB colour from the palette of the raw bitmap held in 'data'
-------------------------------------------------------------------------------}
function TMainForm.GetRGB(x,y: Cardinal; var data: array of Byte): Cardinal;
var
 c: TCoords;
begin
 c.x:=x;
 c.y:=y;
 Result:=GetRGB(c,data);
end;
function TMainForm.GetRGB(pixel: TCoords; var data: array of Byte): Cardinal;
var
 colour: Byte=0;
 bpp   : Byte=0;
 offset: Cardinal=0;
 size  : TSize=();
begin
 //Get the bits per pixel
 bpp:=(data[$1C]+data[$1D]<<8)>>3;//1=8;2=16;3=24;4=32
 //Size of the bitmap
 size.width :=data[$12]+data[$13]<<8+data[$14]<<16+data[$15]<<24;
 size.height:=data[$16]+data[$17]<<8+data[$18]<<16+data[$19]<<24;
 //Offset to the pixel
 offset:=data[$0A]+data[$0B]<<8+data[$0C]<<16+data[$0D]<<24;//Location of data
 inc(offset,((size.height-pixel.y)*size.width+pixel.x)*bpp);
 //Get the colour
 case bpp of
  //8 bits per pixel (get from the palette table)
  1  : Result:=data[$36+data[offset]*4]<<16//B
              +data[$37+data[offset]*4]<< 8//G
              +data[$38+data[offset]*4];   //R
  //16 bits per pixel
  2  : Result:=(data[offset  ]AND$F0)<<16  //B
              +(data[offset+1]AND$0F)<<12  //G
              +(data[offset+2]AND$F0);     //R
  //24 or 32 bits per pixel
  3,4: Result:=data[offset  ]<<16          //B
              +data[offset+1]<< 8          //G
              +data[offset+2];             //R
 end;
end;

{-------------------------------------------------------------------------------
Work out the difference between RGB colours a and b and assign a score
-------------------------------------------------------------------------------}
function TMainForm.Diff(a,b: Cardinal;retvalue: Boolean=False): Real;
var
 r1,b1,g1,
 r2,b2,g2 : Byte;
begin
 //Split a into R,G and B components
 r1:= a AND $0000FF;
 g1:=(a AND $00FF00)>> 8;
 b1:=(a AND $FF0000)>>16;
 //Split b into R,G and B components
 r2:= b AND $0000FF;
 g2:=(b AND $00FF00)>> 8;
 b2:=(b AND $FF0000)>>16;
 //Use the 'closest colour' calculation to work out how close they are
 Result:=$100-Round(sqrt(Power((r2-r1)*0.299,2)
                        +Power((g2-g1)*0.587,2)
                        +Power((b2-b1)*0.114,2)));
 //(We subtract from $100 so that the higher the number, the more likely it is)
 if not retvalue then Result:=(Result/$100)*100; //As a percentage
end;

{-------------------------------------------------------------------------------
Compare a map bitmap with the character panel, returns probability of match
-------------------------------------------------------------------------------}
function TMainForm.CompareBitmaps(var bmp_map:array of Byte;var bigch:Integer): Byte;
var
 ch       : Integer=0;
 big      : Integer=0;
 x        : Integer=0;
 y        : Integer=0;
 size_map : TSize=();  //Size of the bitmap lifted from the map (under test)
 size_com : TSize=();  //Size of the bitmap lifted from the panel (comparison)
 poff_map : Cardinal=0;//Pixel offset of the bitmap from the map (under test)
 poff_com : Cardinal=0;//Pixel offset of the bitmap from the panel (comparison)
 match    : array of Cardinal=();
begin
 SetLength(match,Length(atlas));
 ch   :=-1;//Current character in the atlas
 big  :=0; //Best match, so far (match score)
 bigch:=-1;//Best match, so far (character ID)
 repeat
  //Go to the next character in the atlas
  inc(ch);
  //Set the match score to zero
  match[ch]:=0;
  //Get the sizes of the bitmaps
  size_map.width :=bmp_map[$12]
                  +bmp_map[$13] << 8
                  +bmp_map[$14] <<16
                  +bmp_map[$15] <<24;
  size_map.height:=bmp_map[$16]
                  +bmp_map[$17] << 8
                  +bmp_map[$18] <<16
                  +bmp_map[$19] <<24;
  size_com.width :=atlas[ch,$12]
                  +atlas[ch,$13]<< 8
                  +atlas[ch,$14]<<16
                  +atlas[ch,$15]<<24;
  size_com.height:=atlas[ch,$16]
                  +atlas[ch,$17]<< 8
                  +atlas[ch,$18]<<16
                  +atlas[ch,$19]<<24;
  if (size_map.Width =size_com.Width)
  and(size_map.Height=size_com.Height)then
  begin
   //Get the pixel offsets
   poff_map      :=bmp_map[$0A]
                  +bmp_map[$0B] << 8
                  +bmp_map[$0C] <<16
                  +bmp_map[$0D] <<24;
   poff_com      :=atlas[ch,$0A]
                  +atlas[ch,$0B]<< 8
                  +atlas[ch,$0C]<<16
                  +atlas[ch,$0D]<<24;
   //Now compare the pixel data
   //The comparison of each pixel will produce a score - the higher the score
   //the greater probability of a match
   for y:=0 to size_map.Height-1 do
    for x:=0 to size_map.Width-1 do
     inc(match[ch],Round(Diff(GetRGB(x,y,atlas[ch])
                             ,GetRGB(x,y,bmp_map)
                             ,True)));
   //Is this a better match than what has been found already?
   if match[ch]>big then
   begin
    //Yes, so take a note
    big  :=match[ch];
    bigch:=ch;
   end;
  end;
  //And continue until we have gone through all characters, or found a
  //perfect match
 until(ch=Length(match)-1)or(big>=charwidth*charheight*$100);
 //This function returns the probability of the most likely match.
 Result:=Round((big/(charwidth*charheight*$100))*100);
 if Result<charmatch then bigch:=-1;
 //Repton 2 has some extra, different styled, characters
 if bigch=33 then bigch:=3; //Egg
 if bigch=34 then bigch:=5; //Key
end;

end.
