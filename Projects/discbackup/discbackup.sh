#!/bin/bash

# Parse the command line
usage() {
  echo $0 Backup a file system to a local file
  echo ' '
  echo $0 '[-f|-d] -c config_file'
  echo ' '
}

# Find the directory in which this script lives
getMyDirectory() {
  # Full path spec to script
  if echo $0 | grep -q -e '^/' ; then
    myDir=`dirname $0`
  
  # Current dir relative
  elif  echo $0 | grep -q -e '^./' ; then
   myDir=`pwd`/`dirname $0`

  # Using PATH
  else
   whichPath=`which $0`
   mYDir=`basename $whichPath`
  fi
}

# Check the user config file for a backupName and backupFS
validateUserConfig() {
  valid="True"
  if [ -z ${backupName} ] ; then
    echo backupName not defined in user config file
    valid="False"
  fi

  if [ -z ${backupFS} ] ; then
    echo backupFS not defined in user config file
    valid="False"
  fi

  if [ ${valid} != "True" ] ; then
    exit -1
  fi
}

# Mount the filesystem to be backed up
mountFileSystem() {
  echo "Mounting ${backupFS}"
  if echo ${backupFS} | grep -q -e '^//' ; then
    mount -t smbfs -o credentials=${backupDir}/smbcredentials ${backupFS} ${localMountPoint}
    if [ $? != "0" ] ; then
      echo "Unable to mount" ${backupFS} on ${localMountPoint}
      exit -1
    fi

  elif echo ${backupFS} | grep -q -e ':' ; then
    mount ${backupFS} ${localMountPoint}
    if [ $? != "0" ] ; then
      echo "Unable to mount" ${backupFS} on ${localMountPoint}
      exit -1
    fi

  elif [ ${backupFS} = "/" ] ; then  
    echo "Local filesystem"

  else
    echo "Unknown filesystem specfication: " ${backupFS}
    exit -1
  fi
}

archiveBackupSequence() {
  echo "Archiving old backup sequence"
  echo backupDir ${backupDir}
  archiveDir=${backupDir}/OldBackup
  archiveDirTemp=${backupDir}/OldBackup.temp
  echo archiveDir ${archiveDir}
  echo archiveDirTemp ${archiveDirTemp}
  if [ -e ${archiveDir} ] ; then
    echo "Moving old archive dir"
    mv  ${archiveDir} ${archiveDirTemp} 
    if [ $? != "0" ] ; then
      echo "Unable to move archive directory " ${archiveDir} to ${archiveDirTemp} 
      exit -1
    fi
  fi
  
  echo "Making archive dir"
  mkdir ${archiveDir}
  if [ $? != "0" ] ; then
    echo "Unable to create archive directory " ${archiveDir}
    exit -1
  fi

  # Move the full backup and any differential backups into the archive directory
  echo "Moving full archive if any"
  ls ${fullArchivePath} > /dev/null 2>&1
  if [ $? = "0" ] ; then
    mv ${fullArchivePath}* ${archiveDir}
    if [ $? != "0" ] ; then
      echo "Unable to move " ${fullArchivePath} to ${archiveDir}
      exit -1
    fi
  fi

  echo "Moving any differential archives"
  ls ${backupDir}/${diffBackBase}* > /dev/null 2>&1
  if [ $? = "0" ] ; then
    mv ${backupDir}/${diffBackBase}* ${archiveDir}
    if [ $? != "0" ] ; then
      echo "Unable to move differential archives" to ${archiveDir}
      exit -1
    fi
  fi
}
echo " "
echo " "
echo "AfioHDBackup"
date
# Default values
localMountPoint=/mnt/AfioBackup

# Check to see if we have enough arguments
if [[ $# < "1" ]] ; then
  usage
  exit 2
fi

while getopts "c:df" Option
do
  case $Option in
    c )
      configFile=$OPTARG
      ;;

    d )
      flgFullBackup="False"
      echo "Performing differential backup"
      ;;

    f )
      flgFullBackup="True"
      echo "Performing full backup"
      ;;

    * )
      echo "Unknown option: $Option."
      ;;
  esac
done

shift $(($OPTIND - 1))

# Add /usr/local/bin to the path
export PATH=${PATH}:/usr/local/bin

getMyDirectory


# Load in the system configuration file then the one specified on the command line
. $myDir/afioHDBackup.config
if [ -n "${configFile}" ] ; then
  . ${configFile}
else
  usage
  exit -1
fi

backupDir=${baseBackupDir}/${backupName}

# Validate the user config file
validateUserConfig

# Mount the required filesystem
mountFileSystem

# Construct the exclude and compression file name
excludeArgs=""
if [ -e ${backupDir}/${excludeFile} ] ; then
  echo "Using exclude file" ${backupDir}/${excludeFile}
  excludeArgs="-W ${backupDir}/${excludeFile}"
fi

nocompressArgs=""
if [ -e ${backupDir}/${noCompress} ] ; then
  echo "Using no compression file" ${backupDir}/${noCompress}
  nocompressArgs="-E ${backupDir}/${noCompress}"
fi


# Construct the full archive file name
fullArchivePath=${backupDir}/${fullBackFile}

# If this is a full backup preserve the existing backup sequence
# assign the appropriate archive path and log
if [ ${flgFullBackup} = "True" ] ; then
  archivePath=${fullArchivePath}
  archiveBackupSequence
  differentialArgs=""
else
  strDate=`date "+%F_%H_%M"`
  archivePath=${backupDir}/${diffBackBase}-${strDate}.afio
  differentialArgs="-newer $fullArchivePath"
fi
archiveLog=${archivePath}.log


# Cd to the filesyststem and afio archive it the specified backup file
cwd=`pwd`
cd ${localMountPoint}

echo "Creating afio archive file"
find "${backupPaths[@]}" ${differentialArgs} |\
  afio -v -o ${compressionArgs} ${excludeArgs} ${nocompressArgs} ${archivePath} 2> ${archiveLog}
retVal="$?"
if [ ${retVal} != "0" ] ; then
  echo "afio returned a nonzero status of " ${retVal}
fi

# verify the backup
echo "Verifying afio archive against filesystem"
afio -r ${compressionArgs} ${archivePath}
retVal="$?"
if [ ${retVal} != "0" ] ; then
  echo "afio verify returned a nonzero status of " ${retVal}
else
  echo "  verify passed"
fi

# unmount the file system
cd ${cwd}
echo "Unmounting ${backupFS}"
umount ${localMountPoint}

# Clean up the archived sequence if this is full backup
if [ ${flgFullBackup} = "True" ] ; then 
 echo archiveDirTemp ${archiveDirTemp}

 if [ -e ${archiveDirTemp} ]; then
  rm -rf ${archiveDirTemp}
 fi
fi
