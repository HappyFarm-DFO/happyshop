contract Book {

    address[] public doors;
    mapping(address => bool)public isModule;
    mapping(address => bool)public isDoor;
    address public master;
    
    constructor () public { master=msg.sender; }
    
    function setDoor(address tkn)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        if(!isDoor[tkn]){
        doors.push(tkn);
        isDoor[tkn]=true;
        }
        return true;
    }
    
    function setModule(address tkn)public returns(bool){
        require((isModule[msg.sender])||(msg.sender==master));
        isModule[tkn]=true;
        return true;
    }
    
    function setMaster(address mstr)public returns(bool){
        require((msg.sender==master)||(isModule[msg.sender]));
        master=mstr;
        return true;
    }
    
    function door(uint i)public view returns(address,uint){
        return (doors[i],doors.length);
    }
    
    
}
