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
    function ReadStrFromChild(Timeout: Integer=1000): AnsiString;
    function WriteStrToChild(Data: AnsiString): Boolean;
  end;

implementation

{ TChildProc }

constructor TChildProc.Create(ExeName, CommadLine: String);
Var
  StdoutRdTmp, StdinWrTmp: THandle;
  saAttr: TSecurityAttributes;
begin
  ZeroMemory(@saAttr, SizeOf(TSecurityAttributes));
  saAttr.nLength := SizeOf(TSecurityAttributes);
  saAttr.bInheritHandle := True;
  saAttr.lpSecurityDescriptor := Nil;
  If not CreatePipe(StdoutRdTmp, FChildStdoutWr, @saAttr, 0) Then
    raise ECreatePipeErr.CreateRes(@sCreatePipeMsg);

  If not CreatePipe(FChildStdinRd, StdinWrTmp, @saAttr, 0) Then
    raise ECreatePipeErr.CreateRes(@sCreatePipeMsg);

	If not DuplicateHandle(GetCurrentProcess(), StdoutRdTmp, GetCurrentProcess(), @FChildStdoutRd,
      0, true, DUPLICATE_SAME_ACCESS) Then
    raise EDuplicateHandleErr.CreateRes(@sDuplicateHandleMsg);

  If not DuplicateHandle(GetCurrentProcess(), StdinWrTmp, GetCurrentProcess(), @FChildStdinWr,
      0, true, DUPLICATE_SAME_ACCESS) Then
    raise EDuplicateHandleErr.CreateRes(@sDuplicateHandleMsg);

  CloseHandle(StdoutRdTmp);
  CloseHandle(StdinWrTmp);

  If not CreateChildProcess(ExeName, CommadLine, FChildStdinRd, FChildStdoutWr) Then
    raise ECreateChildProcessErr.CreateRes(@sCreateChildProcessMsg)
end;

function TChildProc.CreateChildProcess(ExeName, CommadLine: String; StdIn,
  StdOut: THandle): Boolean;
Var
  piProcInfo: TProcessInformation;
  siStartInfo: TStartupInfo;
begin
  ZeroMemory(@siStartInfo, SizeOf(siStartInfo));
  siStartInfo.cb := SizeOf(siStartInfo);
  siStartInfo.hStdInput := StdIn;
  siStartInfo.hStdOutput := StdOut;
	siStartInfo.dwFlags := STARTF_USESTDHANDLES;

  Result := CreateProcess(Nil,
      PChar(ExeName + ' ' + CommadLine),
      Nil,
      Nil,
      TRUE,
      0,
      Nil,
      Nil,
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
Const
  SleepDevider = 10;
Var
	i: Integer;
	dwRead, BufSize, DataSize: DWORD;
  Res: Boolean;
  SleepTime: Integer;
begin
	Try
    SleepTime := Timeout div SleepDevider;
    Repeat
      For i := 0 to SleepDevider - 1 do
	      begin
  	      Res := PeekNamedPipe(FChildStdoutRd, nil, 0, nil, @DataSize, nil);
     	    Res := Res and (DataSize > 0);
          If Res Then
            Break;
          Sleep(SleepTime);
        end;
      If Res Then  //Если есть данные
        begin
          BufSize := Length(Result);
          SetLength(Result, BufSize + DataSize);
	  	   	Res := ReadFile(FChildStdoutRd, Result[BufSize + 1], DataSize, dwRead, Nil);
        end;
    Until not Res;
  Except
  	Result := 'Read Err!';
  End;

{Var
  i: Integer;
  dwRead, DesBufSize: DWORD;
  chBuf: PAnsiChar;
  Res: Boolean;
begin
  GetMem(chBuf, 1024);
  Try
    Repeat
      For i:=0 to 9 do
      begin
        Res:=PeekNamedPipe(FChildStdoutRd, nil, 0, nil, @DesBufSize, nil);
        Res:=Res and (DesBufSize > 0);
        If Res Then
          Break;
        Sleep(Round(Timeout/10));
      end;
      If Res Then
      begin
        Res:=ReadFile(FChildStdoutRd, chBuf^, 1024, dwRead, Nil);
        OemToAnsi(chBuf, chBuf);
        Result:=Result + LeftStr(chBuf, dwRead);
      end;
    Until not Res;
  Except
    Result:='Read Err';
  End;
  FreeMem(chbuf);}
end;


function TChildProc.WriteStrToChild(Data: AnsiString): Boolean;
Var
  dwWritten, BufSize: DWORD;
  chBuf: PAnsiChar;
begin
  chBuf := PAnsiChar(Data + #13#10);
  BufSize := Length(chBuf);
  Result := WriteFile(FChildStdinWr, chBuf^, BufSize, dwWritten, Nil);
  Result := Result and (BufSize = dwWritten);
end;

end.
