PIX=\
MulleObjC-dependencies.png \
threadlocal.png \
thread-setup.png

%.png: %.dot
	dot -Tpng -o $*.png $<


all: $(PIX)


.dot.png:
	dot -Tpng -o $@ $<
