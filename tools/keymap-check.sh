#!/bin/sh
# Copyright Richard Hughes <richard@hughsie.com>

# checks to see if the keycode is in the quirk keymap list
isin ()
{
	got="0"
	for query in `cat /tmp/quirk-keymap-list.txt`
	do
		if [ "$query" = "$1" ]; then
			got="1"
		fi
	done
	echo "$got"
}

# processes each line of the fdi file
get_line ()
{
	cat "$1" | sed -ne '/<!--/ { :c; /-->/! { N; b c; }; /-->/s/<!--.*-->//g }; /^  *$/!p;' | grep "input.keymap.data" | while read line
	do
		data=`echo "${line}" | cut -d":" -f2 | cut -d"<" -f1`
		if [ -n "${data}" ] ; then
			found=`isin $data`
			if [ "$found" = "0" ]; then
				echo "$data "
			fi
		fi
	done
}

# processes each line of the fdi file
get_files ()
{
	find "../fdi/information/10freedesktop/" -name '30-keymap-*.fdi'  | while read file
	do
		status="ok"
		ret=`get_line "${file}"`
		if [ ! -z "$ret" ]; then
			status="FAILED"
			retval=1
		fi
		echo "Validate keycode in ${file} : ${status}"
		if [ ! -z "$ret" ]; then
			echo "$ret" | xargs
		fi
	done
}

retval=0

# look for a hal install with gperf
fqpath="../../hal/tools/hal-setup-keymap-keys.txt"
if [ ! -e "$fqpath" ]; then
	echo "HAL keymap source not found, falling back to local db"
	# fall back to local version
	fqpath="hal-setup-keymap-keys.txt"
fi

# make lowercase and save in /tmp
cat "$fqpath" | tr '[A-Z]' '[a-z]' | sort > /tmp/quirk-keymap-list.txt

echo "Validating keycodes..."
result=`get_files`
echo "$result"

if [ ! -z "`echo $result | grep FAILED`" ]; then
	retval=1
fi

if [ -e /tmp/quirk-keymap-list.txt ]; then
	rm -rf /tmp/quirk-keymap-list.txt
fi

exit $retval

