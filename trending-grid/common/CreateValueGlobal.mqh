#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern double priceCenterInput;
extern double gridAmountInput;
extern int totalGridInput;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;
extern string UNKNOWN_CONSTANT;

double GetPriceStartGrid()
{
   return priceCenterInput - (gridAmountInput * ((totalGridInput / 2) - 0.5));
}
