/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author: -
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint256) public credit;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint256 amount) {
        if (credit[msg.sender] >= amount) {
            // <yes> <report> REENTRANCY
            bool res = msg.sender.call.value(amount)();
            credit[msg.sender] -= amount;
        }
    }

    function queryCredit(address to) returns (uint256) {
        return credit[to];
    }
}
