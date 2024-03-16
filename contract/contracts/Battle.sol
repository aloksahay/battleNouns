// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

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

    constructor(
        address _team1,
        address _team2,
        uint duration
    ) payable {
        team1 = _team1;
        team2 = _team2;
        deadline = block.timestamp + duration;
    }

    function participate(address supportiveTeam, uint amount) external {
        require(amount > 0);  // Need to have some token
        require(steps[msg.sender] == 0);  // Have not already participate
        require(supportiveTeam == team1 || supportiveTeam == team2);  // Valid team

        // Transfer user token to the smart contract
        IERC20 token = IERC20(supportiveTeam);
        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
        
        // Increase the point to the respective teams
        if (supportiveTeam == team1) {
            points1 += 100;
        } else {
            points2 += 100;
        }

        // Initialize the amount & the steps
        amount[msg.sender] = amount;
        steps[msg.sender] = 1;
    }

    function nextSteps() external {
        steps[msg.sender]++;
    }

}
