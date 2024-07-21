#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>

extern int limitGridInput;

extern MagicDetailObject magicDetailArrGlobal[];

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

void TakeProfitAction()
{
   for (int i = 0; i < ArraySize(magicDetailArrGlobal); i++)
   {
      MagicDetailObject magicDetail = magicDetailArrGlobal[i];

      if (magicDetail.takeProfitCurrent == BUY_TYPE_CONSTANT)
      {
         double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         if (bidPrice >= GetTPByMagicDetail(magicDetail))
         {
            CloseAllPositionByMagicNo(magicDetail.magicNo);
         }
         else if (magicDetail.totalPosition >= limitGridInput)
         {
            if (bidPrice <= GetSLByMagicDetail(magicDetail))
            {
               CloseAllPositionByMagicNo(magicDetail.magicNo);
            }
         }
      }
      else
      {
         double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         if (askPrice <= GetTPByMagicDetail(magicDetail))
         {
            CloseAllPositionByMagicNo(magicDetail.magicNo);
         }
         else if (magicDetail.totalPosition >= limitGridInput)
         {
            if (askPrice >= GetSLByMagicDetail(magicDetail))
            {
               CloseAllPositionByMagicNo(magicDetail.magicNo);
            }
         }
      }
   }
}

void CloseAllPositionByMagicNo(ulong magicNo)
{
   int totalPosition = PositionsTotal();
   for (int i = totalPosition - 1; i >= 0; i--)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (PositionGetInteger(POSITION_MAGIC) == magicNo)
      {
         ClosePosition(positionTicket);
      }
   }
}

void ClosePosition(ulong ticket)
{
   CTrade trade;
   if (trade.PositionClose(ticket))
   {
      Print("Close position success: Type: ", ticket);
   }
   else
   {
      Print("Close position failure: Type: ", ticket);
   }
}
