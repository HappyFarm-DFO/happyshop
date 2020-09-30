/* 
 *  DecrementalSellerModule
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


contract ItemsGifterDB{
    
    event Gifted(address gifted);
    
    address[] public modules_list;
    mapping(address => bool)public modules;
    
    ERC20 public token;
    address master;
    address public receiver;
    
    constructor() public{
        master=msg.sender;
    }
    
    function gift(address tkn,uint amount,address gifted) public returns(bool){
        require(modules[msg.sender]);
        ERC20 token=ERC20(tkn);
        require(token.transfer(gifted, amount));
        emit Gifted(gifted);
        return true;
    } 
    
    function burn(address tkn)public returns(bool){
        require(msg.sender==master);
        ERC20 token=ERC20(tkn);
        token.transfer(master, token.balanceOf(address(this)));
    }
    
    function setModule(address new_module,bool set)public returns(bool){
        require(msg.sender==master);
        modules[new_module]=set;
        if(set)modules_list.push(new_module);
        return true;
    }
    
    function setMaster(address new_master)public returns(bool){
        require(msg.sender==master);
        master=new_master;
        return true;
    }
    
}


contract DecrementalSellerModule {
    
    address public vault;
    ItemsGifterDB public gifter;
    uint public eth_percent_price=10000;
    address gift=0x801F90f81786dC72B4b9d51Ab613fbe99e5E4cCD;
    
    constructor(address vlt) public{
        vault=vlt;
        gifter=ItemsGifterDB(0xC9746af16e5d5cc414eDF53f91cBA76e6Eaf739D);
    }
    
    function buy() payable public returns(bool){
        require(gifter.gift(gift,msg.value*(eth_percent_price--)/10000,msg.sender)); //!!!
        payable(vault).transfer(msg.value);
        return true;
    } 
    
}
