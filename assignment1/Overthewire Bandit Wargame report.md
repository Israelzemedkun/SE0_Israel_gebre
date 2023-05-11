Overthewire Bandit Wargame report
Level 0 to Level 1
Task
Log into the level with SSH.
Get the password from the file called readme.
Server: bandit.labs.overthewire.org

Connect to the Bandit Level 0 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit0

Enter the password when prompted: bandit0

Use the ls command to list the contents of the directory. There is a file called readme.
bandit0@bandit:~$ ls
readme


Use the cat command to display the contents of the file: cat readme.

bandit0@bandit:~$ cat readme
NH2SXQwcBdpmTEzi3bvBHMM9H66vVXjL

Level 1 to Level 2

Task
Get the password from the file called ‘-’.

Connect to the Bandit Level 1 server using SSH:
   ssh bandit.labs.overthewire.org -p 2220 -l bandit1

Enter the password when prompted: NH2SXQwcBdpmTEzi3bvBHMM9H66vVXjL

ls command to list the contents of the directory.

bandit1@bandit:~$ ls

-
There is a file called - (a hyphen). ‘-’ is the standard option character for adding specific options to a command. Hence a file with this symbol as the first character cannot just be referenced as other files. Instead, use the following command to display the contents of the file: cat ./-.


bandit1@bandit:~$ cat ./-
rRGizSaX8Mk1RTb1CNQoXTcYZWU6lgzi


Level 2 to Level 3

Task

Get the password from the file called ‘spaces in this filename’.

Connect to the Bandit Level 2 server using SSH:

ssh bandit.labs.overthewire.org -p 2220 -l bandit2


Enter the password when prompted: rRGizSaX8Mk1RTb1CNQoXTcYZWU6lgzi

Once logged in, use the ls command to list the contents of the directory.

bandit2@bandit:~$ ls
spaces in this filename


There is a file called spaces in this filename. It is unconventional and goes against best practice to include spaces in a filename (as well as a directory name). The reason for this, is that In a command, spaces indicate a new addition to the command. In  this case we have to indicate that the words belong together to one name. This can be done with quotes (single or double), 

bandit2@bandit:~$ cat 'spaces in this filename'
aBZ0W5EmUfAf7kHTQeOwd8bauFJ2lAiG




Level 3 to Level 4

Task

Get the password from a hidden file in the inhere directory.

Connect to the Bandit Level 3 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit3

Enter the password when prompted: aBZ0W5EmUfAf7kHTQeOwd8bauFJ2lAiG

Use the ls command to list the contents of the directory.

bandit3@bandit:~$ ls
inhere


There is a directory called inhere. Use the cd command to change to this directory: cd inhere.

bandit3@bandit:~$ cd inhere
bandit3@bandit:~/inhere$ ls -a
.  ..  .hidden

The file with the password is called .hidden, and we can read its content.
cat .hidden
2EW7BBsr6aMMoJ2HjW067dm8EgX26xNe

.

Level 4 to Level 5

Task

Get the password from a file that is the only human-readable file in the inhere directory.

Connect to the Bandit Level 4 server using SSH:
bandit.labs.overthewire.org -p 2220 -l bandit4

Enter the password when prompted: 2EW7BBsr6aMMoJ2HjW067dm8EgX26xNe

ls command to list the contents of the directory and there is a directory called inhere. Then use the cd command to change to this directory

bandit4@bandit:~$ cd inhere
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file09


In the inhere directory, there are several files. Use the file command to determine the type of each file. file ./file1 will show you the type of file1.To use the command on all the files in the directory without a lot of writing, we can use ‘*’, which is called a ‘wildcard symbol’. ‘*’ can stand for any number of any literal characters.

