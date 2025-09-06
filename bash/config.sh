#Configuration for the other aliases and functions

function create_dependency {
	#Argument to be passed to qsub/sbatch to create a dependency on a job (ID of the latter passed as argument)
	#To be used without quoting the output
	echo "-W" "depend=afterany:$1"
	}

_submit_batch="qsub" #this will be used unquoted in some contexts.
_job_script_name="job.pbs"
