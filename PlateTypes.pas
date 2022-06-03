unit PlateTypes;

interface
const MaxLim = 1000;

type TCell =
  record
    ID    :   byte;
  end;


type TMap = array [-MaxLim..MaxLim,-MaxLim..MaxLim] of TCell;
implementation

end.
