chapter {* Generated by Lem from gnu_extensions/gnu_ext_section_header_table.lem. *}

theory "Gnu_ext_section_header_table" 

imports 
 	 Main
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_bool" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_maybe" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_string" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Show" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Error" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/String_table" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_map" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_section_header_table" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_interpreted_section" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Hex_printing" 

begin 

(** The module [gnu_ext_section_header_table] implements function, definitions
  * and types relating to the GNU extensions to the standard ELF section header
  * table.
  *)

(*open import Basic_classes*)
(*open import Bool*)
(*open import Map*)
(*open import Maybe*)
(*open import Num*)
(*open import String*)

(*open import Hex_printing*)

(*open import Error*)
(*open import String_table*)
(*open import Show*)

(*open import Elf_section_header_table*)
(*open import Elf_interpreted_section*)

(** GNU extended section types *)

(** [GNU_HASH] does not appear to be defined in the LSB but is present in
  * several ELF binaries collected in the wild...
  *
  * TODO: find out where this comes from?
  * ANSW: a mailing list apparently!  See here:
  *   https://sourceware.org/ml/binutils/2006-10/msg00377.html
  *)
definition sht_gnu_hash  :: " nat "  where 
     " sht_gnu_hash = ( (( 2 :: nat) *( 939524091 :: nat)))"
     (* 0x6FFFFFF6 *)

(** The following are all defined in Section 10.2.2.2 of the LSB as additional
  * section types over the ones defined in the SCO ELF spec.
  *)

(** [sht_gnu_verdef] contains the symbol versions that are provided.
  *)
definition sht_gnu_verdef  :: " nat "  where 
     " sht_gnu_verdef = ( (( 2 :: nat) *( 939524095 :: nat)) -( 1 :: nat))"
 (* 0x6ffffffd *)
(** [sht_gnu_verneed] contains the symbol versions that are required.
  *)
definition sht_gnu_verneed  :: " nat "  where 
     " sht_gnu_verneed = ( (( 2 :: nat) *( 939524095 :: nat)))"
     (* 0x6ffffffe *)
(** [sht_gnu_versym] contains the symbol version table.
  *)
definition sht_gnu_versym  :: " nat "  where 
     " sht_gnu_versym = ( (( 2 :: nat) *( 939524095 :: nat)) +( 1 :: nat))"
 (* 0x6fffffff *)
(** [sht_gnu_liblist] appears to be undocumented but appears in PowerPC 64 ELF
  * binaries in the wild.
  *)
definition sht_gnu_liblist  :: " nat "  where 
     " sht_gnu_liblist = ( (( 2 :: nat) *( 939524091 :: nat)) +( 1 :: nat))"
 (* 0x6FFFFFF7 *)

(** [string_of_gnu_ext_section_type m] produces a string based representation of
  * GNU extension section type [m].
  *)
(*val string_of_gnu_ext_section_type : natural -> string*)
    
(** [gnu_ext_additionall_special_sections] records additional section names that
  * map appear in GNU ELF binaries and their required associated types and
  * attributes.  See Section 10.3.1.1 of the LSB and the related map
  * [elf_special_sections] in [Elf_section_header_table] which records section
  * names and their required types and attributes that all ELF binaries share.
  *)
(*val gnu_ext_additional_special_sections : Map.map string (natural * natural)*)
definition gnu_ext_additional_special_sections  :: "((string),(nat*nat))Map.map "  where 
     " gnu_ext_additional_special_sections = (
  Map.map_of (List.rev [
    ((''.ctors''), (sht_progbits, (shf_alloc + shf_write)))
  , ((''.data.rel.ro''), (sht_progbits, (shf_alloc + shf_write)))
  , ((''.dtors''), (sht_progbits, (shf_alloc + shf_write)))
  , ((''.eh_frame''), (sht_progbits, shf_alloc))
  , ((''.eh_frame_hdr''), (sht_progbits, shf_alloc))
  , ((''.gcc_execpt_table''), (sht_progbits, shf_alloc))
  , ((''.gnu.version''), (sht_gnu_versym, shf_alloc))
  , ((''.gnu.version_d''), (sht_gnu_verdef, shf_alloc))
  , ((''.gnu.version_r''), (sht_gnu_verneed, shf_alloc))
  , ((''.got.plt''), (sht_progbits, (shf_alloc + shf_write)))
  , ((''.jcr''), (sht_progbits, (shf_alloc + shf_write)))
  , ((''.note.ABI-tag''), (sht_note, shf_alloc))
  , ((''.stab''), (sht_progbits,( 0 :: nat)))
  , ((''.stabstr''), (sht_strtab,( 0 :: nat)))
  ]))"

  
