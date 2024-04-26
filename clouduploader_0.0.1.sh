#!/bin/bash

SHOW_ALL_STORAGES=exec az storage account list | grep 'name'
#SHOW_ALL_CONTAINERS=exec az storage container list --account-name $BLOB_STORAGE_NAME | grep 'name'
AUTH_MODE=login

$SHOW_ALL_STORAGES
read -p "Enter blob storage name: " BLOB_STORAGE_NAME
#$show_all_containers
exec az storage container list --account-name $BLOB_STORAGE_NAME --auth-mode $AUTH_MODE | grep 'name'
read -p "Enter name of container: " CONTAINER_NAME


### SEARCH FOR FILES IN LOCAL DIRECTORY ###
search_dir=.
for entry in "$search_dir"/*
do
    echo "${entry/'./'/}"
done

read -p "Enter path to file: " FILENAME
#read -p "Enter name of blob storage: "


### CHECK IF FILE EXISTS LOCALLY ###
if [ -f ./$FILENAME ]
then
    echo "File $FILENAME locally exists."
else
    echo "File $FILENAME locally doesn't exists."
    exit 0
fi


### CHECK IF FILE EXISTS REMOTELY ###
CHECK_BLOB=$(exec az storage blob exists\
    --account-name $BLOB_STORAGE_NAME\
    --container-name $CONTAINER_NAME\
    --name $FILENAME\
    --auth-mode $AUTH_MODE)

if [[ "$CHECK_BLOB" == *"false"* ]] ; then
    echo "Blob doesn't exists in the storage"
else
    echo "Blob is already exists in the storage"
    exit 0
fi 
#echo "$CHECK_BLOB"


### UPLOAD ###
UPLOAD=$(exec az storage blob upload\
    --account-name $BLOB_STORAGE_NAME\
    --container-name $CONTAINER_NAME\
    --file $FILENAME\
    --name $FILENAME\
    --auth-mode $AUTH_MODE)
    
    
if [[ "$UPLOAD" == *"client_request_id"* ]] ; then
    echo "File succesfully uploaded!"
elif [[ "$UPLOAD" == *"ErrorCode:BlobAlreadyExists"* ]] ; then
    date >> error.txt
    echo "$UPLOAD" >> error.txt
    echo "Blob is already exists in the storage"
else
    date >> error.txt
    echo "$UPLOAD" >> error.txt
    echo "Unknown error check error.txt file"
fi 