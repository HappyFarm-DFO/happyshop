/* 
 *  ListerShop
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
    
    event Bought(uint256 amount);
    address public master;
    mapping(address => uint)public price;
    address public receiver;

    //lister
    address[] public list;

    constructor(address vault) public {
        
        master=msg.sender;
        receiver=vault;
    }
    
    function buy(address tkn) payable public {
        uint256 amountTobuy = msg.value*price[tkn]/1000; // !!!
        ERC20 token = ERC20(tkn);
        uint256 shopBalance = token.balanceOf(address(this));
        require(amountTobuy > 0, "You need to send some Ether");
        require(amountTobuy <= shopBalance, "Not enough tokens in the reserve");
        require(token.transfer(msg.sender, amountTobuy));
        emit Bought(amountTobuy); 
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
    
        
    function burn(address tkn)public returns(bool){
        require(msg.sender==master);
        ERC20 token=ERC20(tkn);
        token.transfer(receiver, token.balanceOf(address(this)));
    }
    
}
