// const Map<String, dynamic> initialChatRequest = {
//   "message":
//       "I am a wholesaler. Recommend me products for car clutch along me with their details, cost and delivery time",
//   "agents_info": [
//     {
//       "name": "RecommendationAgent",
//       "type": "AssistantAgent",
//       "llm": {"model": "gpt-4o-mini"},
//       "system_message":
//           "You are a Recommendation AI Agent for the virtual customer service of the software application in the manufacturing industry which is capable of giving business oriented answers like cost, description, delivery etc..  Train yourself with the data provided. Return the data in json format with the products list and response as an parameter. Please strictly it shouldn't consist as a string but only json as a format. Only strictly 2 parameters response and data",
//       "description": "You are a Product recommendation AI agent."
//     }
//   ],
//   "task_info": {
//     "id": 0,
//     "name": "Recommendation AI Assistant",
//     "description":
//         "This task is to recommend products to the customer based on the customer's query",
//     "maxMessages": 5,
//     "speakSelMode": "auto"
//   }
// };

const Map<String, dynamic> initialChatRequest = {
  "message":
      "I am a wholesaler. Recommend me products for car clutch along me with their details, cost and delivery time",
  "agents_info": [
    {
      "name": "RecommendationAgent",
      "type": "AssistantAgent",
      "llm": {"model": "gpt-4o-mini"},
      "system_message":
          "You are a Recommendation AI Agent for the virtual customer service of the software application in the manufacturing industry which is capable of giving business oriented answers like cost, description, delivery etc..  Train yourself with the data provided.",
      "description": "You are a Product recommendation AI agent."
    }
  ],
  "task_info": {
    "id": 0,
    "name": "Recommendation AI Assistant",
    "description":
        "This task is to recommend products to the customer based on the customer's query",
    "maxMessages": 5,
    "speakSelMode": "auto"
  }
};
