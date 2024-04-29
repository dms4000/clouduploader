#!/bin/bash

SHOW_ALL_STORAGES=exec az storage account list | grep 'name'
AUTH_MODE=login

$SHOW_ALL_STORAGES

main_upload() {

    ### UPLOAD ###
    UPLOAD=$(exec az storage blob upload\
        --account-name $BLOB_STORAGE_NAME\
        --container-name $CONTAINER_NAME\
        --file $FILENAME\
        --name $NAME\
        --auth-mode $AUTH_MODE\
        --overwrite $OVERWRITE)
        
        
    if [[ "$UPLOAD" == *"client_request_id"* ]] ; then
        echo "File succesfully uploaded!"
    elif [[ "$UPLOAD" == *"ErrorCode:BlobAlreadyExists"* ]] ; then
        date >> error.txt
        echo "$UPLOAD" >> error.txt
        echo "Blob is already exists in the storage"
    elsesa
        date >> error.txt
        echo "$UPLOAD" >> error.txt
        echo "Unknown error check error.txt file"
    fi 

}


link() {
    read -p "Do you want to get sharebale link? y/N " LINK_AGREE

    if [[ "$LINK_AGREE" == "Y" || "$LINK_AGREE" == "y" ]] ; then
        read -p "How many days link works? (max. 7 days) " DAYS
        LINK=$(exec az storage blob generate-sas\
        --account-name $BLOB_STORAGE_NAME\
        --container-name $CONTAINER_NAME\
        --permissions r\
        --name $NAME\
        --auth-mode $AUTH_MODE\
        --as-user\
        --full-uri\
        --expiry `date '+%F' -d "$end_date+$DAYS days"`)
        echo "The link is valid during $DAYS days"
        echo $LINK
    else
        exit 0
    fi 
}


read -p "Enter blob storage name: " BLOB_STORAGE_NAME
exec az storage container list --account-name $BLOB_STORAGE_NAME --auth-mode $AUTH_MODE | grep 'name'
read -p "Enter name of container: " CONTAINER_NAME


### SEARCH FOR FILES IN LOCAL DIRECTORY ###
search_dir=.
for entry in "$search_dir"/*
do
    echo "${entry/'./'/}"
done

read -p "Enter path to file: " FILENAME
NAME=$FILENAME


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
    OVERWRITE='false'
    main_upload
    link
else
    echo "Blob is already exists in the storage"
    read -p "Do you want to overwrite(1)/rename(2)/skip(3) it? " BLOB_EXISTS
        if [[ $BLOB_EXISTS == "overwrite" || $BLOB_EXISTS == "1" ]] ; then
            OVERWRITE='true'
            main_upload
            link
        elif [[ $BLOB_EXISTS == "rename" || $BLOB_EXISTS == "2" ]] ; then  
            OVERWRITE='false'
            read -p "Type new filename: " NAME
            main_upload
            link
        elif [[ $BLOB_EXISTS == "skip" || $BLOB_EXISTS == "3" ]] ; then
            exit 0
        fi

fi 










