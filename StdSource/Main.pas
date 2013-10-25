unit Main;

interface

uses
  Forms, StdCtrls, Controls, Classes, uChildProc;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
Var
  i: Integer;
begin
  With TChildProc.Create(Edit1.Text, '') do
    Try
      For i:=0 to Memo2.Lines.Count-1 do
        WriteStrToChild(Memo2.Lines[i]);
      Memo1.Lines.Add(ReadStrFromChild(500));
    Finally
      Free;
    End;
end;


end.
