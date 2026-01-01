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
 (synopsis "Rh-UserLand")
 (description "Shared library code for rhUL utilities.")
 (depends (ocaml (>= 5.4.0))
          (core (>= 0.17.1))
          (core_unix (>= 0.17.1))
          (ppx_deriving (>= 6.1.1))
  ;; Dev setup
           (utop :with-dev-setup)
           (ocamlformat :with-dev-setup)
           (ocp-indent :with-dev-setup)
           (merlin :with-dev-setup)
           (ocaml-lsp-server :with-dev-setup)
           (alcotest :with-test)))

(package
 (name rh-audio)
 (synopsis "Rh-audio")
 (description "Linux audio control utility written in OCaml.")
 (depends (ocaml (>= 5.4.0))
          (obus (>= 1.2.5)))
 )

(package
 (name rh-backlight)
 (synopsis "Rh-backlight")
 (description "Linux backlight control utility written in OCaml.")
 (depends (ocaml (>= 5.4.0))
          (cmdliner (>= 2.1.0))
          (ppx_deriving (>= 6.1.1))
           (alcotest :with-test)))

(package
 (name rh-network)
 (synopsis "Rh-network")
 (description "Linux network control utility written in OCaml.")
 (depends (ocaml (>= 5.4.0)))
 )
; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
