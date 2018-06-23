#!/bin/sh
kill -9 `ps -ef|grep sar|awk '$3==1 {print $2}'`
kill -9 `ps -ef|grep nmon|awk '$3==1 {print $2}'`
exit 0
