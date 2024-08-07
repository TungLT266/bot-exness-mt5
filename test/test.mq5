#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/StructCommon.mqh>

// Input
double volumeInput = 0.1;
double priceInput = 33 * _Point;
double testInput = 31 * _Point;

int OnInit()
{
   // CreateOrder();
   // CloseAllPosition();

   MagicDetailObject arr[2];

   MagicDetailObject arr1 = GetDefaultMagicDetailObject();
   arr1.magic3 = 4;
   MagicDetailObject arr2 = GetDefaultMagicDetailObject();

   arr[0] = arr1;
   arr[1] = arr2;
   ArrayPrint(arr);

   return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   Print("EA đã bị gỡ bỏ, lý do: ", reason);
}

void OnTick()
{
}

void CloseAllPosition()
{
   int totalPosition = PositionsTotal();
   for (int i = totalPosition - 1; i >= 0; i--)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == 111)
      {
         ulong id = PositionGetInteger(POSITION_TICKET);
         ClosePosition(positionTicket, id);
      }
   }
}

void ClosePosition(ulong ticket, ulong id)
{
   CTrade trade;
   if (trade.PositionClose(ticket))
   {
      Print("Close position success: Type: ", ticket);
   }
   else
   {
      Print("Close position failure: Type: ", ticket);
   }
}

void CreateOrder()
{
   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   ZeroMemory(request);
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = 0.01;
   request.type = ORDER_TYPE_BUY;
   request.magic = 111;

   if (OrderSend(request, result))
   {
      Print("Create Order Success");
   }
   else
   {
      Print("Create Order Error: ", result.comment);
   }
}
