
require('dotenv').config()

const express = require('express');
const Web3 = require('web3');
const fs = require('fs');

const app = express();
const port = 3000;

// import ContractFactory from 'ethers';
// import { ethers } from 'ethers';
const { ethers } = require('ethers');

const contractInfo = require("./Battle.json") 

const ERC20_ABI = require("./data/erc_20_abi.json");

let provider = new ethers.JsonRpcProvider("https://spicy-rpc.chiliz.com/");


const TEST_CONTRACT_ADDRESS = "0xF7c81e84F7e4DF917E8f47009f9c56b2512cF71C";

const CONTRACT_OWNER_KEY = process.env.CONTRACT_OWNER_KEY;

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

        let provider = new ethers.JsonRpcProvider("https://spicy-rpc.chiliz.com/");

        let signer = new ethers.Wallet(CONTRACT_OWNER_KEY, provider);

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


//
// Get team name
// 

async function get_team_1(contract_address) {
    let contract = new ethers.Contract(
        contract_address,
        contractInfo.abi,
        provider
    );

    // Get the team ERC20 address
    const team_1_address = await contract.team1();
    
    return await get_team_name_from_address(team_1_address);
}

async function get_team_2(contract_address) {

    let contract = new ethers.Contract(
        contract_address,
        contractInfo.abi,
        provider
    );

    // Get the team ERC20 address
    const team_2_address = await contract.team2();
    
    return await get_team_name_from_address(team_2_address);
}

// TESTING PURPOSE
app.get('/fan-player-1', async (req, res) => {
    let team_name = await get_team_1("0x6C97f9A13c658B1eabCC774C20C8ad1d2A6D6190");
    res.send(team_name);
});

// TESTING PURPOSE
app.get('/fan-player-2', async (req, res) => {
    let team_name = await get_team_2("0x6C97f9A13c658B1eabCC774C20C8ad1d2A6D6190");
    res.send(team_name);
});

app.get('/fan-player-1/:contract_address', async (req, res) => {
    let contract_address = req.params['contract_address'];
    let team_name = await get_team_1(contract_address);
    res.send(team_name);
});

app.get('/fan-player-2/:contract_address', async (req, res) => {
    let contract_address = req.params['contract_address'];
    let team_name = await get_team_2(contract_address);
    res.send(team_name);
});



app.get('/balance/:fan_token/:user_address', async (req, res) => {

    // Example call 
    // http://localhost:3000/balance/0xa4bf4104ec0109591077Ee5F4a2bFD13dEE1Bdf8/0x2aAbDd5b684B99aa16955cc1f107A7479Bf5512d

    try {
        // Extract the addresses
        let fan_token_address = req.params['fan_token'];
        let user_address = req.params['user_address'];
        

        let contract = new ethers.Contract(
            fan_token_address,
            ERC20_ABI,
            provider
        );

        let user_balance = await contract.balanceOf(user_address);

        res.send("" + user_balance);
    } catch (error) {
        console.log(error);
        res.status(500).send('Error when looking at the user balance');
    }
    
});


app.get('/upgrade/:contract_address/:user_address', async (req, res) => {

    // Example call 
    // http://localhost:3000/upgrade/0xF7c81e84F7e4DF917E8f47009f9c56b2512cF71C/0x2aAbDd5b684B99aa16955cc1f107A7479Bf5512d

    try {
        // Extract the addresses
        let contract_address = req.params['contract_address'];
        let user_address = req.params['user_address'];

        let signer = new ethers.Wallet(CONTRACT_OWNER_KEY, provider);

        // Get the contract 
        let contract = new ethers.Contract(
            contract_address,
            contractInfo.abi,
            signer
        );

        // Go to the next level
        await contract.nextSteps(user_address);

        res.send("true");
    } catch (error) {
        console.log(error);
        res.status(500).send('Error when looking at the user balance');
    }
    
});

app.get('/levelComplete/:contract_address/:user_address', async (req, res) => {

    try {
        // Extract the addresses
        let contract_address = req.params['contract_address'];
        let user_address = req.params['user_address'];

        let signer = new ethers.Wallet(CONTRACT_OWNER_KEY, provider);

        // Get the contract 
        let contract = new ethers.Contract(
            contract_address,
            contractInfo.abi,
            signer
        );

        // Go to the next level
        await contract.levelComplete(user_address);

        res.send("true");
        
    } catch (error) {
        console.log(error);
        res.status(500).send('Error when looking at the user balance');
    }
});





// Start the server
// app.listen(443)
// app.listen(80)
app.listen(3001)