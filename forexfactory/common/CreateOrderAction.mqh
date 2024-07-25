#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern double volumeInput;
extern ulong deviationInput;
extern double orderAmountInput;
extern double slAmountInput;
extern double tpAmountInput;

extern ulong magicGlobal;

void CreateOrderAction()
{
   CreateOrder(ORDER_TYPE_BUY_STOP);
   CreateOrder(ORDER_TYPE_SELL_STOP);
}

void CreateOrder(ENUM_ORDER_TYPE type)
{
   double tp;
   double sl;
   double price;
   if (type == ORDER_TYPE_BUY_STOP)
   {
      price = SymbolInfoDouble(_Symbol, SYMBOL_ASK) + orderAmountInput;
      sl = price - slAmountInput;
      tp = price + tpAmountInput;
   }
   else
   {
      price = SymbolInfoDouble(_Symbol, SYMBOL_BID) - orderAmountInput;
      sl = price + slAmountInput;
      tp = price - tpAmountInput;
   }

   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = volumeInput;
   request.type = type;
   request.tp = tp;
   request.sl = sl;
   request.price = price;
   request.magic = magicGlobal;

   if (OrderSend(request, result))
   {
      Print("Create order success: Type: ", EnumToString(type), " - Ticket: ", result.order, " - Price: ", price, " - TP: ", tp, " - SL: ", sl);
   }
   else
   {
      Print("Create order failure: Type: ", EnumToString(type), " - Comment: ", result.comment, " - Price: ", price, " - TP: ", tp, " - SL: ", sl);
   }
}