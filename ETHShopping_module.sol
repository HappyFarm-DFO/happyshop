contract ETHShoppingModule {
    
    address public vault;
    ItemsGifterDB public gifter;
    uint public eth_percent_price=100;
    
    constructor(address vlt) public{
        vault=vlt;
        gifter=ItemsGifterDB(0xC9746af16e5d5cc414eDF53f91cBA76e6Eaf739D);
    }
    
    function buy() payable public returns(bool){
        require(gifter.gift(0x801F90f81786dC72B4b9d51Ab613fbe99e5E4cCD,msg.value*eth_percent_price/100,msg.sender));
        payable(vault).transfer(msg.value);
        return true;
    } 
    
}
