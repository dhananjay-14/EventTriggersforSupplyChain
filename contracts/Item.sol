pragma solidity 0.8.16;
import "./ItemManager.sol";
contract Item{
    uint index;
    uint priceInWei;
    uint paidWei;

    ItemManager parentContract;
    constructor(ItemManager _parentContract,uint _index,uint _priceInWei){
        parentContract = _parentContract;
        priceInWei = _priceInWei;
        index = _index;
    }
    receive () external payable{
        require(msg.value==priceInWei,"only full payment accepted");
        require(paidWei==0,"item is already paid");
        paidWei+=msg.value;
        (bool success,)=address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)",index));
        require(success,"transaction failed,cancelling...");
    }
    fallback() external{}
}