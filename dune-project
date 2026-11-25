(lang dune 3.0)
(name facial-geometry)
(version 0.1.0)
(generate_opam_files true)
(source (github visualcraft-lab/facial-geometry-ocaml))
(license MIT)
(authors "VisualCraft Lab <wzzhang96@gmail.com>")
(maintainers "VisualCraft Lab <wzzhang96@gmail.com>")
(homepage "https://looksmaxscale.com/")
(bug_reports "https://github.com/visualcraft-lab/facial-geometry-ocaml/issues")

(package
 (name facial-geometry)
 (synopsis "Pure-math 2D facial landmark geometry metrics")
 (description
  "OCaml library with no dependencies beyond the standard library for computing 2D facial landmark geometry metrics: canthal tilt angle, vertical facial thirds balance, golden ratio deviation, and bilateral mirror symmetry.")
 (depends
  (ocaml (>= 4.14))
  (dune (>= 3.0))))
