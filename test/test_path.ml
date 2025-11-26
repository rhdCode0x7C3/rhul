open Core
open Alcotest
open Rhul

let result_path =
  result
    (testable Path.pp Path.equal)
    (testable
       (fun ppf e -> Format.fprintf ppf "%s" (Path.error_to_string e))
       (fun a b ->
         String.equal (Path.error_to_string a) (Path.error_to_string b)))

let path = testable Path.pp Path.equal

let test_roundtrip_abs () =
  let input = "/absolute/path/to/file" in
  let expected = input in
  let f i = Path.of_string i |> Path.to_string in
  (check string) "same string" expected (f input)

let test_roundtrip_rel () =
  let input = "./relative/to/file" in
  let expected = input in
  let f i = Path.of_string i |> Path.to_string in
  (check string) "same string" expected (f input)

let test_roundtrip_malformed () =
  let input = "./relative///////////////to/file" in
  let expected = "./relative/to/file" in
  let f i = Path.of_string i |> Path.to_string in
  (check string) "removed sequential slashes" expected (f input)

let test_equal () =
  let input1 = Path.of_string "/path/to/file" in
  let input2 = Path.of_string "/path/to/file" in
  let expected = true in
  let f i1 i2 = Path.equal i1 i2 in
  (check bool) "paths are equal" expected (f input1 input2)

let test_not_equal () =
  let input1 = Path.of_string "/path/to/file" in
  let input2 = Path.of_string "/path/to/another/file" in
  let expected = false in
  let f i1 i2 = Path.equal i1 i2 in
  (check bool) "paths are  not equal" expected (f input1 input2)

let test_is_absolute () =
  let input = Path.of_string "/path/to/file" in
  let expected = true in
  let f = Path.is_absolute in
  (check bool) "path is absolute" expected (f input)

let test_is_not_absolute () =
  let input = Path.of_string "path/to/file" in
  let expected = false in
  let f = Path.is_absolute in
  (check bool) "path is not absolute" expected (f input)

let test_is_relative () =
  let input = Path.of_string "path/to/file" in
  let expected = true in
  let f = Path.is_relative in
  (check bool) "path is relative" expected (f input)

let test_is_not_relative () =
  let input = Path.of_string "/path/to/file" in
  let expected = false in
  let f = Path.is_relative in
  (check bool) "path is not relative" expected (f input)

let test_append () =
  let prefix = Path.of_string "/some/abs/path" in
  let suffix = Path.of_string "some/rel/path" in
  let expected = Ok (Path.of_string "/some/abs/path/some/rel/path") in
  let f = Path.append in
  (check result_path) "path is appended correctly" expected
    (f ~relative:suffix ~to_path:prefix)

let test_append_with_abs_sx () =
  let prefix = Path.of_string "/some/abs/path" in
  let suffix = Path.of_string "/another/abs/path" in
  let expected = Error (Path.Validation suffix) in
  let f = Path.append in
  (check result_path) "path validation failed" expected
    (f ~relative:suffix ~to_path:prefix)

let test_append_unsafe () =
  let prefix = Path.of_string "/some/abs/path" in
  let suffix = Path.of_string "/another/abs/path" in
  let expected = Path.of_string "/some/abs/path/another/abs/path" in
  let f = Path.append_unsafe in
  (check path) "path is appended unsafely" expected (f suffix prefix)

let test_prepend () =
  let prefix = Path.of_string "/some/abs/path" in
  let suffix = Path.of_string "/another/abs/path" in
  let expected = Path.of_string "/some/abs/path/another/abs/path" in
  let f = Path.prepend in
  (check path) "path is prepended correctly" expected (f prefix ~to_path:suffix)

let test_parent () =
  let input = Path.of_string "/some/abs/path" in
  let expected = Path.of_string "/some/abs" in
  let f = Path.parent in
  (check path) "parent is returned" expected (f input)

let () =
  run "Path"
    [
      ( "Roundtrip",
        [
          test_case "Roundtrip absolute" `Quick test_roundtrip_abs;
          test_case "Roundtrip relative" `Quick test_roundtrip_rel;
          test_case "Roundtrip malformed" `Quick test_roundtrip_malformed;
        ] );
      ( "Equality",
        [
          test_case "Equal" `Quick test_equal;
          test_case "Not equal" `Quick test_not_equal;
        ] );
      ( "Variants",
        [
          test_case "Is Absolute" `Quick test_is_absolute;
          test_case "Is not Absolute" `Quick test_is_not_absolute;
          test_case "Is Relative" `Quick test_is_relative;
          test_case "Is not Relative" `Quick test_is_not_relative;
        ] );
      ( "Append",
        [
          test_case "Append succeeds" `Quick test_append;
          test_case "Append fails" `Quick test_append_with_abs_sx;
          test_case "Unsafe append" `Quick test_append_unsafe;
          test_case "Prepend" `Quick test_prepend;
        ] );
      ("Parent", [ test_case "Parent" `Quick test_parent ]);
    ]
