#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>

extern MagicDetailObject magicDetailArrGlobal[];

void RemoveOrderAction()
{
   for (int i = 0; i < ArraySize(magicDetailArrGlobal); i++)
   {
      MagicDetailObject magicDetail = magicDetailArrGlobal[i];
      if (GetTotalPositionByMagicNo(magicDetail.magicNo) == 0)
      {
         RemoveOrderByMagicNo(magicDetail.magicNo);
      }
   }
}

void RemoveOrderAll()
{
   int total = OrdersTotal();
   for (int i = total - 1; i >= 0; i--)
   {
      ulong orderTicket = OrderGetTicket(i);
      ulong magic = OrderGetInteger(ORDER_MAGIC);
      if (IsCorrectMagic(magic))
      {
         RemoveOrderByTicket(orderTicket);
      }
   }
}

void RemoveOrderByMagicNo(ulong magicNo)
{
   int total = OrdersTotal();
   for (int i = total - 1; i >= 0; i--)
   {
      ulong orderTicket = OrderGetTicket(i);
      if (OrderGetInteger(ORDER_MAGIC) == magicNo)
      {
         RemoveOrderByTicket(orderTicket);
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