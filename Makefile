# pkg-config packages list
PKGS := x264 libavutil libavformat libavcodec libswscale libv4l2 opencv
PKG_CFLAGS := $(shell pkg-config --cflags $(PKGS))
PKG_LDFLAGS := $(shell pkg-config --libs $(PKGS))

ADD_CFLAGS := -g -D__STDC_CONSTANT_MACROS
ADD_LDFLAGS := -lrt -lv4l1 -lv4l2 -lswscale -lx264

CFLAGS  := $(PKG_CFLAGS) $(ADD_CFLAGS) $(CFLAGS)
LDFLAGS := $(PKG_LDFLAGS) $(ADD_LDFLAGS) $(LDFLAGS)
CXXFLAGS := $(CFLAGS)

ALL_BUILDS = \
	encoder\
	v4l2_enumerate\
	network_joystick\

all: .depend $(ALL_BUILDS)

SOURCES=`ls *.cpp`

.depend:
	fastdep $(SOURCES) > .depend

-include .depend

encoder: encoder.o
	g++ $? $(CFLAGS) -o $@ $(LDFLAGS)

v4l2_enumerate: v4l2_enumerate.o
	g++ $? -o $@ $(LDFLAGS)

network_joystick: network_joystick.o
	g++ $? -o $@ $(LDFLAGS)

clean:
	rm -f *.o $(ALL_BUILDS)
