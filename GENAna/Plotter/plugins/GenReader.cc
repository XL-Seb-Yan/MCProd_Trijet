// system include files
#include <memory>

// framework
#include "FWCore/Framework/interface/Frameworkfwd.h"
#include "FWCore/Framework/interface/EDAnalyzer.h"
#include "FWCore/Framework/interface/Event.h"
#include "FWCore/Framework/interface/MakerMacros.h"
#include "FWCore/ParameterSet/interface/ParameterSet.h"
#include "FWCore/MessageLogger/interface/MessageLogger.h"

// input data formats
#include "DataFormats/JetReco/interface/GenJetCollection.h"
#include "SimDataFormats/GeneratorProducts/interface/GenEventInfoProduct.h"

#include "DataFormats/HepMCCandidate/interface/GenParticle.h"
#include "SimDataFormats/GeneratorProducts/interface/HepMCProduct.h"
#include "HepMC/GenParticle.h"
#include "HepMC/GenVertex.h"
#include "DataFormats/HepMCCandidate/interface/GenParticle.h"

#include "SimDataFormats/PileupSummaryInfo/interface/PileupSummaryInfo.h"


// ROOT output stuff
#include "FWCore/ServiceRegistry/interface/Service.h"
#include "CommonTools/UtilAlgos/interface/TFileService.h"
#include "TH1.h"
#include "TCanvas.h"

//
// class declaration
//

class GenReader : public edm::EDAnalyzer {
public:
  explicit GenReader(const edm::ParameterSet&);
  ~GenReader() override;
  
  
private:
  void beginJob(void) override ;
  void analyze(const edm::Event&, const edm::EventSetup&) override;
  void endJob() override;  

private:

  // EDM input tags
  edm::EDGetTokenT<reco::GenJetCollection> genJetToken_;
  edm::EDGetTokenT<reco::GenParticleCollection> genParticleToken_;
  edm::EDGetTokenT<GenEventInfoProduct> genInfoToken_;
  
  // Trees
  TH1F *hist0 = new TH1F("m","m",500,0,13000);
};



GenReader::GenReader(const edm::ParameterSet& iConfig)
{

  genJetToken_ = consumes<reco::GenJetCollection>(iConfig.getUntrackedParameter<edm::InputTag>("genJetToken"));
  genParticleToken_ = consumes<reco::GenParticleCollection>(iConfig.getUntrackedParameter<edm::InputTag>("genParticleToken"));
  genInfoToken_ = consumes<GenEventInfoProduct>(iConfig.getParameter<edm::InputTag>("genInfoToken"));
}


GenReader::~GenReader()
{
 
  // do anything here that needs to be done at desctruction time
  // (e.g. close files, deallocate resources etc.)

}


//
// member functions
//

// ------------ method called to for each event  ------------
void GenReader::analyze(const edm::Event& iEvent, const edm::EventSetup& iSetup)
{
  
  edm::Handle<reco::GenParticleCollection> genParticles;
  iEvent.getByToken(genParticleToken_, genParticles);

  if(genParticles.isValid()){
    for(size_t i = 0; i < genParticles->size(); ++ i) {
      const reco::GenParticle & p = (*genParticles)[i];
      int id = p.pdgId();
      if(id == 9900023){
        hist0->Fill(p.mass());
        break;
        //std::cout<<i<<" "<<p.mass()<<" "<<p.eta()<<std::endl;
      }
    }
  }
	else {
    edm::LogWarning("MissingProduct") << "Gen Particles not found. Branch will not be filled" << std::endl;
  }
}

// ------------ method called once each job just before starting event loop  ------------
void 
GenReader::beginJob(void)
{
}

// ------------ method called once each job just after ending the event loop  ------------
void 
GenReader::endJob() {
  TCanvas *c = new TCanvas("","",1200,900);
  c->cd();
  hist0->Draw();
  c->Print("m.png");
}

//define this as a plug-in
DEFINE_FWK_MODULE(GenReader);