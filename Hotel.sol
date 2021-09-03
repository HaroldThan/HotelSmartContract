pragma solidity ^0.6.0;

contract HotelRoom {
    //Status Object For Each Room
    enum Statuses { Vacant, Occupied }
    Statuses currentStatus;
    
    //Creator/Owner Of Smart Contract can receive Payable
    address payable public owner;
    
    
    // Event Call
    event Occupy(address _occupant, uint _value);
    
    
    constructor() public {
        //Person Who Called This Smart Contract is the Owner
        owner = msg.sender;
        //Automatically Vacant Room Initially
        currentStatus = Statuses.Vacant;
    }
    
    
     // Modifier: Check For Conditions Before Entering function
    modifier onlyWhileVacant {
        require(currentStatus== Statuses.Vacant, "Room Is Already Occupied"); //Vacancy Check
        _; //Follow Through With Function
    }
    modifier onlyWhenHasEnoughEther(uint _amount) {
        require(msg.value >= _amount ether, "Not Enough Ether To Book"); // Payment Check
        _; // Follow Through With Function
    }
    
    
    // SPECIAL FUNCTION receive(): Transfer ETH to Contract When Someone Pay (Check for Vacancy and at least 1 ETH in Account)
    receive() external payable onlyWhileVacant onlyWhenHasEnoughEther(1) {
        // Owner Receive Money
        owner.transfer(msg.value);
        // Status Of Room Change To Occupied
        currentStatus = Statuses.Occupied;
        // Event Call
        emit Occupy(msg.sender, msg.value);
    }
    
}
