#!/bin/bash
/usr/bin/consul agent -config-dir /etc/consul.d/bootstrap/&
sleep 30
/usr/bin/consul join consul1 consul2 consul3 
while true; do sleep 300; done
