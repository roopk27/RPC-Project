# Makefile 

RPCGEN ?= rpcgen
XFILE  ?= date.x

CC ?= gcc
CFLAGS ?= -Wall -Wextra -O2

# libtirpc 

TIRPC_CFLAGS := $(shell pkg-config --cflags libtirpc 2>/dev/null)
TIRPC_LIBS   := $(shell pkg-config --libs libtirpc 2>/dev/null)

ifeq ($(strip $(TIRPC_LIBS)),)
TIRPC_CFLAGS := -I/usr/include/tirpc
TIRPC_LIBS   := -ltirpc
endif

GEN_SRCS = date_clnt.c date_svc.c date_xdr.c
GEN_HDRS = date.h

.PHONY: all clean rpcgen

all: rpcgen rpcstat_server rpcstat_client

rpcgen: $(GEN_SRCS) $(GEN_HDRS)

$(GEN_SRCS) $(GEN_HDRS): $(XFILE)
	$(RPCGEN) -C $(XFILE)

rpcstat_server: server.o date_svc.o date_xdr.o
	$(CC) $(CFLAGS) -o $@ $^ $(TIRPC_LIBS)

rpcstat_client: client.o date_clnt.o date_xdr.o
	$(CC) $(CFLAGS) -o $@ $^ $(TIRPC_LIBS)

%.o: %.c
	$(CC) $(CFLAGS) $(TIRPC_CFLAGS) -c $< -o $@

clean:
	rm -f *.o rpcstat_server rpcstat_client $(GEN_SRCS) $(GEN_HDRS)
