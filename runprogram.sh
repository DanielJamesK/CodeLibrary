#!/bin/bash

read -p "Would you like to see the help instructions? Y/N " ANSWER
case "$ANSWER" in
    [yY] | [yY][eE][sS])
    cd src
        ruby main.rb -h
    ;;
[nN] | [nN][oO])
    ;;
*)
    echo "Please enter y/yes or n/no"
    ;;
esac

read -p "Would you like to install the program? Y/N " ANSWER
case "$ANSWER" in
    [yY] | [yY][eE][sS])
    cd src
        bundle install
        ruby main.rb 
    ;;
[nN] | [nN][oO])
    echo "Goodbye"
    ;;
*)
    echo "Please enter y/yes or n/no"
    ;;
esac
