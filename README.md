# facial-geometry-ocaml

OCaml library with no dependencies beyond the standard library for computing 2D facial landmark geometry metrics (canthal tilt angle, vertical facial thirds balance, golden ratio deviation, and bilateral mirror symmetry).

## Install

```bash
opam install facial-geometry
```

## Example

```ocaml
open Facial_geometry

let () =
  match canthal_tilt_deg ~medial:{ x = 100.0; y = 200.0 } ~lateral:{ x = 140.0; y = 195.0 } with
  | Ok deg -> Printf.printf "Canthal tilt: %.2f deg\n" deg
  | Error msg -> prerr_endline msg
```

## Online Tool

Companion web calculator and landmark diagrams: [Looksmax Scale](https://looksmaxscale.com/).

## License

MIT
