#r @"../../SheetFill/packages-static/Funcalc.Corecalc.dll"
#r @"../../SheetFill/packages-static/Funcalc.dll"
#r @"../../SheetFill/packages-static/Funcalc.IO.dll"
#r @"../../SheetFill/SheetFill/bin/Release/SheetFill.dll"

open System

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

let genMap cols rows w =
    let wb = Workbook.createWithSheetsSized [("map", 2 * cols, rows + 1); ("@sdf", 10, 10)]
    genSdf <| wb.["@sdf"] |> ignore;
    let sheet = wb.["map"]
    Fill.constant ((0, 0), (cols - 1, rows - 1)) sheet w;
    Fill.constant ((cols, 0), (2 * cols - 1, rows - 1))
                  sheet
                  (sprintf "=FIB(RC[%d])" -cols);
    Workbook.save (sprintf "map-%d-%d-%d.xml" cols rows w) wb


match Array.tail fsi.CommandLineArgs with
    | [| s0; s1; s2|] ->
        let mutable cols = 100;
        let mutable rows = 100;
        let mutable w = 10;
        Int32.TryParse (s0, &cols) |> ignore;
        Int32.TryParse (s1, &rows) |> ignore;
        Int32.TryParse (s2, &w)    |> ignore;
        if genMap cols rows w then 0 else failwith "Failed."
    | _ -> failwith "Usage: map cols rows work."
