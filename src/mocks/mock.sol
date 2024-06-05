// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface mock {
    function ffi(string[] calldata) external returns (bytes memory);
}
