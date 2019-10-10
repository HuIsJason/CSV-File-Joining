type=
optional="-b"
enrolmentfile=
inputmarkfile=
valid=0
for option in "$@" ; do
    if [ "$option" = "-u" ] || [ "$option" = "-s" ] && [ "$valid" = 0 ] ; then
        type="$option"
    elif [ "$option" = "-b" ] || [ "$option" = "-0" ] || [ "$option" = "-q" ] && [ "$valid" = 0 ] ; then
        optional="$option"
    elif [ -f "$option" ] ; then
        if [ -z "$enrolmentfile" ] ; then
            enrolmentfile="$option"
	    valid=1
        else
            inputmarkfile="$option"
        fi
    fi
done

if [ -z "$type" ] || [ -z "$enrolmentfile" ] || [ -z "$inputmarkfile" ] ; then
    exit 1
fi

if [ "$type" = "-s" ] ; then
    if [ "$optional" = "-0" ] ; then
        sort -t, -k 2,2 "$enrolmentfile" | join -t, -1 2 -2 1 -o 1.1,2.2 -a 1 -e 0 - "$inputmarkfile" | sort -t, -k 1,1
    elif [ "$optional" = "-q" ] ; then
        sort -t, -k 2,2 "$enrolmentfile" | join -t, -1 2 -2 1 -o 1.1,2.2 - "$inputmarkfile" | sort -t, -k 1,1
    else
        sort -t, -k 2,2 "$enrolmentfile" | join -t, -1 2 -2 1 -o 1.1,2.2 -a 1 - "$inputmarkfile" | sort -t, -k 1,1
    fi
elif [ "$type" = "-u" ] ; then
    if [ "$optional" = "-0" ] ; then
        sort -t, -k 1,1 "$enrolmentfile" | join -t, -1 1 -2 1 -o 1.2,2.2 -a 1 -e 0 - "$inputmarkfile" | sort -t, -k 1,1
    elif [ "$optional" = "-q" ] ; then
        sort -t, -k 1,1 "$enrolmentfile" | join -t, -1 1 -2 1 -o 1.2,2.2 - "$inputmarkfile" | sort -t, -k 1,1
    else
        sort -t, -k 1,1 "$enrolmentfile" | join -t, -1 1 -2 1 -o 1.2,2.2 -a 1 - "$inputmarkfile" | sort -t, -k 1,1
    fi
fi
