terraform output -json | jq .cert.value.private_key > thing.private.key -r
terraform output -json | jq .cert.value.certificate_pem > thing.cert.pem -r

mv thing.cert.pem ./run
mv thing.private.key ./run

sh ./run/device1.sh