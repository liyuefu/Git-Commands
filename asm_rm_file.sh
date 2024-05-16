#!/bin/bash
#run as grid user.
DATA_GROUP="+data"
DB_UNIQUE_NAME=ctp
#delete datafile, tempfile, controlfile
for dir in $(asmcmd ls ${DATA_GROUP}/${DB_UNIQUE_NAME}); do
    asmcmd rm ${DATA_GROUP}/${DB_UNIQUE_NAME}/$dir/*
done
#delete archivelog
for dir in $(asmcmd ls ${DATA_GROUP}/${DB_UNIQUE_NAME}/archivelog); do
    asmcmd rm ${DATA_GROUP}/${DB_UNIQUE_NAME}/archivelog/$dir/*
done

