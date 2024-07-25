#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trending-grid/common/CommonFunction.mqh>

extern int totalGridInput;
extern double volumeInput;

extern ulong magicNoGlobal;
extern int gridNoCurrentGlobal;
extern double volumeBuyTotalGlobal;
extern double volumeSellTotalGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

void CreateOrderAction()
{
   if (CompareDouble(volumeBuyTotalGlobal, volumeSellTotalGlobal) > 0)
   {
      CreateOrderForDifferenceVolume(SELL_TYPE_CONSTANT);
   }
   else if (CompareDouble(volumeBuyTotalGlobal, volumeSellTotalGlobal) < 0)
   {
      CreateOrderForDifferenceVolume(BUY_TYPE_CONSTANT);
   }
   else
   {
      CreateOrder(GetGridNoUp(BUY_TYPE_CONSTANT), BUY_TYPE_CONSTANT, volumeInput);
      CreateOrder(GetGridNoDown(BUY_TYPE_CONSTANT), BUY_TYPE_CONSTANT, volumeInput);
      CreateOrder(GetGridNoUp(SELL_TYPE_CONSTANT), SELL_TYPE_CONSTANT, volumeInput);
      CreateOrder(GetGridNoDown(SELL_TYPE_CONSTANT), SELL_TYPE_CONSTANT, volumeInput);
   }
}

void CreateOrderForDifferenceVolume(string typeStr)
{
   double differenceVolume = MathAbs(volumeBuyTotalGlobal - volumeSellTotalGlobal);
   int gridNoUp = GetGridNoUp(typeStr);
   int gridNoDown = GetGridNoDown(typeStr);
   if (CompareDouble(differenceVolume, volumeInput) > 0)
   {
      if (gridNoUp == gridNoCurrentGlobal + 1)
      {
         CreateOrder(gridNoUp, typeStr, differenceVolume);
      }
      else
      {
         CreateOrder(gridNoCurrentGlobal + 1, typeStr, differenceVolume - volumeInput);
         CreateOrder(gridNoUp, typeStr, volumeInput);
      }

      if (gridNoDown == gridNoCurrentGlobal)
      {
         CreateOrder(gridNoDown, typeStr, differenceVolume);
      }
      else
      {
         CreateOrder(gridNoCurrentGlobal, typeStr, differenceVolume - volumeInput);
         CreateOrder(gridNoDown, typeStr, volumeInput);
      }
   }
   else
   {
      CreateOrder(gridNoUp, typeStr, volumeInput);
      CreateOrder(gridNoDown, typeStr, volumeInput);
   }
}

bool IsExistGridNo(int gridNo, string typeStr)
{
   double priceGrid = GetPriceByGridNo(gridNo);
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

   return IsExistGridNoInPosition(gridNo, typeStr);
}

void CreateOrder(int gridNo, string typeStr, double volume)
{
   if (IsExistGridNo(gridNo, typeStr))
   {
      return;
   }

   double price = GetPriceByGridNo(gridNo);
   ENUM_ORDER_TYPE type;
   double tp;
   double sl;

   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if (typeStr == BUY_TYPE_CONSTANT)
   {
      tp = price + gridAmountInput;
      sl = GetSLDown();
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
      tp = price - gridAmountInput;
      sl = GetSLUp();
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
   request.volume = volume;
   request.type = type;
   request.tp = tp;
   request.sl = sl;
   request.price = price;
   request.comment = IntegerToString(gridNo);
   request.magic = magicNoGlobal;

   if (OrderSend(request, result))
   {
      Print("Create order success: Type: ", EnumToString(type), " - Ticket: ", result.order, " - Grid No: ", gridNo, " - Price: ", price, " - TP: ", tp, " - SL: ", sl, " - Volume: ", volume);
   }
   else
   {
      Print("Create order failure: Type: ", EnumToString(type), " - Comment: ", result.comment, " - Grid No: ", gridNo, " - Price: ", price, " - TP: ", tp, " - SL: ", sl, " - Volume: ", volume);
   }
}
