#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/trend-trading-dca/common/CommonFunction.mqh>

extern ulong magicNumberInput;
extern double volumeInput;

extern double volumeBuyTotalGlobal;
extern double volumeSellTotalGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

void RemoveOrderAction()
{
   for (int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong orderTicket = OrderGetTicket(i);
      ulong magic = OrderGetInteger(ORDER_MAGIC);
      if (magic == magicNumberInput)
      {
         string typeStr = GetTypeOrderStrByType((ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE));
         int gridNo = (int)StringToInteger(OrderGetString(ORDER_COMMENT));
         double volume = PositionGetDouble(POSITION_VOLUME);
         if (IsOrderTicketInvalid(gridNo, typeStr, volume))
         {
            RemoveOrderByTicket(orderTicket);
         }
      }
   }
}

bool IsOrderTicketInvalidForDifferenceVolume(int gridNo, string typeStr, double volume)
{
   double differenceVolume = MathAbs(volumeBuyTotalGlobal - volumeSellTotalGlobal);
   int gridNoUp = GetGridNoUp(typeStr);
   int gridNoDown = GetGridNoDown(typeStr);
   if (CompareDouble(differenceVolume, volumeInput) > 0)
   {
      if (gridNoUp == gridNoCurrentGlobal + 1)
      {
         if (gridNo == gridNoUp && CompareDouble(volume, differenceVolume) == 0)
         {
            return false;
         }
      }
      else
      {
         if (gridNo == gridNoCurrentGlobal + 1 && CompareDouble(volume, differenceVolume - volumeInput) == 0)
         {
            return false;
         }
         if (gridNo == gridNoUp && CompareDouble(volume, volumeInput) == 0)
         {
            return false;
         }
      }

      if (gridNoDown == gridNoCurrentGlobal)
      {
         if (gridNo == gridNoDown && CompareDouble(volume, differenceVolume) == 0)
         {
            return false;
         }
      }
      else
      {
         if (gridNo == gridNoCurrentGlobal && CompareDouble(volume, differenceVolume - volumeInput) == 0)
         {
            return false;
         }
         if (gridNo == gridNoDown && CompareDouble(volume, volumeInput) == 0)
         {
            return false;
         }
      }
   }
   else
   {
      if (gridNo == gridNoUp && CompareDouble(volume, volumeInput) == 0)
      {
         return false;
      }
      if (gridNo == gridNoDown && CompareDouble(volume, volumeInput) == 0)
      {
         return false;
      }
   }
   return true;
}

bool IsOrderTicketInvalid(int gridNo, string typeStr, double volume)
{
   if (CompareDouble(volumeBuyTotalGlobal, volumeSellTotalGlobal) > 0)
   {
      if (typeStr != SELL_TYPE_CONSTANT)
      {
         return true;
      }
      return IsOrderTicketInvalidForDifferenceVolume(gridNo, typeStr, volume);
   }
   else if (CompareDouble(volumeBuyTotalGlobal, volumeSellTotalGlobal) < 0)
   {
      if (typeStr != BUY_TYPE_CONSTANT)
      {
         return true;
      }
      return IsOrderTicketInvalidForDifferenceVolume(gridNo, typeStr, volume);
   }
   else
   {
      if (gridNo == GetGridNoUp(typeStr) && CompareDouble(volume, volumeInput) == 0)
      {
         return false;
      }
      if (gridNo == GetGridNoDown(typeStr) && CompareDouble(volume, volumeInput) == 0)
      {
         return false;
      }
   }
   return true;
}

void RemoveOrderByTicket(ulong ticket)
{
   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   ZeroMemory(result);
   request.action = TRADE_ACTION_REMOVE;
   request.order = ticket;

   if (OrderSend(request, result))
   {
      Print("Remove Order Success: Ticket: ", ticket);
   }
   else
   {
      Print("Remove Order Error: Ticket: ", ticket, " - Comment: ", result.comment);
   }
}