[![Build Status](https://travis-ci.org/mmateja/dirclean.svg?branch=master)](https://travis-ci.org/mmateja/dirclean)

### Description

The script removes all files and directories inside a provided directory path that were not used for over 30 days.

In case of files it checks maximum of access time and modification. When it comes to directories it recursively finds maximum of those times for all files inside a directory. 

### Usage

`bin/dirclean directory_path ...`

### Logs

Script creates `/tmp/dirclean.log` file and saves the track of its activity there.
