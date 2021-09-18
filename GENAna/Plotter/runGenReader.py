import FWCore.ParameterSet.Config as cms
from FWCore.ParameterSet.VarParsing import VarParsing

options = VarParsing('analysis')
options.parseArguments()

process = cms.Process("GenReader")

# conditions
process.load("Configuration.StandardSequences.FrontierConditions_GlobalTag_cff")
from Configuration.AlCa.autoCond_condDBv2 import autoCond
process.GlobalTag.globaltag = cms.string("106X_mc2017_realistic_v6")

process.load("FWCore.MessageLogger.MessageLogger_cfi")
process.MessageLogger.cerr.FwkReport.reportEvery = 5

process.source = cms.Source("PoolSource",
    fileNames = cms.untracked.vstring(options.inputFiles),
    duplicateCheckMode = cms.untracked.string("noDuplicateCheck")
)

process.gen = cms.EDAnalyzer("GenReader",
    genJetToken     = cms.untracked.InputTag("ak4GenJets"),
    genParticleToken = cms.untracked.InputTag("genParticles"),
    genInfoToken = cms.InputTag("generator")
)

process.p = cms.Path(
  process.gen
)