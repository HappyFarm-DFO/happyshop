/* 
 *  WalletShop
 *  VERSION: 1.1
 *
 */

pragma solidity ^0.6.12;


contract ERC20{
    function allowance(address owner, address spender) external view returns (uint256){}
    function transfer(address recipient, uint256 amount) external returns (bool){}
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){}
    function balanceOf(address account) external view returns (uint256){}
}

contract ShopFactory{
    
    address[] public shopsList;
    mapping(address => bool)public listed;
    
    function newShop()public{
        require(!listed[msg.sender]);
        WalletShop shp=new WalletShop(msg.sender);
        shp.setMaster(msg.sender);
        shopsList.push(address(shp));
        listed[address(shp)]=true;
    }
    
    function list(uint index,uint amount)view public returns(string memory,uint length){
        string memory tempS="[";
        for(uint i=0;i<shopsList.length;i++){
            if(i<shopsList.length-1)
            tempS=append(tempS,toString(shopsList[index]),",");
            if(i==shopsList.length-1)
            tempS=append(tempS,toString(shopsList[index]),"]");
        }
        return (tempS,shopsList.length);
    }
    
    function append(string memory a, string memory b, string memory c) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }
    
    function toString(address account) internal pure returns(string memory) {
        return toString(abi.encodePacked(account));
    }
    
    function toString(bytes memory data) internal pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }
}

contract HappyFarm{
  receive() external payable{}
}


contract WalletShop {
    
    address payable hf=payable(0x510f0a380c914928386bdA31dC159FcB30Ffa708);
    address public master;
    mapping(address => uint)public price;
    address public receiver;

    //lister
    address[] public list;

    constructor(address vault) public {
        master=msg.sender;
    }
    
    function buyRef(address tkn,address shop,address ref) payable public returns(bool){
        uint fees=msg.value/400;
        //require(hf.transfer(fees));
        //require(ref.transfer(fees));
        require(buyUtil(tkn,shop));
    }
    
    function buy(address tkn,address shop) payable public {
        //require(0x510f0a380c914928386bdA31dC159FcB30Ffa708.transfer(msg.value/200));
        require(buyUtil(tkn,shop));
    }
    
    function buyRef(address tkn,address ref) payable public {
        require(buyRef(tkn,master,ref));
    }
    
    function buy(address tkn) payable public {
        //require(0x510f0a380c914928386bdA31dC159FcB30Ffa708.transfer(msg.value/200));
        require(buyUtil(tkn,master));
    }
    
    function buyUtil(address tkn,address shop) internal returns(bool){
        uint256 buyAmount = msg.value*price[tkn]/1000; // !!!
        require(buyAmount > 0);
        ERC20 token = ERC20(tkn);
        require(buyAmount <= token.balanceOf(shop));
        require(token.transferFrom(shop,msg.sender, buyAmount));
        return true;
    }
    
    
    function shopListing(uint index)view public returns(uint){
        return (list.length);
    }
    
    function setMaster(address new_master)public{
        require(msg.sender==master);
        master=new_master;
    }
    
    function setPrice(address tkn,uint prc)public{
        require(msg.sender==master);
        require(prc > 0, "Price > 0 please");
        if(price[tkn]==0)list.push(tkn);
        price[tkn]=prc;
    }
    

    
}
