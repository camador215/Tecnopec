pageextension 91300 "Account Receivables Ext" extends "Account Receivables"
{
    layout
    {
        addlast(RoleCenter)
        {
            part("Customer Name"; "CuentasxCobrar")
            {
                ApplicationArea = All;
            }
        }
    }
}