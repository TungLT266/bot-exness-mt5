#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>

extern ulong magicNumberInput;
extern int limitGridInput;

extern double priceStartGlobal;
extern bool isTakeProfitBuyGlobal;

void ModifyPositionTPSLAction()
{
   double tpNew = GetTP();
   double slNew = GetSL();
   int totalPositionMagic = GetTotalPosition();

   int totalPosition = PositionsTotal();
   for (int i = 0; i < totalPosition; i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
      {
         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         double tp = PositionGetDouble(POSITION_TP);
         double sl = PositionGetDouble(POSITION_SL);

         if (type == POSITION_TYPE_BUY)
         {
            if (isTakeProfitBuyGlobal && tp != tpNew)
            {
               ModifyPositionTP(positionTicket, tpNew, type);
            }
         }
         else
         {
            if (!isTakeProfitBuyGlobal && tp != tpNew)
            {
               ModifyPositionTP(positionTicket, tpNew, type);
            }
         }

         if (totalPositionMagic >= limitGridInput)
         {
            if (sl != slNew)
            {
               ModifyPositionSL(positionTicket, slNew, type);
            }
         }
      }
   }
}

void ModifyPositionTP(ulong ticket, double tpNew, ENUM_POSITION_TYPE positionType)
{
   if (tpNew > 0)
   {
      if (positionType == POSITION_TYPE_BUY)
      {
         if (tpNew <= SymbolInfoDouble(_Symbol, SYMBOL_BID))
         {
            Print("Modify Position TP failure: Ticket: ", ticket, " - TP: ", tpNew);
            return;
         }
      }
      else
      {
         if (tpNew >= SymbolInfoDouble(_Symbol, SYMBOL_ASK))
         {
            Print("Modify Position TP failure: Ticket: ", ticket, " - TP: ", tpNew);
            return;
         }
      }
   }

   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   ZeroMemory(result);
   request.action = TRADE_ACTION_SLTP;
   request.position = ticket;
   request.symbol = _Symbol;
   request.tp = tpNew;

   if (OrderSend(request, result))
   {
      Print("Modify Position TP success: Ticket: ", ticket, " - TP: ", tpNew);
   }
   else
   {
      Print("Modify Position TP failure: Ticket: ", ticket, " - TP: ", tpNew, " - Comment: ", result.comment);
   }
}

void ModifyPositionSL(ulong ticket, double slNew, ENUM_POSITION_TYPE positionType)
{
   if (slNew > 0)
   {
      if (positionType == POSITION_TYPE_BUY)
      {
         if (slNew >= SymbolInfoDouble(_Symbol, SYMBOL_BID))
         {
            Print("Modify Position SL failure: Ticket: ", ticket, " - SL: ", slNew);
            return;
         }
      }
      else
      {
         if (slNew <= SymbolInfoDouble(_Symbol, SYMBOL_ASK))
         {
            Print("Modify Position SL failure: Ticket: ", ticket, " - SL: ", slNew);
            return;
         }
      }
   }

   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   ZeroMemory(result);
   request.action = TRADE_ACTION_SLTP;
   request.position = ticket;
   request.symbol = _Symbol;
   request.sl = slNew;

   if (OrderSend(request, result))
   {
      Print("Modify Position SL success: Ticket: ", ticket, " - SL: ", slNew);
   }
   else
   {
      Print("Modify Position SL failure: Ticket: ", ticket, " - SL: ", slNew, " - Comment: ", result.comment);
   }
}
