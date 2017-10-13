#r @"../SheetFill/packages-static/Funcalc.Corecalc.dll"
#r @"../SheetFill/packages-static/Funcalc.dll"
#r @"../SheetFill/packages-static/Funcalc.IO.dll"
#r @"../SheetFill/SheetFill/bin/Debug/SheetFill.dll"

open System

open SheetFill
open SheetFill.SDF
open SheetFill.Sheet
open SheetFill.Workbook

// let name  = "map"
let name  = "prefix"
let wb    = Workbook.createWithSheetsSized [(name, 200, 100)]
let sheet = wb.[name]

let rnd = Random(23)
Fill.range ((0, 0), (99, 99)) sheet (fun c r -> rnd.NextDouble() * 1000.0)
// Fill.constant ((100, 0), (199, 99)) sheet "=SIN(RC[-100])"
Fill.constant ((100, 0), (199,  0)) sheet 0
Fill.constant ((100, 0), (100, 99)) sheet 0
Fill.constant ((101, 1), (199, 99)) sheet "=SIN(RC[-100] + RC[-1] + R[-1]C + R[-1]C[-1])"

if Workbook.save (sprintf "./synth-%s.xml" name) wb then
    printfn "Saved."
else
    printfn "Failed?"
