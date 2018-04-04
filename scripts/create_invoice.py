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

#CREATE_INVOICE = "/mnt/data/lightning/lightning/cli/lightning-cli --lightning-dir=/mnt/data/lightning/data_testnet invoice " + str(AMOUNT) + " " + NAME + "#" + str(ID) + " 1440"
CREATE_INVOICE = "/mnt/data/lnd/lndbin/lncli --lnddir /mnt/data/lnd/data2_testnet --rpcserver=localhost:19736 --macaroonpath /mnt/data/lnd/data2_testnet/admin.macaroon addinvoice --memo=\"" + NAME + "#" + str(ID) + "\" --amt=" + str(AMOUNT) + " --expiry=86400"

process = subprocess.Popen( CREATE_INVOICE.split( ), stdout=subprocess.PIPE )
invoice_output, invoice_error = process.communicate( )

if invoice_error:
	raise RuntimeError("failed to create invoice")

#INVOICE_STR = '{ "r_hash": "659f482ec55b606eaefabbfad79603967c1a89ae71b495d578c380fb6d4c6fab", "pay_req": "lntb500u1pdvfqgtpp5vk05stk9tdsxath6h0ad09srje7p4zdwwx6ft4tccwq0km2vd74sdqdgfskwat9w36x2cqzysxqr8pqnexw2fa0znsfm2d0rmnwdcv6y5gsgkfun5yp7c89093f07ts6up4l08ejy4xjynmfylw60tajavqrefdmphshvm7te5lmd0xm038a4qqqc0lw7" }'
#INVOICE=json.loads(INVOICE_STR)

INVOICE=json.loads(invoice_output)

print "LN payment: " + str(INVOICE["pay_req"])

LNS = 'https://bit-1.biluminate.net/#/pay/' + str(INVOICE["pay_req"])
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
