unit SQL.Impl.Fabrica;

interface

uses
  SQL.Enums,
  SQL.Intf.Tabela,
  SQL.Intf.Coluna,
  SQL.Intf.Fabrica;

type
  TFabrica = class(TInterfacedObject, IFabrica)
  private
    FBancoDeDados: TBancoDeDados;
    FFabrica: IFabrica;
    procedure InicializarFabrica;
  public
    constructor Create(const ABancoDeDados: TBancoDeDados);
    class function New(const ABancoDeDados: TBancoDeDados): IFabrica;
    function Tabela: ISQLTabela;
    function Coluna: ISQLColuna;
    procedure AfterConstruction; override;
  end;

implementation

{ TFabrica }

uses
  SQL.Impl.PadraoSQL3.Fabrica;

function TFabrica.Tabela: ISQLTabela;
begin
  result := FFabrica.Tabela;
end;

procedure TFabrica.AfterConstruction;
begin
  inherited;
  InicializarFabrica;
end;

function TFabrica.Coluna: ISQLColuna;
begin
  result := FFabrica.Coluna;
end;

constructor TFabrica.Create(const ABancoDeDados: TBancoDeDados);
begin
  FBancoDeDados := ABancoDeDados;

  FFabrica := nil;
end;

procedure TFabrica.InicializarFabrica;
begin
  case FBancoDeDados of
    bdPadraoSQL3:
      FFabrica := TSQL3Fabrica.Create;
  end;
end;

class function TFabrica.New(const ABancoDeDados: TBancoDeDados): IFabrica;
begin
  result := Create(ABancoDeDados);
end;

end.