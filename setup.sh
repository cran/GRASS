GM=$1
GS=`grep SRC $GM | cut -f2 -d"="`
if test -z $GS
   then
   echo "GRASS sources not found"
   exit 1
fi
CMD=`grep "^CMD=" $GM | cut -f2 -d"="`
if test -z $CMD
   then
   echo "GRASS CMD not found"
   exit 1
fi
HEADER=`grep HEADER $GM | cut -f2 -d"="`
if test -z $HEADER
   then
   echo "GRASS HEADER not found"
   exit 1
fi
HEAD=$CMD/head/$HEADER
if test ! -r $HEAD
   then
   echo "$HEAD not readable"
   exit 1
fi
ARCH="`sed 's/=/ /' $HEAD | awk '$1 ~ /^ARCH$/ {if(NF>1)print $2}'`"
if test -z $ARCH
   then
   echo "GRASS architecture not found"
   exit 1
fi
LIB=LIB.$ARCH
if test ! -d $GS/libes/$LIB
   then
   echo "$GS/libes/$LIB: not found"
   exit 1
fi
if test ! -r $GS/libes/$LIB/libgis.a
   then
   echo "$GS/libes/$LIB/libgis.a: not found"

   exit 1
fi
if test ! -d $GS/include
   then
   echo "$GS/include: not found"
   exit 1
fi
if test ! -r $GS/include/gis.h
   then
   echo "$GS/include/gis.h: not found"
   exit 1
fi
echo "GRASS source directory: $GS"
echo "GRASS library directory: $LIB"

echo "GRASS_SRCDIR=$GS" > orig/src/Makefile
echo "" >> orig/src/Makefile
echo "GRASS_OBJ=$LIB" >> orig/src/Makefile
echo "" >> orig/src/Makefile
cat orig/src/Makefile.in >> orig/src/Makefile

exit 0

