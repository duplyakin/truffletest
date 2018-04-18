
module.exports = function(deployer, network, accounts) {


  var safeMath= artifacts.require("SafeMath");
/*  var zeppelinSolidity= artifacts.require("zeppelin-solidity");*/
  var iBaseHolder = artifacts.require("iBaseHolder");
    var icoBaseHolder = artifacts.require("iBaseHolder");
  var iCreator = artifacts.require("iCreator");
  var iDocument = artifacts.require("iDocument");
  var SampleToken = artifacts.require("SampleToken");
  var SampleTokenCreator = artifacts.require("SampleTokenCreator");
  var myStorage = artifacts.require("Storage");
  var iVersionable=artifacts.require("iVersionable");
  var IncreasingPriceCrowdsaleBuilder=artifacts.require("IncreasingPriceCrowdsaleBuilder");
  var IncreasingPriceCrowdsaleCreator=artifacts.require("IncreasingPriceCrowdsaleCreator");
  var IncreasingPriceCrowdsale=artifacts.require("IncreasingPriceCrowdsale");
  deployer.deploy(safeMath);
  deployer.link(safeMath,[iVersionable,iBaseHolder,myStorage]);
  deployer.deploy(myStorage);
  deployer.deploy(iBaseHolder);

  var storage,holder;
  var stc;
  var icoHolder,icoCreator;
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
  return SampleTokenCreator.new(holder.address,1, { from: accounts[0]});

}).then(function(instance) {
  return holder.updateCreator(instance.address);
}).then(function() {
  return icoBaseHolder.new( { from: accounts[0]})
}).then(function(instance) {
    icoHolder= instance;
    return  storage.addHolder("IncreasingPriceCrowdsale",icoHolder.address);
}).then(function() {
  return    IncreasingPriceCrowdsaleCreator.new(icoHolder.address,1, { from: accounts[0]});
}).then(function(instance) {
  return icoHolder.updateCreator(instance.address);
});



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
