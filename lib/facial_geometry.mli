(** Pure-math 2D facial landmark geometry metrics in top-down image space
    ([x] increases right, [y] increases downward). *)

val phi : float
(** The golden ratio constant [(1.0 +. sqrt 5.0) /. 2.0]. *)

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

val canthal_tilt_deg : medial:point2d -> lateral:point2d -> (float, string) result
(** Computes the medial-to-lateral canthal tilt angle in degrees.
    Positive degrees indicate an upward lateral tilt in top-down image space. *)

val compute_facial_thirds :
  trichion_y:float ->
  glabella_y:float ->
  subnasale_y:float ->
  menton_y:float ->
  (facial_thirds, string) result
(** Computes normalized vertical facial thirds and an L1 balance score in [[0, 1]]. *)

val golden_ratio_delta :
  face_height:float -> face_width:float -> (golden_ratio_result, string) result
(** Computes [face_height /. face_width] and its signed deviation from {!phi}. *)

val bilateral_symmetry :
  pairs:landmark_pair list ->
  midline_x:float ->
  face_width:float ->
  (float, string) result
(** Computes a normalized bilateral mirror symmetry score in [[0, 1]]. *)
