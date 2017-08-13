{*******************************************************}
{                                                       }
{         EmbeddedED compiler directives                }
{         Copyright (C) 1999-2003, Kurt Senfer          }
{                                                       }
{*******************************************************}


  //{$IFDEF VER100} // Delphi 3.0
  //{$IFDEF VER120} // Delphi 4.0
  //{$IFDEF VER130} // Delphi 5.0
  //{$IFDEF VER140} // Delphi 6.0
  //{$IFDEF VER150} // Delphi 7.0



{$IFDEF VER140} { Borland Delphi 6.0 }
  {$DEFINE D6D7}
{$ENDIF}


{$IFDEF VER150} { Borland Delphi 7.0 }
  {$DEFINE D6D7}
{$ENDIF}


{$IFDEF D6D7}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

