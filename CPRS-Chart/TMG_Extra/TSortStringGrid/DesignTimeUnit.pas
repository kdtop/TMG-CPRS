unit DesignTimeUnit;

interface

  uses Classes;

  procedure Register;

implementation

  uses  SortStringGrid;

  procedure Register;
  begin
    RegisterComponents('Custom Components',[TSortStringGrid]);
  end;

end.
