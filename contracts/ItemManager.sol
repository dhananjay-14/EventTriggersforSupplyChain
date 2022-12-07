pragma solidity 0.8.16;
import "./Ownable.sol";
import "./Item.sol";
contract ItemManager is Ownable{ 

    enum SupplyChainSteps{Created, Paid, Delivered}

    struct S_Item {
        Item _item;
        ItemManager.SupplyChainSteps _step;
        string _identifier;
        uint _priceInWei;
    }
    mapping(uint => S_Item) public items;
    uint index;
   
    event SupplyChainStep(uint _itemIndex, uint _step,address _address);
    
    function createItem(string memory _identifier, uint _priceInWei) public onlyOwner {
        Item item = new Item(this,index,_priceInWei);
        items[index]._item = item;
        items[index]._priceInWei = _priceInWei;
        items[index]._step = SupplyChainSteps.Created;
        items[index]._identifier = _identifier;
        emit SupplyChainStep(index, uint(items[index]._step),address(item));
        index++;
    }

    function triggerPayment(uint _index) public payable {
        require (address(items[_index]._item)==msg.sender,"only item is allowed to update itself");
        require(items[_index]._priceInWei == msg.value, "please pay amount exactly equal to item price ");
        require(items[_index]._step == SupplyChainSteps.Created, "Item is further in the supply chain");
        items[_index]._step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_index, uint(items[_index]._step),address(items[index]._item));
    }
    
    function triggerDelivery(uint _index) public onlyOwner {
        require(items[_index]._step == SupplyChainSteps.Paid, "Item either not created or not paid");
        items[_index]._step = SupplyChainSteps.Delivered;
        emit SupplyChainStep(_index, uint(items[_index]._step),address(items[index]._item));
    }
}   