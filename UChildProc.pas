unit uChildProc;

interface

uses
	Windows, SysUtils, StrUtils;

resourcestring
  sCreatePipeMsg = 'Ошибка при создании "трубы" (Pipe).'#13#13'CreatePipe(FChildStdoutRd, FChildStdoutWr, saAttr, 0)';
  sDuplicateHandleMsg = 'Ошибка при создании копии хэндла.'#13#13'DuplicateHandle(GetCurrentProcess(), FChildStdoutRd, GetCurrentProcess(), @FChildStdoutRdDup, 0, False, DUPLICATE_SAME_ACCESS)';
  sCreateChildProcessMsg = 'Ошибка при создании дочернего процесса.'#13#13'CreateChildProcess(ExeName, CommadLine, FChildStdoutWr)';

type
  ESetStdHandleErr = class(Exception);
  ECreatePipeErr = class(Exception);
  EDuplicateHandleErr = class(Exception);
  ECreateChildProcessErr = class(Exception);

  TChildProc = class(TObject)
    FChildStdoutRd: THandle;
    FChildStdoutWr: THandle;
    FChildStdinRd: THandle;
    FChildStdinWr: THandle;
  private
    function CreateChildProcess(ExeName, CommadLine: String; StdIn: THandle; StdOut: THandle): Boolean;
  public
    constructor Create(ExeName, CommadLine: String);
    destructor Destroy; override;
    function ReadStrFromChild(Timeout: Integer = 1000): AnsiString;
    function WriteStrToChild(const Data: AnsiString): Boolean;
  end;

implementation

{ TChildProc }

constructor TChildProc.Create(ExeName, CommadLine: String);
var
  StdoutRdTmp, StdinWrTmp: THandle;
  saAttr: TSecurityAttributes;
begin
  ZeroMemory(@saAttr, SizeOf(TSecurityAttributes));
  saAttr.nLength := SizeOf(TSecurityAttributes);
  saAttr.bInheritHandle := True;
  saAttr.lpSecurityDescriptor := nil;
  if not CreatePipe(StdoutRdTmp, FChildStdoutWr, @saAttr, 0) then
    raise ECreatePipeErr.CreateRes(@sCreatePipeMsg);

  if not CreatePipe(FChildStdinRd, StdinWrTmp, @saAttr, 0) then
    raise ECreatePipeErr.CreateRes(@sCreatePipeMsg);

  if not DuplicateHandle(GetCurrentProcess(), StdoutRdTmp, GetCurrentProcess(),
      @FChildStdoutRd, 0, False, DUPLICATE_SAME_ACCESS) then
    raise EDuplicateHandleErr.CreateRes(@sDuplicateHandleMsg);

  if not DuplicateHandle(GetCurrentProcess(), StdinWrTmp, GetCurrentProcess(),
      @FChildStdinWr, 0, False, DUPLICATE_SAME_ACCESS) then
    raise EDuplicateHandleErr.CreateRes(@sDuplicateHandleMsg);

  CloseHandle(StdoutRdTmp);
  CloseHandle(StdinWrTmp);

  if not CreateChildProcess(ExeName, CommadLine, FChildStdinRd, FChildStdoutWr) then
    raise ECreateChildProcessErr.CreateRes(@sCreateChildProcessMsg);
end;

function TChildProc.CreateChildProcess(ExeName, CommadLine: String; StdIn, StdOut: THandle): Boolean;
var
  piProcInfo: TProcessInformation;
  siStartInfo: TStartupInfo;
begin
  ZeroMemory(@siStartInfo, SizeOf(siStartInfo));
  siStartInfo.cb := SizeOf(siStartInfo);
  siStartInfo.hStdInput := StdIn;
  siStartInfo.hStdOutput := StdOut;
  siStartInfo.hStdError := StdOut;
	siStartInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  siStartInfo.wShowWindow := SW_HIDE;

   Result := CreateProcess(nil,
      PChar(ExeName + ' ' + CommadLine),
      nil,
      nil,
      true,
      0,
      nil,
      nil,
      siStartInfo,
      piProcInfo);
end;

destructor TChildProc.Destroy;
begin
  CloseHandle(FChildStdoutRd);
  CloseHandle(FChildStdoutWr);
  CloseHandle(FChildStdinRd);
  CloseHandle(FChildStdinWr);
end;

function TChildProc.ReadStrFromChild(Timeout: Integer): AnsiString;
const
  SleepDevider = 10;
var
	i: Integer;
	dwRead, BufSize, DataSize: DWORD;
  Res: Boolean;
  SleepTime: Integer;
begin
	try
    SleepTime := Timeout div SleepDevider;
    Repeat
      For i := 0 to SleepDevider - 1 do
      begin
        Res := PeekNamedPipe(FChildStdoutRd, nil, 0, nil, @DataSize, nil);
        Res := Res and (DataSize > 0);
        if Res then
          Break;
        Sleep(SleepTime);
      end;

      if Res then
      begin
        BufSize := Length(Result);
        SetLength(Result, BufSize + DataSize);
        Res := ReadFile(FChildStdoutRd, Result[BufSize + 1], DataSize, dwRead, nil);
      end;
    until not Res;

    Result := Trim(Result);
  Except
  	Result := 'Read Err!';
  End;
end;


function TChildProc.WriteStrToChild(const Data: AnsiString): Boolean;
var
	dwWritten, BufSize: DWORD;
  chBuf: PAnsiChar;
begin
//  if Trim(Data) = '' then
//    exit;
  chBuf := PAnsiChar(Data + #13#10);
  BufSize := Length(chBuf);
  Result := WriteFile(FChildStdinWr, chBuf^, BufSize, dwWritten, nil);
  Result := Result and (BufSize = dwWritten);
end;

end.
