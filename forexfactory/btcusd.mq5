//+------------------------------------------------------------------+
//|                                                           s1.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>

// Input
double volumeInput = 0.01;
ulong deviationInput = 5;
double stopPriceRateInput = 1000 * _Point;
double stopPriceSLRateInput = 1000 * _Point;
double stopPriceTPRateInput = 10000 * _Point;

// Variable

//+------------------------------------------------------------------+

int OnInit() {
   RemoveOrderAction(true);

   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   Print("OnInit: Giá mua: ", bidPrice, " - Giá bán: ", askPrice);
   
   Print("Point: ", _Point, " - Rate stop: ", stopPriceRateInput, " - Rate SL: ", stopPriceSLRateInput, " - Rate TP: ", stopPriceTPRateInput);
   
   //double price = iClose(Symbol(), PERIOD_CURRENT, 0);
   
   NewStopAction(bidPrice, askPrice, ORDER_TYPE_BUY_STOP);
   NewStopAction(bidPrice, askPrice, ORDER_TYPE_SELL_STOP);

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+

void OnDeinit(const int reason) {
   Print("EA đã bị gỡ bỏ, lý do: ", reason);
}

//+------------------------------------------------------------------+

void OnTick() {
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   Print("OnTick: Giá mua: ", bidPrice, " - Giá bán: ", askPrice);
   
   //int total = PositionsTotal();
   //RemoveOrderAction(false);
   //ModifyOrderAction(bidPrice, askPrice);
   
   //ExpertRemove();
}

//+------------------------------------------------------------------+

void ModifyOrderAction(double bidPrice, double askPrice) {
   int total = OrdersTotal();
   for (int i = 0; i < total; i++) {
      ulong ticket = OrderGetTicket(i);
      ENUM_ORDER_TYPE type= (ENUM_ORDER_TYPE) OrderGetInteger(ORDER_TYPE);
   
      ModifyStopAction(ticket, bidPrice, askPrice, type);
   }
}

void RemoveOrderAction(bool isRemoveAll) {
   int total = OrdersTotal();
   if (isRemoveAll) {
      for (int i = 0; i < total; i++) {
         RemoveFirstOrder();
      }
   } else if (total == 1) {
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
   
   if(OrderSend(request, result)) {
      Print("RemoveOrder: ", ticket);
   } else {
      Print("RemoveOrder Error: ", ticket, " - ", result.comment);
   }
}

void ModifyStopAction(ulong ticket, double bidPrice, double askPrice, ENUM_ORDER_TYPE type) {
   double price;
   double sl;
   double tp;
   if (type == ORDER_TYPE_BUY_STOP) {
      price = askPrice + stopPriceRateInput;
      sl = price - stopPriceSLRateInput;
      tp = price + stopPriceTPRateInput;
   } else if (type == ORDER_TYPE_SELL_STOP) {
      price = bidPrice - stopPriceRateInput;
      sl = price + stopPriceSLRateInput;
      tp = price - stopPriceTPRateInput;
   }
   
   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   ZeroMemory(result);
   request.action = TRADE_ACTION_MODIFY;
   request.symbol = _Symbol;
   request.price = price;
   request.sl = sl;
   request.tp = tp;
   request.order = ticket;
   request.deviation = deviationInput;
   
   if (OrderSendAsync(request, result)) {
      Print("ModifyStopAction ", EnumToString(type), ": ", ticket, " - Price: ", price, " - SL: ", sl, " - TP: ", tp, " - Volume: ", volumeInput);
   } else {
      Print("ModifyStopAction ", EnumToString(type), " Error: ", ticket, " - Comment: ", result.comment);
   }
}

void NewStopAction(double bidPrice, double askPrice, ENUM_ORDER_TYPE type) {
   double price;
   double sl;
   double tp;
   if (type == ORDER_TYPE_BUY_STOP) {
      price = askPrice + stopPriceRateInput;
      sl = price - stopPriceSLRateInput;
      tp = price + stopPriceTPRateInput;
   } else if (type == ORDER_TYPE_SELL_STOP) {
      price = bidPrice - stopPriceRateInput;
      sl = price + stopPriceSLRateInput;
      tp = price - stopPriceTPRateInput;
   }
   
   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = volumeInput;
   request.type = type;
   request.price = price;
   request.sl = sl;
   request.tp = tp;
   request.deviation = deviationInput;
   
   if (OrderSend(request, result)) {
      Print("NewStopAction ", EnumToString(type), ": ", result.order, " - Price: ", price, " - SL: ", sl, " - TP: ", tp, " - Volume: ", volumeInput);
   } else {
      Print("NewStopAction ", EnumToString(type), " Error: ", result.comment);
   }
}