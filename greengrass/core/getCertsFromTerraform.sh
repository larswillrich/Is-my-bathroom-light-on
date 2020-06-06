terraform output -json | jq .cert.value.private_key > core.private.key -r
terraform output -json | jq .cert.value.certificate_pem > core.cert.pem -r

mv core.cert.pem ./mounting/certs
mv core.private.key ./mounting/certs