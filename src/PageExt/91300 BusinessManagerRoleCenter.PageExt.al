pageextension 91300 "Business Manager RC Ext" extends "Business Manager Role Center"
{
    layout
    {
        addlast(rolecenter)
        {
            part(ReceivablesCue; "Receivables Cue")
            {
                ApplicationArea = All;
            }
            part(PayablesCue; "Payables Cue")
            {
                ApplicationArea = All;
            }
        }
    }
}
