page 90101 "CuentasxCobrar"
{
    Caption = 'Cuentas por Cobrar';
    PageType = CardPart;
    SourceTable = "Finance Cue";

    layout
    {
        area(Content)
        {
            cuegroup("Cuentas por Cobrar")
            {
                CuegroupLayout = Wide;

                field("Cuentas por Cobsrar"; Rec."Saldo Total Pendiente")
                {
                    ApplicationArea = All;
                    StyleExpr = 'Subordinate';
                }
            }
        }
    }
}
