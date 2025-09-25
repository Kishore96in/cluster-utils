# Installation

To use these, clone the repository at, say, `~/.software/cluster-utils/`, and add the following to your bashrc (depending on the scheduler available).

## PBS
```
_job_script_name="job.sh"
_cluster_utils_location="$HOME/.software/cluster-utils"
source "$_cluster_utils_location"/bash/pbs/monitoring.sh
source "$_cluster_utils_location"/bash/pbs/submission.sh
source "$_cluster_utils_location"/bash/submission_common.sh
```

## SLURM
```
_job_script_name="job.sh"
_cluster_utils_location="$HOME/.software/cluster-utils"
source "$_cluster_utils_location"/bash/slurm/monitoring.sh
source "$_cluster_utils_location"/bash/slurm/submission.sh
source "$_cluster_utils_location"/bash/submission_common.sh
```
