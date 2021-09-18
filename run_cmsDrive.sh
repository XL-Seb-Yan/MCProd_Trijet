#!/bin/sh

cmsDriver.py Configuration/GenProduction/python/EXO-RunIIFall17GS-04948-fragment.py --python_filename GENSIM_cfg.py --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --fileout file:GENSIM.root --conditions 106X_mc2017_realistic_v8 --beamspot Realistic25ns13TeVEarly2017Collision --customise_commands 'process.source.numberEventsInLuminosityBlock = cms.untracked.uint32(50)' --step GEN,SIM --geometry DB:Extended --era Run2_2017 --no_exec --mc -n 100

cmsDriver.py  --python_filename DRPremix_cfg.py --eventcontent PREMIXRAW --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-DIGI --fileout file:DRPremix.root --pileup_input "dbs:/Neutrino_E-10_gun/RunIISummer20ULPrePremix-UL17_106X_mc2017_realistic_v6-v3/PREMIX" --conditions 106X_mc2017_realistic_v8 --step DIGI,DATAMIX,L1,DIGI2RAW --procModifiers premix_stage2 --geometry DB:Extended --filein file:GENSIM.root --datamix PreMix --era Run2_2017 --no_exec --mc -n 100

# cmsDriver.py  --python_filename HLT_cfg.py --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-RAW --fileout file:HLT.root --conditions 106X_mc2017_realistic_v8 --step HLT:2e34v40 --geometry DB:Extended --filein file:DRPremix.root --era Run2_2017 --no_exec --mc -n 100

cmsDriver.py  --python_filename RECO_cfg.py --eventcontent AODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier AODSIM --fileout file:RECO.root --conditions 106X_mc2017_realistic_v8 --step RAW2DIGI,RECO,RECOSIM,EI --geometry DB:Extended --filein file:HLT.root --era Run2_2017 --runUnscheduled --no_exec --mc -n 100

cmsDriver.py  --python_filename MiniAOD_cfg.py --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --fileout file:miniAOD.root --conditions 106X_mc2017_realistic_v8 --step PAT --scenario pp --geometry DB:Extended --filein file:RECO.root --era Run2_2017 --runUnscheduled --no_exec --mc -n 100

cmsDriver.py  --python_filename NanoAOD_cfg.py --eventcontent NANOEDMAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier NANOAODSIM --fileout file:nanoAOD.root --conditions 106X_mc2017_realistic_v8 --step NANO --filein file:miniAOD.root --era Run2_2017,run2_nanoAOD_106Xv1 --no_exec --mc -n 100