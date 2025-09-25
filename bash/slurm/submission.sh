function get_workdir_for_jobid {
	scontrol show job $@ | grep WorkDir | cut -d '=' -f 2
	}
