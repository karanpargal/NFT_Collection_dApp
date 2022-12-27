// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface IWhitelist {
    function whitelistedAddress(address) external view returns(bool);
}