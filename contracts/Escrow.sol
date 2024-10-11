// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;
// import "@openzeppelin/contracts/access/Ownable.sol";

contract Escrow {
    address public owner;

    struct History {
        uint256 transactionType; // 0 for deposit, 1 for withdrawal
        address from;
        address to;
        uint256 amount;
    }

    mapping(address => History[]) public transactionHistory;

    // depositer => to and amount deposited
    mapping(address => address) depositer;
    mapping(address => mapping(address => uint256)) public whitelisted;

    constructor() {
        owner = msg.sender;
    }

    function deposit(address to, uint256 _amountToDeposit) external payable {
        whitelisted[msg.sender][to] = _amountToDeposit;
        depositer[msg.sender] = to;
        transactionHistory[msg.sender].push(
            History({
                transactionType: 0,
                from: msg.sender,
                to: to,
                amount: _amountToDeposit
            })
        );
        bool success = payable(address(this)).send(msg.value);
        require(success, "Transfer failed");
    }

    function withdraw(address _depositer) external {
        address receiverAddr = depositer[_depositer];
        require(receiverAddr == msg.sender, "invalid caller");
        uint256 amountTowithdraw = whitelisted[_depositer][receiverAddr];

        transactionHistory[msg.sender].push(
            History({
                transactionType: 1,
                from: _depositer,
                to: receiverAddr,
                amount: amountTowithdraw
            })
        );

        bool success = payable(receiverAddr).send(amountTowithdraw);
        require(success, "Transfer failed");
    }

    function getTransactionHistory(
        address account
    ) public view returns (History[] memory) {
        return transactionHistory[account];
    }
}
