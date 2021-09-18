import FWCore.ParameterSet.Config as cms

from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.MCTunes2017.PythiaCP5Settings_cfi import *
from Configuration.Generator.PSweightsPythia.PythiaPSweightsSettings_cfi import *

masses = [1500, 1750, 2000, 2250, 2500, 2750, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000]

generator = cms.EDFilter("Pythia8GeneratorFilter",
    maxEventsToPrint = cms.untracked.int32(1),
    pythiaPylistVerbosity = cms.untracked.int32(1),
    filterEfficiency = cms.untracked.double(1.0),
    pythiaHepMCVerbosity = cms.untracked.bool(False),
    comEnergy = cms.double(13000.),
    RandomizedParameters = cms.VPSet(),
)

for mass in masses:
    basePythiaParameters = cms.PSet(
        pythia8CommonSettingsBlock,
        pythia8CP5SettingsBlock,
        pythia8PSweightsSettingsBlock,
        processParameters = cms.vstring(
            'LeftRightSymmmetry:ffbar2ZR = on',
            '9900023:onMode = off',
            '9900023:addChannel = 1 1 101 21 21 21', # onMode bRatio meMode product1 product2 ...
            '9900023:onIfMatch = 21 21 21',
            '9900023:m0 = {}'.format(mass),
            '9900023:mMin = {}'.format(mass*0.5),
            '9900023:mWidth = {}'.format(mass*0.01)
        ),
        parameterSets = cms.vstring(
            'pythia8CommonSettings',
            'pythia8CP5Settings',
            'pythia8PSweightsSettings',
            'processParameters',
        )
    )

    generator.RandomizedParameters.append(
        cms.PSet(
            ConfigWeight = cms.double(1.0),
            ConfigDescription = cms.string("m{}".format(mass)),
            PythiaParameters = basePythiaParameters,
        ),
    )

ProductionFilterSequence = cms.Sequence(generator)
