codeunit 91300 "Receivables Mgt"
{
    procedure CalcTotalOutstanding(): Decimal
    var
        CustRemainAmt: Query "Cust. Remain. Amt.";
    begin
        CustRemainAmt.SetFilter(
            Document_Type,
            '%1',
            "Gen. Journal Document Type"::Invoice);

        CustRemainAmt.SetFilter(
            IsOpen,
            '%1',
            true);

        CustRemainAmt.Open();

        if CustRemainAmt.Read() then
            exit(CustRemainAmt.Remaining_Amt_LCY);

        exit(0);
    end;


    procedure CalcOverdueAmount(): Decimal
    var
        CustRemainAmt: Query "Cust. Remain. Amt.";
    begin
        CustRemainAmt.SetFilter(
            Document_Type,
            '%1',
            "Gen. Journal Document Type"::Invoice);

        CustRemainAmt.SetFilter(
            IsOpen,
            '%1',
            true);

        CustRemainAmt.SetFilter(
            Due_Date,
            '<%1',
            WorkDate());

        CustRemainAmt.Open();

        if CustRemainAmt.Read() then
            exit(CustRemainAmt.Remaining_Amt_LCY);

        exit(0);
    end;


    procedure CalcNotDueAmount(): Decimal
    var
        CustRemainAmt: Query "Cust. Remain. Amt.";
    begin
        CustRemainAmt.SetFilter(
            Document_Type,
            '%1',
            "Gen. Journal Document Type"::Invoice);

        CustRemainAmt.SetFilter(
            IsOpen,
            '%1',
            true);

        CustRemainAmt.SetFilter(
            Due_Date,
            '%1..|%2',
            WorkDate(),
            0D);

        CustRemainAmt.Open();

        if CustRemainAmt.Read() then
            exit(CustRemainAmt.Remaining_Amt_LCY);

        exit(0);
    end;


    procedure CalcPaymentsReceived(): Decimal
    var
        CustPayments: Query "Cust. Payments Amt.";
        MonthStart: Date;
        MonthEnd: Date;
    begin
        MonthStart := CalcDate('<-CM>', WorkDate());
        MonthEnd := CalcDate('<CM>', WorkDate());

        CustPayments.SetFilter(
            Document_Type,
            '%1',
            "Gen. Journal Document Type"::Payment);

        CustPayments.SetFilter(
            Posting_Date,
            '%1..|%2',
            MonthStart,
            MonthEnd);

        CustPayments.Open();

        if CustPayments.Read() then
            exit(CustPayments.Credit_Amount_LCY);

        exit(0);
    end;

    procedure IsCachedCueDataExpired(ActivitiesCue: Record "Receivables Cue"; DataCacheComparisonDateTime: DateTime): Boolean
    begin
        if ActivitiesCue."Last Date/Time Modified" = 0DT then
            exit(true);

        exit(DataCacheComparisonDateTime - ActivitiesCue."Last Date/Time Modified" >= GetActivitiesCueRefreshInterval())
    end;

    local procedure GetActivitiesCueRefreshInterval() Interval: Duration
    var
        MinInterval: Duration;
    begin
        MinInterval := 2 * 60 * 1000; // 2 minutes
        Interval := 5 * 60 * 1000; // 5 minutes
        if Interval < MinInterval then
            Interval := MinInterval;
    end;
}