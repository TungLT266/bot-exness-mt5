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

         bool isSameDirectionWithTakeProfit = IsSameDirectionWithTakeProfit(type);

         if (totalPositionMagic >= limitGridInput)
         {
            if (isSameDirectionWithTakeProfit)
            {
               if (compareDouble(tp, tpNew) != 0 || compareDouble(sl, slNew) != 0)
               {
                  ModifyPositionTPSL(positionTicket, tpNew, slNew, type);
               }
            }
            else
            {
               if (compareDouble(tp, slNew) != 0 || compareDouble(sl, tpNew) != 0)
               {
                  ModifyPositionTPSL(positionTicket, slNew, tpNew, type);
               }
            }
         }
         else
         {
            if (isSameDirectionWithTakeProfit)
            {
               if (compareDouble(tp, tpNew) != 0 || compareDouble(sl, 0) != 0)
               {
                  ModifyPositionTPSL(positionTicket, tpNew, 0, type);
               }
            }
            else
            {
               if (compareDouble(tp, 0) != 0 || compareDouble(sl, tpNew) != 0)
               {
                  ModifyPositionTPSL(positionTicket, 0, tpNew, type);
               }
            }
         }
      }
   }
}

bool IsSameDirectionWithTakeProfit(ENUM_POSITION_TYPE type)
{
   if (isTakeProfitBuyGlobal)
   {
      return type == POSITION_TYPE_BUY;
   }
   else
   {
      return type == POSITION_TYPE_SELL;
   }
}

void ModifyPositionTPSL(ulong ticket, double tpNew, double slNew, ENUM_POSITION_TYPE positionType)
{
   if (tpNew > 0)
   {
      if (positionType == POSITION_TYPE_BUY)
      {
         if (tpNew <= SymbolInfoDouble(_Symbol, SYMBOL_BID))
         {
            Print("Modify Position TPSL failure: Ticket: ", ticket, " - TP: ", tpNew);
            return;
         }
      }
      else
      {
         if (tpNew >= SymbolInfoDouble(_Symbol, SYMBOL_ASK))
         {
            Print("Modify Position TPSL failure: Ticket: ", ticket, " - TP: ", tpNew);
            return;
         }
      }
   }

   if (slNew > 0)
   {
      if (positionType == POSITION_TYPE_BUY)
      {
         if (slNew >= SymbolInfoDouble(_Symbol, SYMBOL_BID))
         {
            Print("Modify Position TPSL failure: Ticket: ", ticket, " - SL: ", slNew);
            return;
         }
      }
      else
      {
         if (slNew <= SymbolInfoDouble(_Symbol, SYMBOL_ASK))
         {
            Print("Modify Position TPSL failure: Ticket: ", ticket, " - SL: ", slNew);
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
   request.sl = slNew;

   if (OrderSend(request, result))
   {
      Print("Modify Position TPSL success: Ticket: ", ticket, " - TP: ", tpNew, " - SL: ", slNew);
   }
   else
   {
      Print("Modify Position TPSL failure: Ticket: ", ticket, " - TP: ", tpNew, " - SL: ", slNew, " - Comment: ", result.comment);
   }
}
