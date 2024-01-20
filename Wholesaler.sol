//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import './MedicineW_D.sol';
import './Medicine.sol';

contract Wholesaler {
    
    mapping(address => address[]) public MedicinesAtWholesaler;
    mapping(address => address[]) public MedicineWtoD;
    mapping(address => address) public MedicineWtoDTxContract;

    constructor() {}
    
    function medicineRecievedAtWholesaler(
        address _address
    ) public {

        uint rtype = Medicine(_address).receivedMedicine(msg.sender);
        if(rtype == 1){
            MedicinesAtWholesaler[msg.sender].push(_address);
        }
    }
    
    function transferMedicineWtoD(
        address _address,
        address transporter,
        address receiver
    ) public {
        
        MedicineW_D wd = new MedicineW_D(
            _address,
            msg.sender,
            transporter,
            receiver
        );
        MedicineWtoD[msg.sender].push(address(wd));
        MedicineWtoDTxContract[_address] = address(wd);
    }


    function getBatchIdByIndexWD(uint index) public view returns(address packageID) {
        return MedicineWtoD[msg.sender][index];
    }

    function getSubContractWD(address _address) public view returns (address SubContractWD) {
        return MedicineWtoDTxContract[_address];
    }
    
    function getAllMedicinesAtWholesaler() public view returns(address[] memory) {
        uint len = MedicinesAtWholesaler[msg.sender].length;
        address[] memory ret = new address[](len);
        for (uint i = 0; i < len; i++) {
            ret[i] = MedicinesAtWholesaler[msg.sender][i];
        }
        return ret;
    }
}