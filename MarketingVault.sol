pragma solidity ^0.4.15;

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
contract MarketingVault {

  // ERC20 token contract being held (BUZZ Token)
  Token token;

  // beneficiary of tokens after they are released
  address beneficiary;

  // timestamp when token release is enabled
  uint64 releaseTime = 1505138400 + 1 years;

  function MarketingVault(address _tokenAddress, address _beneficiary) {
    token = Token(_tokenAddress);
    beneficiary = _beneficiary;
  }

  /**
   * @notice Transfers tokens held by vault to beneficiary.
   */
  function release() {
    require(msg.sender == beneficiary);
    require(now >= releaseTime);

    uint256 amount = token.balanceOf(this);
    require(amount > 0);

    token.transfer(beneficiary, amount);
  }
}
