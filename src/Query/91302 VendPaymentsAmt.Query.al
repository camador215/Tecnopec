query 91303 "Vend. Payments Amt."
{
    QueryType = Normal;

    elements
    {
        dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
        {
            column(Document_Type; "Document Type")
            {
            }

            column(Posting_Date; "Posting Date")
            {
            }

            column(Debit_Amount_LCY; "Debit Amount (LCY)")
            {
                Method = Sum;
            }
        }
    }
}