#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading-dca/common/CommonFunction.mqh>

extern double volumeInput;
extern double gridAmountInput;
extern ulong magicNumberInput;

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
   if (differenceVolume > volumeInput)
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
   int totalOrder = OrdersTotal();
   for (int i = 0; i < totalOrder; i++)
   {
      ulong orderTicket = OrderGetTicket(i);
      ulong magic = OrderGetInteger(ORDER_MAGIC);
      if (magic == magicNumberInput)
      {
         string comment = OrderGetString(ORDER_COMMENT);
         ENUM_ORDER_TYPE orderType = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
         if (typeStr == GetTypeOrderStrByType(orderType) && gridNo == StringToInteger(comment))
         {
            return true;
         }
      }
   }

   return IsExistGridNoInPosition(gridNo, typeStr);
}

void CreateOrder(int gridNo, string typeStr, double volume)
{
   if (gridNo == 0)
   {
      return;
   }
   if (IsExistGridNo(gridNo, typeStr))
   {
      return;
   }

   double price = GetPriceByGridNo(gridNo);
   double tp;
   ENUM_ORDER_TYPE type;

   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
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
   request.volume = volume;
   request.type = type;
   request.price = price;
   request.tp = tp;
   request.comment = IntegerToString(gridNo);
   request.magic = magicNumberInput;

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
