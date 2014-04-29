unit Unit1;

interface

  uses
    Windows,
    Messages,
    SysUtils,
    Variants,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    Grids,

    ARSyncGrid
  ;

  type TForm1 = class( TForm )
      Grid1: TARSyncGrid;
      Grid2: TARSyncGrid;

    public
      constructor create( AOwner: TComponent ); override;

    end
  ;


  var
    Form1: TForm1;

implementation

{$R *.dfm}


  constructor TForm1.create( AOwner: TComponent );
    begin
      inherited create( AOwner );

      makeSyncGridPair( Grid1, Grid2 );
    end
  ;

end.
