program TesteSQL;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}


uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Teste.Builder.Select in 'Teste.Builder.Select.pas',
  Teste.Builder.Coluna in 'Teste.Builder.Coluna.pas',
  Teste.Builder.Condicao in 'Teste.Builder.Condicao.pas',
  Teste.Builder.Juncao in 'Teste.Builder.Juncao.pas',
  uSQLTabelaTeste in 'uSQLTabelaTeste.pas',
  uSQLColunaTeste in 'uSQLColunaTeste.pas',
  uSQLCondicaoTeste in 'uSQLCondicaoTeste.pas',
  uSQLJuncaoTeste in 'uSQLJuncaoTeste.pas',
  uSQLSelectTeste in 'uSQLSelectTeste.pas',
  Teste.Builder.Tabela in 'Teste.Builder.Tabela.pas',
  Teste.Constantes in 'Teste.Constantes.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger: ITestLogger;

begin
  ReportMemoryLeaksOnShutdown := True;
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    // Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    // Create the test runner
    runner := TDUnitX.CreateRunner;
    // Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    // tell the runner how we will log things
    // Log to the console window
    logger := TDUnitXConsoleLogger.Create(True);
    runner.AddLogger(logger);
    // Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; // When true, Assertions must be made during tests;

    // Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

{$IFNDEF CI}
    // We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
{$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;

end.
