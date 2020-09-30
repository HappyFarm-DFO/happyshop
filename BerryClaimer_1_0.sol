/* 
 *  BerryClaimer_1_0
 *  VERSION: 1.0
 *
 */

contract ERC20{
    function allowance(address owner, address spender) external view returns (uint256){}
    function transfer(address recipient, uint256 amount) external returns (bool){}
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){}
    function balanceOf(address account) external view returns (uint256){}
}

contract PeriodicStaker {
    
    event Staked(address staker);

    ERC20 public token;
    uint public total_stake=0;
    uint public total_stakers=0;
    mapping(address => uint)public stake;
    
    uint public status=0;
    
    uint safeWindow=40320;
    
    uint public startLock;
    uint public lockTime;
    uint minLock=10000;
    uint maxLock=200000;
    
    uint public freezeTime;
    uint minFreeze=10000;
    uint maxFreeze=200000;

    address public master;
    mapping(address => bool)public modules;
    address[] public modules_list;
    

    constructor(address tokenToStake,address mastr) public {
        token=ERC20(tokenToStake);
        master=mastr;
    }
    

    function stakeNow(uint256 amount) public returns(bool){
        require(stk(amount,msg.sender));
        return true;
    }
    
    function stakeNow(uint amount,address staker) public returns(bool){
        require(modules[msg.sender]);
        require(stk(amount,staker));
        return true;
    }
    
    function stk(uint amount,address staker)internal returns(bool){
        require(amount > 0);
        require(status!=2);
        uint256 allowance = token.allowance(staker, address(this));
        require(allowance >= amount);
        require(token.transferFrom(staker, address(this), amount));
        if(stake[staker]==0)total_stakers++;
        stake[staker]+=amount;
        total_stake+=amount;
        emit Staked(staker);
        return true;
    }
    
    function unstake() public returns(bool){
        require(unstk(msg.sender));
        return true;
    }
    
    function unstake(address unstaker) public returns(bool){
        require(modules[msg.sender]);
        require(unstk(unstaker));
        return true;
    }
    
    function unstk(address unstaker)internal returns(bool){
        require(stake[unstaker] > 0);
        if(status==1)require((startLock+lockTime)<block.number);
        require(token.transfer(unstaker, stake[unstaker]));
        total_stake-=stake[unstaker];
        stake[unstaker]=0;
        total_stakers--;
        return true;
    }
    
    function openDropping(uint lock) public returns(bool){
        require(msg.sender==master);
        require(block.number>startLock+safeWindow);
        require(minLock<=lock);
        require(lock<=maxLock);
        require(status==0);
        status=1;
        lockTime=lock;
        startLock=block.number;
        return true;
    }
    
    function freeze(uint freez) public returns(bool){
        require(msg.sender==master);
        require(block.number>startLock+safeWindow);
        require(minFreeze<=freez);
        require(freez<=maxFreeze);
        require(status==0);
        status=2;
        freezeTime=freez;
        startLock=block.number;
        return true;
    }
    
    function open() public returns(bool){
        require(status>0);
        if(status==1)require(block.number>startLock+lockTime);
        if(status==2)require(block.number>startLock+freezeTime);
        startLock=block.number;
        status=0;
        return true;
    }
    
    function setMaster(address new_master)public returns(bool){
        require(msg.sender==master);
        master=new_master;
        return true;
    }
    
    function setModule(address new_module,bool set)public returns(bool){
        require(msg.sender==master);
        modules[new_module]=set;
        if(set)modules_list.push(new_module);
        return true;
    }
    

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


contract BerryClaimer{
    
    PeriodicStaker public staker;
    ItemsGifterDB public gifter;
    address berry;
    
    constructor() public{
        staker=PeriodicStaker(0x7d410AFA45377006A0F79Ae6157A6A873Bfa5567);
        gifter=ItemsGifterDB(0xC9746af16e5d5cc414eDF53f91cBA76e6Eaf739D);
        berry=0xC9746af16e5d5cc414eDF53f91cBA76e6Eaf739D;
    }
    
    function claimBerry() public returns(bool){
        require(staker.stake(msg.sender)>0);
        require(gifter.gift(berry,1,msg.sender));
        return true;
    } 
     
}
