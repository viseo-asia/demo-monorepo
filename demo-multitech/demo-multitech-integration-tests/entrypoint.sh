#!/bin/sh

cd /opt/app/
npm run test

echo "Waiting services to start"

sleep 10

echo "Test finished"
echo "TODO: Upload Report"

tail -f /dev/null
