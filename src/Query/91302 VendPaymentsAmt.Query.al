query 91303 "Vend. Payments Amt."
{
    Caption = 'Vend. Payments Amt.';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(VendLedgerEntry; "Vendor Ledger Entry")
        {
            filter(Document_Type; "Document Type")
            {
            }

            filter(Posting_Date; "Posting Date")
            {
            }

            column(Debit_Amount_LCY; "Debit Amount (LCY)")
            {
                Method = Sum;
            }
        }
    }
}