all: pyquen1_5 pyquenZJet

# path to LHAPDF library
LHAPDF_PATH := /data/yjlee/jewel/lhapdf/lib
LHAPDF_INCL_PATH := /data/yjlee/jewel/lhapdf/include

FC := gfortran
FFLAGS := -g -static

pyquen1_5: pyquen1_5.o pythia-6.4.28.o test_pyquen.o
	$(FC) -o $@ $^

pyquenZJet: pyquen1_5.o pythia-6.4.28.o test_pyquenZJet.o
	$(FC) -o $@ $^

pyquen_ee: pyquen1_5.o pythia-6.4.28.o test_pyquen_ee.o
	$(FC) -o $@ $^

pyquenPhoton: pyquen1_5.o pythia-6.4.28.o test_pyquenPhoton.o
	$(FC) -o $@ $^
pyquenPromptPhoton: pyquen1_5.o pythia-6.4.28.o test_pyquenPromptPhoton.o
	$(FC) -o $@ $^

clean:
	rm -f medium-*.o 
	rm -f jewel*.o
	rm -f pythia-6.4.28.o meix.o
	rm -f *~

.PHONY: all
