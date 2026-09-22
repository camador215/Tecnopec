query 91300 "Cust. Remain. Amt."
{
    QueryType = Normal;

    elements
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
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

            column(Posting_Date; "Posting Date")
            {
            }

            column(Remaining_Amt_LCY; "Remaining Amt. (LCY)")
            {
                Method = Sum;
            }
        }
    }
}