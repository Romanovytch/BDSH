#!/bin/sh

Error()

{

        echo "Syntax error : Usage bdsh.sh [-k] [-f <db_file>] (put (<clef> | $<clef>) (<valeur> | $<clef>) | del (<clef> | $<clef>) [<valeur> | $<clef>] | select [<expr> | $<clef>] )"

	    exit

	    }



if [ $# -ge 1 ] && [ $1 = "-k" ]

    then

        shift

	    pars=1

	    else

        pars=0

	fi



if [ $# -ge 1 ] && [ $1 = "-f" ]

    then

        shift

	    if [ -f $1 ] && [ $# -ge 1 ]

		    then

		file_name="$1"

		let "pars += 10"

		shift

		    fi

	        let "pars += 10"

		fi



if [ $pars -eq 10 ] || [ $pars -eq 11 ]; then

        echo "No base found : file "$1""

	    exit

	    fi



if [ $pars -eq 0 ] || [ $pars -eq 1 ]; then

        file_name="sh.db"

	fi



while [ $# -ge 1 ]

do

        if [ $# -ge 1 ] && [ $1 = "flush" ]; then

	    cut -d '' -f1 $file_name > $file_name

	    exit

	        fi

	    if [ $# -ge 1 ] && [ $1 = "put" ]

		    then

		let "pars += 100"

		if [ $# -eq 3 ]; then

		        param1="$2"

			    param2="$3"

			        shift

				    shift

				    else

		        Error;

			fi

		    elif [ $# -ge 1 ] && [ $1 = "select" ]

		    then

		if [ $# -eq 1 ] || [ $# -eq 2 ]; then

		        if [ $# -eq 2 ]; then

			    param1="$2"

			    shift

			        else

			    param1=''

			        fi

			else

		        Error;

			fi

		let "pars += 200"

		    elif [ $# -ge 1 ] && [ $1 = "del" ]

		    then

		if [ $# -eq 2 ] || [ $# -eq 3 ]; then

		        param1="$2"

			    if [ $# -eq 3 ]; then

				param2="$3"

				shift

				    else

				param2=''

				    fi

			        shift

				else

		        Error;

			fi

		let "pars += 300"

		    fi

	        shift

		done



if [ $pars -lt 100 ] || [ $pars -gt 321 ]; then

        Error

	    exit

	    fi



##---------------------PUT-------------------------------------

if [ $pars -ge 100 ] && [ $pars -lt 200 ]; then

    

        if [[ "$param1" = \$* ]]; then

	    echo $param1 > tmp1

	    cut -d '$' -f2 tmp1 > t

	    param1=`cat t`

	    grep $param1 $file_name > tmp1

	    tmp=`cat tmp1`

	    if [[ -z $tmp ]]; then

		    echo "No such key : $param1"

		        exit

			else

		    cut -d " " -f2 tmp1 > tmp

		        param1=`cat tmp`

			fi

	    rm -f tmp1

	        fi

	

	    if [[ "$param2" = \$* ]]; then

		echo $param2 > tmp1

		cut -d '$' -f2 tmp1 > t

		param2=`cat t`

		grep $param2 $file_name > tmp1

		tmp=`cat tmp1`

		if [[ -z $tmp ]]; then

		        echo "No such key : $param2"

			    exit

			    else

		        cut -d " " -f2 tmp1 > tmp

			    param2=`cat tmp`

			    fi

		rm -f tmp1

		    fi

	    

	        res="$param1 $param2"

		    cut -d ' ' -f1 $file_name > is_file

		        is=`grep $param1 is_file`

			    rm -f is_file

			        if [[ -z $is ]]; then

				    echo $res >> $file_name

				        else

				    sed "/$param1/d" $file_name > tmp

				    rm $file_name

				    mv tmp $file_name

				    echo $res >> $file_name

				        fi

				fi



## ---------------------SELECT---------------------------------

if [ $pars -ge 200 ] && [ $pars -lt 300 ]; then

    

            if [[ "$param1" = \$* ]]; then

		echo $param1 > tmp1

		cut -d '$' -f2 tmp1 > t

		param1=`cat t`

		grep $param1 $file_name > tmp1

		tmp=`cat tmp1`

		if [[ -z $tmp ]]; then

		        echo "No such key : $param1"

			    exit

			    else

		        cut -d " " -f2 tmp1 > tmp

			    param1=`cat tmp`

			    fi

		rm -f tmp1

		    fi

	    

	        if [[ "$param2" = \$* ]]; then

		    echo $param2 > tmp1

		    cut -d '$' -f2 tmp1 > t

		    param2=`cat t`

		    grep $param2 $file_name > tmp1

		    tmp=`cat tmp1`

		    if [[ -z $tmp ]]; then

			    echo "No such key : $param2"

			        exit

				else

			    cut -d " " -f2 tmp1 > tmp

			        param2=`cat tmp`

				fi

		    rm -f tmp1

		        fi

		

		    varK=0

		        let "varK = pars % 2"

			    if [ $varK -eq 0 ]; then

				if [ -z $param1 ]; then

				        cut -d " " -f2 $file_name > tmp

					    cat tmp

					    else

				        grep ".*$param1.* .*" $file_name > t

					    cut -d " " -f2 t > tmp

					        cat tmp

						    rm -f t tmp

						    fi

				rm -f t

				    else

				if [ -z $param1 ]; then

				        cat $file_name > tmp

					    sed -i 's/ /=/g' tmp

					        cat tmp

						    rm -f tmp

						    else

				        grep ".*$param1.* .*" $file_name > tmp

					    sed -i 's/ /=/g' tmp

					        cat tmp

						    rm -f tmp

						    

						    

						    

						    fi

				

				    fi

			    fi



## ---------------------DEL------------------------------------

if [ $pars -ge 300 ]; then

    

            if [[ "$param1" = \$* ]]; then

		echo $param1 > tmp1

		cut -d '$' -f2 tmp1 > t

		param1=`cat t`

		grep $param1 $file_name > tmp1

		tmp=`cat tmp1`

		if [[ -z $tmp ]]; then

		        echo "No such key : $param1"

			    exit

			    else

		        cut -d " " -f2 tmp1 > tmp

			    param1=`cat tmp`

			    fi

		rm -f tmp1

		    fi

	    

	        if [[ "$param2" = \$* ]]; then

		    echo $param2 > tmp1

		    cut -d '$' -f2 tmp1 > t

		    param2=`cat t`

		    grep $param2 $file_name > tmp1

		    tmp=`cat tmp1`

		    if [[ -z $tmp ]]; then

			    echo "No such key : $param2"

			        exit

				else

			    cut -d " " -f2 tmp1 > tmp

			        param2=`cat tmp`

				fi

		    rm -f tmp1

		        fi

		

		    res="$param1 $param2"

		        sed "/$res/d" $file_name > tmp

			    rm $file_name

			        cp tmp $file_name

				    if [ $tmp ]; then

					res="$param1="

					echo $res >> $file_name

					    fi

				        rm tmp

					fi
