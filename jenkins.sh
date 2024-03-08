#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

printf "Script started executing at %s\n" "$TIMESTAMP" &>> "$LOGFILE"

VALIDATE(){
    if [ "$1" -ne 0 ]; then
        printf "%s...%s FAILED %s\n" "$2" "$R" "$N"
        exit 1
    else
        printf "%s....%s SUCCESS %s\n" "$2" "$G" "$N"
    fi
}

if [ "$(id -u)" -ne 0 ]; then
    printf "ERROR :: Please install with Root Access\n"
    exit 1
else
    printf "You are root user\n"
fi

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo &>> "$LOGFILE"
VALIDATE $? "Downloading the Jenkins file"

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key &>> "$LOGFILE"
VALIDATE $? "Stable key downloading"

sudo yum install fontconfig java-17-openjdk -y &>> "$LOGFILE"
VALIDATE $? "Installing Java 17"

sudo yum install jenkins -y &>> "$LOGFILE"
VALIDATE $? "Installing Jenkins"

sudo systemctl enable jenkins &>> "$LOGFILE"
VALIDATE $? "Enabling Jenkins"

systemctl start jenkins &>> "$LOGFILE"
VALIDATE $? "Starting Jenkins"
