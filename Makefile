# pkg-config packages list
PKGS := x264 libavutil libavformat libavcodec libswscale opencv
PKG_CFLAGS := $(shell pkg-config --cflags $(PKGS))
PKG_LDFLAGS := $(shell pkg-config --libs $(PKGS))

ADD_CFLAGS := -g -D__STDC_CONSTANT_MACROS
ADD_LDFLAGS := -lrt -lswscale -lx264

CFLAGS  := $(PKG_CFLAGS) $(ADD_CFLAGS) $(CFLAGS)
LDFLAGS := $(PKG_LDFLAGS) $(ADD_LDFLAGS) $(LDFLAGS)
CXXFLAGS := $(CFLAGS)

ALL_BUILDS = \
	encoder\
	
all: .depend $(ALL_BUILDS)

SOURCES=`ls *.cpp`

.depend:
	fastdep $(SOURCES) > .depend

-include .depend

encoder: encoder.o
	g++ $? $(CFLAGS) -o $@ $(LDFLAGS)

clean:
	rm -f *.o $(ALL_BUILDS)
