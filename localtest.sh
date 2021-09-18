cmsDriver.py Configuration/GenProduction/python/newproc.py --python_filename GEN_cfg.py --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN --fileout file:GEN.root --conditions 106X_mc2017_realistic_v6 --beamspot Realistic25ns13TeVEarly2017Collision --customise_commands "process.source.numberEventsInLuminosityBlock=cms.untracked.uint32(200)\n process.RandomNumberGeneratorService.generator.initialSeed=123456" --step GEN --geometry DB:Extended --era Run2_2017 --no_exec --mc -n 5