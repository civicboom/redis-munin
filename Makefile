all: munin-plugins-redis.deb

VERSION := $(shell git describe)

munin-plugins-redis.deb: control Makefile
	rm -rf fs-mpr
	mkdir -p fs-mpr/DEBIAN/
	cp control fs-mpr/DEBIAN/control
	sed -i s/VERSION/${VERSION}/ fs-mpr/DEBIAN/control
	mkdir -p fs-mpr/usr/share/munin/plugins
	cp redis_* fs-mpr/usr/share/munin/plugins/
	chmod 755 fs-mpr/usr/share/munin/plugins/redis_*
	fakeroot dpkg -b fs-mpr munin-plugins-redis_${VERSION}_all.deb
	ln -sf munin-plugins-redis_${VERSION}_all.deb munin-plugins-redis.deb

control:
	echo "Package: munin-plugins-redis" > control
	echo "Version: VERSION" >> control
	echo "Architecture: all" >> control
	echo "Maintainer: Shish <shish@civicboom.com>" >> control
	echo "Depends: ruby, python, python-redis" >> control
	echo "Description: some munin plugins to monitor redis instances" >> control

clean:
	rm -rf fs-* *.deb
