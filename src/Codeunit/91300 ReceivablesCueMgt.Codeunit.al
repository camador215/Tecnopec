codeunit 91300 "Receivables & Payables Cue Mgt"
{
    procedure CalculatePayables(var Cue: Record "Payables Cue"; WorkDateValue: Date; MonthStart: Date; MonthEnd: Date)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        Clear(Cue."Total Outstanding");
        Clear(Cue."Overdue Amount");
        Clear(Cue."Not Due Amount");
        Clear(Cue."Payments Made");
        Clear(Cue."Outstanding Invoice Count");
        Clear(Cue."Overdue Invoice Count");
        Clear(Cue."Not Due Invoice Count");

        VendorLedgerEntry.SetRange(Open, true);
        VendorLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Invoice);
        if VendorLedgerEntry.FindSet() then
            repeat
                VendorLedgerEntry.CalcFields("Remaining Amt. (LCY)");
                if VendorLedgerEntry."Remaining Amt. (LCY)" <> 0 then begin
                    Cue."Total Outstanding" += VendorLedgerEntry."Remaining Amt. (LCY)";
                    Cue."Outstanding Invoice Count" += 1;
                    if (VendorLedgerEntry."Due Date" <> 0D) and (VendorLedgerEntry."Due Date" < WorkDateValue) then begin
                        Cue."Overdue Amount" += VendorLedgerEntry."Remaining Amt. (LCY)";
                        Cue."Overdue Invoice Count" += 1;
                    end else begin
                        Cue."Not Due Amount" += VendorLedgerEntry."Remaining Amt. (LCY)";
                        Cue."Not Due Invoice Count" += 1;
                    end;
                end;
            until VendorLedgerEntry.Next() = 0;

        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Payment);
        VendorLedgerEntry.SetRange("Posting Date", MonthStart, MonthEnd);
        if VendorLedgerEntry.FindSet() then
            repeat
                Cue."Payments Made" += VendorLedgerEntry."Debit Amount (LCY)";
            until VendorLedgerEntry.Next() = 0;
    end;

    procedure CalculateReceivables(var Cue: Record "Receivables Cue"; WorkDateValue: Date; MonthStart: Date; MonthEnd: Date)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        Clear(Cue."Total Outstanding");
        Clear(Cue."Overdue Amount");
        Clear(Cue."Not Due Amount");
        Clear(Cue."Payments Received");
        Clear(Cue."Outstanding Invoice Count");
        Clear(Cue."Overdue Invoice Count");
        Clear(Cue."Not Due Invoice Count");

        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Invoice);
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry.CalcFields("Remaining Amt. (LCY)");
                if CustLedgerEntry."Remaining Amt. (LCY)" <> 0 then begin
                    Cue."Total Outstanding" += CustLedgerEntry."Remaining Amt. (LCY)";
                    Cue."Outstanding Invoice Count" += 1;
                    if (CustLedgerEntry."Due Date" <> 0D) and (CustLedgerEntry."Due Date" < WorkDateValue) then begin
                        Cue."Overdue Amount" += CustLedgerEntry."Remaining Amt. (LCY)";
                        Cue."Overdue Invoice Count" += 1;
                    end else begin
                        Cue."Not Due Amount" += CustLedgerEntry."Remaining Amt. (LCY)";
                        Cue."Not Due Invoice Count" += 1;
                    end;
                end;
            until CustLedgerEntry.Next() = 0;

        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Payment);
        CustLedgerEntry.SetRange("Posting Date", MonthStart, MonthEnd);
        if CustLedgerEntry.FindSet() then
            repeat
                Cue."Payments Received" += CustLedgerEntry."Credit Amount (LCY)";
            until CustLedgerEntry.Next() = 0;
    end;
}
