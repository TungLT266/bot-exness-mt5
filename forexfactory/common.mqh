//+------------------------------------------------------------------+
//|                                                       common.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
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

void CreateOrderStopAction(double bidPrice, double askPrice, ENUM_ORDER_TYPE type, double volume, ulong deviation,
                           double stopPriceRate, double stopPriceSLRate, double stopPriceTPRate) {
   double price;
   double sl;
   double tp;
   if (type == ORDER_TYPE_BUY_STOP) {
      price = askPrice + stopPriceRate;
      sl = price - stopPriceSLRate;
      tp = price + stopPriceTPRate;
   } else if (type == ORDER_TYPE_SELL_STOP) {
      price = bidPrice - stopPriceRate;
      sl = price + stopPriceSLRate;
      tp = price - stopPriceTPRate;
   }
   
   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = volume;
   request.type = type;
   request.price = price;
   request.sl = sl;
   request.tp = tp;
   //request.deviation = deviation;
   
   Print("CreateOrderStopAction ", EnumToString(type), ": Price: ", price, " - SL: ", sl, " - TP: ", tp, " - Volume: ", volume, " - Deviation: ", deviation);
   
   if (!OrderSendAsync(request, result)) {
      Print("CreateOrderStopAction ", EnumToString(type), " Error: ", result.comment);
   }
}