	    echo -n "Checking for services that may need to be restarted..."
	    # Only get the ones that are installed, and configured
	    check=$(dpkg -s $check 2> /dev/null | egrep '^Package:|^Status:' | awk '{if ($1 ~ /^Package:/) { package=$2 } else if ($0 ~ /^Status: .* installed$/) { print package }}')
	    # some init scripts don't match the package names
	    check=$(echo $check | \
		    sed -e's/\bapache2.2-common\b/apache2/g' \
			-e's/\bat\b/atd/g' \
			-e's/\bdovecot-common\b/dovecot/g' \
			-e's/\bexim4-base\b/exim4/g' \
			-e's/\blpr\b/lpd/g' \
			-e's/\blpr-ppd\b/lpd-ppd/g' \
			-e's/\bmysql-server\b/mysql/g' \
			-e's/\bsasl2-bin\b/saslauthd/g' \
			-e's/\bsamba\b/smbd/g' \
			-e's/\bpostgresql-common\b/postgresql/g' \
		    )
	    echo
	    echo "Checking init scripts..."
	    for service in $check; do
		invoke-rc.d ${service} status >/dev/null 2>/dev/null && status=0 || status=$?
		if [ "$status" = "0" ] || [ "$status" = "2" ] ; then
		    services="$service $services"
		elif [ "$status" = "100" ] ; then
		    echo "WARNING: init script for $service not found."
		fi
	    done
