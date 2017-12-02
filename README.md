# xdmod_cisl_logingest
## Logingest service for CISL XDMOD

This service processes daily resource accounting files.

The service will loop, waiting for daily accounting files to appear under a
specific directory (/var/cisl_acct_log/resources-xdmod.d by default); the
file names are assumed to be in the form <resource>/<type>/<YYYYMMDD>, where
<resource> is a resource name, <type> is "lsf", "pbs", or "slurm", and
<YYYYMMDD> is a date.

Whenever a daily account file appears, the file is shredded and then ingested.
If both steps are successful, the file is removed. If an error in encountered,
the file is temporarily moved to "<YYYYMMDD>.rejected". When there are no more
files to process, the service sleeps for a configurable time and then restarts
the loop. Files with the ".rejected" suffix are automatically renamed to remove
the suffix after a configurable retry period; the renamed files are then
processed again as if they were just detected.

