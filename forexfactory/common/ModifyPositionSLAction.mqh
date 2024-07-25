#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/forexfactory/common/CommonFunction.mqh>

extern double slAmountInput;

extern ulong magicGlobal;

void ModifyPositionSLAction()
{
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (PositionGetInteger(POSITION_MAGIC) == magicGlobal)
      {
         ModifyPositionSL(positionTicket);
      }
   }
}

double GetSLNewForBuy(double priceOpen)
{
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if (bidPrice >= (priceOpen + slAmountInput))
   {
      return priceOpen;
   }
   else if (bidPrice >= priceOpen)
   {
      return priceOpen - slAmountInput;
   }
   return 0;
}

double GetSLNewForSell(double priceOpen)
{
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   if (askPrice <= (priceOpen - slAmountInput))
   {
      return priceOpen;
   }
   else if (askPrice <= priceOpen)
   {
      return priceOpen + slAmountInput;
   }
   return 0;
}

void ModifyPositionSL(ulong positionTicket)
{
   ENUM_POSITION_TYPE positionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   double slOld = PositionGetDouble(POSITION_SL);
   double positionPrice = PositionGetDouble(POSITION_PRICE_OPEN);

   double slNew;
   if (positionType == POSITION_TYPE_BUY)
   {
      slNew = GetSLNewForBuy(positionPrice);
   }
   else
   {
      slNew = GetSLNewForSell(positionPrice);
   }

   if (CompareDouble(slNew, 0) == 0 || CompareDouble(slNew, slOld) == 0)
   {
      return;
   }

   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   ZeroMemory(result);
   request.action = TRADE_ACTION_SLTP;
   request.position = positionTicket;
   request.symbol = _Symbol;
   request.sl = slNew;
   request.tp = PositionGetDouble(POSITION_TP);

   if (OrderSend(request, result))
   {
      Print("Modify SL success: Type: ", EnumToString(positionType), " - Ticket: ", positionTicket, " - SL New: ", slNew, " - SL Old: ", slOld);
   }
   else
   {
      Print("Modify SL failure: Type: ", EnumToString(positionType), " - Ticket: ", positionTicket, " - Comment: ", result.comment);
   }
}
