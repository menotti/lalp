if [ $LALP_HOME = "" ] 
then
	export LALP_HOME=$1
	export PATH=$LALP_HOME:$PATH
	echo $LALP_HOME
else
	echo $LALP_HOME
fi
