default: Makefile.coq Makefile.coq.local
	$(MAKE) -f Makefile.coq

install: Makefile.coq Makefile.coq.local
	$(MAKE) -f Makefile.coq install

Makefile.coq: _CoqProject
	coq_makefile -f _CoqProject -o Makefile.coq

clean: Makefile.coq Makefile.coq.local
	$(MAKE) -f Makefile.coq cleanall
	rm -f Makefile.coq

.PHONY: default install clean
