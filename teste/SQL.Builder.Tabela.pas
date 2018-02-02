unit SQL.Builder.Tabela;

interface

uses
  SQL.Enums,
  SQL.Constantes,
  SQL.Intf.Tabela;

type
  TBuilderTabela = class
  protected
    FTabela: ISQLTabela;
  public
    function getTabela: ISQLTabela;
    procedure criarNovaTabela;
    procedure buildNomeTabela(); virtual; abstract;
    procedure buildAliasTabela(); virtual; abstract;
  end;

  TBuilderTabelaComNomeApenas = class(TBuilderTabela)
  public
    procedure buildAliasTabela; override;
    procedure buildNomeTabela; override;
  end;

  TBuilderTabelaComNomeEAlias = class(TBuilderTabela)
  public
    procedure buildAliasTabela; override;
    procedure buildNomeTabela; override;
  end;

  TDirectorTabela = class
  private
    FTabelaBuilder: TBuilderTabela;
  public
    procedure setBuilderTabela(var ABuilderTabela: TBuilderTabela);
    procedure construirTabela();
    function getTabela: ISQLTabela;
  end;

implementation

uses
  SQL.Intf.Fabrica,
  SQL.Impl.Fabrica, Teste.Constantes;

{ TBuilderTabela }

procedure TBuilderTabela.criarNovaTabela;
var
  _fabrica: IFabrica;
begin
  _fabrica := TFabrica.New(SQL_TIPO_PADRAO);

  FTabela := _fabrica.Tabela;
end;

function TBuilderTabela.getTabela: ISQLTabela;
begin
  result := FTabela;
end;

{ TBuilderTabelaComNomeApenas }

procedure TBuilderTabelaComNomeApenas.buildAliasTabela;
begin
  FTabela.setAlias('');
end;

procedure TBuilderTabelaComNomeApenas.buildNomeTabela;
begin
  FTabela.setNome(TABELA_SEM_ALIAS);
end;

{ TBuilderTabelaComNomeEAlias }

procedure TBuilderTabelaComNomeEAlias.buildAliasTabela;
begin
  FTabela.setAlias(TABELA_ALIAS)
end;

procedure TBuilderTabelaComNomeEAlias.buildNomeTabela;
begin
  FTabela.setNome(TABELA_COM_ALIAS);
end;

{ TDirectorTabela }

procedure TDirectorTabela.construirTabela;
begin
  FTabelaBuilder.criarNovaTabela;
  FTabelaBuilder.buildNomeTabela;
  FTabelaBuilder.buildAliasTabela;
end;

function TDirectorTabela.getTabela: ISQLTabela;
begin
  result := FTabelaBuilder.getTabela;
end;

procedure TDirectorTabela.setBuilderTabela(var ABuilderTabela: TBuilderTabela);
begin
  FTabelaBuilder := ABuilderTabela;
end;

end.