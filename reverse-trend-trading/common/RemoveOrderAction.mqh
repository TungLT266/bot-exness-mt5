#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/reverse-trend-trading/common/CommonFunction.mqh>

extern ulong magicNumberInput;

extern int differenceBuyAndSellGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

void RemoveOrderAction()
{
   for (int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong orderTicket = OrderGetTicket(i);
      ulong magic = OrderGetInteger(ORDER_MAGIC);
      if (magic == magicNumberInput)
      {
         string typeStr = GetTypeOrderStrByType((ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE));
         int gridNo = (int)StringToInteger(OrderGetString(ORDER_COMMENT));
         if (IsOrderTicketInvalid(gridNo, typeStr))
         {
            RemoveOrderByTicket(orderTicket);
         }
      }
   }
}

bool IsOrderTicketInvalid(int gridNo, string typeStr)
{
   if (differenceBuyAndSellGlobal > 0)
   {
      if (gridNo == GetGridNoSellUp() && typeStr == SELL_TYPE_CONSTANT)
      {
         return false;
      }
      if (gridNo == GetGridNoSellDown() && typeStr == SELL_TYPE_CONSTANT)
      {
         return false;
      }
   }
   else if (differenceBuyAndSellGlobal < 0)
   {
      if (gridNo == GetGridNoBuyUp() && typeStr == BUY_TYPE_CONSTANT)
      {
         return false;
      }
      if (gridNo == GetGridNoBuyDown() && typeStr == BUY_TYPE_CONSTANT)
      {
         return false;
      }
   }
   else
   {
      if (gridNo == GetGridNoSellUp() && typeStr == SELL_TYPE_CONSTANT)
      {
         return false;
      }
      if (gridNo == GetGridNoSellDown() && typeStr == SELL_TYPE_CONSTANT)
      {
         return false;
      }
      if (gridNo == GetGridNoBuyUp() && typeStr == BUY_TYPE_CONSTANT)
      {
         return false;
      }
      if (gridNo == GetGridNoBuyDown() && typeStr == BUY_TYPE_CONSTANT)
      {
         return false;
      }
   }
   return true;
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