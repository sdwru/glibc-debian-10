# configuration options for all flavours
extra_config_options = --enable-multi-arch --enable-static-pie

ifeq (,$(filter stage1 stage2, $(DEB_BUILD_PROFILES)))
# We use -mno-tls-direct-seg-refs to not wrap-around segments, as it
# greatly increase the speed when running under the 32bit Xen hypervisor.
GLIBC_PASSES += xen
DEB_ARCH_REGULAR_PACKAGES += libc6-xen
xen_extra_cflags = -mno-tls-direct-seg-refs
xen_slibdir = /lib/$(DEB_HOST_MULTIARCH)/i686/nosegneg

define libc6-xen_extra_pkg_install
mkdir -p debian/libc6-xen/etc/ld.so.conf.d
echo '# This directive teaches ldconfig to search in nosegneg subdirectories' >  debian/libc6-xen/etc/ld.so.conf.d/libc6-xen.conf
echo '# and cache the DSOs there with extra bit 1 set in their hwcap match'   >> debian/libc6-xen/etc/ld.so.conf.d/libc6-xen.conf
echo '# fields. In Xen guest kernels, the vDSO tells the dynamic linker to'   >> debian/libc6-xen/etc/ld.so.conf.d/libc6-xen.conf
echo '# search in nosegneg subdirectories and to match this extra hwcap bit'  >> debian/libc6-xen/etc/ld.so.conf.d/libc6-xen.conf
echo '# in the ld.so.cache file.'                                             >> debian/libc6-xen/etc/ld.so.conf.d/libc6-xen.conf
echo 'hwcap 1 nosegneg'                                                       >> debian/libc6-xen/etc/ld.so.conf.d/libc6-xen.conf
endef

define libc6-dev_extra_pkg_install
mkdir -p debian/libc6-dev/$(libdir)/xen
cp -af debian/tmp-xen/$(libdir)/*.a \
	debian/libc6-dev/$(libdir)/xen
endef
endif

# multilib flavours
ifeq (,$(filter nobiarch, $(DEB_BUILD_PROFILES)))

# build 64-bit (amd64) alternative library
GLIBC_PASSES += amd64
DEB_ARCH_MULTILIB_PACKAGES += libc6-amd64 libc6-dev-amd64
libc6-amd64_shlib_dep = libc6-amd64 (>= $(shlib_dep_ver))
amd64_configure_target = x86_64-linux-gnu
# __x86_64__ is defined here because Makeconfig uses -undef and the
# /usr/include/asm wrappers need that symbol.
amd64_CC = $(CC) -m64 -D__x86_64__
amd64_CXX = $(CXX) -m64 -D__x86_64__
amd64_mvec = yes
amd64_rtlddir = /lib64
amd64_slibdir = /lib64
amd64_libdir = /usr/lib64

define amd64_extra_install
cp debian/tmp-amd64/usr/bin/ldd \
	debian/tmp-libc/usr/bin
endef

define libc6-dev-amd64_extra_pkg_install

mkdir -p debian/libc6-dev-amd64/usr/include
ln -sf i386-linux-gnu/bits debian/libc6-dev-amd64/usr/include/
ln -sf i386-linux-gnu/gnu debian/libc6-dev-amd64/usr/include/
ln -sf i386-linux-gnu/fpu_control.h debian/libc6-dev-amd64/usr/include/

mkdir -p debian/libc6-dev-amd64/usr/include/i386-linux-gnu/gnu
cp -a debian/tmp-amd64/usr/include/gnu/lib-names-64.h \
	debian/tmp-amd64/usr/include/gnu/stubs-64.h \
	debian/libc6-dev-amd64/usr/include/i386-linux-gnu/gnu

mkdir -p debian/libc6-dev-amd64/usr/include/sys
for i in `ls debian/tmp-libc/usr/include/i386-linux-gnu/sys` ; do \
	ln -sf ../i386-linux-gnu/sys/$$i debian/libc6-dev-amd64/usr/include/sys/$$i ; \
done

endef

# build x32 ABI alternative library
GLIBC_PASSES += x32
DEB_ARCH_MULTILIB_PACKAGES += libc6-x32 libc6-dev-x32
libc6-x32_shlib_dep = libc6-x32 (>= $(shlib_dep_ver))
x32_configure_target = x86_64-linux-gnux32
x32_CC = $(CC) -mx32
x32_CXX = $(CXX) -mx32
x32_mvec = yes
x32_rtlddir = /libx32
x32_slibdir = /libx32
x32_libdir = /usr/libx32

define libc6-dev-x32_extra_pkg_install

mkdir -p debian/libc6-dev-x32/usr/include/i386-linux-gnu/gnu
cp -a debian/tmp-x32/usr/include/gnu/lib-names-x32.h \
	debian/tmp-x32/usr/include/gnu/stubs-x32.h \
	debian/libc6-dev-x32/usr/include/i386-linux-gnu/gnu

endef

endif # multilib
