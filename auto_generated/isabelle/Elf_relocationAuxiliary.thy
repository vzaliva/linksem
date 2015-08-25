header{*Generated by Lem from elf_relocation.lem.*}

theory "Elf_relocationAuxiliary" 

imports 
 	 Main "~~/src/HOL/Library/Code_Target_Numeral"
	 "Lem_num" 
	 "Lem_list" 
	 "Lem_set" 
	 "Lem_basic_classes" 
	 "Lem_string" 
	 "Show" 
	 "Missing_pervasives" 
	 "Error" 
	 "Byte_sequence" 
	 "Endianness" 
	 "Elf_types_native_uint" 
	 "Elf_relocation" 

begin 


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

termination read_elf32_relocation_section' by lexicographic_order

termination read_elf64_relocation_section' by lexicographic_order

termination read_elf32_relocation_a_section' by lexicographic_order

termination read_elf64_relocation_a_section' by lexicographic_order



end
