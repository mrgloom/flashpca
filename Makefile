
.PHONY: all

EIGEN=/usr/include/eigen3

all: flashpca

GITVER := $(shell git describe --dirty --always)

OBJ = \
   randompca.o \
   flashpca.o \
   data.o \
   util.o

CXXFLAGS = -Iboost -IEigen -I/usr/include/eigen3

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
   CXXFLAGS += -msse2
else
   CXXFLAGS += -march=native
endif

BOOST = -lboost_system-mt \
   -lboost_iostreams-mt \
   -lboost_filesystem-mt \
   -lboost_program_options
 
debug: LDFLAGS = $(BOOST)
debug: CXXFLAGS += -O0 -ggdb3 -DGITVER=\"$(GITVER)\"
debug: $(OBJ)
	$(CXX) $(CXXFLAGS) -o flashpca $^ $(LDFLAGS)

flashpca: LDFLAGS = $(BOOST)
flashpca: CXXFLAGS += -g -O3 -DNDEBUG -DGITVER=\"$(GITVER)\" \
   -funroll-loops -ftree-vectorize -ffast-math -fopenmp
flashpca: $(OBJ)
	$(CXX) $(CXXFLAGS) -o flashpca $^ $(LDFLAGS)

$(OBJ): %.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) flashpca

