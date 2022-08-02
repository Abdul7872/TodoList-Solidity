// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract TaskContract {
  event AddTask(address recipient,  uint taskId);
  event DeleteTask(uint taskId, bool isDeleted);

  struct Task {
    uint id;
    string taskText;
    bool isDeleted;
  }

  Task[] private tasks;
  mapping(uint256 => address) taskToOwner;

  function addTask(string memory taskText, bool isDeleted) external {
    uint taskId = tasks.length;  
    tasks.push(Task(taskId, taskText, isDeleted));
    taskToOwner[taskId] = msg.sender;
    emit AddTask(msg.sender, taskId);
  }

  function getMyTasks() external view returns(Task[] memory) {
    Task[] memory temp = new Task[](tasks.length);
    uint count = 0;
    for (uint i=0; i<tasks.length; i++){
      if(taskToOwner[i] == msg.sender && tasks[i].isDeleted == false){
        temp[count] = tasks[i];
        count ++;
      }
    }
    Task[] memory result = new Task[](count);
    for (uint i=0; i<count; i++){
      result[i] = temp[i];
    }  
    return result;
  }

  function deleteTask(uint taskId, bool isDeleted) external {
    if(taskToOwner[taskId] == msg.sender){
      tasks[taskId].isDeleted = isDeleted;
      emit DeleteTask(taskId, isDeleted);
    }
  }
  
}
