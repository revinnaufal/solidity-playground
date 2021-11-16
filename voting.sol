pragma solidity ^0.8.1;

contract voting{
    
    struct itemDetails{
        uint votenumber;
        bool votingStatus;
        address itemAddress;
    }
    
    mapping(address=>bool) initiator;
    mapping(string=>itemDetails) public itemList;
    mapping(address=>bool) voters;
    mapping(uint=>string) namesItemUint;
    
    uint numberOfItem;
    uint maxVoteNew;
    string winnerNew;
    
    //string[] itemListShow;
    
    constructor(){
        initiator[msg.sender] = true;
    }
    
    
    function addVotingItem(string memory item,address receiverAddress) public{
        numberOfItem +=1;
        itemList[item].votingStatus = true;
        itemList[item].itemAddress = receiverAddress;
        namesItemUint[numberOfItem] = item;

        //itemListShow.push(item);
    }
    
    function vote(string memory item) public{
        require(itemList[item].votingStatus == true,"The Voting has been closed");
        itemList[item].votenumber += 1;
        if(maxVoteNew <= itemList[item].votenumber){
            maxVoteNew = itemList[item].votenumber;
            winnerNew = item;
        } else{
            maxVoteNew = maxVoteNew;
            winnerNew = winnerNew;
        } 
        
    }
    /**
    function showItem() public view returns(string[] memory){
        return itemListShow;
    }**/
    
    function closeVoting() public returns(string memory){
        for(uint i=1;i<=numberOfItem;i++){
            itemList[namesItemUint[i]].votingStatus = false;
        }
        
        return winnerNew;
    }
    
}