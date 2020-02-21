pragma solidity >=0.4.22 <0.7.0;

contract Token {
    // owner of the token contract
    address public owner;

    // Token Balances
    mapping(address => uint) tokenBalances;

    // Allowances
    mapping(address => mapping(address => uint)) tokenAllowances;

    string public constant name = "Standard Media Token";
    string public constant symbol = "SMT";
    uint8 public constant decimals = 18;

    // total number of tokens minted
    uint currentSupply;

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    // set the owner and set the initial number of currentSupply to zero
    constructor() public {
        owner = msg.sender;

        // set maximum token supply to 12.5 billion
        currentSupply = 12500000000;
    }

    /** Approve spender to spend tokens from caller's account.
        If this function is called multiple times, the previous allowance
        is replaced.

        Successful execution of this function should emit the Approval() event.
     */
    function approve(address spender, uint tokens) public returns (bool success) {
        tokenAllowances[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // Required ERC-20 Functions

    /** Returns the current total supply of tokens available. The easisest
        way to implement this function is to keep track of the total supply
        in a storage variable and to return it when this functino is called. */
    function totalSupply() public view returns (uint) {
        return currentSupply;
    }

    /** Return the balance of a given token owner. */
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return tokenBalances[tokenOwner];
    }

    /** Transfer tokens from sender's account to the to account.
        Zero-value transfers MUST be treated as normal transfers.
        This function should throw an error (use require(condition, message)) if
        the account has insufficient tokens.
        A successful transfer should emit the Transfer() event.
     */
    function transfer(address to, uint tokens) public returns (bool success) {
        uint tokenBalance = tokenBalances[msg.sender];
        require(tokenBalance > tokens, "You do not have enough tokens");
        tokenBalances[msg.sender] -= tokens;
        tokenBalances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    /** Transfer tokens from one account to another account.

        Zero-value transfers MUST be treated as normal transfers.
        This function should throw an error (use require(condition, message)) if
        the from account has insufficient tokens or there is insufficient allowance
        for the caller account.

        A successful transfer should emit the Transfer() event.
     */
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(tokenAllowances[from][msg.sender] > tokens, "Not enough token allowance to transfer!");
        require(tokenBalances[from] > tokens, "Account does not have enough tokens");
        tokenBalances[from] -= tokens;
        tokenBalances[to] += tokens;
        emit Transfer(from, to, tokens);
        return true;
    }

    /** This event is emitted when tokens are transferred from one account to another. */
    event Transfer(address indexed from, address indexed to, uint tokens);

    /** This event is emitted when tokens are approved for transfer from one account to another.. */
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}