unit ARSyncGrid;

(*
ARSyncGrid.pas
--------------
Begin: 2007/01/03
Last revision: $Date: 2010-05-21 16:54:53 $ $Author: areeves $
Version number: $Revision: 1.4 $
Project: various
Website: http://www.naadsm.org/opensource/delphi
Author: Aaron Reeves <Aaron.Reeves@colostate.edu>
--------------------------------------------------
Copyright (C) 2007, 2010 Animal Population Health Institute, Colorado State University

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
*)

interface

  uses
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    Grids
  ;


  type TARSyncGrid = class( TStringGrid )
    protected
      FSyncGrid: TARSyncGrid;

      OriginalWindowProc: TWndMethod;
      procedure NewWindowProc(var Message: TMessage);

    public
      constructor create( AOwner: TComponent ); override;

    published
      property SyncGrid: TARSyncGrid read FSyncGrid write FSyncGrid;

      procedure KeyUp( var Key: Word; Shift: TShiftState ); override;
    end
  ;

  procedure makeSyncGridPair( grid1, grid2: TARSyncGrid );

  procedure Register();


implementation

{$R ARSyncGrid.Res}

(*
  uses
    DebugWindow
  ;

  const
    DEBUGMSG: boolean = false; // Set to true to enable debugging messages for this unit.
*)

  procedure makeSyncGridPair( grid1, grid2: TARSyncGrid );
    begin
      grid1.SyncGrid := grid2;
      grid2.SyncGrid := grid1;
    end
  ;

  constructor TARSyncGrid.create( AOwner: TComponent );
    begin
      inherited create( AOwner );
      OriginalWindowProc := self.WindowProc;

      self.WindowProc := newWindowProc;

      syncGrid := nil;
    end
  ;


  procedure TARSyncGrid.NewWindowProc( var Message: TMessage );
    var
      i: smallint;
    begin
      OriginalWindowProc( message );

      if
        ( assigned( SyncGrid ) )
      and
        (
          ( WM_VSCROLL = Message.Msg )
        or
          ( WM_HSCROLL = Message.Msg )
        or
          ( WM_Mousewheel = Message.msg )
        )
      then
        begin
          if ( WM_Mousewheel = Message.msg ) then
            begin
              {
                When makeSyncGridPair has been called several odd behaviors
                occur between the two grids when the mouse scrolling wheel is used.
                The lines below correct these:
                  1. The mouse scroll bar turning moves but skips every other cell.
                  2. Scrolling through the cells only occurs in the one grid.
              }
              Message.msg :=  WM_KEYUP; //don't use WM_KEYDOWN, will not result in sync
              Message.lParam := 0;
              i := HiWord(Message.wParam) ;
              if (i > 0) then Message.wParam := VK_UP
              else Message.wParam := VK_DOWN;

              {
                The lines below keep rows and chart parameters synced when the mouse
                wheel is rotated very quickly. Without setting col and row
                the grids will sync but the charts will unsync with a fast wheel roll
              }
              SyncGrid.Col := self.Col;
              SyncGrid.Row := self.Row;
              SyncGrid.Selection := self.Selection;
              SyncGrid.TopRow := self.TopRow;

            end
          ;
          syncGrid.OriginalWindowProc( Message );
        end
      ;
    end
  ;


  procedure TARSyncGrid.KeyUp( var Key: Word; Shift: TShiftState );
    begin
      inherited;

      if
        ( assigned( SyncGrid ) )
      and
        ( ( VK_UP = key ) or ( VK_DOWN = key ) )
      then
        begin
          SyncGrid.Selection := self.Selection;
          SyncGrid.TopRow := self.TopRow;
        end
      ;
    end
  ;


  procedure Register();
    begin
      RegisterComponents('APHIControls', [TARSyncGrid]);
    end
  ;

end.
