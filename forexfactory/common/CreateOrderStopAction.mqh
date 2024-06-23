#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

extern double volumeInput;
extern double stopPriceRateInput;
extern double stopPriceSLRateInput;
extern double stopPriceTPRateInput;

void CreateOrderStopAction(double bidPrice, double askPrice, ENUM_ORDER_TYPE type) {
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
   } else {
      Print("Error CreateOrderStopAction: Type invalid.");
      return;
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
   //request.deviation = deviation;
   
   Print("CreateOrderStopAction ", EnumToString(type), ": Price: ", price, " - SL: ", sl, " - TP: ", tp, " - Volume: ", volumeInput);
   
   if (!OrderSendAsync(request, result)) {
      Print("CreateOrderStopAction ", EnumToString(type), " Error: ", result.comment);
   }
}