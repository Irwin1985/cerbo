#!/usr/bin/env bash

# Common functionality

# helper function for print_decade_url()
dfield () {
echo "$1" | awk -v T="$2" '    
BEGIN {
  if(T == 0) { keys[1] = "a" ; keys[2] = "b" ; keys[3] = "c" }
  else { keys[1] = "d" ; keys[2] = "e" ; keys[3] = "f" };

}
{  
  split($0, arr, "-"); 
  # month requires decrement due to Yahoo
  y = arr[1]; m = arr[2] -1; d = arr[3];
  printf "%s=%s&%s=%s&%s=%s", keys[1], m, keys[2], d, keys[3], y;
}
'
}


# Given a ticker (e.g. VOD.L), print a URL that will download a decade's
# worth of data
function print_decade_url () {
	d0=$(date -d '10 years ago' -I)
	f0=$(dfield $d0 0)

	d1=$(date -I)
	f1=$(dfield $d1 1)

	sym="$1"
	pre="http://ichart.finance.yahoo.com/table.csv?s=$sym&"
	post="&g=d&ignore=.csv"
	url="$pre$f0&$f1$post"

	echo $url

}


