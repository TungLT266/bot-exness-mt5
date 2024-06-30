#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

extern double gridStartInput;
extern double gridAmountInput;

double GetPriceByGridNumber(double gridNumber) {
   return gridStartInput + ((gridNumber - 1) * gridAmountInput);
}

int GetTotalOrderAndPosition() {
   int totalOrder = OrdersTotal();
   int totalPosition = PositionsTotal();
   return totalOrder + totalPosition;
}