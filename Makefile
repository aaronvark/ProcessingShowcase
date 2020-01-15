PRC=/opt/processing-3.5.3
JFLAGS = -g -cp "./src:./src/pde:$(PRC)/core/library/core.jar:minim.jar:$(PRC)/core/library/jogl-all.jar"
JVMFLAGS = -cp "./src:./src/pde:$(PRC)/core/library/core.jar:minim.jar:jsminim.jar:$(PRC)/core/library/jogl-all.jar:$(PRC)/core/library/gluegen-rt.jar:mp3spi1.9.5.jar:tritonus_aos.jar:tritonus_share.jar"
JC = javac
JVM = $(PRC)/java/bin/java
SKETCH_DIRS = pde/*


.SUFFIXES: .java .class

.java.class:
	$(JC) $(JFLAGS) $*.java

CLASSES = src/*.java

MAIN = ProcessingShowcase

default: classes

classes: $(CLASSES:.java=.class)

procparse:
	./processing-parse.sh pde/*

clean:
	$(RM) src/*.class src/pde/*.class

run:
	$(JVM) $(JVMFLAGS) $(MAIN)
