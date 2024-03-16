const express = require('express');
const Web3 = require('web3');
const fs = require('fs');

const app = express();
const port = 3000;



const factory = new ContractFactory(contractAbi, contractByteCode);

// If your contract requires constructor args, you can specify them here
const contract = await factory.deploy(deployArgs);

console.log(contract.address);
console.log(contract.deployTransaction);



// Connect to the Ethereum node
const web3 = new Web3(new Web3.providers.HttpProvider('https://spicy-rpc.chiliz.com/')); 

// Read the solidity contract
const contractFile = fs.readFileSync('../contract/contracts/Battle.sol', 'utf8');
const contractSource = contractFile.toString();

// Compile the contract
const contractCompiled = web3.eth.compile.solidity(contractSource);

// Get the contract ABI and bytecode
const contractABI = contractCompiled.Battle.info.abiDefinition;
const contractBytecode = '0x' + contractCompiled.Battle.code;

// Deploy the contract
async function deployContract() {
    try {
        const accounts = await web3.eth.getAccounts();
        const deploy = new web3.eth.Contract(contractABI);
        const deployedContract = await deploy.deploy({
            data: contractBytecode
        }).send({
            from: accounts[0],
            gas: 1500000,
            gasPrice: '30000000000'
        });
        console.log('Contract deployed at address:', deployedContract.options.address);
        return deployedContract.options.address;
    } catch (error) {
        console.error('Error deploying contract:', error);
        throw error;
    }
}

// Deploy route
app.get('/deploy', async (req, res) => {
    try {
        const deployedAddress = await deployContract();
        res.send('Contract deployed at address: ' + deployedAddress);
    } catch (error) {
        res.status(500).send('Error deploying contract: ' + error.message);
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
