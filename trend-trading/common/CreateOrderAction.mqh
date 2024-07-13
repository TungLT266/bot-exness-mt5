#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/CommonFunction.mqh>

extern int totalOrderInput;
extern double volumeInput;
extern double gridAmountInput;
extern ulong magicNumberInput;

extern int gridNoCurrentGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

void CreateOrderAction()
{
   for (int i = GetGridNoStart(); i <= GetGridNoEnd(); i++)
   {
      if (!IsExistGridNo(i))
      {
         CreateOrder(i);
      }
   }
}

bool IsExistGridNo(int gridNo)
{
   int totalOrder = OrdersTotal();
   for (int i = 0; i < totalOrder; i++)
   {
      ulong orderTicket = OrderGetTicket(i);
      ulong magic = OrderGetInteger(ORDER_MAGIC);
      if (magic == magicNumberInput)
      {
         string comment = OrderGetString(ORDER_COMMENT);
         if (gridNo == StringToInteger(comment))
         {
            return true;
         }
      }
   }

   int totalPosition = PositionsTotal();
   for (int i = 0; i < totalPosition; i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
      {
         string comment = PositionGetString(POSITION_COMMENT);
         if (gridNo == StringToInteger(comment))
         {
            return true;
         }
      }
   }
   return false;
}

void CreateOrder(int gridNo)
{
   double price = GetPriceByGridNo(gridNo);
   double tp;
   ENUM_ORDER_TYPE type;

   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   string typeStr = GetTypeOrderByGridNo(gridNo);
   if (typeStr == BUY_TYPE_CONSTANT)
   {
      tp = price + gridAmountInput;
      if (price > askPrice)
      {
         type = ORDER_TYPE_BUY_STOP;
      }
      else
      {
         type = ORDER_TYPE_BUY_LIMIT;
      }
   }
   else if (typeStr == SELL_TYPE_CONSTANT)
   {
      tp = price - gridAmountInput;
      if (price < bidPrice)
      {
         type = ORDER_TYPE_SELL_STOP;
      }
      else
      {
         type = ORDER_TYPE_SELL_LIMIT;
      }
   }
   else
   {
      Print("Create order failure: Type invalid.");
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
   request.tp = tp;
   request.comment = IntegerToString(gridNo);

   if (OrderSend(request, result))
   {
      Print("Create order success: Type: ", EnumToString(type), " - Ticket: ", result.order, " - Grid No: ", gridNo, " - Price: ", price, " - TP: ", tp);
   }
   else
   {
      Print("Create order failure: Type: ", EnumToString(type), " - Comment: ", result.comment, " - Grid No: ", gridNo, " - Price: ", price, " - TP: ", tp);
   }
   Sleep(1000);
}
