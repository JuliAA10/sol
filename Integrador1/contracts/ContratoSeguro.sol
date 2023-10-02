// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ContratoSeguro is Ownable, ReentrancyGuard{
    using Counters for Counters.Counter;
    Counters.Counter private ContadorContratoSeguro;

    string public compania;

    struct SeguroAuto{
        address asegurado;
        uint256 prima; // Prima del seguro
        uint256 MontoCobertura;
        uint256 InicioFecha;
        uint256 FinFecha;
        bool Activo;
        bool Reclamado;
    }

    mapping(uint256 => SeguroAuto) public seguroauto;

    event CreacionContrato(
        uint256 indexed IdContrato,
        address asegurado,
        uint256 prima,
        uint256 MontoCobertura,
        uint256 InicioFecha,
        uint256 FinFecha
    );

    event ReclamoContrato(uint256 indexed IdContrato);

     constructor(string memory _compania) {
        compania = _compania;
    }

    function crearContrato(
        address _asegurado,
        uint256 _prima,
        uint256 _MontoCobertura,
        uint256 _Duracion
    ) external onlyOwner nonReentrant {
        uint256 IdContrato = ContadorContratoSeguro.current();
        uint256 InicioFecha = block.timestamp;
        uint256 FinFecha = InicioFecha + (_Duracion * 1 days);

        seguroauto[IdContrato] = SeguroAuto(
            _asegurado,
            _prima,
            _MontoCobertura,
            InicioFecha,
            FinFecha,
            true,
            false
        );
        ContadorContratoSeguro.increment();

        emit CreacionContrato(IdContrato, _asegurado, _prima, _MontoCobertura, InicioFecha, FinFecha);
    }

    function PresentarReclamo(uint256 _IdContrato) external nonReentrant{
        SeguroAuto storage contractInfo = seguroauto[_IdContrato];
        require(contractInfo.Activo, "El contrato de seguro no esta activo");
        require(msg.sender == contractInfo.asegurado, "Solo el asegurado puede presentar un reclamo");
        require(!contractInfo.Reclamado, "El reclamo ya se ha realizado");

        // Realizar el pago al asegurado
        payable(msg.sender).transfer(contractInfo.MontoCobertura);

        // Marcar el contrato como reclamado
        contractInfo.Reclamado = true;
    }


}
