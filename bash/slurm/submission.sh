alias jdel='scancel'
alias jint='salloc --ntasks=1 srun --pty bash -l'
alias jhold='scontrol hold'
alias jrls='scontrol release'

function create_dependency {
	#Argument to be passed to _submit_batch to create a dependency on a job (ID of the latter passed as argument)
	#To be used without quoting the output
	echo "--dependency=afterok:$1"
	}

_submit_batch="sbatch" #this will be used unquoted in some contexts.
_submit_batch_held_flag="-H"

function get_workdir_for_jobid {
	scontrol show job $@ | grep WorkDir | cut -d '=' -f 2
	}
