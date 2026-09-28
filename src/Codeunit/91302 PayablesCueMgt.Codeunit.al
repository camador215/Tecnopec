codeunit 91302 "Payables Mgt"
{
    procedure CalcTotalOutstanding(): Decimal
    var
        VendRemainAmt: Query "Vend. Remain. Amt.";
    begin
        VendRemainAmt.SetRange(
            Document_Type,
            "Gen. Journal Document Type"::Invoice);

        VendRemainAmt.SetRange(
            IsOpen,
            true);

        VendRemainAmt.Open();

        if VendRemainAmt.Read() then
            exit(VendRemainAmt.Remaining_Amt_LCY);

        exit(0);
    end;


    procedure CalcOverdueAmount(): Decimal
    var
        VendRemainAmt: Query "Vend. Remain. Amt.";
    begin
        VendRemainAmt.SetRange(
            Document_Type,
            "Gen. Journal Document Type"::Invoice);

        VendRemainAmt.SetRange(
            IsOpen,
            true);

        VendRemainAmt.SetFilter(
            Due_Date,
            '<%1',
            WorkDate());

        VendRemainAmt.Open();

        if VendRemainAmt.Read() then
            exit(VendRemainAmt.Remaining_Amt_LCY);

        exit(0);
    end;


    procedure CalcNotDueAmount(): Decimal
    var
        VendRemainAmt: Query "Vend. Remain. Amt.";
    begin
        VendRemainAmt.SetRange(
            Document_Type,
            "Gen. Journal Document Type"::Invoice);

        VendRemainAmt.SetRange(
            IsOpen,
            true);

        VendRemainAmt.SetFilter(
            Due_Date,
            '%1..|%2',
            WorkDate(),
            0D);

        VendRemainAmt.Open();

        if VendRemainAmt.Read() then
            exit(VendRemainAmt.Remaining_Amt_LCY);

        exit(0);
    end;


    // procedure CalcPaymentsMade(): Decimal
    // var
    //     VendPayments: Query "Vend. Payments Amt.";
    //     MonthStart: Date;
    //     MonthEnd: Date;
    // begin
    //     MonthStart := CalcDate('<-CM>', WorkDate());
    //     MonthEnd := CalcDate('<CM>', WorkDate());

    //     Message(
    //     'WorkDate: %1\MonthStart: %2\MonthEnd: %3',
    //     WorkDate(),
    //     MonthStart,
    //     MonthEnd);

    //     VendPayments.SetRange(
    //         Document_Type,
    //         "Gen. Journal Document Type"::Payment);

    //     VendPayments.SetRange(
    //         Posting_Date,
    //         MonthStart,
    //         MonthEnd);

    //     VendPayments.Open();

    //     if VendPayments.Read() then
    //         exit(VendPayments.Debit_Amount_LCY);

    //     exit(0);
    // end;


    procedure IsCachedCueDataExpired(
        PayablesCue: Record "Payables Cue";
        DataCacheComparisonDateTime: DateTime): Boolean
    begin
        if PayablesCue."Last Date/Time Modified" = 0DT then
            exit(true);

        exit(
            DataCacheComparisonDateTime -
            PayablesCue."Last Date/Time Modified" >=
            GetActivitiesCueRefreshInterval());
    end;


    local procedure GetActivitiesCueRefreshInterval() Interval: Duration
    var
        MinInterval: Duration;
    begin
        MinInterval := 2 * 60 * 1000; // 2 minutos
        Interval := 5 * 60 * 1000; // 5 minutos

        if Interval < MinInterval then
            Interval := MinInterval;
    end;
}