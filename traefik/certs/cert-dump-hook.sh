#!/bin/sh
CWD=$(pwd)
DUMPDIR=/output
KEYDIR=$HOOK_KEYS_DIR
TRUSTDIR=$HOOK_TRUST_DIR

cd $DUMPDIR
mkdir -p $KEYDIR
mkdir -p $TRUSTDIR
# For each dumped domain
for d in */ ; do
    [ -L "${d%/}" ] && continue
	domain=$(echo $d | sed 's/.$//')
    echo "== Processing: $domain"
	cp $d/key.pem $KEYDIR/${domain}_key.pem
	cp $d/key+cert.pem $KEYDIR/${domain}_key+cert.pem
	cp $d/cert.pem $KEYDIR/${domain}_cert.pem
	cp $d/cert.p12 $KEYDIR/${domain}_cert.p12
	openssl x509 -outform pem -in $d/cert.pem -out $TRUSTDIR/${domain}_cert.crt
	# openssl pkcs12 -export -out keystore.p12 -inkey $KEYDIR/${domain}_key.pem -in $KEYDIR/${domain}_cert.pem
done
cd $CWD