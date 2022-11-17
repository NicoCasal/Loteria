// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Loteria is ERC20, Ownable {

    //========================================
    //===========Token Managment==============
    //========================================

    //contract address NFT proyect
    address public nft;

    //constructor
    constructor () ERC20("Loteria", "JA"){
        _mint(address(this), 1000);
        nft = address (new mainERC721());

    }

    //lottery winner
    address public ganador;

    //registration
    mapping(address => address) public user_contract;

    //Token Priece
    function precioTokens(uint256 _numTokens) internal pure returns(uint256){
        return _numTokens * (1 ether);

    }

    // user token balance view
    function balanceTokens(address _account) public view returns(uint256){
        return balanceOf(_account);

    }

     //smart contract token balance view
    function balanceTokensSC() public view returns(uint256){
        return balanceOf(address(this));

    }

    //smart contract ethers balance view
    function blanceEthersSC() public view returns (uint256){
        return address(this).balance / 10**18;
        
    }

    //ERC20 Token generator (only owner)
    function mint(uint256 _amount)public onlyOwner {
        _mint(address(this), _amount);
    }

    //user reggit
    function registrar()internal {
        address addr_personal_contract = address(new boletosNFT(msg.sender, address(this), nft));
        usuario_contract[msg.sender] = addr_personal_contract;
    }

    //user info
    function usersInfo(address _account) public view returns (address){
        return usurio_contact[_account];
    }


    //tokens buy ERC20
    function compraTokens (uint256 _numTokens) public payable{
        //user reggit
        if(usuario_contract[msg.sender] == address(0)){
            registrar();
        }
        //establecer el precio de los token a comprar
        uint256 coste = precioTokens(_numTokens);
        require (msg.value >= coste, "compra menos tokens o paga mas ETH");
        //obtencion del numero de tokens disponible
        uint256 balance = balanceTokenSC();
        require (_numTokens <= balance, "compra menos tokens");
        //devolucion del dinero sobrante
        uint256 returnValue = msg.value - coste;
        //el smart contrar devuelve la cantidad restante
        payable(msg.sender).transfer(returnValue);
        //envio de los tokens al usurio
        _transfer(address(this), msg.sender, _numTokens);
        
    } 




















}











//NFTs smart contract
contract mainERC721 is ERC721{
    address public direccionLoteria;
    constructor() ERC721 ("Loteria", "STE"){}
        direccionLoteria = msg.sender;
    //nft creation
    function safeMint(address _propietario, uint256 _boleto) public  {
        require(msg.sender == Loteria(direccionLoteria).usersInfo(_propietario),
        "no tienes permisos para ejecutar esta funcion" );
        _safeMint(_propietario, _boleto);
    }
}



contract boletosNFT {
    //data structure
    struct Owner{
        address propietario;
        address contratoPadre;
        address contratoNFT;
        address contratoUsuario;
    }

    //Owner data structure
    Owner public propietario;

    //constructor (son)
  constructor(address _propietario, address _contratoPadre, address _contratoNFT){
    propietario = Owner(
                        _propietario,
                        _contratoPadre,
                        _contratoNFT, 
                        address(this)
                        );
    }


    //conversion de los numeros de los boletos de loteria

    function mintBoletos(address _propietario, uint _boleto) public {
        require(msg.sender == propietario.contratoPadre,
                             "you dont have permission");   
        mainERC721(propietario.contratoNFT).safeMint(_propietario, _boleto);
    }

}