#! /bin/bash
# this will be a simple scanner to intiate a scan of MYSQL port .

nmap -sT 192.168.1.13 -p 3306 >/dev/null -oG MYSQLscan
cat MYSQLscan |grep close > MYSQLscan2
cat MYSQLscan2

