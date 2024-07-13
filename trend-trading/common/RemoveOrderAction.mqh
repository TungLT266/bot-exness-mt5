#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/CommonFunction.mqh>

extern int totalOrderInput;
extern double gridAmountInput;
extern ulong magicNumberInput;
extern int limitPositionInput;

extern int gridNoCurrentGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

void RemoveOrderAction()
{
   int gridNoStart = GetGridNoStart();
   int gridNoEnd = GetGridNoEnd();

   for (int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong orderTicket = OrderGetTicket(i);
      ulong magic = OrderGetInteger(ORDER_MAGIC);
      if (magic == magicNumberInput)
      {
         ENUM_ORDER_TYPE orderType = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
         string comment = OrderGetString(ORDER_COMMENT);
         int gridNo = (int)StringToInteger(comment);
         if (gridNo < (gridNoStart) || gridNo > gridNoEnd)
         {
            RemoveOrderByTicket(orderTicket);
         }
         else if (GetTypeOrderStrByType(orderType) != GetTypeOrderByGridNo(gridNo))
         {
            RemoveOrderByTicket(orderTicket);
         }
      }
   }
}

void RemoveOrderByTicket(ulong ticket)
{
   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   ZeroMemory(result);
   request.action = TRADE_ACTION_REMOVE;
   request.order = ticket;

   if (OrderSend(request, result))
   {
      Print("Remove Order Success: Ticket: ", ticket);
   }
   else
   {
      Print("Remove Order Error: Ticket: ", ticket, " - Comment: ", result.comment);
   }
}