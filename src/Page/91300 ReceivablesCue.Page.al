page 91300 "Receivables Cue"
{
    Caption = 'Cuentas por cobrar';
    PageType = CardPart;
    SourceTable = "Receivables Cue";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            cuegroup(Amounts)
            {
                Caption = 'Importes';
                CuegroupLayout = Wide;

                field(TotalOutstanding; Rec."Total Outstanding")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Saldo total pendiente';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenCustomerEntries(0);
                    end;
                }
                field(OverdueAmount; Rec."Overdue Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Monto vencido';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenCustomerEntries(1);
                    end;
                }
                field(NotDueAmount; Rec."Not Due Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Monto no vencido';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenCustomerEntries(2);
                    end;
                }
                field(PaymentsReceived; Rec."Payments Received")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pagos recibidos';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenCustomerEntries(3);
                    end;
                }
            }
            cuegroup(Counts)
            {
                Caption = 'Cantidad de Facturas de Venta';

                field(OutstandingInvoiceCount; Rec."Outstanding Invoice Count")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Facturas pendientes';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenCustomerEntries(0);
                    end;
                }
                field(OverdueInvoiceCount; Rec."Overdue Invoice Count")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Facturas vencidas';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenCustomerEntries(1);
                    end;
                }
                field(NotDueInvoiceCount; Rec."Not Due Invoice Count")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Facturas no vencidas';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenCustomerEntries(2);
                    end;
                }
            }
            usercontrol(BusinessChart; BusinessChart)
            {
                ApplicationArea = Basic, Suite;
                trigger AddInReady()
                begin
                    UpdateChart();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Input: Dictionary of [Text, Text];
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
            Commit();
        end;
        SetDateFilters();
        CalculateCueFieldValues();
    end;

    var
        ChartMgt: Codeunit "Business Chart";
        ReceivablesMgt: Codeunit "Receivables Mgt";
        TaskIdCalculateCue: Integer;
        PBTList: Dictionary of [Integer, Text];
        PBTTelemetryMsgTxt: Label 'PBT errored with code %1 and text %2. The call stack is as follows %3.', Locked = true;
        RecordForUpdateCachedCueValuesIsLocked: Boolean;
        CachedCueValuesCalculationStartDateTime: DateTime;

    local procedure SetDateFilters()
    var
        WorkDateValue: Date;
    begin
        WorkDateValue := WorkDate();
        Rec."Work Date Filter" := WorkDateValue;
        Rec."Month Start Filter" := CalcDate('<-CM>', WorkDateValue);
        Rec."Month End Filter" := CalcDate('<CM>', WorkDateValue);
        Rec.SetFilter("Overdue Date Filter", '<%1', WorkDateValue);
        Rec.SetFilter("Not Due Date Filter", '%1..|%2', WorkDateValue, 0D);
        Rec.SetFilter("Month Date Filter", '%1..%2', Rec."Month Start Filter", Rec."Month End Filter");
    end;

    local procedure UpdateChart()
    var
        TotalOutstanding: Decimal;
        OverdueAmount: Decimal;
        NotDueAmount: Decimal;
    begin
        TotalOutstanding := Rec."Total Outstanding";
        OverdueAmount := Rec."Overdue Amount";
        NotDueAmount := Rec."Not Due Amount";

        ChartMgt.Initialize();
        ChartMgt.SetXDimension('Estado', Enum::"Business Chart Data Type"::String);
        ChartMgt.AddMeasure('Importe', 0, Enum::"Business Chart Data Type"::Decimal, Enum::"Business Chart Type"::Pie);
        ChartMgt.AddDataRowWithXDimension(StrSubstNo('Vencido (%1%)', Format(GetPercentage(OverdueAmount, TotalOutstanding))));
        ChartMgt.SetValue('Importe', 0, OverdueAmount);
        ChartMgt.AddDataRowWithXDimension(StrSubstNo('No vencido (%1%)', Format(GetPercentage(NotDueAmount, TotalOutstanding))));
        ChartMgt.SetValue('Importe', 1, NotDueAmount);
        ChartMgt.Update(CurrPage.BusinessChart);
    end;

    local procedure GetPercentage(Amount: Decimal; Total: Decimal): Decimal
    begin
        if Total = 0 then
            exit(0);
        exit(Round(Amount / Total * 100, 0.1));
    end;

    local procedure OpenCustomerEntries(FilterType: Integer)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        SetDateFilters();
        CustLedgerEntry.SetRange(Open, true);
        case FilterType of
            0:
                CustLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Invoice);
            1:
                begin
                    CustLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Invoice);
                    CustLedgerEntry.SetRange("Due Date", 0D, Rec."Work Date Filter");
                end;
            2:
                begin
                    CustLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Invoice);
                    CustLedgerEntry.SetFilter("Due Date", '%1..|%2', Rec."Work Date Filter", 0D);
                end;
            3:
                begin
                    CustLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Payment);
                    CustLedgerEntry.SetRange("Posting Date", Rec."Month Start Filter", Rec."Month End Filter");
                end;
        end;
        CustLedgerEntry.SetFilter("Remaining Amt. (LCY)", '>0');
        Page.Run(Page::"Customer Ledger Entries", CustLedgerEntry);
    end;

    local procedure SchedulePBT(FieldName: Text; FieldCaption: Text)
    var
        Input: Dictionary of [Text, Text];
        TimeoutinMs: Integer;
    begin
        TimeoutinMs := 2000; // Default timeout;
        Clear(Input);
        Input.Add(FieldName, '');
        CurrPage.EnqueueBackgroundTask(TaskIdCalculateCue, Codeunit::"Receivables Dictionary", Input, TimeoutInMs);
        if TaskIdCalculateCue <> 0 then
            PBTList.Add(TaskIdCalculateCue, FieldCaption);
    end;

    trigger OnPageBackgroundTaskCompleted(TaskId: Integer; Results: Dictionary of [Text, Text])
    var
        ReceivablesDictionary: Codeunit "Receivables Dictionary";
    begin
        // As PBT runs synchronously when running in test, the task is called even before PBTList is updated.
        // So, we use (TaskIdCalculateCue = TaskId) to check if the task is the one we are interested in.
        if PBTList.ContainsKey(TaskId) then begin
            if not RecordForUpdateCachedCueValuesIsLocked then begin
                Rec.LockTable(true);
                Rec.Get();
                RecordForUpdateCachedCueValuesIsLocked := true;
            end;
            ReceivablesDictionary.FillReceivablesCue(Results, Rec);
            if PBTList.ContainsKey(TaskId) then begin
                PBTList.Remove(TaskId);
                if PBTList.Count() = 0 then begin
                    RecordForUpdateCachedCueValuesIsLocked := false;
                    if CachedCueValuesCalculationStartDateTime <> 0DT then
                        Rec."Last Date/Time Modified" := CachedCueValuesCalculationStartDateTime;
                    Rec.Modify(true);
                    Commit();
                end;
            end;
            exit;
        end;

        // If task is finished before PBTList is updated.
        if TaskIdCalculateCue = TaskId then begin
            Rec.LockTable(true);
            Rec.Get();
            ReceivablesDictionary.FillReceivablesCue(Results, Rec);
            // Set new date/time if this is the last PBT task.
            if Results.ContainsKey(Rec.FieldName("Payments Received")) then
                Rec."Last Date/Time Modified" := CachedCueValuesCalculationStartDateTime;
            Rec.Modify(true);
            Commit();
            TaskIdCalculateCue := 0;
        end;
    end;

    procedure CalculateCueFieldValues()
    begin
        ClearExistingPageBackgroundTasks();
        CalculateCachedCueFieldValues();
    end;

    local procedure ClearExistingPageBackgroundTasks()
    var
        TaskId: Integer;
    begin
        if PBTList.Count() > 0 then
            foreach TaskId in PBTList.Keys() do begin
                CurrPage.CancelBackgroundTask(TaskId);
                PBTList.Remove(TaskId);
            end;
    end;

    local procedure CalculateCachedCueFieldValues()
    begin
        CachedCueValuesCalculationStartDateTime := CurrentDateTime();
        if not ReceivablesMgt.IsCachedCueDataExpired(Rec, CachedCueValuesCalculationStartDateTime) then begin
            Clear(CachedCueValuesCalculationStartDateTime);
            exit;
        end;

        SchedulePBT(Rec.FieldName("Total Outstanding"), Rec.FieldCaption("Total Outstanding"));
        SchedulePBT(Rec.FieldName("Overdue Amount"), Rec.FieldCaption("Overdue Amount"));
        SchedulePBT(Rec.FieldName("Not Due Amount"), Rec.FieldCaption("Not Due Amount"));
        SchedulePBT(Rec.FieldName("Payments Received"), Rec.FieldCaption("Payments Received"));
    end;
}
