#/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$( cd "$( dirname "${SCRIPT}" )"; pwd )"

if [ $# -ne 2 ]; then
   echo "Error: Script must be run with two arguments."
   exit 1
fi

RMAN_SCRIPT="$1"
RMAN_BACKUP_DIR="$2"

if [ -z "${RMAN_SCRIPT}" ]; then
   echo "Error: RMAN script argument cannot be empty."
   exit 1
fi

if [ -z "${RMAN_BACKUP_DIR}" ]; then
   echo "Error: RMAN backup directory argument cannot be empty."
   exit 1
fi

. ${SCRIPT_DIR}/backup_env.sh

RMAN_SCRIPT="${RMAN_SCRIPT_DIR}/${RMAN_SCRIPT}"
RMAN_CMD="$( which rman 2> /dev/null )"
RMAN_CMD="/u01/app/oracle/product/11.2.0/xe/bin/rman"

if [ -z "${RMAN_CMD}" ] || [ ! -f "${RMAN_CMD}" ]; then
   echo "Error: RMAN command not found. Cannot continue, exiting..."
   exit 1
fi

if [ ! -f "${RMAN_SCRIPT}" ]; then
   echo "Error: RMAN script ${RMAN_SCRIPT} does not exist. Cannot continue, exiting..."
   exit 1
fi

if [ ! -d "${RMAN_BACKUP_DIR}" ]; then
   echo "Backup directory ${RMAN_BACKUP_DIR} is missing. Creating it..."
   if [ ! mkdir -p "${RMAN_BACKUP_DIR}" > /dev/null 2>&1 ]; then
      echo "Error: Unable to create backup directory ${RMAN_BACKUP_DIR}. Cannot continue, exiting..."
      exit 1
   fi
fi

${RMAN_CMD} target / cmdfile="${RMAN_SCRIPT}"