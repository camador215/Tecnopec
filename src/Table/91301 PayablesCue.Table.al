table 91301 "Payables Cue"
{
    Caption = 'Cuentas por pagar';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Clave primaria';
        }
        field(10; "Work Date Filter"; Date)
        {
            Caption = 'Fecha de trabajo';
            FieldClass = FlowFilter;
        }
        field(11; "Month Start Filter"; Date)
        {
            Caption = 'Inicio del mes';
            FieldClass = FlowFilter;
        }
        field(12; "Month End Filter"; Date)
        {
            Caption = 'Fin del mes';
            FieldClass = FlowFilter;
        }
        field(13; "Overdue Date Filter"; Date)
        {
            Caption = 'Filtro de vencimiento';
            FieldClass = FlowFilter;
        }
        field(14; "Not Due Date Filter"; Date)
        {
            Caption = 'Filtro de no vencimiento';
            FieldClass = FlowFilter;
        }
        field(15; "Month Date Filter"; Date)
        {
            Caption = 'Filtro del mes';
            FieldClass = FlowFilter;
        }
        field(20; "Total Outstanding"; Decimal)
        {
            Caption = 'Saldo total pendiente';
        }
        field(21; "Overdue Amount"; Decimal)
        {
            Caption = 'Monto vencido';
        }
        field(22; "Not Due Amount"; Decimal)
        {
            Caption = 'Monto no vencido';
        }
        field(23; "Payments Made"; Decimal)
        {
            Caption = 'Pagos realizados';
        }
        field(30; "Outstanding Invoice Count"; Integer)
        {
            Caption = 'Facturas pendientes';
            CalcFormula = count("Vendor Ledger Entry"
                where(
                    "Document Type" = const(Invoice),
                    Open = const(true)
                ));
            FieldClass = FlowField;
        }
        field(31; "Overdue Invoice Count"; Integer)
        {
            Caption = 'Facturas vencidas';
            CalcFormula = count("Vendor Ledger Entry"
                where(
                    "Document Type" = const(Invoice),
                    Open = const(true),
                    "Due Date" = field("Overdue Date Filter")
                ));
            FieldClass = FlowField;
        }
        field(32; "Not Due Invoice Count"; Integer)
        {
            Caption = 'Facturas no vencidas';
            CalcFormula = count("Vendor Ledger Entry"
                where(
                    "Document Type" = const(Invoice),
                    Open = const(true),
                    "Due Date" = field("Not Due Date Filter")
                ));
            FieldClass = FlowField;
        }
        field(33; "Last Date/Time Modified"; DateTime)
        {
            Caption = 'Last Date/Time Modified';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    local procedure GetAmountFormat(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        AmountFormat: Text;
    begin
        AmountFormat := TypeHelper.GetAmountFormatLCYWithUserLocale().Trim();

        if AmountFormat = '<Precision,0:0><Standard Format,0>' then
            exit('$' + '<Precision,0:0><Standard Format,0>');

        exit(AmountFormat);
    end;
}
