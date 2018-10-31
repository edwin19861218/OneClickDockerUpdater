#!/bin/bash

DOCKERDIR="$HOME/dockerfiles"
IGNORELIST="ignoreList.txt"
cd $DOCKERDIR

if [ -s $(echo "$DOCKERDIR$IGNORELIST") ]
then
	IGNORE=$(cat `cat ignoreList.txt` | grep "\-\-name=" | cut -d '=' -f 2 | cut -d ' ' -f 1)  #Read an ignore list and get the name of containers from their respective dockerfiles
else
	echo "Empty ignore list."
	IGNORE="LOREMIPSUMLOREMIPSUM"	#Add something unlikely to be found to IGNORE
fi

LINES=$(docker ps -a | grep -v "$IGNORE" | grep -v latest | grep -v CONTAINER) #Get docker lines without IGNORE  and the ones without the latest image

if [ -z "$LINES" ]
then
	echo "Nothing to update. Exiting."
	exit 0
fi

NAMES=$(echo "$LINES" | grep -oE '[^ ]+$') #Get the names of the dockers to be updated
IDS=$(echo "$LINES" | cut -d ' ' -f 1)	#Get the remaining IDs
UPDATELIST=$(grep -l "$NAMES" * 2>/dev/null) #Make a list of the dockerfiles that are in need of an update

#
#echo "----------------------------DEBUGGING ----------------------------"
#echo "IGNORE LIST $IGNORE"
#echo "LINES $LINES"
#echo "IDS $IDS"
#echo "NAMES $NAMES"
#echo "UPDATELIST $UPDATELIST"
#echo "------------------------------------------------------------------"
#

#Stop and remove the containers to be updated
docker stop $IDS
docker rm $IDS

#Create the new containers
for f in $UPDATELIST; do  # or wget-*.sh instead of *.sh
	echo -e  "\n===$f===\n"
	bash "$f" || continue
done

#Start the new containers and prune the old images
docker start `docker ps -aq` > /dev/null 2>&1
yes | docker image prune > /dev/null 2>&1 

exit 0
