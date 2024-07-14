#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/CommonFunction.mqh>

extern double volumeInput;
extern double gridAmountInput;
extern ulong magicNumberInput;

extern int gridNoCurrentGlobal;
extern int differenceBuyAndSellGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

void CreateOrderAction()
{
   if (differenceBuyAndSellGlobal > 0)
   {
      CreateOrder(GetGridNoSellUp(), SELL_TYPE_CONSTANT);
      CreateOrder(GetGridNoSellDown(), SELL_TYPE_CONSTANT);
   }
   else if (differenceBuyAndSellGlobal < 0)
   {
      CreateOrder(GetGridNoBuyUp(), BUY_TYPE_CONSTANT);
      CreateOrder(GetGridNoBuyDown(), BUY_TYPE_CONSTANT);
   }
   else
   {
      CreateOrder(GetGridNoBuyUp(), BUY_TYPE_CONSTANT);
      CreateOrder(GetGridNoBuyDown(), BUY_TYPE_CONSTANT);
      CreateOrder(GetGridNoSellUp(), SELL_TYPE_CONSTANT);
      CreateOrder(GetGridNoSellDown(), SELL_TYPE_CONSTANT);
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

void CreateOrder(int gridNo, string typeStr)
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
   double sl;
   ENUM_ORDER_TYPE type;

   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   if (typeStr == BUY_TYPE_CONSTANT)
   {
      sl = price - gridAmountInput;
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
      sl = price + gridAmountInput;
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
   request.sl = sl;
   request.comment = IntegerToString(gridNo);
   request.magic = magicNumberInput;

   if (OrderSend(request, result))
   {
      Print("Create order success: Type: ", EnumToString(type), " - Ticket: ", result.order, " - Grid No: ", gridNo, " - Price: ", price, " - SL: ", sl);
   }
   else
   {
      Print("Create order failure: Type: ", EnumToString(type), " - Comment: ", result.comment, " - Grid No: ", gridNo, " - Price: ", price, " - SL: ", sl);
   }
   Sleep(1000);
}
