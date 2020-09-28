contract priceList {
    
    address public master;
    mapping(address => uint)price;
    address[] list;
    

    constructor() public {
        master=msg.sender;
    }
    
    function priceListing(uint index)view public returns(address,uint,uint){
        return (list[index],price[list[index]],list.length);
    }
    
    function setPrice(address tkn,uint prc)public returns(bool){
        require(msg.sender==master);
        require(prc > 0, "Price > 0 please");
        if(price[tkn]==0)list.push(tkn);
        price[tkn]=prc;
        return true;
    }
    
}
