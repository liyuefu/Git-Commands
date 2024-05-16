#!/bin/bash
#read parameter from configuration file.
#para1: name of parameter

if [ -z $1 ];then
        echo "USAGE:parameter name"
        exit 0
fi
export PARANAME=$1
export PARAFILE=`pwd`'/para.cfg'

gawk 'BEGIN{FS="=";paraName=ENVIRON["PARANAME"];paraValue="";}
        ($0!~/^$/&&$0!~/^#/){
        if($1==paraName){
                paraValue=$2
        }
}END{print paraValue}' $PARAFILE
