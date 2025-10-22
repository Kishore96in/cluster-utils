# Installation

To use these,
1. clone the repository at, say, `~/.software/cluster-utils/`; and
2. depending on the scheduler available, add one of the following to your `~/.bash_profile`.

## PBS
```
_job_script_name="job.pbs"
_cluster_utils_location="$HOME/.software/cluster-utils"
. "$_cluster_utils_location"/bash/pbs/monitoring.sh
. "$_cluster_utils_location"/bash/pbs/submission.sh
. "$_cluster_utils_location"/bash/submission_common.sh
```

## SLURM
```
_job_script_name="job.sh"
_cluster_utils_location="$HOME/.software/cluster-utils"
. "$_cluster_utils_location"/bash/slurm/monitoring.sh
. "$_cluster_utils_location"/bash/slurm/submission.sh
. "$_cluster_utils_location"/bash/submission_common.sh
```

# Commands

## Cluster/job status
- `ja`: show all jobs
- `jaq`: show all queued jobs
- `jar`: show all running jobs
- `myq`: show current user's jobs
- `myj`: more detailed display of current user's jobs

## Job handling
### Generic
- `jdel $job_id`: cancels a job
- `jint`: requests an interactive job
- `sub $job_dir_1 $job_dir_2`: submit jobs, one job for each given directory
- `subh $job_dir_1 $job_dir_2`: submit jobs in a held state

### Pencil-code-specific
- `pc_stop $job_id_1 $job_id_2`
- `pc_reload $job_id_1 $job_id_2`
- `pc_sub $job_id_1 $job_id_2`
- `pc_suh $job_id_1 $job_id_2`
