// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Payper {
    event Registered(address owner, string name);
    mapping(string => address) nameToAddressMap;
    mapping(string => uint256) nameToStableIDMap;
    mapping(string => Transaction[]) nameToTransactions;
    uint256 mintPrice = 5 * 10**17;

    struct Transaction {
        address from;
        address to;
        uint256 amount;
        uint256 stableIndex;
        uint256 time;
    }

    modifier onlyOwner() {
        require(
            msg.sender == address(0x28172273CC1E0395F3473EC6eD062B6fdFb15940)
        );
        _;
    }

    function registerName(string calldata name, uint256 _stableID)
        external
        payable
    {
        require(msg.value == mintPrice, "Mint price is not correct");
        require(!checkNameExists(name), "Name is already registered");
        nameToStableIDMap[name] = _stableID;
        nameToAddressMap[name] = msg.sender;
        emit Registered(msg.sender, name);
    }

    function recordTransaction(
        address from,
        uint256 amount,
        uint256 stableIndex,
        string calldata _name
    ) public {
        nameToTransactions[_name].push(
            Transaction(
                from,
                nameToAddressMap[_name],
                amount,
                stableIndex,
                block.timestamp
            )
        );
    }

    function resolveName(string calldata name) public view returns (address) {
        require(checkNameExists(name), "Name doesn't exist");
        return nameToAddressMap[name];
    }

    function checkIsOwner(string calldata name) internal view returns (bool) {
        address owner = resolveName(name);
        if (msg.sender == owner) {
            return true;
        } else {
            return false;
        }
    }

    function checkNameExists(string calldata name) public view returns (bool) {
        if (nameToAddressMap[name] == address(0)) {
            return false;
        } else {
            return true;
        }
    }

    function setMintPrice(uint256 newPrice) public onlyOwner {
        mintPrice = newPrice;
    }
}
