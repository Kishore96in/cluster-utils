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
