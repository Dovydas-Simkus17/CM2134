#!/bin/bash
#Task 1

#Make a main folder that holds group 1 and group 2 folders

#Make users 1 - 3 for group 1 and 4 - 5 for group 2
#Each user has their own folder

#User xy can see both

#Functions
#To add folders and groups to relevant folders
makeFolders(){ 
	mkdir main

	for i in {1,2}; do
		echo "Current number is $i"
		name="main/folder0$i"
		mkdir "$name"
		
		groupadd "group0$i"
		
		#Set default
		commandGroup="-m d:g:group0$i:rwx $name"
		setfacl $commandGroup 
		#Set group privilege 
		commandGroup="-m g:group0$i:rwx $name"
		setfacl $commandGroup 
		#Set default in main
		commandGroup="-m d:g:group0$i:rwx main"
		setfacl $commandGroup
		#Set privilege in main
		commandGroup="-m g:group0$i:rwx main"
		setfacl $commandGroup
		
	done
	touch main/check.sh
	echo "The folder structure has been made"
}

addAdmin(){
	username="userXY"
	useradd $username
	#Set current folder privilege
	command="-R -m u:$username:rwx main"
	setfacl $command
	#Set default privilege
	command="-R -m d:u:$username:rwx main"
	setfacl $command
}


#To add users to a group and their own folders
addUsers(){
	echo "here is $1 folder"
	currentFolder=$1
	currentFolderNumber=${currentFolder:7:1}

	echo "here is $2 loop amount"
	loopAmount=$2
	echo "here is $3 starting point"
	startPoint=$3
	for i in $(seq 1 $2); do
		#Make User
		username="user0$startPoint"
		useradd $username
		
		#Privilege for Main
		command="-m d:u:$username:rx main/$1"
		setfacl $command
		
		#Add user to group
		command="-aG group0$currentFolderNumber $username"
		usermod $command
		
		#Make userFolder
		userFolder="main/$1/userfolder0$startPoint"
		mkdir $userFolder
		#Default Privilege for folder
		command="-R -m d:u:$username:rwx $userFolder"
		setfacl $command
		#User Privilege for folder
		command="-R -m u:$username:rwx $userFolder"
		setfacl $command
		#Make file to check privilege
		userFile="$userFolder/user$startPoint.sh"
		touch $userFile
		
		#Increment
		((startPoint+=1))
		echo $startPoint
	done

}

#Main Script
currentUser=1
makeFolders

addAdmin
addUsers "folder01" 3 "$currentUser"
addUsers "folder02" 2 "$startPoint"
