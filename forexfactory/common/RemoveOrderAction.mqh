#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

void RemoveOrderAction() {
   int total = OrdersTotal();
   if (total == 1) {
      RemoveFirstOrder();
   }
}

void RemoveFirstOrder() {
   ulong ticket = OrderGetTicket(0);
   
   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   ZeroMemory(result);
   request.action=TRADE_ACTION_REMOVE;
   request.order = ticket;
   
   Print("RemoveFirstOrder: ", ticket);
   
   if (!OrderSend(request, result)) {
      Print("RemoveFirstOrder Error: ", ticket, " - ", result.comment);
   }
}