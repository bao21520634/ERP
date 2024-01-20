//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MedicineW_D.sol";
import "./Medicine.sol";
import "./MedicineD_C.sol";

contract Distributor {
    mapping(address => address[]) public MedicinesAtDistributor;
    mapping(address => address[]) public MedicineDtoC;
    mapping(address => address) public MedicineDtoCTxContract;

    function medicineRecievedAtDistributor(address _address, address cid)
        public
    {
        uint256 rtype = Medicine(_address).receivedMedicine(msg.sender);
        if (rtype == 2) {
            MedicinesAtDistributor[msg.sender].push(_address);
            if (Medicine(_address).getWDC()[0] != address(0)) {
                MedicineW_D(cid).receiveWD(_address, msg.sender);
            }
        }
    }

    function transferMedicineDtoC(
        address _address,
        address transporter,
        address receiver
    ) public {
        MedicineD_C dp = new MedicineD_C(
            _address,
            msg.sender,
            transporter,
            receiver
        );
        MedicineDtoC[msg.sender].push(address(dp));
        MedicineDtoCTxContract[_address] = address(dp);
    }

    function getBatchesCountDC() public view returns (uint256 count) {
        return MedicineDtoC[msg.sender].length;
    }

    function getBatchIdByIndexDC(uint256 index)
        public
        view
        returns (address packageID)
    {
        return MedicineDtoC[msg.sender][index];
    }

    function getSubContractDC(address _address)
        public
        view
        returns (address SubContractDP)
    {
        return MedicineDtoCTxContract[_address];
    }

    function getAllMedicinesAtDistributor()
        public
        view
        returns (address[] memory)
    {
        uint256 len = MedicinesAtDistributor[msg.sender].length;
        address[] memory ret = new address[](len);
        for (uint256 i = 0; i < len; i++) {
            ret[i] = MedicinesAtDistributor[msg.sender][i];
        }
        return ret;
    }
}
