SRCFILES = src/*.ml* code_gen/*.ml*

C_FILES = code_gen/*.c code_gen/*.h

CINAPSFILES = code_gen/*.cinaps

OCAMLFORMAT = ocamlformat \
	--inplace \
	--field-space loose \
	--let-and sparse \
	--let-open auto \
	--type-decl sparse \
	--sequence-style terminator \
	$(SRCFILES) \
	$(CINAPSFILES)

OCPINDENT = ocp-indent \
	--inplace \
	$(SRCFILES) \
	$(CINAPSFILES)

CLANG_FORMAT = clang-format \
	-i \
	$(C_FILES)

.PHONY: all
all :
	dune build @all

.PHONY: doc
doc :
	dune build @doc

.PHONY: format
format :
	$(OCAMLFORMAT)
	$(OCPINDENT)

.PHONY: format_c
format_c :
	$(CLANG_FORMAT)

.PHONY: cinaps
cinaps :
	cinaps -i $(SRCFILES)
	cinaps -i $(C_FILES)
	$(OCAMLFORMAT)
	$(OCPINDENT)
	$(CLANG_FORMAT)

.PHONY : clean
clean:
	dune clean
