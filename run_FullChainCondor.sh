#!/bin/sh
# Using same condition as /QCD_Pt_300to470_TuneCP5_13TeV_pythia8/RunIISummer20UL17NanoAODv2-106X_mc2017_realistic_v8-v1/NANOAODSIM
# Arguments: 1: nEvents per job, 2: proxy, 3: job name, 2: jobid

seed=$(($(date +%s%N) % 1000000))
echo $seed
numevt=${1}

cd ${_CONDOR_SCRATCH_DIR}
ls ./
tar -xf transfer.tgz
cd 2017/
source /cvmfs/cms.cern.ch/cmsset_default.sh
export X509_USER_PROXY=${2}
voms-proxy-info -all
voms-proxy-info -all -file ${2}
export HOME=${_CONDOR_SCRATCH_DIR}

# GENSIM
if [ -r CMSSW_10_6_19_patch3/src ] ; then
  echo release CMSSW_10_6_19_patch3 already exists
else
  scram p CMSSW CMSSW_10_6_19_patch3
fi
cd CMSSW_10_6_19_patch3/src
eval `scram runtime -sh`
cp -r ../../Configuration ./

scram b
cd ../..

echo "Processing GENSIM ----------------------------------"
cmsDriver.py Configuration/GenProduction/python/EXO-RunIIFall17GS-04948-fragment.py --python_filename GENSIM_cfg.py --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --fileout file:GENSIM.root --conditions 106X_mc2017_realistic_v6 --beamspot Realistic25ns13TeVEarly2017Collision --customise_commands "process.source.numberEventsInLuminosityBlock=cms.untracked.uint32(200)\n process.RandomNumberGeneratorService.generator.initialSeed=${seed}" --step GEN,SIM --geometry DB:Extended --era Run2_2017 --no_exec --mc -n ${numevt}

cmsRun GENSIM_cfg.py

# DRPremixDIGI
if [ -r CMSSW_10_6_17_patch1/src ] ; then
  echo release CMSSW_10_6_17_patch1 already exists
else
  scram p CMSSW CMSSW_10_6_17_patch1
fi
cd CMSSW_10_6_17_patch1/src
eval `scram runtime -sh`
eval `scram runtime -sh`

scram b
cd ../..
echo "Processing DRPremixDIGI ----------------------------------"
cmsDriver.py  --python_filename DRPremix_cfg.py --eventcontent PREMIXRAW --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-DIGI --fileout file:DRPremix.root --pileup_input filelist:pileup.list --conditions 106X_mc2017_realistic_v6 --step DIGI,DATAMIX,L1,DIGI2RAW --procModifiers premix_stage2 --geometry DB:Extended --filein file:GENSIM.root --datamix PreMix --era Run2_2017 --no_exec --mc -n ${numevt}

cmsRun DRPremix_cfg.py

# HLT
if [ -r CMSSW_9_4_14_UL_patch1/src ] ; then
  echo release CMSSW_9_4_14_UL_patch1 already exists
else
  scram p CMSSW CMSSW_9_4_14_UL_patch1
fi
cd CMSSW_9_4_14_UL_patch1/src
eval `scram runtime -sh`
eval `scram runtime -sh`

scram b
cd ../..

echo "Processing HLT ----------------------------------"
cmsDriver.py  --python_filename HLT_cfg.py --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-RAW --fileout file:HLT.root --conditions 94X_mc2017_realistic_v15 --customise_commands 'process.source.bypassVersionCheck = cms.untracked.bool(True)' --step HLT:2e34v40 --geometry DB:Extended --filein file:DRPremix.root --era Run2_2017 --no_exec --mc -n ${numevt}

cmsRun HLT_cfg.py

# AODSIM
if [ -r CMSSW_10_6_17_patch1/src ] ; then
  echo release CMSSW_10_6_17_patch1 already exists
else
  scram p CMSSW CMSSW_10_6_17_patch1
fi
cd CMSSW_10_6_17_patch1/src
eval `scram runtime -sh`
eval `scram runtime -sh`

scram b
cd ../..

echo "Processing AODSIM ----------------------------------"
cmsDriver.py  --python_filename RECO_cfg.py --eventcontent AODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier AODSIM --fileout file:RECO.root --conditions 106X_mc2017_realistic_v6 --step RAW2DIGI,RECO,RECOSIM,EI --geometry DB:Extended --filein file:HLT.root --era Run2_2017 --runUnscheduled --no_exec --mc -n ${numevt}

cmsRun RECO_cfg.py

# MINIAODSIM
if [ -r CMSSW_10_6_17_patch1/src ] ; then
  echo release CMSSW_10_6_17_patch1 already exists
else
  scram p CMSSW CMSSW_10_6_17_patch1
fi
cd CMSSW_10_6_17_patch1/src
eval `scram runtime -sh`
eval `scram runtime -sh`

scram b
cd ../..

echo "Processing MINIAODSIM ----------------------------------"
cmsDriver.py  --python_filename MiniAOD_cfg.py --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --fileout file:miniAOD.root --conditions 106X_mc2017_realistic_v6 --step PAT --scenario pp --geometry DB:Extended --filein file:RECO.root --era Run2_2017 --runUnscheduled --no_exec --mc -n ${numevt}

cmsRun MiniAOD_cfg.py

# NANOAODSIM
if [ -r CMSSW_10_6_19_patch2/src ] ; then
  echo release CMSSW_10_6_19_patch2 already exists
else
  scram p CMSSW CMSSW_10_6_19_patch2
fi
cd CMSSW_10_6_19_patch2/src
eval `scram runtime -sh`
eval `scram runtime -sh`

scram b
cd ../..

echo "Processing NANOAODSIM ----------------------------------"
cmsDriver.py  --python_filename NanoAOD_cfg.py --eventcontent NANOAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier NANOAODSIM --fileout file:nanoAOD.root --conditions 106X_mc2017_realistic_v8 --step NANO --filein file:miniAOD.root --era Run2_2017,run2_nanoAOD_106Xv1 --no_exec --mc -n ${numevt}

cmsRun NanoAOD_cfg.py

xrdcp -f -p nanoAOD.root /eos/user/x/xuyan/TrijetData/NanoAODs/${3}/nanoAOD_${4}.root