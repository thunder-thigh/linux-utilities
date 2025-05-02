
NEET=`date -d "April 20 2027" +%s`
TODAY=`date +%s`

DAYS=$((($NEET - $TODAY)/86400))


echo "$DAYS days until NEET"
