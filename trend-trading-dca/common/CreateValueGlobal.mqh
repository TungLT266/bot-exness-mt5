#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading/common/CommonFunction.mqh>

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

int GetDifferenceBuyAndSell()
{
   int totalPosition = GetTotalPosition();
   if (totalPosition > 0)
   {
      return GetTotalPositionBuy() - GetTotalPositionSell();
   }
   return 0;
}