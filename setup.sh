GR=$1
GS=`grep "^GISBASE" $GR | cut -f2 -d"="`
if test -z $GS
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

if test ! -r $GS/include/gisdefs.h
   then
   echo "$GS/include/gisdefs.h: not found, looking for source directory ..."
   if test -z $GM
      then
      GM=`which gmake5 2> /dev/null`
      if test $? -eq 0
         then
         GMDEF="yes"
      else
         echo "Your gmake5 is not on your current PATH."
         echo "Either add the directory it is in to your PATH,"
         echo "or run \"R INSTALL --configure-args=--gmake5=/.../gmake5 GRASS\""
         echo "giving the fully qualified path to and name of your gmake5."
         echo "To install the interpreted interface, use:"
         echo "\"R INSTALL --configure-args=--interp GRASS\""
         exit 1
      fi
   fi
   if test ! -r $GM
      then
      echo "$GM not readable"
      exit 1
   fi
   GSRC=`grep "^SRC" $GM | cut -f2 -d"="`
   if test -z $GSRC
      then
      echo "GRASS source directory not found"
      exit 1
   fi
   if test ! -d $GSRC/include
      then
      echo "$GSRC/include: not found"
      exit 1
   fi
   if test ! -r $GSRC/include/gisdefs.h
      then
      echo "$GSRC/include/gisdefs.h: not found"
      exit 1
   fi
   if test ! -r $GSRC/include/site.h
      then
      echo "$GSRC/include/site.h: not found"
      exit 1
   fi
   if test ! -r $GSRC/include/P_site.h
      then
      echo "$GSRC/include/P_site.h: not found"
      exit 1
   fi
   if test ! -r $GSRC/include/datetime.h
      then
      echo "$GSRC/include/datetime.h: not found"
      exit 1
   fi
   if test ! -r $GSRC/include/P_datetime.h
      then
      echo "$GSRC/include/P_datetime.h: not found"
      exit 1
   fi

   echo "GRASS SRC directory: $GSRC"

   echo "GRASS_SRC_INC_DIR=$GSRC/include" >> orig/src/Makefile
   echo "" >> orig/src/Makefile
fi

exit 0

