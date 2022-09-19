# Backup script for Redmine distribution from Bitnami

This script performs a simple backup for the Redmine installation
that is provided by Bitnami.

The following steps will be executed
- Get current date/time (format: yyyy-MM-dd_HH-mm-ss) as base file name 
  for log file and archive
- Create empty log file
- Stop Redmine
- Perform backup (creation of tar.gz file)
- Start Redmine

Log and archive file will be placed at `/mnt/redminebkp`. This path
can be changed in the script, if needed.


## Target system

There are two alternatives to ensure that the backup data are stored
in a safe location (typically a NAS or some kind of cloud storage):
- Mount an SMB or NFS share into the target path (recommended)
- Transfer the data to its final destination via a separate script
  (theoretically this could also be done manually, but in practice
  this creates a high risk of errors or forgetting it altogether)


## Backup content

A single backup will be around 300 MB for a fresh system. This size
stems from the fact that the entire `/opt/bitnami` directory is copied to
the archive file. While this is somewhat inefficient, it is done
to ensure that all binaries are available and have the correct versions
for the actual data.
