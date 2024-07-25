#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/forexfactory/common/CommonFunction.mqh>

extern ulong magicGlobal;

void StopBotAction()
{
   if (GetTotalOrder() == 0 && GetTotalPosition() == 0)
   {
      Print("Stop bot.");
      ExpertRemove();
   }

   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (PositionGetInteger(POSITION_MAGIC) == magicGlobal)
      {
         if (CompareDouble(PositionGetDouble(POSITION_SL), PositionGetDouble(POSITION_PRICE_OPEN)) == 0)
         {
            Print("Stop bot.");
            ExpertRemove();
            return;
         }
      }
   }
}
