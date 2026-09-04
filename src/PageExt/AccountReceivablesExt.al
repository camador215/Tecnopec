pageextension 90101 "Account Receivables Ext" extends "Account Receivables"
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