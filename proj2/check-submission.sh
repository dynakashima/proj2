#!/bin/bash -e
#
# To check your submission you should run:
#
#   $ make check-part1
#   $ make check-part2
#

if [ `whoami` != eric ]; then
    hostname | grep -q hive || (echo -e "\e[01;31mYou must run this script on the hive machines.\e[00m" && exit 1)
fi

LOGIN=$USER
TMP=`pwd`/.check_submission_tmp
REF=`pwd`/.check_submission_ref

warning() {
    echo -e "\e[01;31mWARNING: $1\e[00m"
    echo -e "\e[00;33mYou tagged $2\e[00m"
}

error() {
    echo -e "\e[01;31mERROR: $@\e[00m"
    echo -e "\e[00;31m"
    echo -e "Read the above output to see what went wrong, and run 'git status' or 'gitk' to see what is going on.
    
If your git repository is seriously messed up, consider cloning a fresh copy from github via 'git clone <giturl>', where <giturl> is listed at your repository page at \e[00;33mhttps://github.com/ucberkeley-cs61c/$LOGIN\e[00;31m

If stuck, please stop by office hours or lab to talk to a TA. There are also many posts on Piazza about submitting via git and numerous other online resources."
    echo -en "\e[00m"
    exit 1
}

ok() {
    echo -e "\e[01;32mSUCCESS: $1\e[00m"
    echo -e "\e[00;32mYou tagged $2\e[00m"
}

rm -rf "$TMP" "$REF"
git clone git@github.com:ucberkeley-cs61c/$LOGIN.git "$TMP" || error "Could not clone your git repo."
git clone git://github.com/ucberkeley-cs61c/proj2.git "$REF" || error "Could not clone project skeleton."

cd "$TMP/proj2" || error "You haven't pushed the proj2 directory to github."

if [ "$1" == "part2" ]; then
    git checkout proj2-2 || error "You haven't tagged any commit proj2-2"
    COMMIT=`git log -1`
    cp disassemble.c "$REF/proj2/" || warning "You did not submit proj2/disassemble.c" "$COMMIT"
    cp processor.c "$REF/proj2/" || warning "You did not submit proj2/processor.c" "$COMMIT"
    cp memory.c "$REF/proj2/" || warning "You did not submit proj2/memory.c" "$COMMIT"
    cd "$REF/proj2/"
	make runtest &&
	    ok "You have submitted proj2-2 correctly." "$COMMIT" ||
	    warning "Your tagged commit does not pass 'make runtest'. Either your code is not working, or you have tagged the wrong commit." "$COMMIT"
else
    git checkout proj2-1 || error "You haven't tagged any commit proj2-1"
    COMMIT=`git log -1`
    cp disassemble.c "$REF/proj2/" || warning "You did not submit proj2/disassemble.c" "$COMMIT"
    cd "$REF/proj2/"
    make disasmtest &&
        ok "You have submitted proj2-1 correctly." "$COMMIT" ||
        warning "Your tagged commit does not pass 'make disasmtest'. Either your code is not working, or you have tagged the wrong commit." "$COMMIT"
fi

rm -rf "$TMP" "$REF"

exit 0
