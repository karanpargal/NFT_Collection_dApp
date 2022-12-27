// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./IWhitelist.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    
    string _baseTokenURI; // base URI in which token Ids will be appended to generate unique URI
    uint256 public _price = 0.01 ether; // Base price
    bool public _paused; // Pause contract
    uint256 public maxTokenIds = 10; // Total Number of NFTs
    uint256 public tokenIds; // Number of NFTs minted
    IWhitelist whitelist; // Instance of whitelist contract
    bool public presaleStarted; 
    uint256 public presaleEnded; // Timestamp to when end the presale

    modifier onlyWhenNotPaused {
        require(!_paused,"Contract Paused Currently");
        _;
    }

    constructor(string memory baseURI, address whitelistContract) ERC721("CryptoDevs","CD"){
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner{
        presaleStarted = true;
        presaleEnded = block.timestamp + 30 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp<presaleEnded,"Presale is not running");
        require(whitelist.whitelistedAddress(msg.sender),"Sorry, you are not whitelisted");
        require(tokenIds<maxTokenIds,"All NFTs have been minted");
        require(msg.value>=_price,"Ether sent is not correct");
        tokenIds+=1;
        _safeMint(msg.sender,tokenIds);
    }

    function mint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp>=presaleEnded,"Presale has not ended yet");
        require(tokenIds<maxTokenIds,"All NFTs have been minted");
        require(msg.value>=_price,"Ether sent is not correct");
        tokenIds+=1;
        _safeMint(msg.sender,tokenIds);
    }

    function _baseURI() internal view virtual override returns(string memory){
        return _baseTokenURI;
    }

    function setPaused(bool val) public onlyOwner{
        _paused = val;
    }

    function withdraw() public onlyOwner{
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent,) = _owner.call{value: amount}("");
        require(sent,"Failed to send ether");
    }

    receive() external payable{}
    fallback() external payable{}
}