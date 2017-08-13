unit fNoteCompParentPick;
//kt added entire unite 6/15
 (*
 Copyright 6/23/2015 Kevin S. Toppenberg, MD
 --------------------------------------------------------------------

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 == Alternatively, at user's choice, GPL license below may be used ===

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may view details of the GNU General Public License at this URL:
 http://www.gnu.org/licenses/
 *)



interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uTIU,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ORCtrls;

type
  TfrmNoteCompParentPick = class(TForm)
    tvDocs: TORTreeView;
    Label1: TLabel;
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure tvDocsChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
    FSelectedNode : TORTreeNode;
  public
    { Public declarations }
    function PrepForm(DocSelRec : TDocSelRec) : boolean;
    property SelectedNode : TORTreeNode read FSelectedNode;
  end;

//var
//  frmNoteCompParentPick: TfrmNoteCompParentPick;

implementation

{$R *.dfm}

  uses
    uConst, uDocTree, rTIU, fNotes, ORFn;

  function TfrmNoteCompParentPick.PrepForm(DocSelRec : TDocSelRec) : boolean;
  //Expected input:  Source should be the node for All Unsigned Notes.
  var
    tmpList: TStringList;
    DocList: TStringList;
    GroupBy : string;
    TreeAscending : boolean;
    UnsignedDocsNode, SelNode : TORTreeNode;

  begin
    if not assigned(DocSelRec.TreeView) then begin
      Result := false;
      exit;
    end;
    Result := true; //default to success
    FSelectedNode := nil;
    tmpList := TStringList.Create;
    DocList := TStringList.Create;
    try
      tvDocs.Items.Clear;
      GroupBy := '';
      TreeAscending := true;
      ListNotesForTree(tmpList, NC_UNSIGNED, 0, 0, 0, 0, TreeAscending);
      if tmpList.Count > 0 then begin
        CreateListItemsforDocumentTree(DocList, tmpList, NC_UNSIGNED, GroupBy, TreeAscending, CT_NOTES);
        case DocSelRec.TreeType of
          edseNotes:   begin
                         frmNotes.UpdateTreeView(DocList, tvDocs);
                       end;
          edseConsults: begin
                          //to be implemented...
                          //would have to be made public --> frmConsults.UpdateConsultsTreeView(tvDocs);
                        end;
          edseDCSumm:   begin
                          //to be implemented...
                          //I think DCSumm are read only, so is this relevant??
                        end;
        end; {case}
      end else begin
        //Indicate that action is impossible
        Result := false;
      end;
      //tvDocs.Selected := nil;
      UnsignedDocsNode := tvDocs.FindPieceNode(IntToStr(NC_UNSIGNED), U);
      if Assigned(UnsignedDocsNode) then begin
        if UnsignedDocsNode.Count > 0 then begin
          SelNode := TORTreeNode(UnsignedDocsNode.Item[0]);
          tvDocs.Selected := SelNode;
        end;
      end;
    finally
      tmpList.Free;
      DocList.Free;
    end;
  end;

  procedure TfrmNoteCompParentPick.tvDocsChange(Sender: TObject; Node: TTreeNode);
  var Enabled : boolean;
  begin
    //handle node selected.
    FSelectedNode := TORTreeNode(Node);
    if assigned(FSelectedNode) then begin
      Enabled := (piece(FSelectedNode.StringData,U,1) <> IntToStr(NC_UNSIGNED));
    end else Enabled := false;
    btnOK.Enabled := Enabled;
  end;

end.

