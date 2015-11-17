(* Generated by Lem from gnu_extensions/gnu_ext_section_header_table.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

(** The module [gnu_ext_section_header_table] implements function, definitions
  * and types relating to the GNU extensions to the standard ELF section header
  * table.
  *)

Require Import lem_basic_classes.
Require Export lem_basic_classes.

Require Import lem_bool.
Require Export lem_bool.

Require Import lem_map.
Require Export lem_map.

Require Import lem_maybe.
Require Export lem_maybe.

Require Import lem_num.
Require Export lem_num.

Require Import lem_string.
Require Export lem_string.


Require Import hex_printing.
Require Export hex_printing.


Require Import error.
Require Export error.

Require Import string_table.
Require Export string_table.

Require Import show.
Require Export show.


Require Import elf_section_header_table.
Require Export elf_section_header_table.

Require Import elf_interpreted_section.
Require Export elf_interpreted_section.


(** GNU extended section types *)

(** [GNU_HASH] does not appear to be defined in the LSB but is present in
  * several ELF binaries collected in the wild...
  *
  * TODO: find out where this comes from?
  * ANSW: a mailing list apparently!  See here:
  *   https://sourceware.org/ml/binutils/2006-10/msg00377.html
  *)
Definition sht_gnu_hash       :  nat :=  ( Coq.Init.Peano.mult( 2)( 939524091)).     (* 0x6FFFFFF6 *)

(** The following are all defined in Section 10.2.2.2 of the LSB as additional
  * section types over the ones defined in the SCO ELF spec.
  *)

(** [sht_gnu_verdef] contains the symbol versions that are provided.
  *)
Definition sht_gnu_verdef     :  nat :=  Coq.Init.Peano.minus ( Coq.Init.Peano.mult( 2)( 939524095))( 1). (* 0x6ffffffd *)
(** [sht_gnu_verneed] contains the symbol versions that are required.
  *)
Definition sht_gnu_verneed    :  nat :=  ( Coq.Init.Peano.mult( 2)( 939524095)).     (* 0x6ffffffe *)
(** [sht_gnu_versym] contains the symbol version table.
  *)
Definition sht_gnu_versym     :  nat :=  Coq.Init.Peano.plus ( Coq.Init.Peano.mult( 2)( 939524095))( 1). (* 0x6fffffff *)
(** [sht_gnu_liblist] appears to be undocumented but appears in PowerPC 64 ELF
  * binaries in "the wild".
  *)
Definition sht_gnu_liblist    :  nat :=  Coq.Init.Peano.plus ( Coq.Init.Peano.mult( 2)( 939524091))( 1).
(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

Definition gnu_ext_additional_special_sections   : fmap (string ) ((nat *nat ) % type):= 
  lem_map.fromList [
    (".ctors", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_write))
  ; (".data.rel.ro", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_write))
  ; (".dtors", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_write))
  ; (".eh_frame", (sht_progbits, shf_alloc))
  ; (".eh_frame_hdr", (sht_progbits, shf_alloc))
  ; (".gcc_execpt_table", (sht_progbits, shf_alloc))
  ; (".gnu.version", (sht_gnu_versym, shf_alloc))
  ; (".gnu.version_d", (sht_gnu_verdef, shf_alloc))
  ; (".gnu.version_r", (sht_gnu_verneed, shf_alloc))
  ; (".got.plt", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_write))
  ; (".jcr", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_write))
  ; (".note.ABI-tag", (sht_note, shf_alloc))
  ; (".stab", (sht_progbits, 0))
  ; (".stabstr", (sht_strtab, 0))]
  .
(* [?]: removed value specification. *)

Definition is_valid_gnu_ext_elf32_section_header_table_entry  (ent : elf32_interpreted_section ) (stbl : string_table )  : bool := 
  match ( string_table.get_string_at(elf32_section_name ent) stbl) with 
    | Fail    f    => false
    | Success name1 =>
      match ( (fmap_lookup_by (fun (x : string ) (y : string )=>EQ) name1 gnu_ext_additional_special_sections)) with 
        | None           =>
            is_valid_elf32_section_header_table_entry ent stbl
        | Some (typ,  flags) => beq_nat
            typ(elf32_section_type ent) && beq_nat flags(elf32_section_flags ent)
      end
  end.
(* [?]: removed value specification. *)

Definition is_valid_gnu_ext_elf32_section_header_table  (ents : list (elf32_interpreted_section )) (stbl : string_table )  : bool := 
  List.forallb (fun (x : elf32_interpreted_section ) => is_valid_gnu_ext_elf32_section_header_table_entry x stbl) ents.
(* [?]: removed value specification. *)

Definition is_valid_gnu_ext_elf64_section_header_table_entry  (ent : elf64_interpreted_section ) (stbl : string_table )  : bool := 
  match ( string_table.get_string_at(elf64_section_name ent) stbl) with 
    | Fail    f    => false
    | Success name1 =>
      match ( (fmap_lookup_by (fun (x : string ) (y : string )=>EQ) name1 gnu_ext_additional_special_sections)) with 
        | None           =>
            is_valid_elf64_section_header_table_entry ent stbl
        | Some (typ,  flags) => beq_nat
            typ(elf64_section_type ent) && beq_nat flags(elf64_section_flags ent)
      end
  end.
(* [?]: removed value specification. *)

Definition is_valid_gnu_ext_elf64_section_header_table  (ents : list (elf64_interpreted_section )) (stbl : string_table )  : bool := 
  List.forallb (fun (x : elf64_interpreted_section ) => is_valid_gnu_ext_elf64_section_header_table_entry x stbl) ents.