alias jdel='qdel'
alias jint='qsub -I -lselect=1:ncpus=1'

function create_dependency {
	#Argument to be passed to _submit_batch to create a dependency on a job (ID of the latter passed as argument)
	#To be used without quoting the output
	echo "-W" "depend=afterany:$1"
	}

_submit_batch="qsub" #this will be used unquoted in some contexts.
_submit_batch_held_flag="-h"

function get_workdir_for_jobid {
	_get_job_workdir "$(qstat -wf $@)"
	}
