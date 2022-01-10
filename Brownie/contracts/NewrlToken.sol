// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract NewrlToken {
    uint256 private constant MAX_UINT256 = 2**256 - 1;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public usdBalance;
    mapping(address => mapping(address => uint256)) public allowed;

    uint256 public totSupply;
    string public name;
    uint8 public decimals;
    string public symbol;
    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor() {
        totSupply = 100000000000000;
        owner = msg.sender;
        balances[msg.sender] = totSupply;
        name = "NewrlToken";
        decimals = 2;
        symbol = "NWT";
    }

    function registerAsset(address _from, uint256 _value)
        public
        returns (bool success)
        {
          if (owner != _from)
          {
            require(balances[owner] >= _value, "No funds available");
            balances[owner] -= _value;
            balances[_from] += _value;
            emit Transfer(owner, _from, _value);
            return true;
          }
          return false;
        }
    
    function lenderFound(address _borrower, address _lender, uint256 _value)
        public
        returns (bool success) 
        {
          if (_borrower != _lender && _borrower != owner && _lender != owner)
          {
            require(balances[_borrower] >= _value, "No funds available");
            usdBalance[_borrower] += _value;
            balances[_borrower] -= _value;
            balances[_lender] += _value;
            emit Transfer(_borrower, _lender, _value);
            return true;
          }
          return false;
        }

    function deadlineEnd(address _borrower, address _lender, uint256 _value)
        public
        returns (bool success)
        {
            if (_borrower != _lender && _borrower != owner && _lender != owner)
            {
                require(balances[_lender] >= _value, "No funds available");
                usdBalance[_borrower] -= _value;
                usdBalance[_lender] += _value;
                balances[_lender] -= _value;
                balances[owner] += _value;
                emit Transfer(_lender, owner, _value);
                return true;
            }
            return false;
        }


    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(balances[msg.sender] >= _value, "No funds available");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        uint256 allowanceAllowed = allowed[_from][msg.sender];
        require(
            balances[_from] >= _value && allowanceAllowed >= _value,
            "Funds not allowed"
        );
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowanceAllowed < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value);
        return true;
    }

    function totalSupply() public view returns (uint256 totSupp) {
        return totSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function usdBalanceOf(address _owner) public view returns (uint256 balance) {
        return usdBalance[_owner];
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }
}