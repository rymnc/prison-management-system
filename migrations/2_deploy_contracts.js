const prisonManagement = artifacts.require("prisonManagement");

module.exports = function(deployer) {
  deployer.deploy(prisonManagement);
};
