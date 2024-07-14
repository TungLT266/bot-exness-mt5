#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/reverse-trend-trading/common/CommonFunction.mqh>

extern int limitPositionInput;
extern ulong magicNumberInput;

extern int gridNoCurrentGlobal;

void ClosePositionAction()
{
   int totalPosition = GetTotalPosition();
   if (totalPosition > limitPositionInput)
   {
      ulong ticketMin = 0;
      ulong ticketMax = 0;
      int gridNoMin = 0;
      int gridNoMax = 0;

      for (int i = PositionsTotal() - 1; i >= 0; i--)
      {
         ulong positionTicket = PositionGetTicket(i);
         ulong magic = PositionGetInteger(POSITION_MAGIC);
         if (magic == magicNumberInput)
         {
            int gridNo = (int)StringToInteger(OrderGetString(ORDER_COMMENT));
            ENUM_POSITION_TYPE positionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            if (positionType == POSITION_TYPE_SELL)
            {
               if (gridNoMax == 0 || gridNoMax < gridNo)
               {
                  gridNoMax = gridNo;
                  ticketMax = positionTicket;
               }
            }
            else
            {
               if (gridNoMin == 0 || gridNoMin > gridNo)
               {
                  gridNoMin = gridNo;
                  ticketMin = positionTicket;
               }
            }
         }
      }

      int differenceUp = gridNoMax - gridNoCurrentGlobal - 1;
      int differenceDown = gridNoCurrentGlobal - gridNoMin;
      if (differenceUp > differenceDown)
      {
         ClosePosition(ticketMax);
      }
      else if (differenceUp < differenceDown)
      {
         ClosePosition(ticketMin);
      }
      else
      {
         ClosePosition(ticketMin);
         ClosePosition(ticketMax);
      }
   }
}

void CloseAllPosition()
{
   int totalPosition = PositionsTotal();
   for (int i = totalPosition - 1; i >= 0; i--)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
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
