#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

ulong ticket;
ENUM_ORDER_TYPE type;
double priceOld;

void ModifyOrderStopAction(double bidPrice, double askPrice, ulong deviation, double stopPriceRate, double stopPriceSLRate, double stopPriceTPRate, double limitModifyPrice) {
   int total = OrdersTotal();
   for (int i = 0; i < total; i++) {
      ticket = OrderGetTicket(i);
      type = (ENUM_ORDER_TYPE) OrderGetInteger(ORDER_TYPE);
      priceOld = OrderGetDouble(ORDER_PRICE_OPEN);
      
      Print("ModifyOrderStopAction ", EnumToString(type), ": ", ticket, " - Price old: ", priceOld);
   
      ModifyStopAction(bidPrice, askPrice, deviation, stopPriceRate, stopPriceSLRate, stopPriceTPRate, limitModifyPrice);
   }
}

double getNewPrice(double priceNew, double limitModifyPrice) {
   if (priceNew > priceOld) {
      double priceChange = priceNew - priceOld;
      if (priceChange > limitModifyPrice) {
         return priceOld + limitModifyPrice;
      }
   } else {
      double priceChange = priceOld - priceNew;
      if (priceChange > limitModifyPrice) {
         return priceOld - limitModifyPrice;
      }
   }
   return priceNew;
}

void ModifyStopAction(double bidPrice, double askPrice, ulong deviation,
                     double stopPriceRate, double stopPriceSLRate, double stopPriceTPRate, double limitModifyPrice) {

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
   
   if (price == priceOld) {
      return;
   }
   
   price = NormalizeDouble(getNewPrice(price, limitModifyPrice), 5);
   
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
   //request.deviation = deviation;
   
   Print("ModifyStopAction ", EnumToString(type), ": ", ticket, " - Price: ", price, " - SL: ", sl, " - TP: ", tp, " - Deviation: ", deviation);
   
   if (!OrderSendAsync(request, result)) {
      Print("ModifyStopAction ", EnumToString(type), " Error: ", ticket, " - Comment: ", result.comment);
   }
}
