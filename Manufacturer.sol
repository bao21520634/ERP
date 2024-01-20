//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import './RawMaterial.sol';
import './Medicine.sol';

contract Manufacturer {
    
    mapping (address => address[]) public manufacturerRawMaterials;
    mapping (address => address[]) public manufacturerMedicines;

    constructor() {}
    
    function manufacturerReceivedPackage(
        address _addr,
        address _manufacturerAddress
        ) public {
            
        RawMaterial(_addr).receivedPackage(_manufacturerAddress);
        manufacturerRawMaterials[_manufacturerAddress].push(_addr);
    }
    
    
    function manufacturerCreatesMedicine(
        address _manufacturerAddr,
        bytes32 _description,
        address[] memory _rawAddr,
        uint _quantity,
        address[] memory _transporterAddr,
        address _recieverAddr,
        uint RcvrType
        ) public {
            
        Medicine _medicine = new Medicine(
            _manufacturerAddr,
            _description,
            _rawAddr,
            _quantity,
            _transporterAddr,
            _recieverAddr,
            RcvrType
        );
        
        manufacturerMedicines[_manufacturerAddr].push(address(_medicine));
        
    }
    
    function getAllRawMaterials() public view returns(address[] memory) {
        uint len = manufacturerRawMaterials[msg.sender].length;
        address[] memory ret = new address[](len);
        for (uint i = 0; i < len; i++) {
            ret[i] = manufacturerRawMaterials[msg.sender][i];
        }
        return ret;
    }

    function getAllCreatedMedicines() public view returns(address[] memory) {
        uint len = manufacturerMedicines[msg.sender].length;
        address[] memory ret = new address[](len);
        for (uint i = 0; i < len; i++) {
            ret[i] = manufacturerMedicines[msg.sender][i];
        }
        return ret;
    }
}