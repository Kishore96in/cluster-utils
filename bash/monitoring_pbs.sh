#Aliases and functions to help monitor PBS jobs

#TODO: in config.sh, may set a variable that chooses between SLURM and PBS. PBS- or SLURM-specific stuff can then be moved to separate files which are conditionally included.

alias ja='qstat -taw' #All jobs
alias jaq='qstat -taw | grep Q' #All queued jobs
alias jar='qstat -taw | grep R' #All running jobs
alias myq="qstat -taw | grep $USER" #All jobs belonging to the current user
alias jinfo='qstat -f' #Get information about a job ID

function _ntype {
	#TODO: I suppose this is specific to IUCAA's Pegasus.
	#Find which node type a job requested
# 	nt="$(qstat -f "$@" | grep Resource_List.select | tr ':' '\n' | grep node_type | cut -d '=' -f 2)"
	nt="$(echo "$@" | grep Resource_List.select | tr ':' '\n' | grep node_type | cut -d '=' -f 2)"
	if [ "$nt" = "lenovo" ]
	then
		echo "L"
	elif [ "$nt" = "advance" ]
	then
		echo "A"
	else
		echo "-"
	fi
}
export -f _ntype
function get_job_workdir {
	#Parse output of qstat -wf to get the job's workdir
	qsoutput="$@"
	echo "$qsoutput" | grep WORKDIR | tr ',' '\n' | grep WORKDIR | cut -d'=' -f 2
}
export -f get_job_workdir
function myj {
	tmpfile="/tmp/kishore_jobs_$BASHPID.txt"
	truncate -s 0 "$tmpfile" #Make the file empty.
	echo "Job ID" "," " " "," "Walltime" "," "CPU" "," "nod"  "," "Working directory" >> "$tmpfile"
	
	jobs=$(qstat -t | grep "$USER" | awk '{print $1 "," $5}')
	n_unheld_jobs=$(echo $jobs | tr ' ' '\n' | grep -v H | wc -l)
	cores=0 #Count the total number of cores I am using
	for job in $jobs
	do 
		jobid=$(echo "$job" | cut -d',' -f 1)
		jobstat=$(echo "$job" | cut -d',' -f 2)
		qsoutput="$(qstat -wf $jobid)"
		if ! echo "$qsoutput" | grep "job_state =" > /dev/null
		then
			#This probably means this particular job has exited after we populated $jobs
			continue
		fi
		#wdir="$(echo "$qsoutput" | grep WORKDIR | cut -d',' -f 7 | cut -d'=' -f 2 )"
		#wdir="$(echo "$qsoutput" | grep WORKDIR | tr ',' '\n' | grep WORKDIR | cut -d'=' -f 2 )"
		wdir=$(get_job_workdir "$qsoutput")
		if [ "$jobstat" = "R" ]
		then
			walltime="$(echo "$qsoutput" | grep resources_used.walltime | cut -d'=' -f 2 | tr -d ' ')"
			tmpcores="$( echo "$qsoutput" | grep resources_used.ncpus | cut -d'=' -f 2 | tr -d ' ' )"
			if ! [ -z "$tmpcores" ]
			then
				cores=$(( cores + tmpcores ))
			fi
		else
			walltime="--:--:--"
		fi
		max_walltime="$(echo "$qsoutput" | grep Resource_List.walltime | cut -d'=' -f 2 | tr -d ' ')"
		cores_req="$( echo "$qsoutput" | grep Resource_List.ncpus | cut -d'=' -f 2 | tr -d ' ' )" #Number of CPUs requested. This may be different from the number of CPUs used if the job is queued or held.
		node_type="$(_ntype "$qsoutput")"
		#TODO: while outputting wdir, if all the wdirs have common directories in front, see if I can elide them by '...'
		if [[ "$wdir" == "$HOME"/* ]]
		then
			wdir="~/${wdir#$HOME/}"
		fi
		echo "$jobid" "," "$jobstat" "," "$walltime/$max_walltime" "," "$cores_req" "," "$node_type" "," "$wdir" >> "$tmpfile"
	done
	cat "$tmpfile" | column -o " | " -t -s ","
	echo " "
	echo "Total cores used by me: $cores"
	echo "My unheld jobs: $n_unheld_jobs"
	rm "$tmpfile"
}
export -f myj #This is so that I can call the function in 'watch'
