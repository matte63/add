#!/bin/sh

sign () {
	echo "$(( $1 < 0 ? -1 : 1 ))"
}

# `exp 2 4` returns 2e4 (or 20000)
exp() {
	f="%f"
	if [ "$2" -lt 0 ]
		then
			f="%.$(($2 * $(sign $2)))f"
	fi
	echo "$(printf "$f" 1e$2) * $1" | bc -l
}


count_decimal() {
	n=$1
	d=${n#*.}
	count=${#d}
	if [ $count -eq  ${#n} ]
		then
			count=0
	fi
	echo $count
}

round() {
	echo $(echo "(${1}+0.5)/1" | bc)
}


min () {
	echo "$(( $1 < $2 ? $1 : $2 ))"
}

max() {
	echo "$(( $1 > $2 ? $1 : $2 ))"
}

add() {
	start=$(date +%s%N)
	esp="-3"

	# if at least one number is greater than 100
	# loses precision but computes faster.
	if [ $(max $1 $2) -gt $(round $(exp 1 2)) ]
		then
			m=$(round $(max $1 $2))
			esp="-${#m}"

	# if there is at least one number smaller than 100
	# is more precise but requires more time to compute.
	elif [ $(min $1 $2) -lt $(round $(exp 1 2)) ]
		then
			esp="0"
	fi

	sleep $(exp $1 $esp) $(exp $2 $esp)

	res=$(exp $(($(date +%s%N) - $start)) $((-$esp - 9)))

	# format (round) result
	f="%.$(max $(count_decimal $1) $(count_decimal $2))f"
	echo $(printf "$f" $res)
}

# test
echo $(add 200 103)
