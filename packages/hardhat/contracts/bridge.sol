//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Import the necessary ERC20 interfaces for token interaction
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenBridgingContract {
    // Address of the Ethereum token contract
    address public ethereumToken;
    
    // Address of the Celo token contract
    address public celoToken;
    
    // Mapping to track token balances on Ethereum
    mapping(address => uint256) public ethereumBalances;
    
    // Event emitted when tokens are bridged from Ethereum to Celo
    event TokensBridged(address indexed user, uint256 amount);
    
    constructor(address _ethereumToken, address _celoToken) {
        ethereumToken = _ethereumToken;
        celoToken = _celoToken;
    }
    
    // Deposit tokens on Ethereum and initiate the bridging process
    function depositTokens(uint256 amount) external {
        // Transfer the tokens from the user to the contract
        IERC20(ethereumToken).transferFrom(msg.sender, address(this), amount);
        
        // Lock the deposited tokens
        ethereumBalances[msg.sender] += amount;
        
        // Emit an event to notify the bridging process
        emit TokensBridged(msg.sender, amount);
    }
    
    // Bridge tokens from Ethereum to Celo
    function bridgeTokens() external {
        // Retrieve the token balance of the user on Ethereum
        uint256 amount = ethereumBalances[msg.sender];
        
        // Ensure the user has deposited some tokens
        require(amount > 0, "No tokens to bridge");
        
        // Transfer the tokens to the Celo token contract
        IERC20(celoToken).transfer(msg.sender, amount);
        
        // Update the token balance on Ethereum
        ethereumBalances[msg.sender] = 0;
    }
}