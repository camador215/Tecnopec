query 91301 "Cust. Payments Amt."
{
    Caption = 'Cust. Payments Amt.';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            filter(Document_Type; "Document Type")
            {
            }

            filter(Posting_Date; "Posting Date")
            {
            }

            column(Credit_Amount_LCY; "Credit Amount (LCY)")
            {
                Method = Sum;
            }
        }
    }
}