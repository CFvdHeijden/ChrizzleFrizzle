pragma solidity ^0.5.0;

// Implement mandatory ERC20 functions and events to inherit from
contract ERC20interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool succes);
    function transferFrom(address from, address to, uint tokens) public returns (bool succes);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// Implement Safemath to prevent overflow
contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
        c = a / b;
    }
}

contract ChrizzleFrizzle is ERC20interface, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals; //18 decimals is suggested
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    // Initializes ERC20 token by deployer of the contract
    constructor() public {
        name = "ChrizzleFrizzle";
        symbol = "CRFR";
        decimals = 18;
        _totalSupply = 100000000000000000000000000;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // Total number of ERC-20 tokens created and determines how many tokens are in the ecosystem
    function totalSupply() public view returns(uint) {
        return _totalSupply - balances[address(0)];
    }

    // Returns number of tokens owned by contract owner
    function balanceOf(address tokenOwner) public view returns(uint balance) {
        return balances[tokenOwner];
    }

    // Function to cancel transaction in case user doesn't have required number of tokens
    function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
        return allowed[tokenOwner][spender];
    }

    // Contract owner gives approval for withdraw of tokens
    function approve(address spender, uint tokens) public returns(bool succes) {
        // Checks total supply of tokens
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // Lets contract owner send tokens
    function transfer(address to, uint tokens) public returns(bool succes) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // Another transfer function to automate transactions
    function transferFrom(address from, address to, uint tokens) public returns (bool succes) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

/* FUNCTIONALITY TO ADD:

MINT FUCTION TO CREATE MORE TOKENS

    // Creates amount tokens and assigns them to account, increasing the total supply.
    _mint(address account, uint256 amount) internal {
            Emits a transfer event with from set to the zero address.
            Requirements:
            to cannot be the zero address.
    }

BURN FUNCTION TO DELETE TOKENS

    // Destroys amount tokens from account, reducing the total supply.
    _burn(address account, uint256 amount) internal {
            Emits a transfer event with to set to the zero address.
            Requirements
            account cannot be the zero address.
            account must have at least amount tokens.
    }
*/


}