page 91301 "Payables Cue"
{
    Caption = 'Cuentas por pagar';
    PageType = CardPart;
    SourceTable = "Payables Cue";
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
                    ApplicationArea = All;
                    Caption = 'Saldo total pendiente';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenVendorEntries(0);
                    end;
                }
                field(OverdueAmount; Rec."Overdue Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Monto vencido';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenVendorEntries(1);
                    end;
                }
                field(NotDueAmount; Rec."Not Due Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Monto no vencido';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenVendorEntries(2);
                    end;
                }
                field(PaymentsMade; Rec."Payments Made")
                {
                    ApplicationArea = All;
                    Caption = 'Pagos realizados';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenVendorEntries(3);
                    end;
                }
            }
            cuegroup(Counts)
            {
                Caption = 'Facturas de Compras';

                field(OutstandingInvoiceCount; Rec."Outstanding Invoice Count")
                {
                    ApplicationArea = All;
                    Caption = 'Facturas pendientes';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenVendorEntries(0);
                    end;
                }
                field(OverdueInvoiceCount; Rec."Overdue Invoice Count")
                {
                    ApplicationArea = All;
                    Caption = 'Facturas vencidas';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenVendorEntries(1);
                    end;
                }
                field(NotDueInvoiceCount; Rec."Not Due Invoice Count")
                {
                    ApplicationArea = All;
                    Caption = 'Facturas no vencidas';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        OpenVendorEntries(2);
                    end;
                }
            }
            usercontrol(BusinessChart; BusinessChart)
            {
                ApplicationArea = All;
                trigger AddInReady()
                begin
                    UpdateChart();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('DEFAULT') then begin
            Rec.Init();
            Rec."Primary Key" := 'DEFAULT';
            Rec.Insert();
        end;
        SetDateFilters();
        // CueMgt.CalculatePayables(Rec, Rec."Work Date Filter", Rec."Month Start Filter", Rec."Month End Filter");
    end;

    var
        ChartMgt: Codeunit "Business Chart";
        CueMgt: Codeunit "Receivables Mgt";

    local procedure SetDateFilters()
    var
        WorkDateValue: Date;
    begin
        WorkDateValue := WorkDate();
        Rec."Work Date Filter" := WorkDateValue;
        Rec."Month Start Filter" := CalcDate('<-CM>', WorkDateValue);
        Rec."Month End Filter" := CalcDate('<CM>', WorkDateValue);
        Rec.SetFilter("Overdue Date Filter", '..%1', WorkDateValue);
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

    local procedure OpenVendorEntries(FilterType: Integer)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        SetDateFilters();
        VendorLedgerEntry.SetRange(Open, true);
        case FilterType of
            0:
                VendorLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Invoice);
            1:
                begin
                    VendorLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Invoice);
                    VendorLedgerEntry.SetRange("Due Date", 0D, Rec."Work Date Filter");
                end;
            2:
                begin
                    VendorLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Invoice);
                    VendorLedgerEntry.SetFilter("Due Date", '%1..|%2', Rec."Work Date Filter", 0D);
                end;
            3:
                begin
                    VendorLedgerEntry.SetRange("Document Type", Enum::"Gen. Journal Document Type"::Payment);
                    VendorLedgerEntry.SetRange("Posting Date", Rec."Month Start Filter", Rec."Month End Filter");
                end;
        end;
        VendorLedgerEntry.SetFilter("Remaining Amt. (LCY)", '<>0');
        Page.Run(Page::"Vendor Ledger Entries", VendorLedgerEntry);
    end;
}
