unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  SynEdit, SynHighlighterIni, SynHighlighterAny, strutils;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItemCopy: TMenuItem;
    MenuItemSelectAll: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItemOpen: TMenuItem;
    MenuItemClose: TMenuItem;
    MenuItem4: TMenuItem;
    OpenDialog1: TOpenDialog;
    SynEdit1: TSynEdit;
    SynIniSyn1: TSynIniSyn;
    procedure FormCreate(Sender: TObject);
    procedure LoadFile(FileName: string);
    procedure MenuItemSelectAllClick(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItemCopyClick(Sender: TObject);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure MenuItemCloseClick(Sender: TObject);
  private

  public

  end;

  FitsCard = record
    line: array[0..79] of char;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if (ParamCount > 0) then
    LoadFile(ParamStr(1));
end;

procedure TMainForm.LoadFile(FileName: string);
var
  fh: file of FitsCard;
  card: FitsCard;
  eoh: boolean = False;
const
  fitsSignature = 'SIMPLE  =                    T';
  endCard = 'END                           ';
begin
  AssignFile(fh, FileName);
  try
    Filemode := fmOpenRead;
    Reset(fh);
    SynEdit1.Lines.Clear;

    Read(fh, card);
    SynEdit1.Lines.Append(card.line);

    if (not AnsiStartsStr(fitsSignature, card.line)) then
    begin
      MessageDlg('Selected file is not a FITS file', mtError, [mbOK], 0);
      EOH := True;
    end;

    while (not eoh) do
    begin
      Read(fh, card);
      SynEdit1.Lines.Append(card.line);
      eoh := AnsiStartsStr(endCard, card.line);
    end;

  finally
    CloseFile(fh);
  end;
end;

procedure TMainForm.MenuItemSelectAllClick(Sender: TObject);
begin
  SynEdit1.SelectAll;
end;

procedure TMainForm.MenuItem9Click(Sender: TObject);
begin
  Application.MessageBox('(c) Benny Colyn 2020. ' + sLineBreak +
    ' Open source under gplv3 license.' + sLineBreak +
    'See https://github.com/bcolyn/fitsmeta', 'FitsMeta');
end;

procedure TMainForm.MenuItemCopyClick(Sender: TObject);
begin
  SynEdit1.CopyToClipboard;
end;

procedure TMainForm.MenuItemOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    LoadFile(OpenDialog1.FileName);
  end;
end;

procedure TMainForm.MenuItemCloseClick(Sender: TObject);
begin
  MainForm.Close;
end;

end.
