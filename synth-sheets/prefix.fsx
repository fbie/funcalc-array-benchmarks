#r @"../../SheetFill/packages-static/Funcalc.Corecalc.dll"
#r @"../../SheetFill/packages-static/Funcalc.dll"
#r @"../../SheetFill/packages-static/Funcalc.IO.dll"
#r @"../../SheetFill/packages/CommandLineParser/lib/net45/CommandLine.dll"
#r @"../../SheetFill/SheetFill/bin/Release/SheetFill.dll"

open System
open CommandLine
open SheetFill
open SheetFill.SDF
open SheetFill.Sheet
open SheetFill.Workbook

let genSdf sheet =
    let fib = {
        name              = "FIB"
        inputCells        = [("B2", "10")]
        intermediateCells = []
        outputCell        = ("B3", "=IF(B2 <= 1, 1, FIB(B2 - 1) + FIB(B2 - 2))")
        }
    SDF.create fib (0, 0) sheet

let genPrefix cols rows w =
    let name  = "prefix"
    let wb    = Workbook.createWithSheetsSized [(name, 2 * cols + 1, rows + 1); ("@sdf", 10, 10)]
    genSdf <| wb.["@sdf"] |> ignore;
    let sheet = wb.[name]
    Fill.constant ((0, 1), (cols - 1, rows)) sheet w;
    Fill.constant ((cols, 0), (2 * cols, 0)) sheet 0
    Fill.constant ((cols, 0), (cols, rows))  sheet 0
    Fill.constant ((cols + 1, 1), (2 * cols, rows))
                  sheet
                  (sprintf "=FIB(RC[%d]) + RC[-1] + R[-1]C + R[-1]C[-1]" -(cols + 1))
    Workbook.save (sprintf "prefix-%i-%i-%i.xml" cols rows w) wb

type Options = {
    [<Value(0, MetaName = "cols", Required = true, HelpText = "Columns of the sheet")>]
    cols : int

    [<Value(1, MetaName = "rows", Required = true, HelpText = "Rows of the sheet")>]
    rows : int

    [<Value(2, MetaName = "work", Required = true, HelpText = "Argument to call FIB with")>]
    work : int
}

match Parser.Default.ParseArguments<Options> fsi.CommandLineArgs.[1..] with
| :? Parsed<Options> as parsed when genPrefix parsed.Value.cols parsed.Value.rows parsed.Value.work -> 0
| _ -> 1
