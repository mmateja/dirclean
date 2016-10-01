### Description

The script removes all files and directories inside a provided directory path that were not used for over 30 days.

In case of files it checks maximum of access time and modification. When it comes to directories it recursively finds maximum of those times for all files inside a directory. 

### Usage

`bin/dirclean ~/Downloads`

### Logs

Script creates `/tmp/dirclean.log` file and saves the track of its activity there.
