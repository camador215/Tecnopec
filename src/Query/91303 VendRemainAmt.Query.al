query 91302 "Vend. Remain. Amt."
{
    QueryType = Normal;

    elements
    {
        dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
        {
            column(Document_Type; "Document Type")
            {
            }

            column(IsOpen; Open)
            {
            }

            column(Due_Date; "Due Date")
            {
            }

            column(Remaining_Amt_LCY; "Remaining Amt. (LCY)")
            {
                Method = Sum;
            }
        }
    }
}