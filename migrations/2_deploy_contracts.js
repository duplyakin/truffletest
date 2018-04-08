var Astral = artifacts.require("./Astral.sol");
var VersionableContract = artifacts.require("./VersionableContract.sol");

module.exports = function(deployer) {
  deployer.deploy(Astral);
  deployer.link(Astral, VersionableContract);
  deployer.deploy(VersionableContract);
};
