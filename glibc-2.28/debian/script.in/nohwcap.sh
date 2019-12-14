    # Handle upgrades when libc-opt package has been installed.
    # When a /etc/ld.so.nohwcap file exists, ld.so only use libraries
    # from /lib, and ignore all optimised libraries. This file is
    # inconditionaly created in the preinst script of libc.
 
    # We check the version between the current installed libc and
    # all optimized packages. Due to multiarch, this has to be done
    # independently of the architecture of the package.
    all_upgraded=yes
    for pkg in libc6.1-alphaev67 libc6-xen ; do
        ver=$(dpkg-query -l $pkg 2>/dev/null | sed -e '/^[a-z][a-z]\s/!d;/^.[nc]/d;' -e "s/^..\s\+$pkg[0-9a-z:]*\s\+//;s/\s.*//g")
        if [ -n "$ver" ] && [ "$ver" != "CURRENT_VER" ]; then
            all_upgraded=no
        fi
    done

    # If the versions of all optimized packages are the same as the libc
    # one, we could remove /etc/ld.so.nohwcap. Otherwise, it will be removed
    # when all optimized packages are upgraded or removed.
    if [ "$all_upgraded" = yes ] ; then
        rm -f /etc/ld.so.nohwcap
    fi
