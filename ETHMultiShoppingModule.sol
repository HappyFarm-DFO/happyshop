contract ETHMultiShoppingModule {
    
    address public vault;
    ItemsGifterDB public gifter;
    priceList public prices;
    uint public eth_percent_price=100;
    
    constructor(address vlt, address prcs, address gftr) public{
        vault=vlt;
        prices=priceList(prcs);
        gifter=ItemsGifterDB(gftr);
    }
    
    function buy(address tkn) payable public returns(bool){
        require(gifter.gift(tkn,msg.value*prices.price(tkn)/100,msg.sender));
        payable(vault).transfer(msg.value);
        return true;
    } 
    
}
