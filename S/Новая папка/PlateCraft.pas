unit PlateCraft;

interface
const MaxLim = 1000;
      ClientHeight = 24;
      ClientWidth  = 32;
      GGrass = 1;
      GGround = 0;
      GIce = 3;
type TCell =
  record
    ObjectID, GroundID    :   Smallint;
  end;

type TGlobalMap = array [-MaxLim..MaxLim,-MaxLim..MaxLim] of TCell;
type TClientMap = array [0..ClientWidth+1,0..ClientHeight+1] of TCell;

type TPlayer =
  object
    name     :  string;
    X,Y,ID   :  integer;
  end;

implementation

end.
