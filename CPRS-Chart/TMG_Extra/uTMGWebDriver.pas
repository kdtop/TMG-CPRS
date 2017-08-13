unit uTMGWebDriver;

interface

uses Forms, Windows, dialogs, SysUtils, Variants,
    TMGHTML2, EmbeddedED, MSHTML_EWB
    ;

  function FillInputValueById(WB: THtmlObj; const Id : string; value : string; var ErrMsg : string) : boolean;  //result is true for success.
  function ButtonClickById(WB: THtmlObj; const Id : string; var ErrMsg : string) : boolean;  //result is true for success.
  function GetInnerTextById(WB: THtmlObj; const Id : string; var OutValue : string; var ErrMsg : string) : boolean;  //result is true for success.

implementation


function FillInputValueById(WB: THtmlObj; const Id : string; value : string; var ErrMsg : string) : boolean;  //result is true for success.
var //e :            IDispatch;
    Elem:          IHTMLElement;
    InputElem:     IHTMLInputElement;
begin
  Result := false; //default to failure
  Elem := WB.GetElementByID(id);
  if not Supports(Elem, IHTMLInputElement, InputElem) then begin
    ErrMsg := 'Element [id='+Id+'] doesn''t support IHTMLInputElement';
    exit;
  end;
  if not Assigned(InputElem) then exit;
  InputElem.value := value;
  Result := true; //signal success.
end;


function GetInnerTextById(WB: THtmlObj; const Id : string; var OutValue : string; var ErrMsg : string) : boolean;  //result is true for success.
var Elem:          IHTMLElement;
begin
  Result := false; //default to failure
  Elem := WB.GetElementByID(id);
  if not Assigned(Elem) then exit;
  OutValue := Elem.innerText;
  Result := true; //signal success.
end;



function ButtonClickById(WB: THtmlObj; const Id : string; var ErrMsg : string) : boolean;  //result is true for success.
var Elem:          IHTMLElement;
    Elem2:          IHTMLElement;
begin
  Result := false; //default to failure
  Elem := WB.GetElementByID(id);
  if not Assigned(Elem) then exit;
  if not Supports(Elem, IHTMLElement, Elem2) then begin
    ErrMsg := 'Element [id='+Id+'] doesn''t support IHTMLInputElement';
    exit;
  end;
  Elem2.click;
  Result := true; //signal success.
end;




end.
