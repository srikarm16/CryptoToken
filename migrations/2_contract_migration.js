const token = artifacts.require("./NewrlToken.sol");

module.exports = function(deployer) {
    deployer.deploy(token);
};