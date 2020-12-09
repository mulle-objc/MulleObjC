PIX=\
MulleObjC-dependencies.png \
threadlocal.png \
thread-flow.png \
thread-setup.png \
thread-and-pools.png

%.png: %.dot
	dot -Tpng -o $*.png $<


all: $(PIX)


.dot.png:
	dot -Tpng -o $@ $<
