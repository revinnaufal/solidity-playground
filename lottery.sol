pragma solidity ^0.8.1;

contract lottery{
    
    address[] participant;
    uint256 balanceContract;
    mapping(address=>bool) admin;
    uint pickedWinner;
    bool randomStatus;
    
    
    address[] winnerCollective;
    
    constructor(){
        //admin[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = true;
        admin[msg.sender] = true;
    }
    
    function registerLottery() public payable returns(uint){
        require(msg.value>=10000000000000000000,"Registration fee is 10 Ether");
        //require(msg.value % 10000000000000000000 == 0,"Please input the money based on 10 Ether");
        require(msg.value / 10000000000000000000 == 1,"You should pay only 10 Ether");
        require(msg.sender.balance >= 10000000000000000000, "MISKIN");
        if(participant.length>0){
            require(checkPresence(msg.sender),"You have already been registered");
        }
        uint numberOfTicket = msg.value / 10000000000000000000;
        for(uint i=0;i<numberOfTicket;i++){
            participant.push(msg.sender);   
        }
        
        balanceContract +=  msg.value;
        
        return balanceContract;
        
    }
    
    function checkPresence(address addressPar) private view returns(bool){
        
        bool checkerBool;
        for(uint x=0;x<participant.length;x++){
            if(participant[x] == addressPar){
                checkerBool = false;
                break;
            } else{
                checkerBool = true;
            }
        }
        
        return checkerBool;
        
    }
    
    function viewParticipant() public view returns(address[] memory){
        return participant;
        
    }
    
    function pickWinner(uint numofWinner) public returns (address) {
        require(admin[msg.sender] == true,"You are not an admin");
        
        for(uint i=0;i<numofWinner;i++){
            uint randomHash = uint(keccak256(abi.encodePacked(block.timestamp)));
            pickedWinner = randomHash % participant.length;
            
            address payable winnerAddress = payable(participant[pickedWinner]);
            winnerAddress.transfer(address(this).balance/numofWinner);
            
            winnerCollective.push(participant[pickedWinner]);
            
            if(pickedWinner == (participant.length-1)){
                participant.pop();
            } else{
                delete participant[pickedWinner];
                participant[pickedWinner] = participant[participant.length-1];
                participant.pop();
            }
            
        }
        
        randomStatus = true;
        
        showWinner();
        
        return participant[pickedWinner];
    }
    
    function showWinner() public view returns(address[] memory){
        require(admin[msg.sender] == true,"You are not an admin");
        require(randomStatus == true,"Please pick winner first");
        return winnerCollective;
    }
    
}