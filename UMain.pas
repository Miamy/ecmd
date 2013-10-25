unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UChildProc, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.ImgList, IniFiles, StrUtils;

type
  TFMain = class(TForm)
    pnlTools: TPanel;
    splVert: TSplitter;
    pnlConsole: TPanel;
    memConsole: TMemo;
    ilHideShow: TImageList;
    sbHideLeft: TSpeedButton;
    pnlHistory: TPanel;
    lbHistory: TListBox;
    Splitter1: TSplitter;
    pnlTemplates: TPanel;
    lbTemplates: TListBox;

    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure sbHideLeftClick(Sender: TObject);
    procedure pnlToolsResize(Sender: TObject);
    procedure memConsoleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure memConsoleKeyPress(Sender: TObject; var Key: Char);
    procedure lbTemplatesDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lbHistoryDblClick(Sender: TObject);
  private
    { Private declarations }
    FChildProc: TChildProc;
    FLeftHidden: boolean;
    FIniPath: string;
    FTemplates: TStringList;
    FHistory: TStringList;

    procedure SetLeftHidden(const Value: boolean);
    procedure SetHideLeftButtonPosition;

    procedure WriteInterfaceSettings;
    procedure ReadInterfaceSettings;

    procedure AddToOutput;
    function GetCommand: string;
    function GetCurrentLine: string;
    procedure SetCurrentLine(const Value: string);

    function GetPrompt: string;
    procedure ClearCommand;
    procedure ExecuteCommand(const aCommand: string);

    procedure AddToConsole(aList: TListBox);
    procedure LoadTemplates;

    procedure AddToHistory(const aCommand: string);

    function GetSettingsFileName: string;
    function GetTemplatesFileName: string;

    procedure TemplatesChanged(Sender: TObject);
    procedure HistoryChanged(Sender: TObject);
  public
    { Public declarations }
    property LeftHidden: boolean read FLeftHidden write SetLeftHidden default false;
    property SettingsFileName: string read GetSettingsFileName;
    property TemplatesFileName: string read GetTemplatesFileName;
    property CurrentLine: string read GetCurrentLine write SetCurrentLine;
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

procedure TFMain.AddToConsole(aList: TListBox);
begin
  if aList.ItemIndex = -1 then
    exit;

  ClearCommand;
  CurrentLine := GetPrompt + aList.Items[aList.ItemIndex];
  memConsole.SetFocus;
end;

procedure TFMain.AddToHistory(const aCommand: string);
begin
  if FHistory.IndexOf(aCommand) < 0 then
    FHistory.Add(aCommand);
end;

procedure TFMain.AddToOutput;
var
  Readed: string;
begin
  Readed := FChildProc.ReadStrFromChild(1000);
  if Readed = '' then
    exit;
  memConsole.Lines.Add(Readed);

  memConsole.Text := Trim(memConsole.Text);
  memConsole.SelStart := Length(memConsole.Text);
end;

procedure TFMain.ClearCommand;
begin
  CurrentLine := GetPrompt;
end;

procedure TFMain.ExecuteCommand(const aCommand: string);
begin
  FChildProc.WriteStrToChild(aCommand);
  AddToOutput;
  AddToHistory(aCommand);
end;

procedure TFMain.FormActivate(Sender: TObject);
begin
  memConsole.SetFocus;
end;

procedure TFMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  WriteInterfaceSettings;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  FIniPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Ini\';
  if not DirectoryExists(FIniPath) then
    CreateDir(FIniPath);

  ReadInterfaceSettings;
  LeftHidden := LeftHidden;

  FTemplates := TStringList.Create;
  FTemplates.OnChange := TemplatesChanged;
  LoadTemplates;

  FHistory := TStringList.Create;
  FHistory.OnChange := HistoryChanged;

  FChildProc := TChildProc.Create('cmd.exe', '');
//  FChildProc.WriteStrToChild('chcp 1251');
  AddToOutput;
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  FChildProc.Free;
  FTemplates.Free;
  FHistory.Free;
end;

procedure TFMain.FormResize(Sender: TObject);
begin
  SetHideLeftButtonPosition;
end;

function TFMain.GetCommand: string;
begin
  Result := ReplaceStr(CurrentLine, GetPrompt, '');
end;

function TFMain.GetCurrentLine: string;
var
  CurX, CurY: integer;
