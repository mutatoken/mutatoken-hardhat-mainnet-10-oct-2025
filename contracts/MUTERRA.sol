// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MUTERRA is Initializable, ERC20Upgradeable, OwnableUpgradeable, PausableUpgradeable, UUPSUpgradeable {
    uint256 public constant MAX_SUPPLY = 42_000_000 * 10 ** 18;
    uint256 public constant QUARTERLY_RELEASE = 1_000_000 * 10 ** 18;
    uint256 public constant BURN_FEE_BP = 10; // 0.1%

    address public treasury;
    uint256 public deployedAt;
    uint256 public totalReleased;

    mapping(address => bool) public burnExempt;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public blacklist;

    event TokensClaimed(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);
    event TreasuryUpdated(address previousTreasury, address newTreasury);
    event EmergencyWithdrawal(address indexed to, uint256 amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _owner, address _treasury) public initializer {
        __ERC20_init("MUTERRA", "MUTA");
        __Ownable_init();
        __Pausable_init();
        __UUPSUpgradeable_init();

        _transferOwnership(_owner);
        deployedAt = block.timestamp;
        treasury = _treasury;

        burnExempt[_treasury] = true;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        _mint(to, amount);
    }

    function batchMint(address[] calldata recipients, uint256[] calldata amounts) external onlyOwner {
        require(recipients.length == amounts.length, "Length mismatch");
        for (uint256 i = 0; i < recipients.length; i++) {
            require(totalSupply() + amounts[i] <= MAX_SUPPLY, "Exceeds max supply");
            _mint(recipients[i], amounts[i]);
        }
    }

    function burn(uint256 amount) external {
        _burn(_msgSender(), amount);
        emit Burn(_msgSender(), amount);
    }

    function releaseToTreasury() external onlyOwner {
        uint256 quartersPassed = ((block.timestamp - deployedAt) / 90 days) + 1;
        uint256 maxRelease = quartersPassed * QUARTERLY_RELEASE;

        require(totalReleased < maxRelease, "Nothing to release");

        uint256 unreleased = maxRelease - totalReleased;
        uint256 amount = unreleased > QUARTERLY_RELEASE ? QUARTERLY_RELEASE : unreleased;

        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");

        totalReleased += amount;
        _mint(treasury, amount);

        emit TokensClaimed(treasury, amount);
    }

    function setBurnExempt(address account, bool exempt) external onlyOwner {
        burnExempt[account] = exempt;
    }

    function updateTreasury(address newTreasury) external onlyOwner {
        require(newTreasury != address(0), "Invalid address");
        address previous = treasury;
        treasury = newTreasury;
        emit TreasuryUpdated(previous, newTreasury);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function emergencyWithdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);
        emit EmergencyWithdrawal(owner(), balance);
    }

    function setWhitelist(address account, bool status) external onlyOwner {
        whitelist[account] = status;
    }

    function setBlacklist(address account, bool status) external onlyOwner {
        blacklist[account] = status;
    }

    function _transfer(address from, address to, uint256 amount) internal override whenNotPaused {
        require(!blacklist[from] && !blacklist[to], "Blacklisted");

        if (burnExempt[from] || burnExempt[to]) {
            super._transfer(from, to, amount);
        } else {
            uint256 burnAmount = (amount * BURN_FEE_BP) / 10_000;
            uint256 sendAmount = amount - burnAmount;

            super._burn(from, burnAmount);
            super._transfer(from, to, sendAmount);

            emit Burn(from, burnAmount);
        }
    }

    receive() external payable {}
}