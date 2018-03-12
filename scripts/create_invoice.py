#!/usr/bin/python
#
# Usage: create_invoice.sh <id> <name> <amount> <QR code filename>
#       <id>            a unique id for this invoice - never reuse id's
#       <name>          a string describing the invoice ("Baguette")
#       <amount>        amount in msatoshi (must be divisible by 1000)
#	<QR>		the name of the file where to store the QR code
#
# Returns a QR code that contains an URL shortened with the Google URL Shortener service (http://goo.gl).
# This goo.gl URL then in turn leads to:
# https://bit-1.biluminate.net/#/pay/<LN invoice string>

import sys
import json
import subprocess
import httplib, urllib

def Shorten(s):
	# api key (user: petr.kovac09@gmail.com)
	# AIzaSyCT-PyKr77ivV9mkkosSb-ZBB-I8E9hP-E
	headers = { 'Content-Type': 'application/json' }
	payload = "{ \"longUrl\": \"" + s + "\" }"

	conn = httplib.HTTPSConnection("www.googleapis.com")
	conn.request("POST", "/urlshortener/v1/url?key=AIzaSyCT-PyKr77ivV9mkkosSb-ZBB-I8E9hP-E", payload, headers)
	response = json.loads(conn.getresponse().read())
	
	if 'id' in response:
		return response["id"]
	else:
		return ""

# Create invoice

if len(sys.argv) < 5:
	raise RuntimeError("invalid number of arguments")

ID=int(sys.argv[1])
NAME=str(sys.argv[2])
AMOUNT=int(sys.argv[3])
QR_PATH=str(sys.argv[4])

if not NAME:
	raise RuntimeError("<name> cannot be empty")

if AMOUNT % 1000 != 0 and AMOUNT < 1000:
	raise RuntimeError("<amount> must be divisible by 1000 and >= 1000")

CREATE_INVOICE = "/mnt/data/lightning/lightning/cli/lightning-cli --lightning-dir=/mnt/data/lightning/data_testnet invoice " + str(AMOUNT) + " " + NAME + "#" + str(ID) + " 1440"

process = subprocess.Popen( CREATE_INVOICE.split( ), stdout=subprocess.PIPE )
invoice_output, invoice_error = process.communicate( )

if invoice_error:
	raise RuntimeError("failed to create invoice")

#INVOICE_STR = '{ "payment_hash" : "69d42628d106f1c84c23fa928b10f7ff057fa6e0cf2b02ed573df510fefce8ab", "expiry_time" : 1520861657, "expires_at" : 1520861657, "bolt11" : "lntb500u1pd2vlpepp5d82zv2x3qmcusnprl2fgky8hluzhlfhqeu4s9m2h8h63plhuaz4sdqsgfskwet5ddsjxdehxqrpdqcqpxjngagj5wrv9rf2pqysg4ph34lgultuxd52n00wvsw5sl6kx26yv5an90xs7saq0rqk6ancxytnx8ea7xh6taxgqz2kgfgy5g79cnhqsqgk7j23" }'
#INVOICE=json.loads(INVOICE_STR)
INVOICE=json.loads(invoice_output)
print "LN payment: " + str(INVOICE["bolt11"])

LNS = 'https://bit-1.biluminate.net/#/pay/' + str(INVOICE["bolt11"])
print "Biluminate URL: " + str(LNS)

RESULT=Shorten(LNS)

if not RESULT:
	raise RuntimeError("Failed to shorten URL using google URL shortener!")	
else:
	print "Shortened Biluminate URL: " + str(RESULT)

# save QR code here
CREATE_QR = "qrencode -s 6 -l M -m 4 -t PNG --foreground=000000 --background=FFFFFF -o " + str(QR_PATH) + " " + str(RESULT)

process = subprocess.Popen( CREATE_QR.split( ), stdout=subprocess.PIPE )
qr_output, qr_error = process.communicate( )

if qr_error:
       raise RuntimeError("failed to create QR code")
else:
	print "Saved QR code to: " + str(QR_PATH)

print "Done"
