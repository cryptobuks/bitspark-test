#/bin/bash

# Creates invoices and qr codes for one week
# Usage: create_invoice.sh <id> <name> <amount> <QR code filename>

if [ "$#" -ne 2 ]; then
	echo "Usage: script.sh <starting id> <number of invoices>"
	exit 1
fi

if [ "$1" -le 0 ]; then
	echo "Starting ID must be positive"
	exit 1
fi

if [ "$2" -le 0 ]; then
	echo "Number of invoices must be positive"
	exit 1
fi

start=$1
end=$(($1 + $2 - 1))

for i in `seq $start $end`;
do
	qrname="lnqr_$i.png"
	echo "Generating invoice ID: $i - $qrname"
	python create_invoice.py $i "Baguette" 50000 "lnqr_$i.png"
done

