default:	all
clean:
	rm *.o *.so* *.cmi *.cmo *.annot tests timedlock unit_tests
all:	tests single_timed_lock unit_test
openfdlocks.cmi:	openfdlocks.mli
	ocamlfind ocamlc -g -c -thread -principal -package core,ctypes,ctypes.foreign openfdlocks.mli
openfdlocks.cmo:	openfdlocks.ml
	ocamlfind ocamlc -g -c -thread -principal -dllpath /usr/local/lib -dllib lib_openfd_locks -package core,ctypes,ctypes.foreign openfdlocks.ml
testml.cmo:	testml.ml openfdlocks.cmi openfdlocks.cmo testml.cmi
	ocamlfind ocamlc -g -c -thread -principal  -linkall -package core,parmap,ctypes,ctypes.foreign testml.ml
testml.cmi:	testml.mli
	ocamlfind ocamlc -g -c -thread -principal -package core,parmap,ctypes,ctypes.foreign testml.mli
tests:	testml.cmo openfdlocks.cmo openfdlocks.cmi testml.cmi
	ocamlfind ocamlc -g -thread -principal -linkpkg -package core,parmap,ctypes,ctypes.foreign openfdlocks.mli testml.mli openfdlocks.cmo testml.cmo -o tests
single_timed_lock.cmo:	single_timed_lock.ml
	ocamlfind ocamlc -g -c -thread -principal -package core,ctypes,ctypes.foreign single_timed_lock.ml
single_timed_lock.cmi:	single_timed_lock.ml
	ocamlfind ocamlc -g -c -thread -principal -package core,ctypes,ctypes.foreign single_timed_lock.mli
single_timed_lock:	single_timed_lock.cmi single_timed_lock.cmo
	ocamlfind ocamlc -g -thread -principal -linkpkg -package core,ctypes,ctypes.foreign openfdlocks.mli openfdlocks.cmo single_timed_lock.cmo -o timedlock
unit_test:	unit_test.ml openfdlocks.cmo
	ocamlfind ocamlc -g -thread -principal -I /usr/local/lib -cclib -l /usr/local/lib/lib_openfd_locks.so -linkpkg -package core,ctypes,ctypes.foreign,parmap,pcre openfdlocks.cmo unit_test.ml -o unit_tests
