#!/bin/bash
source buildEnvironment.sh
export LD_LIBRARY_PATH=/usr/lib:/lib:/usr/lib64:/lib64
export RPMDIR=/awips2/jenkins/build/rpms/awips2_${AWIPSII_VERSION}/
cp comps.xml ${RPMDIR}
cd ${RPMDIR}
pwd
repomanage -k2 --old . | xargs rm -f
createrepo -g ./comps.xml .
unset LD_LIBRARY_PATH
. /etc/profile.d/awips2.sh
rsync --archive --delete $RPMDIR tomcat@www:/web/content/repos/yum/awips2-dev/

cd ..
#rm -rf awips2_${AWIPSII_VERSION}.tar
#tar -cf awips2_${AWIPSII_VERSION}.tar awips2_${AWIPSII_VERSION}
#scp awips2_${AWIPSII_VERSION}.tar mjames@129.114.17.218:/awips2/repo/