(** [is_valid_gnu_ext_elf32_section_header_table_entry scts stbl] checks whether
  * sections [scts] conforms with the contents of the special sections table.
  * Fails otherwise.
  *)
(*val is_valid_gnu_ext_elf32_section_header_table_entry : elf32_interpreted_section ->
  string_table -> bool*)
definition is_valid_gnu_ext_elf32_section_header_table_entry  :: " elf32_interpreted_section \<Rightarrow> string_table \<Rightarrow> bool "  where 
     " is_valid_gnu_ext_elf32_section_header_table_entry ent stbl = (
  (case  String_table.get_string_at(elf32_section_name   ent) stbl of
      Fail    f    => False
    | Success name1 =>
      (case   gnu_ext_additional_special_sections name1 of
          None           =>
            is_valid_elf32_section_header_table_entry ent stbl
        | Some (typ1, flags) =>            
(typ1 =(elf32_section_type   ent)) \<and> (flags =(elf32_section_flags   ent))
      )
  ))"

  
(** [is_valid_gnu_ext_elf32_section_header_table sht stbl] checks whether every
  * member of the section header table [sht] conforms with the special sections
  * table.
  *)
(*val is_valid_gnu_ext_elf32_section_header_table : list elf32_interpreted_section ->
  string_table -> bool*)
definition is_valid_gnu_ext_elf32_section_header_table  :: "(elf32_interpreted_section)list \<Rightarrow> string_table \<Rightarrow> bool "  where 
     " is_valid_gnu_ext_elf32_section_header_table ents stbl = (
  ((\<forall> x \<in> (set ents).  (\<lambda> x .  is_valid_gnu_ext_elf32_section_header_table_entry x stbl) x)))"

  
(** [is_valid_gnu_ext_elf64_section_header_table_entry scts stbl] checks whether
  * sections [scts] conforms with the contents of the special sections table.
  * Fails otherwise.
  *)
(*val is_valid_gnu_ext_elf64_section_header_table_entry : elf64_interpreted_section ->
  string_table -> bool*)
definition is_valid_gnu_ext_elf64_section_header_table_entry  :: " elf64_interpreted_section \<Rightarrow> string_table \<Rightarrow> bool "  where 
     " is_valid_gnu_ext_elf64_section_header_table_entry ent stbl = (
  (case  String_table.get_string_at(elf64_section_name   ent) stbl of
      Fail    f    => False
    | Success name1 =>
      (case   gnu_ext_additional_special_sections name1 of
          None           =>
            is_valid_elf64_section_header_table_entry ent stbl
        | Some (typ1, flags) =>            
(typ1 =(elf64_section_type   ent)) \<and> (flags =(elf64_section_flags   ent))
      )
  ))"

  
(** [is_valid_gnu_ext_elf64_section_header_table sht stbl] checks whether every
  * member of the section header table [sht] conforms with the special sections
  * table.
  *)
(*val is_valid_gnu_ext_elf64_section_header_table : list elf64_interpreted_section ->
  string_table -> bool*)
definition is_valid_gnu_ext_elf64_section_header_table  :: "(elf64_interpreted_section)list \<Rightarrow> string_table \<Rightarrow> bool "  where 
     " is_valid_gnu_ext_elf64_section_header_table ents stbl = (
  ((\<forall> x \<in> (set ents).  (\<lambda> x .  is_valid_gnu_ext_elf64_section_header_table_entry x stbl) x)))"

end