begin
  Result := '';
  CurX := memConsole.CaretPos.X;
  CurY := memConsole.CaretPos.Y;
  if CurY < 0 then
    exit;
  Result := memConsole.Lines[CurY];
end;

function TFMain.GetPrompt: string;
var
  PosDelimiter: integer;
begin
  Result := '';
  PosDelimiter := Pos('>', CurrentLine);
  if PosDelimiter = 0 then
    exit;
  Result := Copy(CurrentLine, 1, PosDelimiter);
end;

function TFMain.GetSettingsFileName: string;
begin
  Result := FIniPath + 'Settings.ini';
end;

function TFMain.GetTemplatesFileName: string;
begin
  Result := FIniPath + 'Templates.ini';
end;

procedure TFMain.HistoryChanged(Sender: TObject);
begin
  lbHistory.Items.Assign(FHistory);
end;

procedure TFMain.lbHistoryDblClick(Sender: TObject);
begin
  AddToConsole(lbHistory);
end;

procedure TFMain.lbTemplatesDblClick(Sender: TObject);
begin
  AddToConsole(lbTemplates);
end;

procedure TFMain.LoadTemplates;
begin
  if not FileExists(TemplatesFileName) then
    exit;

  FTemplates.LoadFromFile(TemplatesFileName);
end;

procedure TFMain.memConsoleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CurLine, PrevSymbol: string;
begin
  case Key of
    VK_UP:
      begin
        Key := 0;
      end;
  end;

end;

procedure TFMain.memConsoleKeyPress(Sender: TObject; var Key: Char);
var
  PrevSymbol: string;
begin
  case Key of
    #8:
      begin
        if Copy(CurrentLine, memConsole.CaretPos.X, 1) = '>' then
          Key := #0;
      end;
    #13:
      begin
        ExecuteCommand(GetCommand);
        Key := #0;
      end;
    #27:
      begin
        ClearCommand;
        Key := #0;
      end;
 end;

end;

procedure TFMain.pnlToolsResize(Sender: TObject);
begin
  SetHideLeftButtonPosition;
end;

procedure TFMain.sbHideLeftClick(Sender: TObject);
begin
  LeftHidden := not LeftHidden;
end;

procedure TFMain.SetCurrentLine(const Value: string);
var
  CurY: integer;
begin
  CurY := memConsole.CaretPos.Y;
  if CurY < 0 then
    exit;
  memConsole.Lines[CurY] := Value;
end;

procedure TFMain.SetHideLeftButtonPosition;
begin
  sbHideLeft.Top := (ClientHeight - sbHideLeft.Height) div 2;
  if LeftHidden then
    sbHideLeft.Left := 0
  else
    sbHideLeft.Left := pnlTools.Width;
//  sbHideLeft.BringToFront;
//sbHideLeft.Parent := splVert;
end;

procedure TFMain.SetLeftHidden(const Value: boolean);
var
  bmp: TBitmap;
begin
//  if FLeftHidden = Value then
//    exit;

  FLeftHidden := Value;
  pnlTools.Visible := not FLeftHidden;
  bmp := TBitmap.Create;
  try
    bmp.Transparent := true;
    bmp.TransparentColor := clWhite;
    ilHideShow.GetBitmap(Ord(FLeftHidden), bmp);
    sbHideLeft.Glyph.Assign(bmp);
//sbHideLeft.Glyph.Canvas.Draw(0, 0, bmp);
  finally
    bmp.Free;
  end;

  SetHideLeftButtonPosition;
end;

procedure TFMain.TemplatesChanged(Sender: TObject);
begin
  lbTemplates.Items.Assign(FTemplates);
end;

procedure TFMain.WriteInterfaceSettings;
begin
  with TIniFile.Create(SettingsFileName) do
  try
    WriteInteger('MainForm', 'Left', Left);
    WriteInteger('MainForm', 'Top', Top);
    WriteInteger('MainForm', 'Width', Width);
    WriteInteger('MainForm', 'Height', Height);
  finally
    Free;
  end;
end;

procedure TFMain.ReadInterfaceSettings;
begin
  if not FileExists(SettingsFileName) then
    exit;

  with TIniFile.Create(SettingsFileName) do
  try
    Width := ReadInteger('MainForm', 'Width', 800);
    Height := ReadInteger('MainFormm', 'Height', 600);
    Left := ReadInteger('MainFormm', 'Left', 200);
    Top  := ReadInteger('MainFormm', 'Top', 200);
  finally
    Free;
  end;
end;


end.
