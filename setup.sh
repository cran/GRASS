GR=$1

GS=`grep "^GISBASE" $GR | cut -f2 -d"="`
if test -z $GS
   then
   echo "GRASS HOME directory not found"
   exit 1
fi
if test ! -d $GS
   then
   echo "GRASS HOME directory not found"
   exit 1
fi
if test ! -r $GS
   then
   echo "GRASS HOME directory not found"
   exit 1
fi
if test ! -d $GS/lib
   then
   echo "$GS/lib: not found"
   exit 1
fi
if test ! -r $GS/lib/libgis.a
   then
   echo "$GS/lib/libgis.a: not found"

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

echo "GRASS HOME directory: $GS"
echo "GRASS_HOME_DIR=$GS" > orig/src/Makefile
echo "" >> orig/src/Makefile

exit 0

