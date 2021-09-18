#!/bin/bash

timestamp=$(date '+%Y%m%d%H%M%S')
jobname="ZprimeTo3Gluon_mCutpm0p5"

# cp /tmp/x509up_u93529 /afs/cern.ch/user/x/xuyan/private/x509up/x509up_u93529
proxy_path="/afs/cern.ch/user/x/xuyan/private/x509up/x509up_u93529"

cd ../
tar --exclude='ignore' --exclude='.git' -zcf transfer.tgz 2017/
cd 2017/

mkdir ${jobname}_${timestamp}
cd ${jobname}_${timestamp}
mkdir log
cp ../run_FullChainCondor.sh ./
cp ../../transfer.tgz ./

cat > submission.jdl <<EOF
universe                = vanilla
executable              = run_FullChainCondor.sh
arguments               = 1500 ${proxy_path} ${jobname}_${timestamp} \$(Process)
should_transfer_files   = YES
transfer_input_files    = transfer.tgz
transfer_output_files   = _condor_stderr, _condor_stdout
when_to_transfer_output = ON_EXIT
output                  = log/Condor_job.\$(Cluster).\$(Process).out
error                   = log/Condor_job.\$(Cluster).\$(Process).err
log                     = log/Condor_job.\$(Cluster).\$(Process).log
+JobFlavour             = "testmatch"
request_cpus            = 4
request_memory          = 5 GB

queue 650
EOF

condor_submit submission.jdl