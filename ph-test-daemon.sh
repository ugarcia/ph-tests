#!/bin/bash

BASEDIR=$(dirname $0)
PROCESSES=1
SCRIPT=""
OPTIONS=""
OUT=/dev/null
COMMAND=phantomjs
PHANTOM_VERSION=1

if [[ $(type -P "phantomjs") ]] ; then

  if [[ -n "$1" ]] ; then

      if [ $1 = "stop" ] ; then
         echo "Killing processes"
         kill -9 $(pidof phantomjs) &>/dev/null
      else
         if [ $1 = "start" ] ; then
          shift
          while getopts p:s:i:o:v:h: option ; do
             case "${option}" in
                "p") 
              PROCESSES=${OPTARG}
              echo "Starting ${PROCESSES} processes"
              ;;
                "s") 
              SCRIPT=${OPTARG}
              echo "Running ${SCRIPT} script"
              ;;
                "i") 
              OPTIONS=${OPTARG}
              echo "Using script options: ${OPTIONS}"
              ;;
                "o") 
              OUT=${OPTARG}
              echo "Dumping output to ${OUT}"
              ;;
                "v") 
              PHANTOM_VERSION=${OPTARG}
              ;;
                "h") 
              USAGE=true
              ;;
                "?")
              echo "Unknown option $OPTARG"
              USAGE=true
              ;;
                ":")
              echo "No argument value for option $OPTARG"
              USAGE=true
              ;;
                *)
              echo "Unknown error while processing options"
              ;;
             esac
          done

          if [[ "$PHANTOM_VERSION" -gt "1" ]] ; then
            COMMAND="${COMMAND}${PHANTOM_VERSION}"
          fi   

          if [ -f $SCRIPT ] ; then
             for i in $(eval echo "{1..$PROCESSES}"); do
                $COMMAND --config=$BASEDIR/phantom-config.json $SCRIPT $OPTIONS >> $OUT &
             done
          else
             echo "Script $SCRIPT not found"
          fi

         else
           USAGE=true
         fi
      fi

  else
    USAGE=true

  fi
  
else
  echo "phantomjs executable should be installed and in system path"
  echo "http://phantomjs.org/download.html"

fi

if [[ -n "$USAGE" ]] ; then
  echo "USAGE:"
  echo "ph-test-daemon start|stop [options]"
  echo "OPTIONS:"
  echo "-s <file> (mandatory): Executes the provided <file> phantom script"
  echo "-p <#processes> (optional): Executes <#processes> concurrent processes [default=1]"
  echo "-i <quoted string> (optional): Passes <quoted string> to script call as arguments [default='']"
  echo "-o <file> (optional): Dumps output to the provided <file>"
  echo "-v <number> (optional): Phantom version, assuming in path as phantomjs, phantomjs2, etc."
  echo "-h <void> (optional): Print this help."
fi
