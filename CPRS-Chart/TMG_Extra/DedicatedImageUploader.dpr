program DedicatedImageUploader;

uses
  Forms,
  fDedicatedImageUploaderMain in 'fDedicatedImageUploaderMain.pas' {Form1},
  fUploadImages in 'fUploadImages.pas' {frmImageUpload},
  fBase508Form in '..\fBase508Form.pas' {frmBase508Form},
  fPage in '..\fPage.pas' {frmPage};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmPage, frmPage);
  Application.Run;
end.
