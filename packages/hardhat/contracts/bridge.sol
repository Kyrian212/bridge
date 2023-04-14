 // SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenBridge {
    address public ethToken;
    address public celoToken;
    address public ethBridge;
    address public celoBridge;

    event Deposit(address indexed user, uint256 amount, address indexed recipient, address indexed toChain);
    event Withdrawal(address indexed user, uint256 amount, address indexed recipient, address indexed toChain);

    constructor(
        address _ethToken,
        address _celoToken,
        address _ethBridge,
        address _celoBridge
    ) {
        ethToken = _ethToken;
        celoToken = _celoToken;
        ethBridge = _ethBridge;
        celoBridge = _celoBridge;
    }

    function deposit(
        uint256 _amount,
        address _recipient,
        address _toChain
    ) external {
        IERC20(ethToken).transferFrom(msg.sender, address(this), _amount);
        IERC20(ethToken).approve(ethBridge, _amount);
        IEthBridge(ethBridge).deposit(ethToken, _amount, _recipient, _toChain);
        emit Deposit(msg.sender, _amount, _recipient, _toChain);
    }

    function withdraw(
        uint256 _amount,
        address _recipient,
        address _fromChain
    ) external {
        ICeloBridge(celoBridge).burn(celoToken, _amount, _recipient, _fromChain);
        emit Withdrawal(msg.sender, _amount, _recipient, _fromChain);
    }
}

interface IEthBridge {
    function deposit(
        address token,
        uint256 amount,
        address recipient,
        bytes32 toChain
    ) external;
}

interface ICeloBridge {
    function burn(
        address token,
        uint256 amount,
        address recipient,
        bytes32 fromChain
    ) external;
}
