
require('dotenv').config()

const express = require('express');
const Web3 = require('web3');
const fs = require('fs');

const app = express();
const port = 3000;

// import ContractFactory from 'ethers';
// import { ethers } from 'ethers';
const { ethers } = require('ethers');

const contractInfo = require("../contract/artifacts/contracts/Battle.sol/Battle.json") 

const ERC20_ABI = require("./data/erc_20_abi.json");


let provider = new ethers.JsonRpcProvider("https://spicy-rpc.chiliz.com/");

// // const factory = new ContractFactory(contractAbi, contractByteCode);

// // // If your contract requires constructor args, you can specify them here
// // const contract = await factory.deploy(deployArgs);

// // console.log(contract.address);
// // console.log(contract.deployTransaction);



// // Connect to the Ethereum node
// const web3 = new Web3(new Web3.providers.HttpProvider('https://spicy-rpc.chiliz.com/')); 

// // Read the solidity contract
// const contractFile = fs.readFileSync('../contract/contracts/Battle.sol', 'utf8');
// const contractSource = contractFile.toString();

// // Compile the contract
// const contractCompiled = web3.eth.compile.solidity(contractSource);

// // Get the contract ABI and bytecode
// const contractABI = contractCompiled.Battle.info.abiDefinition;
// const contractBytecode = '0x' + contractCompiled.Battle.code;

// // Deploy the contract
// async function deployContract() {
//     try {
//         const accounts = await web3.eth.getAccounts();
//         const deploy = new web3.eth.Contract(contractABI);
//         const deployedContract = await deploy.deploy({
//             data: contractBytecode
//         }).send({
//             from: accounts[0],
//             gas: 1500000,
//             gasPrice: '30000000000'
//         });
//         console.log('Contract deployed at address:', deployedContract.options.address);
//         return deployedContract.options.address;
//     } catch (error) {
//         console.error('Error deploying contract:', error);
//         throw error;
//     }
// }


async function get_team_name_from_address(team_address) {
        
    // From the ABI get the name of the team
    let erc_20_contract = new ethers.Contract(
        team_address,
        ERC20_ABI,
        provider
    );

    return await erc_20_contract.name();
}



const PSG_ADDRESS = "0xa4bf4104ec0109591077Ee5F4a2bFD13dEE1Bdf8";
const BAR_ADDRESS = "0x63667746A7A005E45B1fffb13a78d0331065Ff7f";

// Deploy route
app.get('/deploy', async (req, res) => {

    try {

        const privateKey = process.env.CONTRACT_OWNER_KEY;

        let provider = new ethers.JsonRpcProvider("https://spicy-rpc.chiliz.com/");

        let signer = new ethers.Wallet(privateKey, provider);

        const factory = new ethers.ContractFactory(
            contractInfo.abi, 
            contractInfo.bytecode, 
            signer
        );

        // If your contract requires constructor args, you can specify them here
        const contract = await factory.deploy(
            PSG_ADDRESS,
            BAR_ADDRESS,
            100
        );

        res.send(contract.target);

    } catch (error) {
        res.status(500).send('Error deploying contract: ' + error.message);
    }
});


// First API: get fan tokens for player1
// Second: upgradeLevel
// Third: levelComplete -> Airdrop fan tokens to winner


app.get('/fan-player-1', async (req, res) => {

    let contract = new ethers.Contract(
        "0x6C97f9A13c658B1eabCC774C20C8ad1d2A6D6190",
        contractInfo.abi,
        provider
    );

    // Get the team ERC20 address
    const team_1_address = await contract.team1();
    
    const team_name = await get_team_name_from_address(team_1_address);

    res.send(team_name);
});

app.get('/fan-player-2', async (req, res) => {

    let contract = new ethers.Contract(
        "0x6C97f9A13c658B1eabCC774C20C8ad1d2A6D6190",
        contractInfo.abi,
        provider
    );

    // Get the team ERC20 address
    const team_2_address = await contract.team2();
    
    const team_name = await get_team_name_from_address(team_2_address);

    res.send(team_name);
});

// app.get('/next', async (req, res) => {

//     req

// }

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
