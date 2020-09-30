contract AleatorySellerModule {
    
    address public vault;
    ItemsGifterDB public gifter;
    uint public eth_percent_price=100;
    address gift=0x801F90f81786dC72B4b9d51Ab613fbe99e5E4cCD;
    
    constructor(address vlt) public{
        vault=vlt;
        gifter=ItemsGifterDB(0xC9746af16e5d5cc414eDF53f91cBA76e6Eaf739D);
    }

    
    function buy() payable public returns(bool){
        uint price=eth_percent_price;
        if(uint256(keccak256(abi.encode(block.timestamp, block.difficulty))) % 2 == 0){price+=10;}else{price-=10;}
        require(gifter.gift(gift,msg.value*price/100,msg.sender)); //!!!
        payable(vault).transfer(msg.value);
        return true;
    } 
    
}
