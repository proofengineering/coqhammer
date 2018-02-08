
let unique cmp lst =
  let rec pom prev lst =
    match lst with
    | [] -> []
    | h :: t ->
      if cmp prev h = 0 then
	pom prev t
      else
	h :: pom h t
  in
  match lst with
  | [] -> []
  | h :: t -> h :: pom h t

let sort_uniq cmp lst =
  unique cmp (List.sort cmp lst)

let rec take n lst =
  if n = 0 then
    []
  else
    match lst with
    | [] -> []
    | h :: t -> h :: take (n - 1) t

let rec drop n lst =
  if n = 0 then
    lst
  else
    match lst with
    | [] -> []
    | h :: t -> drop (n - 1) t
       
let rec rev_combine lst1 lst2 acc =
  match lst1, lst2 with
  | h1 :: t1, h2 :: t2 ->
      rev_combine t1 t2 ((h1, h2) :: acc)
  | [], [] ->
      acc
  | _ ->
      raise (Invalid_argument "rev_combine")

let index x =
  let rec ind n l =
    match l with
      [] -> failwith "index"
    | (h::t) -> if Pervasives.compare x h = 0 then n else ind (n + 1) t in
  ind 0;;

let assoc_index x =
  let rec ind n l =
    match l with
      [] -> failwith "assoc_index"
    | ((y,_)::t) -> if Pervasives.compare x y = 0 then n else ind (n + 1) t
  in
  ind 0;;

let massoc x lst =
  try
    Some (List.assoc x lst)
  with Not_found ->
    None

let string_contains s1 s2 =
  let re = Str.regexp_string s2
  in
  try ignore (Str.search_forward re s1 0); true
  with Not_found -> false

let string_begins_with s1 s2 =
  try
    String.sub s1 0 (String.length s2) = s2
  with _ ->
    false

let drop_prefix s pref =
  if string_begins_with s pref then
    let plen = String.length pref in
    String.sub s plen (String.length s - plen)
  else
    s
