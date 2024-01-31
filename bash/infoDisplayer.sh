#! /bin/bash

# Write a script that takes a file path as input
# and displays information about the file,
# such as its size, type, and permissions.

echo " this is A simple program to give you all information you need about the file you will enter"
echo " ---------------------------------------------------------"
echo " choose file from these files or enter the full bath about specific file "
ls -a
echo " ----------------------------------------------------------"
echo " enter the file you need information about it "
read filename
ls -all $filename
