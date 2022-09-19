#!/bin/bash

# NAME
#    Backup script for Redmine distribution from Bitnami
#
# SYNOPSIS
#    bitnami-redmine-backup.sh
#
# COPYRIGHT AND LICENSE
#    Bitnami Redmine Backup is Copyright (C) by Christoph Jahn and 
#    licensed under the GNU General Public License v3.0
#
# DESCRIPTION
#    This script performs a simple backup for the Redmine installation
#    that is provided by Bitnami.
#
#    The following steps will be executed
#    - Get current date/time (format: yyyy-MM-dd_HH-mm-ss) as base file name 
#      for log file and archive
#    - Create empty log file
#    - Stop Redmine
#    - Perform backup (creation of tar.gz file)
#    - Start Redmine
#
#    Log and archive file will be placed at `/mnt/redminebkp`. This path
#    can be changed below, if needed.



# Destination directory, please adjust if needed
BKP_DST_DIR=/mnt/redminebkp


# ==============================================
# No changes should be required below this point
# ==============================================

# Source directory
BKP_SRC_DIR=/opt/bitnami

# Bitnami script to start/stop all components of Redmine
SCRIPT="${BKP_SRC_DIR}/ctlscript.sh"
SRV_STOP="${SCRIPT} stop"
SRV_START="${SCRIPT} start"

# Current date/time to be used for file names
DATE=`date +%F_%H-%M-%S`

# Destiname path and base filename for files
FILE_COMMON="${BKP_DST_DIR}/${DATE}"

# Filename extension for log
LOG_FILE="${FILE_COMMON}.log"

# Filename extension for archive
BKP_ARCHIVE="${FILE_COMMON}.tar.gz"


# ============================
# Actual execution starts here
# ============================

# Create log file
RC=`touch $LOG_FILE; echo $?`
if [ "$RC" -ne "0" ]; then
    echo "Log file could not be created" >2
    exit 1
else
    echo "Starting backup of Redmine. Output will be logged to $LOG_FILE"
fi

# Stop all services
echo "Trying to stop all services prior to backup"
RC=`$SRV_STOP >>$LOG_FILE; echo $?`
if [ "$RC" -ne "0" ]; then
    echo "Error while trying to stop services" >2
    exit 1
else
    echo "All services stopped"
fi

# Create backup
echo "Starting to create backup in $BKP_ARCHIVE"
echo "Using command: tar -pczvf ${BKP_ARCHIVE} ${BKP_SRC_DIR} >>${LOG_FILE}; echo $?"
RC=`tar -pczvf ${BKP_ARCHIVE} ${BKP_SRC_DIR} >>${LOG_FILE}; echo $?`
if [ "$RC" -ne "0" ]; then
    echo "Error while trying to create backup" >2
    exit 1
else
    echo "Backup completed"
fi

# Start all services
echo "Trying to start all services after backup"
RC=`$SRV_START >>$LOG_FILE; echo $?`
if [ "$RC" -ne "0" ]; then
    echo "Error while trying to start services" >2
    exit 1
else
    echo "All services started"
fi
