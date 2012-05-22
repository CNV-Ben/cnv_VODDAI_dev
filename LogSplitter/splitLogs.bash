#! /bin/bash

#############################################################################################
#
#   This is the script that runs the log splitting process for Canoe Ventures DAI.
#
#   This script must exist in a deployment directory with the following structure:
#
#       <deployment directory>/
#           lincoln-log4j.xml                    *
#           lincoln.jar                          *
#           lincoln.properties                   *
#           splitLogs.bash                       *
#
#       *  These files are included in the distributed tar.gz file.
#
#   This script is to be run by a cron job. It processes all log files that have rolled
#   over but not yet been processed, so choose a schedule for which it is likely that the
#   preceding interval's log file has rolled over. (Note that one interval's log file
#   does not actually roll over until a message is logged to it in the following interval.)
#   For example, running the script at 1 a.m. every day might be accomplished by the
#   following environment setting and cron command:
#
#       LOG_SPLITTER_DIR=<deployment directory>
#       0 1 * * * (cd $LOG_SPLITTER_DIR; ./splitLogs.bash)
#
#   Usage:
#       Run with the -? option for a usage description.
#
#   Other external dependencies:
#
#       The file lincoln-log4j.xml controls logging. You may edit this file (within reason)
#       for your requirements; if you do, take care that your changes are not over-written by
#       subsequent deployments.
#
#       The file lincoln.properties contains definitions of various configuration parameters.
#       You may edit this file (within reason) for your requirements; if you do, take care
#       that your changes are not overwritten by subsequent deployments.
#
#
##     05-02-2012) Ben Aycrigg used this executable script to split numerous Log File
##                 obtained from Charlie LeCrone associated with "lab-to-lab" testing
##                 done with Time-Warner Cable (TWC).
##
##     This script was run as:
##        ./splitLogs.bash -i request-response.ads0201.log
##
##           "-i" means "the following argument is considered INPUT
##           and the file pattern "request-response.ads0201.log" 
##           applied to numerous (6) ADS log files.  So, the output of
##           the above command was splitting 6 different files consecutively,
##           rather than running splitLogs multiple times.
##
#
#############################################################################################

#############################################################################################
#   The name of the jar file.
#
jarFile=lincoln.jar

#############################################################################################
#   The main function.
#
#   Arguments:
#       The arguments to the script (see the script comment).
#
#############################################################################################
function main
{
    if [ "$1" = '-?' ]
    then
        usage
        exit
    fi

    validateArguments "$@"

    testLogSplitting
    local logSplitting=$?

    if [ $logSplitting -eq 0 ]
    then
        # the log splitting process is running
        :
    else
        # the log splitting process is not running
        startLogSplitting
    fi
}

#############################################################################################
#   Start the log splitting process.
#
#############################################################################################

function startLogSplitting
{
    local JAVA_OPTS=""

    JAVA_OPTS="$JAVA_OPTS -Dlog4j.configuration=file:lincoln-log4j.xml"

    JAVA_OPTS="$JAVA_OPTS -Dconfig.dir=."

    if [ "$inputFileBase" != '' ]
    then
        JAVA_OPTS="$JAVA_OPTS -Dinput.file.base=$inputFileBase"
    fi

    if [ "$minFileAge" != '' ]
    then
        JAVA_OPTS="$JAVA_OPTS -Dmin.file.age=$minFileAge"
    fi

    if [ "$outputDir" != '' ]
    then
        JAVA_OPTS="$JAVA_OPTS -Doutput.dir=$outputDir"
    fi

    if [ "$quarantineDir" != '' ]
    then
        JAVA_OPTS="$JAVA_OPTS -Dquarantine.dir=$quarantineDir"
    fi

    if [ "$targetDir" != '' ]
    then
        JAVA_OPTS="$JAVA_OPTS -Dtarget.dir=$targetDir"
    fi

    touch .logSplitting
    java $JAVA_OPTS -jar $jarFile
    rm .logSplitting
}

#############################################################################################
#   Test whether or not the log splitting process is running.
#
#   Return value:
#       0     if the log splitting process is running.
#       not 0 if the log splitting process is not running.
#
#############################################################################################

function testLogSplitting
{
    [ -f .logSplitting ]

    return $?
}

#############################################################################################
#
#   Print script usage information.
#
#############################################################################################

function usage
{
    echo "Usage:"
    echo "  $(basename $0) <options>"
    echo
    echo "where <options> are any of the following, in any order:"
    echo
    echo "  -?"
    echo "    print this usage information and exit"
    echo
    echo "  ( --age | -a ) minFileAge"
    echo "    minFileAge is the minimum file age to split, in seconds"
    echo
    echo "  ( --inputFile | -i ) inputFileBase"
    echo "    inputFileBase is the input file base name"
    echo
    echo "  ( --outputDir | -o ) outputDir"
    echo "    outputDir is the output directory path"
    echo
    echo "  ( --quarantineDir | -q ) quarantineDir"
    echo "    quarantineDir is the quarantine directory path"
    echo
    echo "  ( --targetDir | -t ) targetDir"
    echo "    targetDir is the target directory path"
    echo
    echo "Default values for options are specified in the lincoln.properties file."
}

#############################################################################################
#
#   Validate the arguments to the script.
#
#   Arguments:
#       The arguments to the script (see the script comment).
#
#   Exit values:
#       1   Argument validation failed.
#
#   On successful return:
#       $inputFileBase is the input file base name, if specified.
#       $minFileAge is the minimum file age to split, in seconds, if specified.
#       $outputDir is the output directory path, if specified.
#       $quarantineDir is the quarantine directory path, if specified.
#       $targetDir is the target directory path, if specified.
#
#############################################################################################

function validateArguments
{
    while [ $# -gt 0 ]
    do
        arg="$1"
        shift

        case "$arg" in

        --age | -a)
            if [[ $# -gt 0 && "$1" =~ ^[0-9]+$ ]]
            then
                minFileAge="$1"
                shift
            else
                echo "The $arg value is not a suitable number of seconds."
                echo
                usage
                exit 1
            fi
            ;;

        --inputFile | -i)
            if [[ $# -gt 0 ]]
            then
                inputFileBase="$1"
                shift
            else
                echo "The $arg value is not a suitable name."
                echo
                usage
                exit 1
            fi
            ;;

        --outputDir | -o)
            if [[ $# -gt 0 ]]
            then
                outputDir="$1"
                shift
            else
                echo "The $arg value is not a suitable path."
                echo
                usage
                exit 1
            fi
            ;;

        --quarantineDir | -q)
            if [[ $# -gt 0 ]]
            then
                quarantineDir="$1"
                shift
            else
                echo "The $arg value is not a suitable path."
                echo
                usage
                exit 1
            fi
            ;;

        --targetDir | -t)
            if [[ $# -gt 0 ]]
            then
                targetDir="$1"
                shift
            else
                echo "The $arg value is not a suitable path."
                echo
                usage
                exit 1
            fi
            ;;

        *)
            echo "The argument $arg is not recognized."
            echo
            usage
            exit 1
            ;;

        esac
    done
}

#############################################################################################
#
#   Go.
#
#############################################################################################

main "$@"