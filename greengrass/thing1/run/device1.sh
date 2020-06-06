python3 basicDiscovery.py \
--endpoint a7n0zvxwzahke-ats.iot.eu-west-1.amazonaws.com \
--rootCA root-ca-cert.pem \
--cert thing.cert.pem \
--key thing.private.key \
--thingName thing1 \
--topic 'hello/world/pubsub' \
--mode publish \
--message 'Hello, World! Sent from Thing1'