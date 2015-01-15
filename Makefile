PYTHON=`which python`
DESTDIR=/
BUILDIR=$(CURDIR)/debian/xsser
PROJECT=xsser
VERSION=1.6.0

all:
	$(MAKE) source
	rm -rf xsser.egg-info

source:
	$(PYTHON) setup.py sdist $(COMPILE)

install:
	chmod +x xsser.py
	cp -f empty.sh xsser.sh
	echo "APPDIR=$(CURDIR)" >> xsser.sh
	cat xsser-tail.sh >> xsser.sh
	chmod +x xsser.sh
	echo "alias xsser='. $(CURDIR)/xsser.sh'" >> '$(HOME)/.bashrc'
	echo "alias xsser='. $(CURDIR)/xsser.sh'" >> '$(HOME)/.bash_profile'

buildrpm:
	$(PYTHON) setup.py bdist_rpm --post-install=rpm/postinstall --pre-uninstall=rpm/preuninstall

builddeb:
	# build the source package in the parent directory
	# then rename it to project_version.orig.tar.gz
	$(PYTHON) setup.py sdist $(COMPILE) --dist-dir=../
	rename -f 's/$(PROJECT)-(.*)\.tar\.gz/$(PROJECT)_$$1\.orig\.tar\.gz/' ../*
	# build the package
	dpkg-buildpackage -i -I -rfakeroot

clean:
	$(PYTHON) setup.py clean
	$(MAKE) -f $(CURDIR)/debian/rules clean
	rm -rf build/ MANIFEST
	find . -name '*.pyc' -delete
	rm -rf xsser.egg-info
