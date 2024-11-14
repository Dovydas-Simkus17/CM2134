#!/bin/bash
#Task 4

#Tells user when backup starts
currTime=$(date)
echo "Started backup at: $currTime" | cat >> 25_cyber_project/log.txt

#the current date of backup
dateStamp=$(date +"%Y-%m-%d")
#where we want to send the folders
backUpName="backUpmain.$dateStamp"

#Search the main folder 3 folders deep, including itself, reading only directories
find ./25_cyber_project/main -maxdepth 3 -mindepth 0 -type d | while read dir; do
 #Print to log which directory we are in and add to zip
 zip -u 25_cyber_project/$backUpName $dir | cat >> 25_cyber_project/log.txt
 count=1
 #Check if there is a file in the folder
 find $dir -maxdepth 1 -mindepth 0 -type f | while read file; do
  #echo "current $dir and current file $count"
  #Any files will be added to the zip file with according log print
  zip -u 25_cyber_project/$backUpName $file | cat >> 25_cyber_project/log.txt
  ((count+=1))
 done
done

#Tells user when backup finishes AND add log to zip file
currTime=$(date)
echo "Finished backup at: $currTime" | cat >> 25_cyber_project/log.txt



