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

.PHONY: all
all :
	dune build @all

.PHONY: format
format :
	$(OCAMLFORMAT)
	$(OCPINDENT)

.PHONY: cinaps
cinaps :
	cinaps -i $(SRCFILES)
	cinaps -i $(C_FILES)
	$(OCAMLFORMAT)
	$(OCPINDENT)

.PHONY : clean
clean:
	dune clean
