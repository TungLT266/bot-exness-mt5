#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trending-grid/common/CommonFunction.mqh>

extern int totalGridInput;
extern double volumeInput;

extern ulong magicNoGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

void CreateOrderAction()
{
   for (int i = 1; i <= totalGridInput; i++)
   {
      createOrder(i, BUY_TYPE_CONSTANT);
      createOrder(i, SELL_TYPE_CONSTANT);
   }
}

bool IsExistGridNo(double priceGrid, string typeStr)
{
   double min = GetPriceMinGrid(priceGrid);
   double max = GetPriceMaxGrid(priceGrid);

   for (int i = 0; i < OrdersTotal(); i++)
   {
      ulong ticket = OrderGetTicket(i);
      if (OrderGetInteger(ORDER_MAGIC) == magicNoGlobal)
      {
         ENUM_ORDER_TYPE type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
         if (GetOrderTypeStr(type) == typeStr)
         {
            double price = OrderGetDouble(ORDER_PRICE_OPEN);
            if (price > min && price < max)
            {
               return true;
            }
         }
      }
   }

   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if (PositionGetInteger(POSITION_MAGIC) == magicNoGlobal)
      {
         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if (GetPositionTypeStr(type) == typeStr)
         {
            double price = PositionGetDouble(POSITION_PRICE_OPEN);
            if (price > min && price < max)
            {
               return true;
            }
         }
      }
   }
   return false;
}

void createOrder(int gridNo, string typeStr)
{
   double price = GetPriceByGridNo(gridNo);
   if (IsExistGridNo(price, typeStr))
   {
      return;
   }

   ENUM_ORDER_TYPE type;

   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if (typeStr == BUY_TYPE_CONSTANT)
   {
      if (CompareDouble(price, askPrice) > 0)
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
      if (CompareDouble(price, bidPrice) < 0)
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

   if (price >= bidPrice && price <= askPrice)
   {
      Print("Create order failure: ", gridNo, " - Price: ", price);
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
   request.comment = IntegerToString(gridNo);
   request.magic = magicNoGlobal;

   if (OrderSend(request, result))
   {
      Print("Create order success: Type: ", EnumToString(type), " - Ticket: ", result.order, " - Grid No: ", gridNo, " - Price: ", price);
   }
   else
   {
      Print("Create order failure: Type: ", EnumToString(type), " - Comment: ", result.comment, " - Grid No: ", gridNo, " - Price: ", price);
   }
}
