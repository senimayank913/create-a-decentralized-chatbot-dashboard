pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/ethereum/wiki/wiki/Standard-License-Header";

contract DecentChatbotDashboard is Ownable {
  // Mapping of chatbot owners to their respective chatbots
  mapping (address => mapping (string => Chatbot)) public chatbots;
  
  // Event emitted when a new chatbot is created
  event NewChatbot(address indexed owner, string chatbotId, string name);
  
  // Event emitted when a chatbot is updated
  event UpdateChatbot(address indexed owner, string chatbotId, string name);
  
  // Event emitted when a message is sent to a chatbot
  event SendMessage(address indexed owner, string chatbotId, string message);
  
  // Struct to represent a chatbot
  struct Chatbot {
    string name;
    string description;
    string[] messages;
  }
  
  // Function to create a new chatbot
  function createChatbot(string memory _chatbotId, string memory _name, string memory _description) public {
    require(msg.sender != address(0), "Invalid owner");
    require(!_exists(_chatbotId), "Chatbot already exists");
    chatbots[msg.sender][_chatbotId] = Chatbot(_name, _description, new string[](0));
    emit NewChatbot(msg.sender, _chatbotId, _name);
  }
  
  // Function to update a chatbot
  function updateChatbot(string memory _chatbotId, string memory _name, string memory _description) public {
    require(msg.sender != address(0), "Invalid owner");
    require(_exists(_chatbotId), "Chatbot does not exist");
    chatbots[msg.sender][_chatbotId].name = _name;
    chatbots[msg.sender][_chatbotId].description = _description;
    emit UpdateChatbot(msg.sender, _chatbotId, _name);
  }
  
  // Function to send a message to a chatbot
  function sendMessage(string memory _chatbotId, string memory _message) public {
    require(msg.sender != address(0), "Invalid owner");
    require(_exists(_chatbotId), "Chatbot does not exist");
    chatbots[msg.sender][_chatbotId].messages.push(_message);
    emit SendMessage(msg.sender, _chatbotId, _message);
  }
  
  // Function to get all chatbots for an owner
  function getChatbots() public view returns (string[] memory) {
    string[] memory chatbotIds = new string[](0);
    for (string chatbotId in chatbots[msg.sender]) {
      chatbotIds.push(chatbotId);
    }
    return chatbotIds;
  }
  
  // Function to get a chatbot by ID
  function getChatbot(string memory _chatbotId) public view returns (string memory, string memory, string[] memory) {
    require(_exists(_chatbotId), "Chatbot does not exist");
    return (chatbots[msg.sender][_chatbotId].name, chatbots[msg.sender][_chatbotId].description, chatbots[msg.sender][_chatbotId].messages);
  }
  
  // Function to check if a chatbot exists
  function _exists(string memory _chatbotId) internal view returns (bool) {
    return chatbots[msg.sender][_chatbotId].name != "";
  }
}