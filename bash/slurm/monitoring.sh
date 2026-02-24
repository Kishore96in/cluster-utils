#Aliases and functions to help monitor PBS jobs

alias ja="squeue --format='%.6i  %.2t %.9L %.5C  %u' " #All jobs
alias jaq='squeue --format="%.6i  %.2t %.9L %.5C  %u" | grep PD' #All queued jobs
alias jar='squeue --format="%.6i  %.2t %.9L %.5C  %u" | grep R' #All running jobs
alias myq="squeue --format='%.6i  %.2t %.9L %.5C'-u $USER" #All jobs belonging to the current user
alias jinfo='scontrol show job' #Get information about a job ID

alias myj="squeue --format='%.6i  %.2t %.9L %.5C  %Z' --sort='-ti' -u $USER | sed \"s#$HOME#~#g\" | sed 's#\./##g'"
