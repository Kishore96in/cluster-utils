#Aliases and functions to help monitor PBS jobs

#TODO: in config.sh, may set a variable that chooses between SLURM and PBS. PBS- or SLURM-specific stuff can then be moved to separate files which are conditionally included.

alias ja="squeue --format='%.6i  %.2t %.9L %.3C' " #All jobs
alias jaq='squeue --format="%.6i  %.2t %.9L %.3C" | grep PD' #All queued jobs
alias jar='squeue --format="%.6i  %.2t %.9L %.3C" | grep R' #All running jobs
alias myq="squeue --format='%.6i  %.2t %.9L %.3C'-u $USER" #All jobs belonging to the current user
alias jinfo='scontrol show job' #Get information about a job ID

alias myj="squeue --format='%.6i  %.2t %.9L %.3C  %Z' --sort='-ti' -u $USER | sed \"s#$HOME#~#g\" | sed 's#\./##g'"
