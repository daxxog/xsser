GOBACK=$(pwd)
cd $APPDIR
$(which python) xsser.py "$@"
cd $GOBACK