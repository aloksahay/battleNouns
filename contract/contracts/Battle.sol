// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Battle {
    
    // Two competitive teams
    address team1;
    address team2;

    // Points for each team
    uint points1;
    uint points2;

    // Deadline before the match
    uint deadline;

    // Steps of the user
    mapping (address => uint) steps;
    mapping (address => uint) amount;
    mapping (address => bool) support;
    mapping (address => bool) completed;

    // Owner of the contract
    address owner;

    constructor(
        address _team1,
        address _team2,
        uint duration
    ) payable {
        team1 = _team1;
        team2 = _team2;
        deadline = block.timestamp + duration;

        owner = msg.sender;
    }

    function participate(address supportiveTeam, uint256 user_amount) external {
        require(user_amount > 0);  // Need to have some token
        // require(steps[msg.sender] == 0);  // Have not already participate
        require(supportiveTeam == team1 || supportiveTeam == team2);  // Valid team

        // Transfer user token to the smart contract
        IERC20 token = IERC20(supportiveTeam);
        require(token.transferFrom(msg.sender, address(this), user_amount), "Token transfer failed");
        
        // Increase the point to the respective teams
        if (supportiveTeam == team1) {
            points1 += 100;
            support[msg.sender] = false;
        } else {
            points2 += 100;
            support[msg.sender] = true;
        }

        // Initialize the amount & the steps
        amount[msg.sender] = user_amount;
        steps[msg.sender] = 1;
    }

    function nextSteps(address user) external {
        require(msg.sender == owner); // Only the owner can update it at the moment
        require(!completed[user], "USER_ALREADY_COMPLETED");
        // require(steps[user] > 0); // Need the user to be register
        
        // Update the user steps
        steps[user]++;

        // Attribute some points to the team
        if (!support[user]) {
            points1 += 100;
        } else {
            points2 += 100;
        }
    }

    function levelComplete(address user) external {
        require(msg.sender == owner, "ONLY_OWNER"); // Only the owner can update it at the moment
        require(!completed[user], "USER_ALREADY_COMPLETED");

        completed[user] = true;

        if (!support[user]) {
            points1 += 1000;
        } else {
            points2 += 1000;
        }

    }

}
