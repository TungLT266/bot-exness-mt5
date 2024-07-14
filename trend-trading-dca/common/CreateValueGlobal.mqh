#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading-dca/common/CommonFunction.mqh>

extern ulong magicNumberInput;

int GetGridNoCurrent()
{
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   int gridNoAtBid = GetGridNoByPrice(bidPrice);
   int gridNoAtAsk = GetGridNoByPrice(askPrice);
   if (gridNoAtBid == gridNoAtAsk)
   {
      return gridNoAtBid;
   }
   return 0;
}

double GetVolumeBuyTotal()
{
   return GetVolumeTotalBuyType(POSITION_TYPE_BUY);
}

double GetVolumeSellTotal()
{
   return GetVolumeTotalBuyType(POSITION_TYPE_SELL);
}

double GetVolumeTotalBuyType(ENUM_POSITION_TYPE typeSelect)
{
   double result = 0;
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
      {
         ENUM_POSITION_TYPE positionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if (positionType == typeSelect)
         {
            result += PositionGetDouble(POSITION_VOLUME);
         }
      }
   }
   return result;
}