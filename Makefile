.phony: all desktop web

D_CC=gcc
D_CXX=g++

W_CC=emcc
W_CXX=em++

AR=ar

SOURCE=source/main.cpp
HEADERS= \
	source/object/drawable.hpp \
	source/drawcontext.hpp \
	source/object/dynamic.hpp \
	source/object/object.hpp \
	source/object/static.hpp \
	source/world.hpp \
	source/physics.hpp \
	source/graphics.hpp \
	source/action/action.hpp \
	quadtree/tree.hpp \
	libla/la/mat.hpp \
	libla/la/vec.hpp

D_OBJ_DIR=build/desktop/obj
D_APP_DIR=build/desktop

W_OBJ_DIR=build/web/obj
W_APP_DIR=build/web

LIBLA_DIR=libla
MEDIA_DIR=libmedia
include $(MEDIA_DIR)/Makefile

GFX_DIR=libgraphics
include $(GFX_DIR)/Makefile

QUADTREE_DIR=quadtree

D_SOURCE=$(SOURCE)

D_HEADERS= \
	$(HEADERS) \
	$(MEDIA_HEADERS) $(MEDIA_D_HEADERS) \
	$(GFX_HEADERS) $(GFX_D_HEADERS)

D_INCLUDES= \
	$(LIBLA_DIR) \
	$(MEDIA_INCLUDES) $(MEDIA_D_INCLUDES) \
	$(GFX_INCLUDES) $(GFX_D_INCLUDES) \
	$(QUADTREE_DIR)

D_LIBS= \
	$(MEDIA_D_LIB) $(GFX_D_LIB)
	
D_LINK_LIBS= \
	$(GFX_D_LINK_LIBS) $(MEDIA_D_LINK_LIBS) 

D_LIB_DIRS= \
	$(MEDIA_D_LIB_DIR) \
	$(GFX_D_LIB_DIR)

D_OBJS= \
	$(MEDIA_D_OBJS) \
	$(GFX_D_OBJS)

D_CFLAGS=$(MEDIA_CFLAGS) $(MEDIA_D_CFLAGS) -Wall -g
D_CXXFLAGS=$(MEDIA_CXXFLAGS) $(MEDIA_D_CXXFLAGS) -Wall -g
D_LFLAGS=$(MEDIA_LFLAGS) $(MEDIA_D_LFLAGS) $(GFX_D_LFLAGS) 

W_SOURCE=$(SOURCE)

W_HEADERS= \
	$(HEADERS) \
	$(MEDIA_HEADERS) $(MEDIA_W_HEADERS) \
	$(GFX_HEADERS) $(GFX_W_HEADERS)

W_INCLUDES= \
	$(LIBLA_DIR) \
	$(MEDIA_INCLUDES) $(MEDIA_W_INCLUDES) \
	$(GFX_INCLUDES) $(GFX_W_INCLUDES) \
	$(QUADTREE_DIR)

W_LIBS= \
	$(MEDIA_W_LIB) $(GFX_W_LIB)

W_LIB_DIRS= \
	$(MEDIA_W_LIB_DIR) \
	$(GFX_W_LIB_DIR)

W_OBJS= \
	$(MEDIA_W_OBJS) \
	$(GFX_W_OBJS)

W_CFLAGS=$(MEDIA_CFLAGS) $(MEDIA_W_CFLAGS) -Wall

W_EXPORTED_FUNCTIONS_LIST=$(MEDIA_W_EXPORTED_FUNCTIONS) $(GFX_W_EXPORTED_FUNCTIONS)
W_EXPORTED_FUNCTIONS=-s EXPORTED_FUNCTIONS="[$(W_EXPORTED_FUNCTIONS_LIST:%='%',)]"

W_LFLAGS=$(W_EXPORTED_FUNCTIONS) $(MEDIA_LFLAGS) $(MEDIA_W_LFLAGS) $(GFX_W_LFLAGS) 

all: build desktop web

desktop: build/desktop libmedia_desktop libgraphics_desktop build/desktop/app

web: build/web libmedia_web libgraphics_web build/web/app.js

build:
	mkdir -p build

build/desktop:
	mkdir -p build/desktop

# build/desktop/app: $(D_SOURCE) $(D_HEADERS) $(MEDIA_D_LIB_FILE) $(GFX_D_LIB_FILE)
# 	$(D_CXX) $(D_CFLAGS) $(D_LFLAGS) $(D_INCLUDES:%=-I%) $(D_LIB_DIRS:%=-L%) $(D_LIBS:%=-l%) $< -o $@

build/desktop/app: $(D_SOURCE) $(D_HEADERS) $(MEDIA_D_LIB_FILE) $(GFX_D_LIB_FILE)
	$(D_CXX) $(D_CFLAGS) $(D_LFLAGS) $(D_INCLUDES:%=-I%) $(D_LINK_LIBS:%=-l%) $(D_OBJS) $< -o $@

build/web:
	mkdir -p build/web

# build/web/app.js: $(W_SOURCE) $(W_HEADERS) $(MEDIA_W_LIB_FILE) $(GFX_W_LIB_FILE)
# 	$(W_CXX) $(W_CFLAGS) $(W_LFLAGS) $(W_INCLUDES:%=-I%) $(W_LIB_DIRS:%=-L%) $(W_LIBS:%=-l%) $< -o $@

build/web/app.js: $(W_SOURCE) $(W_HEADERS) $(MEDIA_W_LIB_FILE) $(GFX_W_LIB_FILE)
	$(W_CXX) $(W_CFLAGS) $(W_LFLAGS) $(W_INCLUDES:%=-I%) $(W_OBJS) $< -o $@
