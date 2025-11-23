(lang dune 3.20)

(name rhul)

(generate_opam_files true)

(source
 (gitlab rhd0x7C3/rhul))

(authors "rhdCode0x7C3 <rhdCode0x7C3@icloud.com>")

(maintainers "rhdCode0x7C3 <rhdCode0x7C3@icloud.com>")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name rhul)
 (synopsis "rh-UserLand")
 (description "Shared library code for rhUL utilities.")
 (depends ocaml)
 )

(package
 (name rh-audio)
 (synopsis "rh-audio")
 (description "Linux audio control utility written in OCaml.")
 (depends ocaml)
 )

(package
 (name rh-backlight)
 (synopsis "rh-backlight")
 (description "Linux backlight control utility written in OCaml.")
 (depends ocaml)
 )

(package
 (name rh-network)
 (synopsis "rh-network")
 (description "Linux network control utility written in OCaml.")
 (depends ocaml)
 )
; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
