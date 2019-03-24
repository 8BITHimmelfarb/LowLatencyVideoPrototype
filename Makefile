# pkg-config packages list
PKGS := x264 libavutil libavformat libavcodec libswscale opencv sdl2 SDL_net
PKG_CFLAGS := $(shell pkg-config --cflags $(PKGS))
PKG_LDFLAGS := $(shell pkg-config --libs $(PKGS))

ADD_CFLAGS := -g -D__STDC_CONSTANT_MACROS
ADD_LDFLAGS := -lrt

CFLAGS  := $(PKG_CFLAGS) $(ADD_CFLAGS) $(CFLAGS)
LDFLAGS := $(PKG_LDFLAGS) $(ADD_LDFLAGS) $(LDFLAGS)
CXXFLAGS := $(CFLAGS)

ALL_BUILDS = \
	viewer_stdin\
	viewer_sdl\
	network_joystick\

all: .depend $(ALL_BUILDS)

SOURCES=`ls *.cpp`

.depend:
	fastdep $(SOURCES) > .depend

-include .depend

viewer_stdin: viewer_stdin.o data_source_ocv_avcodec.o x264_destreamer.o packet_server.o data_source_stdio_info.o
	g++ $? -o $@ $(LDFLAGS)

viewer_sdl: viewer_sdl.o x264_destreamer.o packet_server.o
	g++ $? -o $@ $(LDFLAGS)

network_joystick: network_joystick.o
	g++ $? -o $@ $(LDFLAGS)

clean:
	rm -f *.o $(ALL_BUILDS)
