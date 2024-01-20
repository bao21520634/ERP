//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import './MedicineD_C.sol';

contract Customer {
    
    mapping(address => address[]) public MedicineBatchAtCustomer;
    mapping(address => salestatus) public sale;

    enum salestatus {
        notfound,
        atcustomer,
        sold,
        expired,
        damaged
    }

    event MedicineStatus(
        address _address,
        address indexed Customer,
        uint status
    );

    function medicineRecievedAtCustomer(
        address _address,
        address cid
    ) public {
        MedicineD_C(cid).receiveDC(_address, msg.sender);
        MedicineBatchAtCustomer[msg.sender].push(_address);
        sale[_address] = salestatus(1);
    }

    function updateSaleStatus(
        address _address,
        uint Status
    ) public {
        sale[_address] = salestatus(Status);
        emit MedicineStatus(_address, msg.sender, Status);
    }

    function salesInfo(
        address _address
    ) public
    view
    returns(
        uint Status
    ){
        return uint(sale[_address]);
    }
    
    function getBatchesCountC() public view returns(uint count) {
        return  MedicineBatchAtCustomer[msg.sender].length;
    }

    function getBatchIdByIndexC(uint index) public view returns(address _address) {
        return MedicineBatchAtCustomer[msg.sender][index];
    }
}