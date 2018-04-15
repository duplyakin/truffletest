
module.exports = function(deployer, network, accounts) {


  var safeMath= artifacts.require("SafeMath");
/*  var zeppelinSolidity= artifacts.require("zeppelin-solidity");*/
  var iBaseHolder = artifacts.require("iBaseHolder");
  var iCreator = artifacts.require("iCreator");
  var iDocument = artifacts.require("iDocument");
  var SampleToken = artifacts.require("SampleToken");
  var SampleTokenCreator = artifacts.require("SampleTokenCreator");
  var myStorage = artifacts.require("Storage");
  var iVersionable=artifacts.require("iVersionable");
  deployer.deploy(safeMath);
  deployer.link(safeMath,[iVersionable,iBaseHolder,myStorage]);
  deployer.deploy(myStorage);
  deployer.deploy(iBaseHolder);

  var storage,holder;
  var stc;
  deployer.then(function() {
  return myStorage.deployed();
}).then(function(instance) {
  storage = instance;
  return iBaseHolder.deployed();

}).then(function(instance) {
  holder = instance;
  return  storage.addHolder("token",holder.address);

}).then(function() {
  //holder.address
  deployer.deploy(SampleTokenCreator,holder.address,2, { from: accounts[0]});
  setTimeout(function() {
    stc= SampleTokenCreator.deployed();
  }, 5000);
});/*.then(function() {
  return SampleTokenCreator.deployed();
});*/



/*
deployer.then(function(instance) {
//  a = instance;
  //holder = instance;
  holder.updateCreator(instance.address);
  //return  storage.addHolder("token",holder.address);

}*/
/*  deployer.then(function(){
    return myStorage.new();
  })*/
//  deployer.deploy(SampleToken);
//  deployer.deploy(SampleTokenCreator);




};
