#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/forexfactory/common/CommonFunction.mqh>

extern ulong magicGlobal;

void RemoveOrderAction()
{
   if (GetTotalOrder() == 1)
   {
      for (int i = 0; i < OrdersTotal(); i++)
      {
         ulong ticket = OrderGetTicket(i);
         if (OrderGetInteger(ORDER_MAGIC) == magicGlobal)
         {
            RemoveOrder(ticket);
         }
      }
   }
}

void RemoveOrder(ulong ticket)
{
   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   ZeroMemory(result);
   request.action = TRADE_ACTION_REMOVE;
   request.order = ticket;

   if (OrderSend(request, result))
   {
      Print("Remove order success: Ticket: ", ticket);
   }
   else
   {
      Print("Remove order failure: Ticket: ", ticket, " - Comment: ", result.comment);
   }
}