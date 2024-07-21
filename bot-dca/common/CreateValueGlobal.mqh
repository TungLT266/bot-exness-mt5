#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/MagicDetailObject.mqh>

extern double slAmountInput;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;
extern string UNKNOWN_CONSTANT;

void SetValueForMagicDetail(MagicDetailObject &magicDetailArrNew[])
{
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (IsCorrectMagic(magic))
      {
         if (!IsExitsMagicDetailByMagicNo(magicDetailArrNew, magic))
         {
            MagicDetailObject magicDetailNew = GetDefaultMagicDetailObject();
            magicDetailNew.magicNo = magic;
            magicDetailNew.totalPosition = GetTotalPositionByMagicNo(magic);
            SetSLAmountByMagicDetail(magicDetailNew);
            magicDetailNew.priceStart = GetPriceStartByMagicNo(magic);
            magicDetailNew.takeProfitCurrent = GetTakeProfitCurrentByMagicNo(magic);
            magicDetailNew.takeProfitStart = GetTakeProfitStartByMagicNo(magic);

            AddArrValueMagicDetail(magicDetailArrNew, magicDetailNew);
         }
      }
   }
}

string GetTakeProfitStartByMagicNo(ulong magicNo)
{
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (PositionGetInteger(POSITION_MAGIC) == magicNo)
      {
         int gridNo = GetGridNoByComment(PositionGetString(POSITION_COMMENT));
         if (gridNo == 1)
         {
            if ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
               return BUY_TYPE_CONSTANT;
            }
            else
            {
               return SELL_TYPE_CONSTANT;
            }
         }
      }
   }
   return UNKNOWN_CONSTANT;
}

string GetTakeProfitCurrentByMagicNo(ulong magicNo)
{
   int gridNoMax = 0;
   ENUM_POSITION_TYPE positionTypeAtGridMax = POSITION_TYPE_BUY;
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (PositionGetInteger(POSITION_MAGIC) == magicNo)
      {
         int gridNo = GetGridNoByComment(PositionGetString(POSITION_COMMENT));
         if (gridNo > gridNoMax)
         {
            gridNoMax = gridNo;
            positionTypeAtGridMax = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         }
      }
   }
   if (gridNoMax > 0)
   {
      if (positionTypeAtGridMax == POSITION_TYPE_BUY)
      {
         return BUY_TYPE_CONSTANT;
      }
      else
      {
         return SELL_TYPE_CONSTANT;
      }
   }
   return UNKNOWN_CONSTANT;
}

double GetPriceStartByMagicNo(ulong magicNo)
{
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (PositionGetInteger(POSITION_MAGIC) == magicNo)
      {
         int gridNo = GetGridNoByComment(PositionGetString(POSITION_COMMENT));
         if (gridNo == 1)
         {
            return PositionGetDouble(POSITION_PRICE_OPEN);
         }
      }
   }
   return 0;
}

void SetSLAmountByMagicDetail(MagicDetailObject &magicDetail)
{
   if (magicDetail.totalPosition <= 1)
   {
      magicDetail.slAmount = slAmountInput;
      return;
   }

   double priceAtGrid1 = 0;
   double priceAtGrid2 = 0;
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (PositionGetInteger(POSITION_MAGIC) == magicDetail.magicNo)
      {
         int gridNo = GetGridNoByComment(PositionGetString(POSITION_COMMENT));
         if (gridNo == 1)
         {
            priceAtGrid1 = PositionGetDouble(POSITION_PRICE_OPEN);
         }
         else if (gridNo == 2)
         {
            priceAtGrid2 = PositionGetDouble(POSITION_PRICE_OPEN);
         }
      }
   }
   if (CompareDouble(priceAtGrid1, 0) > 0 && CompareDouble(priceAtGrid2, 0) > 0)
   {
      magicDetail.slAmount = MathAbs(priceAtGrid1 - priceAtGrid2);
      return;
   }
   magicDetail.slAmount = slAmountInput;
}
