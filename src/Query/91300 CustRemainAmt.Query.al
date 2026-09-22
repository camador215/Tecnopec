query 91300 "Cust. Remain. Amt."
{
    Caption = 'Cust. Ledg. Entry Remain. Amt.';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
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