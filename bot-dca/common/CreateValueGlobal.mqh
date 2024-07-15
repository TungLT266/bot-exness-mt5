#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>

extern bool isTradeBuyFirstInput;

extern bool isTradeBuyFirstGlobal;
extern double priceStartGlobal;

double GetSpread()
{
   return SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) * _Point;
}

void SetPriceStartAndIsTradeBuyFirst()
{
   double priceStartNew = 0;
   bool isTradeBuyFirstNew = isTradeBuyFirstInput;

   int totalPosition = PositionsTotal();
   for (int i = 0; i < totalPosition; i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
      {
         string comment = PositionGetString(POSITION_COMMENT);
         if (StringToInteger(comment) == 1)
         {
            priceStartNew = PositionGetDouble(POSITION_PRICE_OPEN);
            if ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
               isTradeBuyFirstNew = true;
            }
            else
            {
               isTradeBuyFirstNew = false;
            }
         }
      }
   }

   if (priceStartNew > 0 && priceStartNew != priceStartGlobal)
   {
      priceStartGlobal = priceStartNew;
      Print("Price Start: ", priceStartGlobal);
   }

   if (isTradeBuyFirstNew != isTradeBuyFirstGlobal)
   {
      isTradeBuyFirstGlobal = priceStartNew;
      if (isTradeBuyFirstGlobal)
      {
         Print("Trade Buy First.");
      }
      else
      {
         Print("Trade Sell First.");
      }
   }
}

bool GetIsTakeProfitBuy()
{
   ENUM_POSITION_TYPE typeToTakeProfit = POSITION_TYPE_BUY;
   int gridNoTakeProfit = 0;

   int totalPosition = PositionsTotal();
   for (int i = 0; i < totalPosition; i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
      {
         string comment = PositionGetString(POSITION_COMMENT);
         int gridNoComment = (int)StringToInteger(comment);
         if (gridNoComment > gridNoTakeProfit)
         {
            gridNoTakeProfit = gridNoComment;
            typeToTakeProfit = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         }
      }
   }
   if (gridNoTakeProfit > 0)
   {
      return typeToTakeProfit == POSITION_TYPE_BUY;
   }
   return isTradeBuyFirstGlobal;
}