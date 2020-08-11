# Switch Repertory

this script is for repertorying the data from the switch and its port from a local network.

## Installation

you will need to have tcl and expect installed in order to run this code.
if not installed, you can find tcl and expect it on the websites:
https://www.tcl.tk/software/tcltk/download84.html
https://sourceforge.net/projects/expect/

## Usage

after putting the Mac address of the switchs you want to check in the feedMeSwitchs.txt file, 
you will need to run the make command inside the local directory, you will then be prompted 
your username and password in your local network.

the program will compile a csv file with the needed information in the Rendu repertory, with
the name of the switch as its name.

also, in ./SwitchData/Data, there will be more directory where the raw information is given to
check in case something went wrong.

thus don't forget to use make clean once the raw data is unneeded.

# Notice

if the command prompt is too small, telnet will sometimes return ----more---- instead of the 
whole detail of the switch, and it will cause the program not to work.
it is recommanded to have your command prompt as long as possible in order to avoid such issues.
