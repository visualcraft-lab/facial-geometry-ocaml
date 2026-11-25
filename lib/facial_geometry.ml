let phi = 1.618033988749895

type point2d = {
  x : float;
  y : float;
}

type landmark_pair = {
  left : point2d;
  right : point2d;
}

type facial_thirds = {
  upper : float;
  middle : float;
  lower : float;
  balance_score : float;
}

type golden_ratio_result = {
  ratio : float;
  delta : float;
}

let is_finite_point p = Float.is_finite p.x && Float.is_finite p.y

let clamp01 v = Float.max 0.0 (Float.min 1.0 v)

let canthal_tilt_deg ~medial ~lateral =
  if not (is_finite_point medial && is_finite_point lateral) then
    Error "landmark coordinates must be finite"
  else
    let dx = Float.abs (lateral.x -. medial.x) in
    if dx <= 1e-12 then
      Error "medial and lateral x coordinates must differ"
    else
      let dy_up = medial.y -. lateral.y in
      Ok (Float.atan2 dy_up dx *. (180.0 /. Float.pi))

let compute_facial_thirds ~trichion_y ~glabella_y ~subnasale_y ~menton_y =
  if
    not
      (Float.is_finite trichion_y
      && Float.is_finite glabella_y
      && Float.is_finite subnasale_y
      && Float.is_finite menton_y)
  then
    Error "y coordinates must be finite"
  else if
    not
      (trichion_y < glabella_y
      && glabella_y < subnasale_y
      && subnasale_y < menton_y)
  then
    Error "y coordinates must strictly increase from trichion to menton"
  else
    let total = menton_y -. trichion_y in
    let upper = (glabella_y -. trichion_y) /. total in
    let middle = (subnasale_y -. glabella_y) /. total in
    let lower = (menton_y -. subnasale_y) /. total in
    let target = 1.0 /. 3.0 in
    let l1 =
      Float.abs (upper -. target)
      +. Float.abs (middle -. target)
      +. Float.abs (lower -. target)
    in
    let balance_score = clamp01 (1.0 -. (l1 /. (4.0 /. 3.0))) in
    Ok { upper; middle; lower; balance_score }

let golden_ratio_delta ~face_height ~face_width =
  if not (Float.is_finite face_height && Float.is_finite face_width) then
    Error "dimensions must be finite"
  else if face_height <= 0.0 || face_width <= 0.0 then
    Error "dimensions must be positive"
  else
    let ratio = face_height /. face_width in
    Ok { ratio; delta = ratio -. phi }

let bilateral_symmetry ~pairs ~midline_x ~face_width =
  match pairs with
  | [] -> Error "pairs must be non-empty"
  | _ ->
    if not (Float.is_finite midline_x && Float.is_finite face_width) then
      Error "midline_x and face_width must be finite"
    else if face_width <= 0.0 then
      Error "face_width must be positive"
    else if
      not
        (List.for_all
           (fun p -> is_finite_point p.left && is_finite_point p.right)
           pairs)
    then
      Error "all landmark coordinates must be finite"
    else
      let sum_err =
        List.fold_left
          (fun acc p ->
            let mirrored_lx = (2.0 *. midline_x) -. p.left.x in
            let dx = mirrored_lx -. p.right.x in
            let dy = p.left.y -. p.right.y in
            acc +. Float.hypot dx dy)
          0.0 pairs
      in
      let mean_err = sum_err /. float_of_int (List.length pairs) in
      Ok (clamp01 (1.0 -. (mean_err /. face_width)))
