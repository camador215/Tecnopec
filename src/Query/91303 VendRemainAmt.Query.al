query 91302 "Vend. Remain. Amt."
{
    Caption = 'Vend. Ledg. Entry Remain. Amt.';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(VendLedgerEntry; "Vendor Ledger Entry")
        {
            filter(Document_Type; "Document Type")
            {
            }

            filter(IsOpen; Open)
            {
            }

            filter(Due_Date; "Due Date")
            {
            }

            column(Remaining_Amt_LCY; "Remaining Amt. (LCY)")
            {
                Method = Sum;
            }
        }
    }
}