type state = Off | Half | On
type kb = { current : state; previous : state }

let make = { current = Off; previous = Off }

let up (kb : kb) =
  let new_val = match kb.current with Off -> Half | Half -> On | On -> On in
  new_val

let down (kb : kb) =
  let new_val = match kb.current with Off -> Off | Half -> Off | On -> Half in
  new_val

let toggle (kb : kb) =
  let new_val =
    match kb.current with Off -> kb.previous | Half -> Off | On -> Off
  in
  new_val

let change f (kb : kb) =
  let new_val = f kb in
  { current = new_val; previous = kb.current }