bandit4@bandit:~$ cd inhere
bandit4@bandit:~/inhere$ ls -la
total 48
drwxr-xr-x 2 root    root    4096 May  7  2020 .
drwxr-xr-x 3 root    root    4096 May  7  2020 ..
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file00
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file01
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file02
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file03
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file04
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file05
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file06
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file07
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file08
-rw-r----- 1 bandit5 bandit4   33 May  7  2020 -file09
bandit4@bandit:~/inhere$ file ./*
./-file00: data
./-file01: data
./-file02: data
./-file03: data
./-file04: data
./-file05: data
./-file06: data
./-file07: ASCII text
./-file08: data
./-file09: data



Notice that one of the files is of type ASCII text and contains a human-readable string that is several characters long, but also has some non-printable characters. 
bandit4@bandit:~/inhere$ cat ./-file07
lrIWWI6bB37kxfiCQZqUdOIYfr6eEeqR


Level 5 to Level 6

Task

Get the password from a file that is stored somewhere under the inhere directory. It is human-readable, not executable and the size of the file is 1033 bytes.

Connect to the Bandit Level 5 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit5

Enter the password when prompted: lrIWWI6bB37kxfiCQZqUdOIYfr6eEeqR

Use ls command to list the contents of the directory and that there is a directory called inhere. Use the cd command to change to this directory: cd inhere. In this directory there are several files and subdirectories. Use the file command to determine the type of each file.

To find this file that contains the password, we can use the find command as follows:find -size 1033c -type f This command is similar to the one used in the previous level, but it searches for files only in the current directory (.) and its subdirectories, of type f (regular file), with a size of 1033 bytes and not executable.

bandit5@bandit:~$ ls
inhere
bandit5@bandit:~$ cd inhere
bandit5@bandit:~/inhere$ ls -la
bandit5@bandit:~/inhere$ find -size 1033c -type f
./maybehere07/.file2
bandit5@bandit:~/inhere$ cat ./maybehere07/.file2
P4L4vucdmLnm8I7Vl7jG1ApGSfjYKqJU


Level 6 to Level 7
Task
Get the password from a file that is stored somewhere under the inhere directory. It is owned by user bandit7, owned by group bandit6 and 33 bytes in size. 

Connect to the Bandit Level 6 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit6

Enter the password when prompted: P4L4vucdmLnm8I7Vl7jG1ApGSfjYKqJU

Ls -la command to list the contents of the directory.

Each file is owned by a user and a group. You can see what user and group owns a file with the ls command and its -l tag.  Find command can be used to find files on the server. It offers flags to look for files owned by a specific user with -user <username> and a specific group with -group <groupname>.We need to run the find command from the root directory since we have no hint where exactly the file is located. 

bandit6@bandit:~$ find / -type f -user bandit7 -group bandit6 -size 33c
find: '/var/log': Permission denied
find: '/var/crash': Permission denied
find: '/var/spool/rsyslog': Permission denied
find: '/var/spool/bandit24': Permission denied
find: '/var/spool/cron/crontabs': Permission denied
find: '/var/tmp': Permission denied
find: '/var/lib/polkit-1': Permission denied
/var/lib/dpkg/info/bandit7.password
bandit6@bandit:~$ cat /var/lib/dpkg/info/bandit7.password
z7WtoNQU2XfjmMtWA8u5rN4vzqu4v99S


Level 7 to Level 8
Task
Get the password from data.txt file, next to the word millionth

Connect to the Bandit Level 7 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit7

Enter the password when prompted: z7WtoNQU2XfjmMtWA8u5rN4vzqu4v99S

Ls -la command to list the contents of the directory. There is a file called data.txt. Use the cat command to display its contents: cat data.txt. The file contains many lines of text. Use the grep command to search for the password: cat data.txt | grep "millionth". This command will display only the line(s) containing the word "millionth" in the data.txt file. 

bandit7@bandit:~$ cat data.txt | grep millionth
millionth       TESKZC0XvTetK0S9xNwm25STk5iWrBvP


Level 8 to Level 9
Task 
Get the password from data.txt file and the password is the only line of text that occurs only once.

Connect to the Bandit Level 8 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit8

Enter the password when prompted: TESKZC0XvTetK0S9xNwm25STk5iWrBvP

sort is a command that sorts the lines of a text file and uniq is a command that filters input and writes to the output. Specifically, it filters based on identical lines. It has a flag -u, which filters for unique lines (lines that appear only ones).

bandit8@bandit:~$ sort data.txt | uniq -u
EN632PlfYiZbn3PhVK3XOGSlNInNE00t




Level 9 to Level 10

Task 
Get the password from data.txt file and the password is one of the few human-readable strings, preceded by several ‘=’ characters.

Connect to the Bandit Level 9 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit9

Enter the password when prompted: EN632PlfYiZbn3PhVK3XOGSlNInNE00t

We can use the strings command and filter that output by looking at lines that include more than one equal sign.


Level 10 to Level 11

Task 

Get the password from data.txt file that the data is base64 encoded.

Connect to the Bandit Level 10 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit9
bandit9@bandit:~$ ls
data.txt
bandit9@bandit:~$ strings data.txt | grep ===
4========== the#
========== password
========== is
========== G7w8LIi6J3kTb8A7j9LgrywtEUlyyp6s

ssh bandit.labs.overthewire.org -p 2220 -l bandit10

Enter the password when prompted: G7w8LIi6J3kTb8A7j9LgrywtEUlyyp6s

We can use the base64 that allows for encoding and decoding in Base64 with -d flag for decoding it. 

bandit10@bandit:~$ base64 -d data.txt
The password is 6zPeziLdR2RKNdNYFNb6nVCKzphlXHBM








Level 11 to Level 12
Task 
The file data.txt contains the password for the subsequent level, with all lowercase (a-z) and uppercase (A-Z) letters rotated by 13 places.

Connect to the Bandit Level 11 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit11

Enter the password when prompted: 6zPeziLdR2RKNdNYFNb6nVCKzphlXHBM

The ROT13 substitution cypher is created by rotating letters by 13 places. We can use the tr command, which stands for ’translate’, and it allows replacing characters with others. In simple terms we are replacing A to N with Z to M for both capital and small letters.

bandit11@bandit:~$ cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
The password is JVNBBFSmZwKKOP0XbFXOoW8chDz5yVRv


 
Level 12 to Level 13
Task:
The password for the next level is stored in the file data.txt, which contains a hexdump of a file that has been repeatedly compressed.

Connect to the Bandit Level 12 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit12

Enter the password when prompted: JVNBBFSmZwKKOP0XbFXOoW8chDz5yVRv
We can use mktemp -d to create a folder with a random name. Then I have to copy the data.txt from the home directory bandit 12 to the created directory in ’tmp’ and rename the file to pass13data. 

bandit12@bandit:~$ ls
data.txt
bandit12@bandit:~$ xxd -r data.txt > data
-bash: data: Permission denied
bandit12@bandit:~$ c\d /tmp
bandit12@bandit:/tmp$ mktemp -d
/tmp/tmp.MnDIEJCr1v
bandit12@bandit:/tmp$ cd /tmp/tmp.MnDIEJCr1v
bandit12@bandit:/tmp/tmp.MnDIEJCr1v$ cp ~/data.txt .
bandit12@bandit:/tmp/tmp.MnDIEJCr1v$ mv data.txt pass13data
bandit12@bandit:/tmp/tmp.MnDIEJCr1v$ ls
pass13data




We start by reverting the hexdump and get the actual data. Then we have to check the data for the compression method that is used by using the file command. And after that we repeatedly decompress the file for all the file types like bzip2, gzip and tar.










Level 12 to Level 13

Task
We need to use SSH private key to login to the next level.

Connect to the Bandit Level 13 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit13
Enter the password when prompted: wbWdlBxEir4CaE8LaPhauuOo6pwRmrDw

There is a private key on the server in the directory sshkey.private. We can use the scp command to download the key to our local system so that we can use it to login to the next level.




Level 14 to Level 15
Task
Get the password for the next level by submitting the password of the current level to port 30000 on localhost using SSL encryption.

Connect to the Bandit Level 14 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit14


We can use the openssl command to connect to the localhost on port 30000 and submit the password of the current level to retrieve the password for the next level.

bandit14@bandit:~$ openssl s_client -connect localhost:30000
fGrHPx402xGC7U7rXKDaxiWFTOiF0ENq
Correct!
jN2kgmIXJ6fShzhT2avhotn4Zcka6tnt



Level 15 to Level 16

Task
Get the password for the next level by submitting the password of the current level to port 30001 on localhost using SSL encryption and a private key that was provided to us.

Connect to the Bandit Level 15 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit15
Enter the password when prompted: BfMYroe26WYalil77FoDi9qh59eK5xNr


We need to use the private key that was provided to us to connect to the port 30001 on localhost. We can use the openssl command to do so.

bandit15@bandit:~$ openssl s_client -connect localhost:30001
...
jN2kgmIXJ6fShzhT2avhotn4Zcka6tnt
Correct!


JQttfApK4SeyHwDlI9SXGR50qclOAil1

Level 16 to Level 17

Task

The password is stored in the file located at /etc/bandit_pass/bandit16 and can only be read by the user bandit17.

Connect to the Bandit Level 16 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit16

Enter the password when prompted: JQttfApK4SeyHwDlI9SXGR50qclOAil1

We can use the ssh command to connect to the next level, and specify the private key we obtained from the previous level using the -i flag.

C:\Users\Israe>ssh -i ssh17.private bandit17@bandit.labs.overthewire.org -p 2220


Then, we can read the password file using the cat command.




bandit17@bandit:~$ cat /etc/bandit_pass/bandit17

VwOSWtCA7lRKkTfbr2IDh6awj9RNZM5e




Level 17 to Level 18 (VwOSWtCA7lRKkTfbr2IDh6awj9RNZM5e)

Task

There are 2 files in the home directory: passwords.old and passwords.new. The password for the next level is in passwords.new and is the only line that has been changed between passwords.old and passwords.new

The diff command prints the difference between two files.

bandit17@bandit:~$ diff passwords.old passwords.new 
42c42
< w0Yfolrc5bwjS4qw5mq1nnQi6mF03bii
---
> kfBf3eYk5BPBRzwjqutbbfE887SVc5Yd





Level 18 to Level 19

Task
Every time a terminal is loaded, a file called ".bashrc" is executed. Since using SSH also loads a terminal, it follows that it is also executed while doing so.

Connect to the Bandit Level 18 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit18

Enter the password when prompted: hga5tuuCLF6fFzUpnagiMN8ssu9LFrdg

Instead of logging into the system using SSH, we execute a command via SSH. First, we use ls to ensure that the readme file is there in the folder, and then we use cat to read it.

Level 19 to Level 20

Task
To go to the next level, we can use setuid binary.  After using the setuid binary, the password for this level may be located /etc/bandit_pass

Connect to the Bandit Level 19 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit19

Enter the password when prompted: awhqfNnAbc1naukrpqDYcF95h7HoMTrC




Level 20 to Level 21

Task 

In the home directory, there is a setuid programme and it connects to localhost on the port we choose. It then reads a line of text from the connection and matches it to the previous level's password; if the password is accurate, the password for the next level will be revealed.

Connect to the Bandit Level 20 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit20

Enter the password when prompted: VxCazJaVykI6W36BkBU0mJTCM8rR95XT


Level 21 to Level 22
Task 

There is a setuid programme and it connects to localhost on the port we choose. It then reads a line of text from the connection and matches it to the previous level's password; if the password is accurate, the password for the next level will be revealed.

Connect to the Bandit Level 21 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit21

Enter the password when prompted: NvEJF7oVjkddltPSrdKEFOllh9V1IBcq



Level 22 to Level 23

Task 

Look in /etc/cron.d/ for the configuration and see what command is being executed.

Connect to the Bandit Level 22 server using SSH:
ssh bandit.labs.overthewire.org -p 2220 -l bandit22

Enter the password when prompted: WdDozAdTM2z9DiFEQ2mGlwngMfj4EZff