#!/bin/bash

# constants
CHECKING_TIME_INTERVAL_IN_MINUTES=1
#
IS_SNAPSHOT_CREATED=1
# ====================
cd `dirname $0`
./init_repo.sh
[ $? -ne 0 ] && exit 1

echo "Try Deleting snapshot \"snapshots:01\" ..."
./delete_snapshot.sh 2>&1

echo ""
echo "Wait for the snapshot \"snapshots:01\" to be removed ..."
while true; do
  GET_SNAPSHOT_RESULT=`./get_snapshot.sh 2>&1`
  HTTP_CODE_404=`echo "${GET_SNAPSHOT_RESULT}" | grep "HTTP/1.1 404"`
  HTTP_CODE_500=`echo "${GET_SNAPSHOT_RESULT}" | grep "HTTP/1.1 500"`
  if [ "${HTTP_CODE_404}" != "" ]; then
    break;
  fi
  if [ "${HTTP_CODE_500}" != "" ]; then
    echo "Error deleting snapshot \"snapshots:01\" before creating a new snapshot."
    exit 1
  fi
  echo "Verify for the snapshot \"snapshots:01\" to be deleted on next ${CHECKING_TIME_INTERVAL_IN_MINUTES} minutes"
  sleep ${CHECKING_TIME_INTERVAL_IN_MINUTES}m
done
echo "Snapshot \"snapshots:01\" is deleted."
echo ""
echo "Create a new snapshot \"snapshots:01\""
./create_snapshot.sh
echo ""

while true; do
  GET_SNAPSHOT_RESULT=`./get_snapshot.sh 2>&1`
  GET_RESULT_JSON=`echo "${GET_SNAPSHOT_RESULT}" | tail -n 1`
  SUCCESS_RESULT=`echo "${GET_RESULT_JSON}" | grep '"state":"SUCCESS"'`
  FAILED_RESULT=`echo "${GET_RESULT_JSON}" | grep '"state":"FAILED"'`
  PARTIAL_RESULT=`echo "${GET_RESULT_JSON}" | grep '"state":"PARTIAL"'`
  INCOMPATIBLE_RESULT=`echo "${GET_RESULT_JSON}" | grep '"state":"INCOMPATIBLE"'`
  if [ "${SUCCESS_RESULT}" != "" ]; then
    echo -e "ELK elasticsearch backup completed: \n${GET_SNAPSHOT_RESULT}"
    IS_SNAPSHOT_CREATED=0
    break
  fi
  if [ "${FAILED_RESULT}" != "" ] || [ "${PARTIAL_RESULT}" != "" ] || [ "${INCOMPATIBLE_RESULT}" != "" ]; then
    echo -e "ELK elasticsearch backup failed: \n${GET_SNAPSHOT_RESULT}"
    IS_SNAPSHOT_CREATED=1
    breakw
  fi
  # wait sometime for next interval checking
  sleep ${CHECKING_TIME_INTERVAL_IN_MINUTES}m
done
exit $IS_SNAPSHOT_CREATED
