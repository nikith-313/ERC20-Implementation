// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import "ERC20PRAC/IERC20.sol";
import "ERC20PRAC/mycontext.sol";
import "ERC20PRAC/errors.sol";
abstract contract ERC20 is IERC20,IERC20Errors,MyContext{
    mapping(address=>uint256) private _balances;
    mapping(address=>mapping(address=>uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    constructor(string memory name_,string memory symbol_){
        _name=name_;
        _symbol=symbol_;
    }
    function name() public view virtual returns(string memory){
        return _name;
    }
    function symbol() public view virtual returns(string memory){
        return _symbol;
    }
    function decimals() public view virtual returns(uint8){
        return 18;
    }
    function totalSupply()public view virtual returns(uint256){
        return _totalSupply;
    }
    function balanceOf(address account) public view virtual returns(uint256){
        return _balances[account];
    }
    function transfer(address to,uint256 value) public virtual returns(bool){
        address owner=_msgSender();
        _transfer(owner,to,value);
        return true;
    }
    function allowance(address owner,address spender) public view virtual returns(uint256){
        return _allowances[owner][spender];
    }
    function approve(address spender,uint256 value)public virtual returns(bool){
        address owner=_msgSender();
        _approve(owner,spender,value);
        return true;
    }
    function transferFrom(address from,address to,uint256 value) public virtual returns(bool){
        address spender=_msgSender();
        _spendAllowance(from,spender,value);
        _transfer(from,to,value);
        return true;
    }
    function _mint(address account,uint256 value)internal{
        if(account==address(0)){
            revert ERC20InvalidReciever(address(0));
        }
        _update(address(0),account,value);
    }
    function _burn(address account,uint256 value)internal{
        if(account==address(0)){
            revert ERC20InvalidSender(address(0));
        }
        _update(account,address(0),value);
    }
    function _spendAllowance(address owner,address spender,uint256 value) internal virtual{
        uint currentAllowance=allowance(owner,spender);
        if(currentAllowance<type(uint256).max){
            if(currentAllowance<value){
                revert ERC20InsufficientAllowance(spender,currentAllowance,value);
            }
            _approve(owner,spender,currentAllowance-value,false);
        }
    }

    function _approve(address owner,address spender,uint256 value) internal{
        _approve(owner,spender,value,true);
    }
    function _approve(address owner,address spender,uint256 value,bool emitEvent) internal virtual{
        if(owner==address(0)){
            revert ERC20InvalidApprover(address(0));
        }
        if(spender==address(0)){
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender]=value;
        if(emitEvent){
            emit Approval(owner, spender, value);
        }
    }
    function _transfer(address from,address to,uint256 value) internal{
        if(from==address(0)){
            revert ERC20InvalidSender(address(0));
        }
        if(to==address(0)){
            revert ERC20InvalidReciever(address(0));
        }
        _update(from,to,value);
    }
    function _update(address from,address to,uint256 value) internal virtual{
        if(from==address(0)){
            _totalSupply+=value;
        }else{
            uint256 fromBalance=_balances[from];
            if(fromBalance<value){
                revert ERC20InsufficientBalance(from,fromBalance,value);
            }
            unchecked{
                _balances[from]-=value;
            }
        }
        if(to==address(0)){
            _totalSupply-=value;
        }else{
            unchecked{
            _balances[to]+=value;
            }
        }
        emit Transfer(from, to, value);
    }


}
