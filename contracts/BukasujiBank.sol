//SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

contract BukasujiBank{

    error InvalidAmount (uint256 sent, uint256 minRequired);
    
    mapping(address=>uint256) public balances;
     mapping(address => bool) public isDeposited;

    mapping(string=>uint256) public kycDetails;
    address public owner;

    event FundsDeposited (address indexed user, uint amount, uint timestamp);
    event ProfileUpdated (address indexed user);
    
    struct UserDetails {
        string name;
        uint age;
    }

    //UserDetails details array
    UserDetails[] detailArr;
    
    //a modifier to specify owner of contract
    modifier isOwner {
        require(owner == msg.sender);
        _;
    }

    // modifier to specify that it is the right address that increases their fund
    modifier increaseDeposit {
        require(balances[msg.sender] > 0, "you have 0 balance, deposit first before increasing your deposit");
        _;
    }

    constructor(){
        owner= (msg.sender);
    }

   
  // function to make deposit.
    function deposit() public payable  {
       balances[msg.sender] += msg.value;
       emit FundsDeposited(msg.sender, msg.value,block.timestamp );
        
    }

    //function to increase fund, it has two modifiers
    function addfund() public payable  increaseDeposit {
        balances[msg.sender] += msg.value;
        emit FundsDeposited(msg.sender, msg.value, block.timestamp);
    }

    //function to check balance
    function checkBalance() public view returns (uint256) {
        return balances[msg.sender];
 
    }

    //function to withdraw deposit
    function withdraw(uint256 amount) public isOwner  {
        require(balances[msg.sender] >= amount,  "insufficient fund, please reduce amount");
        payable(msg.sender).transfer(amount);
        balances[msg.sender] -= amount;

    }

   // function used to set user details and pushed to the array
   function setUserDetails(string calldata name, uint256 age) public {
        emit ProfileUpdated(msg.sender);
        detailArr.push(UserDetails(name, age));
        kycDetails[name] = age;
    }
    
   // function fetches all stored details in the array
    function getDetail(string memory name) public view  returns ( uint) {
        return  kycDetails[name];
        
    }
/// @return The balance of the  Bank contract
    function depositsBalance() public view returns (uint) {
        return address(this).balance;
    }

    //Need to have a fallback function for the contract to be able to receive funds
    fallback () external payable {
       
    }

    receive() external payable {
        
    }
    

}   
