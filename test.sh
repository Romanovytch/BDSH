#!/bin/bash

syntax_error()
{
    echo "Syntax error : Usage bdsh.sh [-k] [-f <db_file>] (put (<clef> | $<clef>) (<valeur> | $<clef>) | del (<clef> | $<clef>) [<valeur> | $<clef>] | select [<expr> | $<clef>] )"
    exit 0
}



if [ ! -e db.sh ];
    then
    touch db.sh
fi
if [ $# = 0 ];
    then
    syntax_error
fi

case $1 in
    "put" )
	if [ $# != 3 ];
	then
	    syntax_error
	else
	    key=$2
	    val=$3
	    if [[ $key = \$* ]];
	    then
		key=${key:1}
		tst=`grep $key db.sh`
		if [[ -z $tst ]];
		then
		    echo "No such key : $key"
		    exit 0
		else
		    key=`grep $key db.sh`
		    key=${key#* }
		fi
	    fi
	    if [[ $val = \$* ]];
	    then
		val=${val:1}
		tst=`grep $val db.sh`
		if [[ -z $tst ]];
		then
		    echo "No such key : $val"
		    exit 0
		else
		    val=`grep $val db.sh`
		    val=${val#* }
		fi
	    fi
	    tmp=`grep "^$key*" db.sh`
	    tmp=${tmp% *};
	    if [[ -z $tmp ]];
	    then
		echo $key $val >> db.sh
	    elif [[ $tmp != $key ]];
	    then
		echo $key $val >> db.sh
	    else
		sed "/^$key*/c $key $val" db.sh > tmp
		rm db.sh
		mv tmp db.sh
	    fi
	fi;;
    "del" ) echo "You choosed del";;
    "select" ) echo "You choosed select";;
    *) syntax_error;;  
esac
exit 0
