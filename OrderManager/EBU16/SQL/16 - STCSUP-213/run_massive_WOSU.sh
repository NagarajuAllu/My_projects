#! /bin/bash
WOSU_FILE_DIR=$PWD
echo ${WOSU_FILE_DIR}

for entry in "${WOSU_FILE_DIR}"/completion_*.xml ;
do
  echo "processing $entry"
  \cp $entry sendCompletionWOSU.xml
  ./send_single_WOSU.sh
  new_filename=$(echo "$entry" | sed 's/.xml$/.result_xml/')
  \mv responseCompletionWOSU.xml $new_filename
done
