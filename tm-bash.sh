#!/bin/bash

### configuration

logging_log=0
logging_error=1
logging_info=1

# @todo look for wemo.sh in this script's directory instead of full path
wemo_script="/Users/jule_/settings/scripts/tm/wemo.sh"
wemo_ip="192.168.0.66"
wemo_name="WeMo Switch"

progress_divisor=60
progress_character="■"
progress_interval=1

timemachine_volume="timemachine"

clear

### functions

# param1: log-string
log() {
	if [ "$logging_log" == 1 ] ; then
		echo "LOG: $1"
	fi
}

# param1: error-string
error() {
	if [ "$logging_error" == 1 ] ; then
  		echo "ERROR: $1"
	fi
}

# param1: info-string
info() {
	if [ "$logging_info" == 1 ] ; then
  		echo "INFO: $1"
	fi
}

# param1: WeMo's script name
isWemoDependencyAvailable() {
	if [ -f $1 ]; then
   		log "dependency '$wemo_script' is available"
	else
   		error "dependency '$wemo_script' not found."
        exit 1
	fi
}

# param1: IP
# param2: WeMo's friendly name
isWemoAvailable() {
	local wemo_friendlyname=`$wemo_script $1 GETFRIENDLYNAME`
	if [ "$wemo_friendlyname" == "$2" ] ; then
		log "WeMo '$2' is available"
	else
		error "WeMo '$2' with IP $1 not found in network."
        exit 1
	fi
}

# param1: IP
getWemoState() {
	local wemo_state=`$wemo_script $1 GETSTATE`
	if [ "$wemo_state" != "ON" ] &&  [ "$wemo_state" != "OFF" ] ; then
    	error "'$wemo_script $1 GETSTATE' returned $wemo_state"
    	exit 1
    fi
	echo "$wemo_state"
}

# param1: IP
# param2: ON or OFF
setWemoState() {
	if [ "$2" != "ON" ] &&  [ "$2" != "OFF" ] ; then
    	error "use either ON or OFF as second parameter"
    	exit 1
    fi
	local wemo_state=`$wemo_script $1 $2`
	if [ "$wemo_state" == "Error" ] ; then
    	error "failed setting WeMo's state to '$2', maybe it is already '$2'?"
    	exit 1
    fi
	log "WeMo's state is now '$2', return value was '$wemo_state'"
}

# no param
isTimemachineRunning() {
	local running=1
	local tm_status="$(tmutil status)"
	local needle="Running = 0"
    case "$tm_status" in 
        *"$needle"* ) running=0;;
        * ) running=1;;
    esac
    echo "$running"
}

# param1: i
printProgress() {
	# print progress indicator
	printf "$progress_character"
	
	# insert linebreak if necessary
	remainder=`echo "${1}%${progress_divisor}" | bc`
	if [ "$remainder" == 0 ] ; then
   		printf "\n"
	fi		
}

### procedure

isWemoDependencyAvailable "$wemo_script"
isWemoAvailable "$wemo_ip" "$wemo_name"

wemo_state=$(getWemoState "$wemo_ip")
if [ "$wemo_state" == "OFF" ] ; then
	info "setting WeMo to 'ON'"
	setWemoState "$wemo_ip" "ON"
else
	log "WeMo is already 'ON'"
fi

tmRunning=$(isTimemachineRunning)
if [ "$tmRunning" == 0 ] ; then

	# wait until timemachine is available in Finder
	info "waiting for Timemachine volume"
	i=0
	while [ "$mount" == "" ]
	do
		sleep $progress_interval
		mount=$(mount | grep "$timemachine_volume")
		
		i=$[$i+1]
		printProgress "$i"
		
		# @todo maybe add a timeout if user forgets to actually plug in the USB cable
	done
	printf "\n"

	info "starting Timemachine backup"
	
	tmutil startbackup
	
	tmRunning=$(isTimemachineRunning)
	i=0
	while [ "$tmRunning" == 1 ]
	do
		sleep $progress_interval
		tmRunning=$(isTimemachineRunning)
		
		i=$[$i+1]
		printProgress "$i"	
	done
	printf "\n"
	
	info "Timemachine backup complete"
	
	# unmount time machine volume
	mount=$(mount | grep "$timemachine_volume")
	if [ "$mount" ] ; then
		info "unmounting '$timemachine_volume'"
		diskutil quiet unmount "$timemachine_volume"
	else 
    	error "no mount point with '$timemachine_volume' found"
    	exit 1
	fi
	
	mount=$(mount | grep "$timemachine_volume")
	if [ "$mount" ] ; then
		error "unmounting '$timemachine_volume' failed, please check and eject it manually"
		exit 1
	fi
	
	# turn off power
	info "setting WeMo to 'OFF'"
	setWemoState "$wemo_ip" "OFF"
	
	info "Backup complete, Timemachine Volume ejected, Power off"
	info "It is now safe to remove the USB cable from the MacBook Pro"
else
	info "Timemachine is already running";
fi

exit 0