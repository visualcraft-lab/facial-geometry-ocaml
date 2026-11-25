open Facial_geometry

let near a b = Float.abs (a -. b) <= 1e-9

let () =
  (match
     canthal_tilt_deg ~medial:{ x = 100.0; y = 200.0 }
       ~lateral:{ x = 140.0; y = 193.0 }
   with
  | Ok deg -> assert (deg > 9.0 && deg < 10.5)
  | Error msg -> failwith msg);

  (match
     canthal_tilt_deg ~medial:{ x = 100.0; y = 200.0 }
       ~lateral:{ x = 100.0; y = 195.0 }
   with
  | Error _ -> ()
  | Ok _ -> failwith "expected error on zero span");

  (match
     canthal_tilt_deg ~medial:{ x = Float.nan; y = 200.0 }
       ~lateral:{ x = 140.0; y = 193.0 }
   with
  | Error _ -> ()
  | Ok _ -> failwith "expected error on NaN");

  (match
     compute_facial_thirds ~trichion_y:100.0 ~glabella_y:200.0
       ~subnasale_y:300.0 ~menton_y:400.0
   with
  | Ok t ->
    assert (near t.upper (1.0 /. 3.0));
    assert (near t.balance_score 1.0)
  | Error msg -> failwith msg);

  (match
     compute_facial_thirds ~trichion_y:0.0 ~glabella_y:1.0 ~subnasale_y:2.0
       ~menton_y:Float.infinity
   with
  | Error _ -> ()
  | Ok _ -> failwith "expected error on infinity");

  (match golden_ratio_delta ~face_height:phi ~face_width:1.0 with
  | Ok gr ->
    assert (near gr.ratio phi);
    assert (near gr.delta 0.0)
  | Error msg -> failwith msg);

  (match golden_ratio_delta ~face_height:Float.nan ~face_width:1.0 with
  | Error _ -> ()
  | Ok _ -> failwith "expected error on NaN");

  let pairs =
    [
      { left = { x = 160.0; y = 200.0 }; right = { x = 240.0; y = 200.0 } };
      { left = { x = 170.0; y = 260.0 }; right = { x = 230.0; y = 260.0 } };
    ]
  in
  (match bilateral_symmetry ~pairs ~midline_x:200.0 ~face_width:160.0 with
  | Ok s -> assert (near s 1.0)
  | Error msg -> failwith msg);

  print_endline "All facial_geometry OCaml tests passed."
