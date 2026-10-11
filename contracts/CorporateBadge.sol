// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CorporateBadge is ERC721, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // OpenZeppelin v5 removed Counters.sol, using raw uint256 counter
    uint256 private _tokenIds;

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => string) public tokenNIK;

    constructor() ERC721("Corporate Badge Piagam", "BADGE") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mintBadge(
        address recipient,
        string memory _tokenURI,
        string memory nik
    ) public onlyRole(MINTER_ROLE) returns (uint256) {
        _tokenIds++;
        uint256 newItemId = _tokenIds;

        _safeMint(recipient, newItemId);
        _tokenURIs[newItemId] = _tokenURI;
        tokenNIK[newItemId] = nik;

        return newItemId;
    }

    function batchMintBadges(
        address[] calldata recipients,
        string[] calldata tokenURIs,
        string[] calldata niks
    ) external onlyRole(MINTER_ROLE) {
        require(
            recipients.length == tokenURIs.length && recipients.length == niks.length,
            "Array lengths mismatch"
        );

        for (uint256 i = 0; i < recipients.length; i++) {
            mintBadge(recipients[i], tokenURIs[i], niks[i]);
        }
    }

    function getTokensByOwner(address owner) external view returns (uint256[] memory) {
        uint256 balance = balanceOf(owner);
        uint256[] memory tokens = new uint256[](balance);
        if (balance == 0) {
            return tokens;
        }

        uint256 count = 0;
        for (uint256 i = 1; i <= _tokenIds; i++) {
            if (_ownerOf(i) == owner) {
                tokens[count] = i;
                count++;
                if (count == balance) {
                    break;
                }
            }
        }
        return tokens;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "ERC721: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    function grantMinter(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(MINTER_ROLE, account);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
