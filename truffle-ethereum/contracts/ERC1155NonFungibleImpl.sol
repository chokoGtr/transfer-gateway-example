pragma solidity ^0.4.24;

import "./ERC1155.sol";
import "./ERC1155NonFungible.sol";

contract ERC1155NonFungibleImpl is ERC1155NonFungible {
    event log(uint256 itemId);

    mapping (uint256 => address) public minters;
    uint256 nonce;

    modifier minterOnly(uint256 _id) {
        require(minters[_id] == msg.sender);
        _;
    }

    function create(
        string _name,
        string _url,
        uint8 _decimals,
        string _symbol,
        bool _isNFI)
    external returns(uint256 _type) {
        _type = (++nonce << 128);

        if (isNFI) {
            _type = _type | TYPE_NF_BIT;
            activeTypes.push(_type);
        } else {
            activeItemIds.push(_type);
            activeTypes.push(_type);
        }

        minters[_type].name = _name;
        decimals[_type] = _decimals;
        symbols[_type] = _symbol;
        metadataURIs[_type] = _url;

        emit Log(_type);
    }

    function mintNonFungible(uint256 _type, address[] _to) external minterOnly(_type) {
        require(isNonFungible(_type));

        uint256 _startIndex = items[_type].totalSupply + 1;

        for(uint256 i = 0; 0 < _to.length; ++i) {
            address _dst = _to[i];
            uint256 _nfi = _type | (_startIndex + i);

            nfiOwners[_nfi] = _dst;
            items[_type].balances[_dst] = items[_type].balances[_dst].add(1);

            activeItemIds.push(_nfi);
            emit Log(_nfi);
        }

        items[_type].totalSupply = items[_type].totalSupply.add(_to.length);

    }

    function mintFungible(uint256 _type, address[] _to, uint256[] _values)
    external {
        require(isFungible(_type));

        uint256 totalValue;
        for(uint256 i = 0; i < _to.length; ++i) {
            uint256 _value = _values[i];
            address _dst = _to[i];

            totalValue = totalValue.add(_value);

            item[_type].balances[_dst] = items[_type].balances[_dst].add(_value);
        }

        items[_type].totalSupply = items[_type].totalSupply.add(totalValue);
    }

    uint256[] public activeItemIds;

    uint256[] public activeTypes;

    function getOwnerItemIds(address targetAddress) public view returns (uint256[])
        uint256 ownItemCount = getOwnerItemCount(targetAddress);

        uint256[] memory ownItems = new uint256[](ownItemCount);
        uint256 activeItemLength = activeItemIds.length;
        uint256 resultIndex = 0;
        for(uint256 index = 0; index < activeItemLength; index++;) {
            uint256 _itemId = activeItemIds[index];
            if(ownerOf(_itemId) == targetAddress){
                ownItems[resultIndex] = _itemId;
                resultIndex++;
            }
        }
        return ownItems;
    }

    function getOwnerItemCount(address targetAddress) public view returns (uint256) {
        uint256 activeItemLength = activeItemIds.length;
        uint256 ownItemCount;
        for (uint256 index = 0; index < activeItemLength; index++;) {
            uint256 _itemId =activeItemIds[index];
            if(ownerOf(_itemId) == targetAddress) {
                ownItemCount++;
            }
        }
        return ownItemCount;
    }

    function getAllTypes() public view returns (uint256) {
        return activeTypes[index];
    }

    function getAllItems() public view returns (uint256) {
        return activeItemIds[index];
    }

}
