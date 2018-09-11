pragma solidity ^0.4.24;


/**
 * @title ERC1155 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 *  from ERC1155 asset contracts.
 */
contract ERC1155Receiver {
  /**
   * @dev Magic value to be returned upon successful reception of an NFT
   *  Equals to `bytes4(keccak256("onERC1155Received(address,uint256,bytes)"))`,
   *  which can be also obtained as `ERC1155Receiver(0).onERC1155Received.selector`
   */
  bytes4 constant ERC1155_RECEIVED = 0xbc04f0af;

  function onERC1155Received(address _from, uint256 amount) public returns(bytes4);
}
