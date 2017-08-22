pragma solidity ^0.4.15;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

}

/**
 * @title Token
 * @dev API for working with separately deployed ERC20 token
 */
interface Token {
  function transfer(address _to, uint256 _value) returns (bool);
  function balanceOf(address _owner) constant returns (uint256 balance);
}

/**
 * @title MarketingVault
 * @dev MarketingVault is a token holder contract that will allow
 * the marketing team to retreive tokens after a given time limit
 */
contract FoundersVault {

  using SafeMath for uint256;

  // ERC20 token contract being held (BUZZ Token)
  Token token;

  // beneficiary of tokens after they are released
  address beneficiary;

  // first timestamp when 50% token release is enabled
  uint64 releaseTime1 = 1505138400 + 1 years;
  bool firstHalfReleased = false;

  // second timestamp when remaining token release is enabled
  uint64 releaseTime2 = 1505138400 + 2 years;

  function FoundersVault(address _tokenAddress, address _beneficiary) {
    token = Token(_tokenAddress);
    beneficiary = _beneficiary;
  }

  /**
   * @notice Transfers tokens held by vault to beneficiary.
   */
  function release() {
    require(msg.sender == beneficiary);
    require(now >= releaseTime1 || now >= releaseTime2);

    uint256 amount;

    if (now >= releaseTime2) {
        amount = token.balanceOf(this);
        require(amount > 0);
        token.transfer(beneficiary, amount);
    } else if (now >= releaseTime1) {
        require(firstHalfReleased == false);
        amount = token.balanceOf(this).div(2);
        require(amount > 0);
        firstHalfReleased = true;
        token.transfer(beneficiary, amount);
    }
  }
}
