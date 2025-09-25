function get_workdir_for_jobid {
	_get_job_workdir "$(qstat -wf $@)"
	}
