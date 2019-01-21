
CXX = g++	
FLAGS = -g -pthread -m64
ROOTINCLUDE=-I$(ROOTSYS)/include
ROOTLIB=-L$(ROOTSYS)/lib
LIBS=-lCore -lCint -lRIO -lNet -lHist -lGraf -lGraf3d -lGpad -lTree -lTrandom -lRint -lPostscript -lMatrix -lPhysics -lMathCore -lThread -lpthread  
LDFLAGS=-lm -ldl -lMinuit
DEPEND = $(CXX) -MM
DEL = rm -rf


SOURCES           := $(wildcard *.cc)
OBJECTS           := $(SOURCES:.cc=.o)
EXESRC            := $(wildcard *.cpp)
EXECUTABLES       := $(EXESRC:.cpp=.exe)
DEPS              := $(SOURCES:.cc=.ccd)
DEPEXE		  := $(EXESRC:.cpp=.d)


all: $(EXECUTABLES)
     
%.exe : %.cpp $(DEPS) $(OBJECTS) %.d   
	$(CXX) $(FLAGS) $(ROOTINCLUDE) $< $(OBJECTS) $(LDFLAGS) $(ROOTLIB) $(LIBS) -o $@ 

%.o : %.cc %.ccd
	$(CXX) $(FLAGS) $(ROOTINCLUDE) $(ROOTLIB) $(LIBS) $(LDFLAGS) -c $< -o $@

%.ccd : %.cc
	$(DEPEND) $(FLAGS) $< > $@

%.d : 	%.cpp
	$(DEPEND) $(FLAGS) $< > $@
	sed s/.o:/.exe:/g $@ >tmp.sed
	mv tmp.sed $@

clean: 	
	@echo cleaning...
	$(DEL) *.o
	$(DEL) *.d 
	$(DEL) *.ccd
	$(DEL) *.exe
	$(DEL) *.dSYM

try:
	@echo $@
	@echo $(EXECUTABLES)
	@echo CXXFLAGS
	@echo $(CXXFLAGS)
	@echo LIBS
	@echo $(LIBS)

