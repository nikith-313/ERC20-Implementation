// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
abstract contract MyContext{
    function _msgSender() internal view virtual returns(address){
        return msg.sender;
    }
    function _msgData() internal view virtual returns(bytes calldata){
        return msg.data;
    }
    function _contextSuffixLength() internal view virtual returns(uint256){
        return 0;
    }
}
