const Token = artifacts.require("Token");
const dBank = artifacts.require("dBank");

module.exports = async function(deployer) {
	await deployer.deploy(Token)

	// Fetch the deployed token contract
	const token = await Token.deployed()

	await deployer.deploy(dBank, token.address)

	//Fetch the deployed dbank contract
	const dbank = await dBank.deployed()

	//pass the ownership to the bank
	await token.passOwnership(dBank.address)
};