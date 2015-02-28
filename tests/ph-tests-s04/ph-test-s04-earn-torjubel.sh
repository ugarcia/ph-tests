#!/bin/bash

BASEDIR=$(dirname $0)
ENV="dev"
PROCESSES=10
SCRIPT="$BASEDIR/ph-test-s04-earn-torjubel.js"
GOALS_SCRIPT="$BASEDIR/../../external/ph-external-post-goals.js"
AMOUNT=5
WAITING=30
OPTIONS=""
USER_BASE="TEST_ING_LOAD"
PASSWORD="Hamburg01#"
OUT_BASE="$BASEDIR/../../out/logs/ph-test-s04-earn-torjubel"
PHANTOM_VERSION=1

while getopts p:o:u:P:e:a:w:c:v:h: option ; do
   case "${option}" in
      "p") 
    PROCESSES=${OPTARG}
    ;;
      "a") 
    AMOUNT=${OPTARG}
    ;;
      "w") 
    WAITING=${OPTARG}
    ;;
      "o") 
    OUT_BASE=${OPTARG}
    ;;
      "u") 
    USER_BASE=${OPTARG}
    ;;
      "P") 
    PASSWORD=${OPTARG}
    ;;
      "e") 
    ENV=${OPTARG}
    ;;
      "h") 
    USAGE=true
    ;;
      "c") 
    SCRIPT="$BASEDIR/ph-test-s04-earn-torjubel.coffee"
    GOALS_SCRIPT="$BASEDIR/../../external/ph-external-post-goals.coffee"
    ;;
      "v") 
    PHANTOM_VERSION=${OPTARG}
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

GOALS_INTERVAL=$(($WAITING/2))
GOALS_AMOUNT=$(($AMOUNT*2))

$BASEDIR/../../ph-test-daemon.sh start -s $GOALS_SCRIPT -v $PHANTOM_VERSION -i "amount=$GOALS_AMOUNT interval=$GOALS_INTERVAL"

for i in $(eval echo "{1..$PROCESSES}"); do
    OPTS="${OPTIONS} user=${USER_BASE}${i} password=$PASSWORD env=$ENV amount=$AMOUNT waiting=$WAITING"
    $BASEDIR/../../ph-test-daemon.sh start -o "${OUT_BASE}-${i}.log" -i "$OPTS" -s $SCRIPT -v $PHANTOM_VERSION
done

if [[ -n "$USAGE" ]] ; then
  echo "USAGE:"
  echo "ph-test-s04-earn-torjubel [options]"
  echo "OPTIONS:"
  echo "-p <#processes> (optional): Executes <#processes> (users) concurrent processes [default=10]"
  echo "-u <string> (optional): Base username which would be used in spawned processes appending process number"
  echo "-P <string> (optional): Password which will be used for all users"  
  echo "-e <string> (optional): Environment in which run the tests (dev|prod) -> (qat|www)"
  echo "-a <number> (optional): Number of goals that users will try to click"
  echo "-w <number> (optional): Time (in seconds) the users will wait for next goal"      
  echo "-o <file> (optional): Dumps outputs to the provided <file>(s) base + process number"
  echo "-c <void> (optional): Use coffescript files rather than javascript"
  echo "-v <number> (optional): Phantom version, assuming in path as phantomjs, phantomjs2, etc."
  echo "-h <void> (optional): Print this help."
fi