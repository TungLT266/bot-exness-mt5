#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>

extern bool isTradeBuyFirstInput;
extern double slAmountInput;

extern int magic3ArrGlobal[];
extern double slAmountArrGlobal[];
extern double priceStartArrGlobal[];
extern string takeProfitCurrentArrGlobal[];
extern string takeProfitStartArrGlobal[];
extern int totalPositionArrGlobal[];

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;
extern string UNKNOWN_CONSTANT;

void SetMagicDependentArr()
{
   SetSLAmountArr();
   SetPriceStartArr();
   SetTakeProfitCurrentArr();
   SetTakeProfitStartArr();
}

void SetTakeProfitStartArr()
{
   int sizeNew = ArraySize(magic3ArrGlobal);
   ArrayResize(takeProfitStartArrGlobal, sizeNew);

   for (int i = 0; i < sizeNew; i++)
   {
      string takeProfitStartNew = GetTakeProfitStartByMagicOrdinal(i);
      if (takeProfitStartArrGlobal[i] != takeProfitStartNew)
      {
         takeProfitStartArrGlobal[i] = takeProfitStartNew;
         Print("Magic 3: ", magic3ArrGlobal[i], " - Take profit start: ", takeProfitStartNew);
      }
   }
}

string GetTakeProfitStartByMagicOrdinal(int magicOrdinal)
{
   int magic3 = magic3ArrGlobal[magicOrdinal];
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (IsCorrectMagicByMagic3(PositionGetInteger(POSITION_MAGIC), magic3))
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

void SetTakeProfitCurrentArr()
{
   int sizeNew = ArraySize(magic3ArrGlobal);
   ArrayResize(takeProfitCurrentArrGlobal, sizeNew);

   for (int i = 0; i < sizeNew; i++)
   {
      string takeProfitCurrentNew = GetTakeProfitCurrentByMagicOrdinal(i);
      if (takeProfitCurrentArrGlobal[i] != takeProfitCurrentNew)
      {
         takeProfitCurrentArrGlobal[i] = takeProfitCurrentNew;
         Print("Magic 3: ", magic3ArrGlobal[i], " - Take profit current: ", takeProfitCurrentNew);
      }
   }
}

string GetTakeProfitCurrentByMagicOrdinal(int magicOrdinal)
{
   int magic3 = magic3ArrGlobal[magicOrdinal];
   int gridNoMax = 0;
   ENUM_POSITION_TYPE positionTypeAtGridMax = POSITION_TYPE_BUY;
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (IsCorrectMagicByMagic3(PositionGetInteger(POSITION_MAGIC), magic3))
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

void SetPriceStartArr()
{
   int sizeNew = ArraySize(magic3ArrGlobal);
   ArrayResize(priceStartArrGlobal, sizeNew);

   for (int i = 0; i < sizeNew; i++)
   {
      double priceStartNew = GetPriceStartByMagicOrdinal(i);
      if (priceStartArrGlobal[i] != priceStartNew)
      {
         priceStartArrGlobal[i] = priceStartNew;
         Print("Magic 3: ", magic3ArrGlobal[i], " - Price start: ", priceStartNew);
      }
   }
}

double GetPriceStartByMagicOrdinal(int magicOrdinal)
{
   int magic3 = magic3ArrGlobal[magicOrdinal];
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (IsCorrectMagicByMagic3(PositionGetInteger(POSITION_MAGIC), magic3))
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

void SetSLAmountArr()
{
   int sizeNew = ArraySize(magic3ArrGlobal);
   ArrayResize(slAmountArrGlobal, sizeNew);

   for (int i = 0; i < sizeNew; i++)
   {
      double slAmountNew = GetSLAmountByMagicOrdinal(i);
      if (slAmountArrGlobal[i] != slAmountNew)
      {
         slAmountArrGlobal[i] = slAmountNew;
         Print("Magic 3: ", magic3ArrGlobal[i], " - SL Amount: ", slAmountNew);
      }
   }
}

double GetSLAmountByMagicOrdinal(int magicOrdinal)
{
   if (totalPositionArrGlobal[magicOrdinal] <= 1)
   {
      return slAmountInput;
   }

   int magic3 = magic3ArrGlobal[magicOrdinal];
   double priceAtGrid1 = 0;
   double priceAtGrid2 = 0;
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (IsCorrectMagicByMagic3(PositionGetInteger(POSITION_MAGIC), magic3))
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
      return MathAbs(priceAtGrid1 - priceAtGrid2);
   }
   return slAmountInput;
}

void SetMagic3Arr()
{
   int magic3ArrNew[];

   int totalPosition = PositionsTotal();
   for (int i = 0; i < totalPosition; i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (IsCorrectMagic(magic))
      {
         int magic3 = GetMagic3ByMagic(magic);
         if (!IsContainsValueInt(magic3ArrNew, magic3))
         {
            AddArrValueInt(magic3ArrNew, magic3);
         }
      }
   }

   if (!IsEqualArrInt(magic3ArrGlobal, magic3ArrNew))
   {
      CopyArrInt(magic3ArrNew, magic3ArrGlobal);
      string magic3Str = "";
      for (int i = 0; i < ArraySize(magic3ArrGlobal); i++)
      {
         magic3Str += IntegerToString(magic3ArrGlobal[i]) + ", ";
      }
      Print("Magic 3: ", StringSubstr(magic3Str, 0, StringLen(magic3Str) - 2));
   }
}
