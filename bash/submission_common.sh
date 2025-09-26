#TODO: it seems some of these functions are becoming complicated enough that I should write them as Python scripts (this would allow me to reuse the logic in more places)

#NOTE: must be sourced after either of {pbs,slurm}/submission.sh

function pc_stop {
	#Stop pencil jobs given a set of job ids as arguments
	cdir=$(pwd)
	for job in "$@"
	do
		dir=$(get_job_workdir "$(qstat -wf $job)")
		cd "$dir"
		touch STOP
		cd "$cdir"
	done
}
function pc_reload {
	#Reload pencil jobs (touch RELOAD) given a set of job ids as arguments
	cdir=$(pwd)
	for job in "$@"
	do
		dir=$(get_job_workdir "$(qstat -wf $job)")
		cd "$dir"
		touch RELOAD
		cd "$cdir"
	done
}

function sub {
	#Submit jobs given a set of directories as arguments
	cdir=$(pwd)
	for dir in "$@"
	do
		if test -e "$dir"; then
			(
			cd "$dir"
			
			#Load modules to ensure that SLURM picks up the right environment for the job
			if test -e "load_modules.sh"; then
				module purge
				source load_modules.sh
			fi
			
			$_submit_batch "$_job_script_name"
			if [ $? -ne 0 ]
			then
				echo "$(tput bold)"
				echo "Failed submitting job in $dir"
				echo "$(tput sgr0)"
			else
				echo "Successfully submitted job in $dir"
			fi
			)
		else
			echo $dir does not exist!
		fi
	done
}
function subh {
	local _submit_batch_orig="$_submit_batch"
	local _submit_batch="$_submit_batch_orig -h"
	sub "$@"
	}

function _get_pcver {
	#git -C $PENCIL_HOME rev-parse HEAD
	#NOTE: The -C option does not exist in very old versions of git (e.g. aqua.iitm.ac.in has git 1.8.3.1
	git --git-dir="$PENCIL_HOME"/.git rev-parse HEAD
	}

function _pc_sub {
	#First argument is the name of the job script, and the remaining arguments are the directories to use.
	scriptname="$1"
	shift
	for dir in "$@"
	do
		(
		if test -e "$dir"; then
			cd "$dir"

			if test -e "load_modules.sh"; then
				module purge
				source load_modules.sh
			fi

			echo "$(date)" > build_output.txt
			echo Pencil version: "$(_get_pcver)" >> build_output.txt
			pc_setupsrc >> build_output.txt 2>&1 && pc_build >> build_output.txt 2>&1 && $_submit_batch "$scriptname"
			if [ $? -ne 0 ]
			then
				echo "$(tput bold)"
				echo "Failed submitting job in $dir"
				echo "$(tput sgr0)"
			else
				echo "Successfully submitted job in $dir"
			fi
		else
			echo $dir does not exist!
		fi
		)
	done
}

function pc_sub {
	_pc_sub "$_job_script_name" "$@"
}
function pc_subh {
	local _submit_batch_orig="$_submit_batch"
	local _submit_batch="$_submit_batch_orig -h"
	pc_sub "$@"
	}

#TODO: pc_resub, resub (see implementation on Pegasus). I suppose it may make sense to just chain pc_stop and sub. Note that at least on SLURM with lmod (not tclmod), even the `module` command is not defined in the job script's context; one HAS to use --export=ALL to get the modules active at the time of job submission. It then makes sense to also make the `sub` function load the modules before calling sbatch/qsub.
#TODO: resubh, pc_resubh (see implementation on Pegasus)
