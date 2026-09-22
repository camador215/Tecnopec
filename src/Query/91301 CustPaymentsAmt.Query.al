query 91301 "Cust. Payments Amt."
{
    QueryType = Normal;

    elements
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            column(Document_Type; "Document Type")
            {
            }

            column(Posting_Date; "Posting Date")
            {
            }

            column(Credit_Amount_LCY; "Credit Amount (LCY)")
            {
                Method = Sum;
            }
        }
    }
}