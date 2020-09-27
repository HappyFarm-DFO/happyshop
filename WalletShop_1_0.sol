/* 
 *  WalletShop
 *  VERSION: 1.0
 *
 */

pragma solidity ^0.6.0;


contract ERC20{
    function allowance(address owner, address spender) external view returns (uint256){}
    function transfer(address recipient, uint256 amount) external returns (bool){}
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){}
    function balanceOf(address account) external view returns (uint256){}
}


contract ListerShop {
    
    address public master;
    mapping(address => uint)public price;
    address public receiver;

    //lister
    address[] public list;

    constructor(address vault) public {
        master=msg.sender;
        receiver=vault;
    }
    
    function buy(address tkn,address shop) payable public {
        uint256 buyAmount = msg.value*price[tkn]/1000; // !!!
        ERC20 token = ERC20(tkn);
        require(buyAmount > 0);
        require(buyAmount <= token.balanceOf(shop));
        require(token.transferFrom(shop,msg.sender, buyAmount));
    }
    
    function shopListing(uint index)view public returns(address,uint,uint){
        return (list[index],price[list[index]],list.length);
    }
    
    function setMaster(address new_master)public returns(bool){
        require(msg.sender==master);
        master=new_master;
        return true;
    }
    
    function setPrice(address tkn,uint prc)public returns(bool){
        require(msg.sender==master);
        require(prc > 0, "Price > 0 please");
        if(price[tkn]==0)list.push(tkn);
        price[tkn]=prc;
        return true;
    }
    

    
}
