{ ******************************************** }
{       KS_lib ver 1.11 (Jan. 19, 2004)        }
{                                              }
{       For Delphi 4, 5 and 6                  }
{                                              }
{       Copyright (C) 1999-2003, Kurt Senfer.  }
{       All Rights Reserved.                   }
{                                              }
{       Support@ks.helpware.net                }
{                                              }
{       Documentation and updated versions:    }
{                                              }
{       http://KS.helpware.net                 }
{                                              }
{ ******************************************** }
{
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}


unit KS_lib;

 {$I KSED.INC} //Compiler version directives

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,
  //ktMSHTML_TLB,
  MSHTML_EWB,
  variants,  //kt 9/11 added
  Activex;

  procedure SafeYield;

  //function GetDocTypeTag(DOC: IHTMLDocument2): String;
  function GetHTMLtext(DOC: IHTMLDocument2): String;
  function GetDocHTML(DOC: IHTMLDocument2): String;
  function IsFilePath(Url: String; var FilePath: string): HResult;
  function GetParentElemetType(aTag: IHTMLElement; aType: string; var ParentElement: IHTMLElement): boolean;

const
  aFilter: string = 'HTML file (*.htm / *.html)|*.htm;*.html|All Files|*.*';
  AboutBlank: string = 'about:blank';
  cNormal: String = 'Normal';
  //cDIV   : String = 'DIV';
  cBODY: string = 'BODY';
  cTABLE: string = 'TABLE';
  cTD: string = 'TD';
  cTH: string = 'TH';
  cTR: string = 'TR';


var
  FLastError: String;

type
  CmdID = TOleEnum;

implementation

uses {$IFDEF D6D7} variants, {$ENDIF} AXCtrls, KS_Procs;


//------------------------------------------------------------------------------
function GetParentElemetType(aTag: IHTMLElement; aType: string; var ParentElement: IHTMLElement): boolean;
begin
  result := false;

  ParentElement := aTag;
  if assigned(ParentElement)
     then begin
        while (not AnsiSameText(ParentElement.tagName, aType)) and
           (not SameText(ParentElement.tagName, cBODY)) do
           begin
              ParentElement := ParentElement.parentElement;
              if not assigned(ParentElement)
                 then exit;
           end;

        result := AnsiSameText(ParentElement.tagName, aType);
     end;

end;
//------------------------------------------------------------------------------
function IsFilePath(Url: String; var FilePath: string): HResult;

  //-----------------------------------------------------
  function IsFilePath(URN: string): HResult;
  begin
     if (length(URN) > 0) and ((copy(URN, 1, 2) = '\\') or (URN[2] = ':'))
        then begin
           result := S_OK;
           FilePath := URN;
        end
        else result := S_FALSE;
  end;
  //-----------------------------------------------------
begin
  //asm int 3 end; //trap
  { we can have a file path:
    file://sie01/ksdata/kvalsys/.....  or
    file:///G:/kvalsys/......
    or a http path and other posibilitys }

    //IsValidURL
    //CoInternetParseUrl
    //if(IsValidURL(nil,PWideChar(WideString(aUrl)),0)=S_OK)

  //asm int 3 end; //trap

  result := IsFilePath(URL);
  if result = S_OK
     then exit;

  result := S_false;

  if Pos('file:', LowerCase(URL)) = 1
     then begin
        FilePath := Copy(URL, 6, Length(URL));
        if FilePath[1] = '/'
           then FilePath := StringReplace(FilePath, '/', '\', [rfReplaceAll])
           else if FilePath[1] <> '\'
              then exit;  //somthings rotten

        if Copy(FilePath, 1, 3) = '\\\' //we have a drive letter type path
           then delete(FilePath, 1, 3);

      (*
        //we have to get ried of the first tree \
        for I := 1 to 3 do
           Delete(FilePath, 1, pos('\', FilePath));
       *)
        result := IsFilePath(FilePath);
     end;
end;
//------------------------------------------------------------------------------
procedure SafeYield;
// Make room for other processes
var
  Msg : TMsg;
begin
  //asm int 3 end; //trap     - not used
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE)
     then begin
        if Msg.Message = wm_Quit
           then PostQuitMessage(Msg.WParam) //Tell main message loop to terminate
     else begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
     end;
  end;
end;
//------------------------------------------------------------------------------
function GetDocTypeTag(DOC: IHTMLDocument2): String;
var
  aElementCollection: IHTMLElementCollection;
  HTMLElement: IHTMLElement;
begin
  //get the <!DOCTYPE tag as the first tag in a collection
  aElementCollection := (DOC as IHTMLDocument3).getElementsByTagName('!') as IHTMLElementCollection;
  if aElementCollection.Length > 0
     then begin
        HTMLElement := aElementCollection.item(0, null) as IHTMLElement;
        if (HTMLElement <> Nil) and
           (pos('<!DOCTYPE', HTMLElement.OuterHTML) = 1)
           then Result := HTMLElement.OuterHTML
           else Result := '';  //no <!DOCTYPE tag in this document
     end
     else Result := ''; //no <!DOCTYPE tag in this document

end;
//------------------------------------------------------------------------------
function GetHTMLtext(DOC: IHTMLDocument2): String;
//GetHTMLtext takes app. 80 millisec. and GetDocumentHTML app. 70 milisec.
var
  aElementCollection: IHTMLElementCollection;
  HTMLElement: IHTMLElement;
begin
  //asm int 3 end; //trap

  if DOC = nil
     then begin
        result := '';
        exit;
     end;

  //first get the <!DOCTYPE tag - if any
  result := GetDocTypeTag(DOC);


  //get the HTML tag (as a collection of one element)
  aElementCollection := (DOC as IHTMLDocument3).getElementsByTagName('HTML') as IHTMLElementCollection;
  if aElementCollection.Length = 1
     then begin
        HTMLElement := aElementCollection.item(0, null) as IHTMLElement;
        if HTMLElement <> Nil
                //add the HTML tag to the <!DOCTYPE tag (if any)
           then Result := Result + HTMLElement.OuterHTML
           else Result := ''; //this is wrong
     end
     else Result := ''; //this is wrong
end;
//------------------------------------------------------------------------------
function GetDocHTML(DOC: IHTMLDocument2): String;
//GetHTMLtext takes app. 80 millisec. and GetDocumentHTML app. 70 milisec.

var
  aStream: TStringStream;
  P: PWideChar;
begin
  //asm int 3 end; //trap

  if DOC = nil
     then Result := ''
     else begin
        aStream := TStringStream.Create('');
        try

           { PersistStream.save returns the DHTML tree in the last rendered version
             Non visible changes isent nessasarely returned
             PersistFile.Save always returns a rendered document }

           //ForceRendering;
           //PersistStream.save(TStreamAdapter.Create(AStream), false);
           //result := aStream.DataString;
           //S := GetHTMLtext;
           //waitWhileDocIsBusy;
           //InsertNewTag2(Doc);

           //waitWhileDocIsBusy;
           //result := aStream.DataString;
           //aStream.free;
           //aStream := TStringStream.Create('');

           (*
           I := GetTickCount;

           CmdSet(IDM_PERSISTSTREAMSYNC);
           i := GetTickCount -i;
           *)


           if S_OK = (DOC as IPersistStreamInit).save(TStreamAdapter.Create(AStream), false)
              then begin
                 //WaitForDocComplete;
                 {this is what DHTMLEDIT does when it is not in preserve Source mode }
                 if aStream.Size = 0  //just in case
                    then begin
                       result := '';
                       exit;
                    end;

                 if aStream.DataString[1] = '<'
                    then result := aStream.DataString
                    else begin
                       P :=  PWideChar(@aStream.DataString[1]) ;
                       result := OleStrToString(P);

                       //the aStream.DataString returns a ? in front of the source
                       if (Length(result) > 0) and  (Result[1] <> '<')
                          then delete(Result, 1, 1);
                    end;
              end;
        finally
           aStream.free;
        end;
     end;
end;
//------------------------------------------------------------------------------
Function ReadRegString(MainKey: HKey; SubKey, ValName: String): String;
  // NB default value is read if subkey isent ended with a backslash
Var
  Key: HKey;
  C: Array[0..1023] of Char;
  D: Cardinal;  //value type
  D2: Cardinal; //buffer size
Begin
  //asm int 3 end; //trap
  result := '';

  if RegOpenKeyEx(MainKey, Pchar(NoEndBackSlash(SubKey)), 0, KEY_READ, Key) = ERROR_SUCCESS
     then begin
        try
           C := '';
           D2 := SizeOf(C);
           if (RegQueryValueEx(Key, Pchar(ValName), Nil, @D, @C, @D2) = ERROR_SUCCESS) and
              ((D = REG_EXPAND_SZ) or (D = REG_SZ))
              then result := C
              else result := '';
        finally
           RegCloseKey(Key);
        end;
     end;
End;
//------------------------------------------------------------------------------
end.
