#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Trade\Trade.mqh>

// Input
double volumeInput = 0.1;
double priceInput = 33 * _Point;
double testInput = 31 * _Point;

int OnInit()
{
   // CreateOrder();
   // CloseAllPosition();

   int magic3ArrNew[];
   ArrayResize(magic3ArrNew, 3);
   Print("123:", magic3ArrNew[1]);

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
