#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>

extern int limitGridInput;

extern int magic3ArrGlobal[];
extern string takeProfitCurrentArrGlobal[];
extern string takeProfitStartArrGlobal[];
extern int totalPositionArrGlobal[];

void ModifyPositionTPSLAction()
{
   for (int i = 0; i < ArraySize(magic3ArrGlobal); i++)
   {
      ModifyPositionTPSLByMagicOrdinal(i);
   }
}

void ModifyPositionTPSLByMagicOrdinal(int magicOrdinal)
{
   int magic3 = magic3ArrGlobal[magicOrdinal];
   double tpNew = GetTPByMagic3(magic3);
   double slNew = GetSLByMagic3(magic3);

   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (IsCorrectMagicByMagic3(magic, magic3))
      {
         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         double tp = PositionGetDouble(POSITION_TP);
         double sl = PositionGetDouble(POSITION_SL);

         if (totalPositionArrGlobal[magicOrdinal] >= limitGridInput)
         {
            if (takeProfitStartArrGlobal[magicOrdinal] == takeProfitCurrentArrGlobal[magicOrdinal])
            {
               if (CompareDouble(tp, tpNew) != 0 || CompareDouble(sl, slNew) != 0)
               {
                  ModifyPositionTPSL(positionTicket, tpNew, slNew, type);
               }
            }
            else
            {
               if (CompareDouble(tp, slNew) != 0 || CompareDouble(sl, tpNew) != 0)
               {
                  ModifyPositionTPSL(positionTicket, slNew, tpNew, type);
               }
            }
         }
         else
         {
            if (takeProfitStartArrGlobal[magicOrdinal] == takeProfitCurrentArrGlobal[magicOrdinal])
            {
               if (CompareDouble(tp, tpNew) != 0 || CompareDouble(sl, 0) != 0)
               {
                  ModifyPositionTPSL(positionTicket, tpNew, 0, type);
               }
            }
            else
            {
               if (CompareDouble(tp, 0) != 0 || CompareDouble(sl, tpNew) != 0)
               {
                  ModifyPositionTPSL(positionTicket, 0, tpNew, type);
               }
            }
         }
      }
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
