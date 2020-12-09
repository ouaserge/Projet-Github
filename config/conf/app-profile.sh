##############################################################################
# ENVIRONMENT VARIABLES
##############################################################################
export CONF="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export REPO="$( dirname $CONF )"
export BRC="$( dirname $REPO )"
export DATA="$REPO/data"
export HISTO="$REPO/histo"
echo "Loading app-profile.sh from this repository: $CONF"

# This folder should contain the source code of the application
export PACKAGE_DIR="toolbox_connected_vehicle"

if [ ! -e $PACKAGE_DIR ]
then
	echo "ERROR! python package '$PACKAGE_DIR' not found in the bin directory '$BIN_PATH'"
	return
fi

##############################################################################
# GENERAL CONFIGURATION
##############################################################################
export LANG=en_US.utf8
export TMOUT=0

# profile ORACLE
# ARCV2
if [ -e /soft/ora1120/fileso/profile ]
then
	source /soft/ora1120/fileso/profile
fi
# ARCV3
if [ -e /soft/ora1210/fileso/profile ]
then
	. /soft/ora1210/fileso/profile
fi

# Allows us to use git
export PATH=/soft/git/bin:$PATH
# This folder contains the correct version of make that we want to use
export PATH=/usr/bin/:$PATH


##############################################################################
# PYTHON SPECIFIC CONFIGURATION
##############################################################################
export PATH=$PATH:$REPO/.venv3/bin
# Add the repo to PYTHONPATH
export PYTHONPATH=$REPO:$PYTHONPATH

# required library and compiler options to install Jupyter
export LD_LIBRARY_PATH=/gpfs/user/common/jupyter/sqlite/sqlite/lib:$LD_LIBRARY_PATH
export CPPFLAGS="-I /gpfs/user/common/jupyter/sqlite/sqlite/include -L /gpfs/user/common/jupyter/sqlite/sqlite/lib"

# in order to use the Artifactory PSA pypi repository
# NOTE: we use 'pypi-virtual' which contains both pypi libraries and PSA-specific libraries.
export PIP_OPTIONS="-i http://repository.inetpsa.com/api/pypi/pypi-virtual/simple --trusted-host repository.inetpsa.com"

# make sur that we use the local python virtual environment
if [ -e .venv3/bin/activate ]
then
	source .venv3/bin/activate
fi

export SPARK_HOME=/usr/hdp/current/spark2-client
export SPARK_MAJOR_VERSION=2
# Adding to pythonpath
# I am not sure I understand this.. But without both tests and notebooks fail:
export PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python/

# Making sure that spark uses the correct python binary
# WARNING: the following command is only usefull AFTER the local virtual environment is activated
# export PYSPARK_PYTHON=$(which python)

# this is required to get the connexion to oracle (exadata) working:
# note: this method is deprecated (see logs for warning)
# recommanded way is: add to both submit args (for driver) and config params (for executors)
# ARCV2
if [ -e /soft/ora1120/db/jdbc/lib/ojdbc6.jar ]
then
	export SPARK_CLASSPATH=/soft/ora1120/db/jdbc/lib/ojdbc6.jar
fi
# ARCV3
if [ -e /soft/ora1210/db/jdbc/lib/ojdbc6.jar ]
then
	export SPARK_CLASSPATH=/soft/ora1210/db/jdbc/lib/ojdbc6.jar
fi

# Python3 support on HDP (solving 'print rack' issue)
export HADOOP_CONF_DIR=/etc/hadoop_spark/conf
export HDP_VERSION=2.6.5.0-292

# Pyspark: specify python binary
export PYSPARK_PYTHON=$REPO/.venv3/bin/python3.6
export PYSPARK_DRIVER_PYTHON=$REPO/.venv3/bin/python

# WARNING: this file contains a RELATIVE path instead of an absolute one.
# This mean that you should allways start jobs from the main repo folder.
export SPARK_OPTIONS="\
                --driver-java-options '-Dlog4j.configuration=file:$BIN_PATH/log4j.properties' \
        "

